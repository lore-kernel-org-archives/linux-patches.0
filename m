Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19857813
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 00:22:21 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id u8so2067507ilq.13
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 16:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3OAfG6VdKk42BmKTv+3PQNhWn9BfRus8iDdWNO6vo/A=;
        b=NcxWcqqnhOvJXIi6LxVBBX+yyYwytaTYLvAXpx/lRZyreXhs0VlJQlt85tCX2xNK6c
         +ZX4FT8u6Fvzr1/v9z6QReYU5qHnpNos7MCetvQL2DiLHqmwec/pygGfozQbJ2ae+GEB
         wzzrvc+D6jF+iKxzoYn1m2Fpy2taVH04oQiyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3OAfG6VdKk42BmKTv+3PQNhWn9BfRus8iDdWNO6vo/A=;
        b=khds9paUNow7+JxorVYpbOTvk3H5MsPwtief0ObMWxR/70/0EHxjVbsQjV8l9j3b1h
         ycxcoDSwjFvlB/ASW0V2oOJAoCMCXz5F1KsrhSuCHcsdm7J1nDuWXzIchBPFE7q5xmYI
         SdaYGQf6iV+cRG33V0Gq3nPv++AbzcBKmA8xUlaFXH3kcI8ufzQaMuxbZFlwWYDlM50t
         SVrG6zJ3U7tvHxFKPwXLixPJu6rYWFGaw+T0zKbTCXKGCEeWOqFFCDvaNYeqhTs3Apsz
         kP40PeB9s3rJp21VgYp37EXTjKVRaDeyIqFi98nAFsT4vdxlN0i6lZ21qXjoX4xI09Up
         EwxQ==
X-Gm-Message-State: ANoB5pm5kOdVphbyOgEKyQO6kWoSWTEXP9+8op0h9M2e1ta6TcyPf2fZ
	7be3r/US7mSG0n4r5BnMCG7p9Q==
X-Google-Smtp-Source: AA0mqf6Pk/PX6xwzcGkpyjlEkp0mkdt02zSc9IVftgm8IB+fM741G0AYNBG9++wFO4ShS5nFOB/F1Q==
X-Received: by 2002:a92:cd4e:0:b0:303:1141:1044 with SMTP id v14-20020a92cd4e000000b0030311411044mr5181169ilq.1.1671495740094;
        Mon, 19 Dec 2022 16:22:20 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n15-20020a92dd0f000000b003032a97913asm3752089ilm.17.2022.12.19.16.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 16:22:19 -0800 (PST)
Message-ID: <09c3977c-11a1-72d9-44dd-d1b10944b9b4@linuxfoundation.org>
Date: Mon, 19 Dec 2022 17:22:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221219182940.701087296@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/22 12:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
