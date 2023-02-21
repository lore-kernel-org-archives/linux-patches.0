Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6C28C0B
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 19:30:23 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso66717pjv.0
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 11:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P/MifN3kOHh8dGdr85tdLTw6o2pirAXtYEvHxB2DK0I=;
        b=Ds0XYlYblvHTuq1YbaF9QXpK+EuWFR51VHNmRz2S064Hq2utjqyBCCsfsio3Zqebx9
         CFpDBDEEabGMdejdTMrZcmBPIvoHFccUslFo6ju9lKKCdDa5/PkpgMiUYj7Z6tXdtgNd
         R5RhpboVo8HE9Mv+mZjBxCUsNjRzvUKNFmpA9FxwpVjWkfB85Qab4187RvLWd7fttS1c
         WMevq9q3zaqSxhxqo1GQNh0L3LewrzCjOXi4J1+UrMZqAPWezr9Mr+fItm6cX1Fw+oJh
         VM7eu7D4xoM2at+8tAc4MvrQA3dhbxIKCueoZDEBgQkDygpITVHdGjv2hZNcQQxRvLhp
         bK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P/MifN3kOHh8dGdr85tdLTw6o2pirAXtYEvHxB2DK0I=;
        b=Z0Y1+aG4sdey+Q1jqqyF7EIOCy4mssAn0LZeqG4cvDionKG0i7OQEoJxmMM7l4HJLI
         LNRveaknl9jqebjpT6AH9PxkiWx3AnRm/QuiZUXECDYJfqZ7Kmb2qpmI6ILsHjmkpQ7/
         ED9fo53h6R9DxIXSDs6I/t1GpgncxQIHk2kC5wxb12B1YKqH3YHY4ExIALjNfOkomQa1
         BsfMA7eYm5h4c18rlAOEGm911BuFTvyvTWfHOrCu1JK9rdZEG03a1QOZDoF2X2UEG6ML
         L9bVIimIs5bsv/lNzC06fPB7F0Zf2yelp3yFNT1ZHVBVuaK8rc55iNaP8enKRHxcN/Ke
         EHQw==
X-Gm-Message-State: AO0yUKV1v87liRPCE1y0Cvh85wq1yQiO5tgXRz68a4z9BGcuWv5iSJJ2
	E/cJTHgdZRaalBz9Rnf2GbA=
X-Google-Smtp-Source: AK7set8f2K4CBSzOdZkvrAUe1MOnQOs2LPIo8Jt9mgMl0j4CT7t+k1PkMMj5p3R11fzqo3w1mwQoDg==
X-Received: by 2002:a17:902:e5c9:b0:199:5208:44de with SMTP id u9-20020a170902e5c900b00199520844demr7417875plf.21.1677007822951;
        Tue, 21 Feb 2023 11:30:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h2-20020a170902f7c200b00194caf3e975sm10250014plw.208.2023.02.21.11.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 11:30:22 -0800 (PST)
Message-ID: <d10e3960-8fe6-2cae-27b9-22fac5aac0e2@gmail.com>
Date: Tue, 21 Feb 2023 11:30:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230220133602.515342638@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 05:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.232-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

