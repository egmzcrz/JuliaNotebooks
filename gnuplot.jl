extension(path::String) = match(r"\.[A-Za-z0-9]+$", path).match
    
struct Gnuplot
    filename::String
    ext::String
    f::Pipe
    p::Base.Process
    function Gnuplot(filename::String, x::Int, y::Int)
        f,p = open(pipeline(`gnuplot`,stdout=DevNull, stderr=DevNull),"w")
        ext = extension(filename)
        if ext == ".svg"
            write(f,"set terminal epslatex standalone size $(x)cm,$(y)cm\\
                    color background 'white' lw 3 font ',12'\\
                    header '\\usepackage[utf8]{inputenc} \\usepackage{amsmath}';
                    set output 'gptemp.tex'; set colorsequence podo;")
        elseif ext == ".png"
            write(f,"set terminal epslatex standalone size $(x)cm,$(y)cm\\
                    color background 'white' lw 3 font ',20'\\
                    header '\\usepackage[utf8]{inputenc} \\usepackage{amsmath}';
                    set output 'gptemp.tex'; set colorsequence podo;")
        elseif ext == ".gif"
            write(f,"set terminal gif animate delay 100;
                    set output '$filename';
                    set colorsequence podo;")
        end
        return new(filename,ext,f,p)
    end
end

function plot(gp::Gnuplot)
    close(gp.f)
    wait(gp.p.closenotify)
    if gp.ext == ".svg"
        run(pipeline(`latex gptemp.tex`, stdout=DevNull, stderr=DevNull))
        run(pipeline(`dvips gptemp.dvi`, stdout=DevNull, stderr=DevNull))
        run(pipeline(`gs -dBATCH -dSAFER -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="gptemp.pdf" gptemp.ps`,stdout=DevNull,stderr=DevNull))
        run(`pdf2svg gptemp.pdf $(gp.filename)`)
        run(`find -x . -name gptemp\* -delete`)
        display("image/svg+xml",readstring("./$(gp.filename)"))
    elseif gp.ext == ".png"
        run(pipeline(`latex gptemp.tex`, stdout=DevNull, stderr=DevNull))
        run(pipeline(`dvips gptemp.dvi`, stdout=DevNull, stderr=DevNull))
        run(pipeline(`gs -dBATCH -dSAFER -dNOPAUSE -sDEVICE=pngalpha -sOutputFile="$(gp.filename)" gptemp.ps`,stdout=DevNull,stderr=DevNull))
        run(`find -x . -name gptemp\* -delete`)
        display("image/png",read("./$(gp.filename)"))
    elseif gp.ext == ".gif"
        display("image/gif",read("./$(gp.filename)"))          
    end
end
