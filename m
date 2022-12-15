Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249C88490
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 23:51:51 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id r72so495937iod.5
        for <patches@lists.linux.dev>; Thu, 15 Dec 2022 15:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ILYOzGOlcnUgJAYdg3KJrA0MBjq7Mpi0z4kbn89zmV8=;
        b=EIS2cGv8LD9/kBmoKOj55rWq3IzpORr6ZL33Z9fGayOW5Q0gm5whglTj0RFgsYPAil
         EAmFanxCA0beyFP858z2OxJgGsuEp05WE0nnvEba6qzsGTOqcvO+5VVUJp6fBSk7YyHa
         d8FBL9+eobM2mi/2d2i5SNsiZNAQICjpH8dtM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ILYOzGOlcnUgJAYdg3KJrA0MBjq7Mpi0z4kbn89zmV8=;
        b=Zbsp8A9GHeKqEf1cb1z5R3p/hKTDoWeouhYNFMadxwmPLqAxL8FXpUFoKqVdzrNo8H
         RrZi6Vb+d6hwIuepay6Oq+QT0ZpZnaykr1Z6SFSe8towCNC52XXk2yR8h3nXa7yQPU4o
         +pq4jqAb5zWz8E9dpSsoMPIuBo3QcVNN3gUGCf7VGow86iRRAmihIS/k66rlIhTvslY7
         /5bLnmsUFz3rgJAwNSBpko/GyhBxDxwjoMeqSzB+39TVH6wu5zQp2zjmS9R9jR2fr9TS
         mViodeHj6WdvAvrkmgkbbOLkqr/E0E0816HZRsFhVSnCi2j7xarsUjyAAqgeZ1LbVY53
         olHQ==
X-Gm-Message-State: ANoB5pnUCkjd/S1JtjOSorgWsbDqXvFVVgoe5993qS2DB4Wu3LkCb2CX
	SiamEiTWa3RDpo3KlrFsjcPoIQ==
X-Google-Smtp-Source: AA0mqf4QVc0MpuqQNi5OeSMrV0I/CML3biumc7bMrEq4VWZB9Yt/1kWFkTSJlipkCzhzzy2IDDx55w==
X-Received: by 2002:a6b:c415:0:b0:6cc:8b29:9a73 with SMTP id y21-20020a6bc415000000b006cc8b299a73mr3385501ioa.1.1671148310101;
        Thu, 15 Dec 2022 15:51:50 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f61-20020a0284c3000000b003717c1df569sm216114jai.165.2022.12.15.15.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 15:51:49 -0800 (PST)
Message-ID: <2103e063-a758-f13a-1402-3a9570377912@linuxfoundation.org>
Date: Thu, 15 Dec 2022 16:51:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 0/9] 5.4.228-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221215172905.468656378@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/22 11:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.228 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.228-rc1.gz
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
