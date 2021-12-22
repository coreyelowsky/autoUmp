function pathVideo(depthVideo, centers, fWithBall, pixelRange, batter)

% Plots the path of the ball from the centers found on top of the
% depthVideo and plays the video
%
% Input : depthVideo
%         centers (nx3 array of points)
%         fWithBall (frames with the ball)


if(min(fWithBall > 0))
    
    px = [pixelRange(1); pixelRange(2); pixelRange(2); pixelRange(1);pixelRange(1)];
    py = [pixelRange(3); pixelRange(3); pixelRange(4); pixelRange(4);pixelRange(3)];
    
    for i = min(fWithBall): max(fWithBall)
        
        % the captured video is mirrored from what we see - for consistency, we undo this mirroring
        image = flipdim(depthVideo(:, :, :, i),2);
      
        if length(depthVideo(1,1,:,1)) == 1
            % enhances contrast of the captured depth data
            image = imadjust(image);
        end
        
     
        imshow(image)
        hold on;
        plot(centers(:,1), centers(:,2),'r*')
        
        % plot borders
        plot(px,py)
       
        if(batter ~= -1)
            plot([1;640], [batter(2);batter(2)], 'b-')
            plot([1;640], [batter(4); batter(4)], 'b-')
        end
        hold on;
        pause(1/30);
    end
end

end

