Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C99DBE73
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 15:22:11 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-34914064ea9so2235685ab.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 08:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693581731; x=1694186531; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vZ/UUo7dmwgPx7RIpKjWTig9qF/FMJDUQUgngiYJLfA=;
        b=UJBQf4ffBqDCe9uMLxK5Cel5sVIGhcdI055ca9gejlCCcSAAneP2YJvtjOML8+U59v
         6p8HcjPkuHmsElu16GHnHD3d3Cis1RULTK4fsit3pScqlIHpW6TppXYQ2S2avxqOo61K
         xYUd2iszkAe3VzZj0CqeA+NKbmEsB6qtY02ZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693581731; x=1694186531;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ/UUo7dmwgPx7RIpKjWTig9qF/FMJDUQUgngiYJLfA=;
        b=UJ7a1bWbvb/Hyk68TLbG6nx2FF++URdD0+tehOTWZc8bhTHTRffkrpDE3Q/RqqyfXR
         3Da1wyQwPePKheiEb/sxnWnO7ssfYnYGy8v8tdTlRgvcPLFeVZtbc+x7oiRvOR4wezhQ
         yIRIPcUJ4YNY31RcAxbdVrF1D8gDBwtxwqlY9XNtJaEZyHSHsDeLiecfcwdqErStMWkW
         bBN3LpvN+O3OMXTGNGLNqPXDOq2Q1QsKipzHEX0eND1zq4tV+AthNI1XqJwo5sGTFhP4
         faVmGTgpXCm4QVfoMuLcMBBcX7B+vPZuHnPqmO0xxh6L3JGsk4RHlL3xIyGV2xVcXyqE
         bSEw==
X-Gm-Message-State: AOJu0Yx0TbzFe+nCfDCWEn2x2VQKe9V2aPQzE6TYmPNetGQCVwmGCFeb
	XrMHdc2xMaO7YY0g4gSGjyPOQw==
X-Google-Smtp-Source: AGHT+IHFcGUzVCAq3Lqr5rDQN9JRA05kvOnNtuaxsaT9/v6PSg4LrB+8Wcv5937QwjnuRm5WtJLImw==
X-Received: by 2002:a92:ce48:0:b0:34d:18b:aede with SMTP id a8-20020a92ce48000000b0034d018baedemr2707579ilr.2.1693581731064;
        Fri, 01 Sep 2023 08:22:11 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q10-20020a056e02078a00b0034901a2f693sm1142863ils.27.2023.09.01.08.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 08:22:10 -0700 (PDT)
Message-ID: <e0636350-cf04-d643-c202-a630802cf541@linuxfoundation.org>
Date: Fri, 1 Sep 2023 09:22:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 0/9] 6.4.14-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230831111127.667900990@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230831111127.667900990@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.14 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:11:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
