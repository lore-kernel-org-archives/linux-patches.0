Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABB5AD20
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 23:39:03 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id b16so6330310iln.3
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 15:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lsTG0FwmjQUr8gaZ4XIHrpahplxKBBfScZGNbgfy4VI=;
        b=Lg29eO1NWuiVzLsytUG/ShQCC92533DRbmqFrEX1/DPQgBCcuPm7seh/KNeZSi3Qqx
         szhm3z0jWm44HU9SJscqSzlAhbVX0uxKA6g8NWWSevpovZKyfNbOOiOMSw3wv6JAgvmt
         xx2HlzfxNGb2YFuNj8XiJEtXZEDb9d32nUm6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lsTG0FwmjQUr8gaZ4XIHrpahplxKBBfScZGNbgfy4VI=;
        b=onz88NpdRl2UVflamSk1tLCvzddID1xMsybOL4IHuSd2+49xWAl/YZL77Bo89qAtI3
         wGeD408BzL5aUkm1iimb7hHYYt7PH6mYGjpF5Lm3ZXq8NWZ8YCaQqumwD/TNXzU8DikI
         r4H3BezWsPLRW89MBrmMGYZdpAgdZT7r7TTiqVTe1IIKS9keo/0aWn02SwQZiSzE98AV
         DQI/XMSCmTLD5ex1BDKRgJypEg+dar5L1fBLaXpsHcK/nJvITjwpa/TrOH43GauQGas6
         wb1vpI8FgQvFH4poRNzMWQxeyvxx/UbbAJW2QeEaSFDldsdZOxVcR4In+p5+PUFSzYng
         wPdQ==
X-Gm-Message-State: AO0yUKWZ4V00poA/F+NWM+6FoVmKn6RVquP8BslHCY76kHUYohjuJWbn
	rWyQgYH/sR14kh3RHaIKB+5Ybw==
X-Google-Smtp-Source: AK7set996W7EQ94N8uwtK4I40yH1eBvB/ADZjQyUwT3eY3/TCJvmTfXR0icA5PWKybCohDe9y/Pu7g==
X-Received: by 2002:a92:c706:0:b0:316:ef1e:5e1f with SMTP id a6-20020a92c706000000b00316ef1e5e1fmr3771399ilp.1.1677195542501;
        Thu, 23 Feb 2023 15:39:02 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k6-20020a02a706000000b003c505bdf305sm2424635jam.141.2023.02.23.15.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:39:01 -0800 (PST)
Message-ID: <12776196-f79c-03c0-eab2-1a69945be8bd@linuxfoundation.org>
Date: Thu, 23 Feb 2023 16:39:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141539.591151658@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.233-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
