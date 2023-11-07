Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F71CAD52
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htl/AWFL"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-35950819c97so3861615ab.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 07:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1699370837; x=1699975637; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9r1p0ZSiR1SW3Vp37rjwojqo5nEaTZFOuzEKg6WqO2c=;
        b=htl/AWFLycSMMgmVRQmp6Dit7231n3KuGI2ghg25NsmD4fa//uFuJylYctMb8CbevO
         X4P+uPTdJfvNSU4F+pKvshvh1dH6FVVffb2W0O3Mdyqqo9OLuAYaSxj2i0AQZQAhnEO7
         M4H/WDzv2jWpGmsfHRcyKJciqW81Zsg54pARU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699370837; x=1699975637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9r1p0ZSiR1SW3Vp37rjwojqo5nEaTZFOuzEKg6WqO2c=;
        b=ZtlUlcRwM4BIrDpExySyBc8Oi1ALAEmuMtdeO+VQ8LjMG/AFDFUxPJhK3flv/LOqTg
         0u0eSNUXykglNH2bUR/t2EolXWp+n1EH6euJBk9lE0rKrFnCD4aCv3qUZpG6+81III2F
         m75tB8nqGQ+qNgNGhwVzpwum0V4toGUEwKzt93nrSGx67FChr3kXMNWK1H0loI/Bleit
         30Ed4oRBCEqfe2HdNBiR4YC/HHoUH1+N5xpEnzF1IZsLBsxWJP49InymePPRooN7Vf0P
         d3ZbCFStYgyhmsyJCI/qABgeKvAjhHr4xd8tsMUYdS+2wz7daWuDaI3B1x/f4Hr8Mvaf
         s2SQ==
X-Gm-Message-State: AOJu0YwYw3bbXgNrMqD478ve8OcSkNKlIu/FqSYmA0Ckbavass2kayCu
	aJWrPd71XYZs0U3mkx9qPQM5Wg==
X-Google-Smtp-Source: AGHT+IE7B0QzN4WoPG0EXWrCKJMWbwGhjT4CgwjteIj3zoF0tGikYBcllHZfBik4artp7ggwYfKjuA==
X-Received: by 2002:a05:6e02:168c:b0:359:4db7:102a with SMTP id f12-20020a056e02168c00b003594db7102amr24948172ila.0.1699370837192;
        Tue, 07 Nov 2023 07:27:17 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id db8-20020a056e023d0800b003596056a051sm3201829ilb.71.2023.11.07.07.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 07:27:16 -0800 (PST)
Message-ID: <2b536b87-33fa-4e84-8c0c-d96fabcec723@linuxfoundation.org>
Date: Tue, 7 Nov 2023 08:27:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231106130257.903265688@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 06:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
