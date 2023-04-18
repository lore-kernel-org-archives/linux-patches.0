Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB45C944
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:26:43 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7606d7ca422so20050739f.1
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 14:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681853202; x=1684445202;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5aYlPNSrwMSPih/Iug9fotKivvMNK1l/gBB6zZEMqg4=;
        b=Au3zxZZMxkQk6R2qMv5e7MPRGJ47vJZO6YOb782cgLRSFq+BNkL+MoybuAfq1oXcDW
         zJE4BD33vPL24PipOOhLxaxKrO8RId3XgIJ4cYV+W5d4WNjekbJmBMdkC9ciWLm0Gdk4
         rKuYnI06M5kEfCJCCXcLZu2kmEDNj5XmPWKUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681853202; x=1684445202;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5aYlPNSrwMSPih/Iug9fotKivvMNK1l/gBB6zZEMqg4=;
        b=HN0qnzOMcBpJYH0PH4KiqSAovidLjDWacTcPyOATADERBfhdaKCO290ISnbKOujdny
         zOzSGezMRUnBX4gIv9gv19oHTUZH/0kMZ16mUSbkbdNvstO7+t7YQm2Xggv9pyqwEpSx
         ZprwL1by0nh5YnHhSLNBdOyz64od0EU2Vsgna5QrUwB77HHHkByiAmvq9ozhm5txP/8I
         G09W+HLk1dbuTEsITP4aI+Vsnrk1gjPmURF7+U2eYJ7jz8H5iaJNJYgktmv4UY4PBaS/
         0atpqoxWryoLlBG0qgr3h6ZhhYs4YLEge3xfNYHutlAa0/jOdJGXibfjl1U2gqOhdTyH
         ZKFw==
X-Gm-Message-State: AAQBX9dK6G45H99a/rxYQryVbi53NjvuCu2kJIwwbRjZEi8u2i/XOiTW
	bvf8/QoUj9Ce7U/mr451IZt12A==
X-Google-Smtp-Source: AKy350ZzaX/hCp9X1YLLSj5lTWXJAeuU0i2KxZICu/wiYEz9CT5zgQxUN0cq+h/za6i6gq+ShyOmUA==
X-Received: by 2002:a92:c5b0:0:b0:32a:d06a:356e with SMTP id r16-20020a92c5b0000000b0032ad06a356emr7351486ilt.1.1681853202546;
        Tue, 18 Apr 2023 14:26:42 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id az30-20020a056638419e00b0040f9ed959e3sm2551448jab.13.2023.04.18.14.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 14:26:42 -0700 (PDT)
Message-ID: <deb9c419-bf63-f1b4-1714-5ab31d3a0db6@linuxfoundation.org>
Date: Tue, 18 Apr 2023 15:26:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/23 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Note - I didn't see any build errors.

thanks,
-- Shuah
