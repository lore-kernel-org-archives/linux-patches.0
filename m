Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D7C3C02
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 19:37:48 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-760a66d23f8so1846539f.0
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 12:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681328268; x=1683920268;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SA+VjG801FJzKZfXKEA6/770snka7mIpjnJyN9XxyfI=;
        b=Ct9UauyxKrxt1IguFNEfeI5UYBISUhiEUYx2BC2rKDFNat95+1S+movXXGCMiSctUs
         KmvowONKOEkuUBQu4nIm10edKsEzhW72W04UcMVMfL9HAHGSyHoSVR9CD3AekPXOOXD/
         KSluP+wtafeVuRw1pkHXVkiuBP1nMycF9r82c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681328268; x=1683920268;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SA+VjG801FJzKZfXKEA6/770snka7mIpjnJyN9XxyfI=;
        b=HuynVe+wgF2lTpNvCJ3WQY6tJpkMGroHnt7SqRYvZOriAkVst3VNtPos+1pbNGZAFV
         Y/aXo2QYxfPiJ5zfyIj6Nmt8tuT9ZBhwc8FZXXpgPWZsKc1AUeo3nmQZ4KBz7aW+AzOt
         u/1xp3jWFoqdHjPtSRiI6u/7i109Ep6/dJDUZ09I0k6/qb3WaT9b2dfxbI6GBKhhtumw
         zjzpE8oFAC7bE20GgA4zP33Ib0G1y6MgaiWF2pb1BTJSmEBWC3bz/5ukIbq3ngIrl15f
         0lZyf4cDKHjrNJ+zPUp6g8LLHBxdu0En0Dn+kD5ZVROQ8EQwn6fAnGq2kFbd17YP6PZp
         KqSQ==
X-Gm-Message-State: AAQBX9e7N2+fEkiHQQO7viZN+QAOxNWkhSHh3ZL7kXyUGTpCBmOooZnb
	SGV1XgJsVo2kfN4GvM7Lo1664A==
X-Google-Smtp-Source: AKy350ZhbHdLt/AXSMTBfteDoZtvSSKGMoJK3SmoZDVGtXm2zVlmnv9oVC2SoaR3njUq6H5e/R6dHg==
X-Received: by 2002:a92:b711:0:b0:329:552e:2040 with SMTP id k17-20020a92b711000000b00329552e2040mr946352ili.3.1681328268017;
        Wed, 12 Apr 2023 12:37:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d9-20020a92d5c9000000b003284a6f4405sm12093ilq.1.2023.04.12.12.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 12:37:47 -0700 (PDT)
Message-ID: <b7e88931-3343-aa16-2880-ada37132aa54@linuxfoundation.org>
Date: Wed, 12 Apr 2023 13:37:46 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/23 02:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
