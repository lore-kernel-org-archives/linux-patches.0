Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5A68C14
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 23:26:48 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id j28so10509215ila.9
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 15:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/xDGNtMWURvljwRiBs8LuLEHcAsVVQHtWigZK+qLiE8=;
        b=AFN26eojPCYRqgY4nrPD0V96+ROKZNOlW2H3Y5HJYtPrDYvaa8TaZW1oMBw9oXoZfN
         40poAMjuNSedgSaEFOr2W4vic7D3GDUh1gnHKgQws8DiMcCtbDN1RYqNHNdn7hHzM1nU
         CWKugpaCFpoXBo/sxQwG/C/lTwIrt8rgeohKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/xDGNtMWURvljwRiBs8LuLEHcAsVVQHtWigZK+qLiE8=;
        b=k5Q/DxCm10UwnAdB+Eod7rfbzbLEli53VHO6StYO/NiSjvssaQWY/r4SFi4oPcomp5
         zGKI6bY23R6HCVIc91HYVnEBWhPAqUZRAx6JKS/0KyN2k7Uv98JA2e4oX8lsNCanSPSn
         4GcdynztsXFT67MyvJsb1AeD/LficMOCs6SwyolQufsYFSMSMaU3D9/I/u1lnsQ45Sx+
         p0bgzi1a3pTCJfbM7sTMhA9kdK9KlaOoEO0kHZNukLSZHAlhtAlBGSE4XcGQAuFAA1SY
         3xfUmjdLiMAe8KSOMqyCS6my23bildKOMsGkaeIfh8lbnQyp0eAV1VZoowSxG68Wsf+L
         n/RA==
X-Gm-Message-State: AFqh2kqwFkrYs2ZQ7JYsM878YbLrl5ZRcZvD0iXJsf1fIvthR9HY/vxX
	QQwhoHpC7xnoahh3I1fMvbbumw==
X-Google-Smtp-Source: AMrXdXubrhQqtg4cUYcuyLvM+GheoaOSWIKj5qAljwWYyGRxDWBGzdrY1eoFmMCwyS8yUhhNdaIgFQ==
X-Received: by 2002:a05:6e02:13e1:b0:30c:276b:af80 with SMTP id w1-20020a056e0213e100b0030c276baf80mr606833ilj.0.1672356407796;
        Thu, 29 Dec 2022 15:26:47 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o8-20020a056e0214c800b0030c048e60bbsm3459978ilk.34.2022.12.29.15.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 15:26:47 -0800 (PST)
Message-ID: <38aa4c96-00bf-d5e1-a820-806d7d7faf78@linuxfoundation.org>
Date: Thu, 29 Dec 2022 16:26:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/22 07:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc1.gz
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

thanks,
-- Shuah

