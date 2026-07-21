Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1E331F98B
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 16:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784651734; cv=none; b=huBsRgiGDVAEt6A4x2dPvd3aVSzoQKlrhvNrgQ94uD+8tpaF+33p46GEPL/G6IoOwsUGp8HZZXcy1CkXMrOG+qbiK6XCAQlXxa4scmecYKqDdViFY8AByZmKMHPLLhA0Ck41Hj/s/GDyiO3iv5350VgJ4LTaM82ibponwDCWjSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784651734; c=relaxed/simple;
	bh=BtQTtCtTSpbowSHyQsXFphn7z4W725woAyiCJc/xTJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PucvUf1qofWANw448mP7uKstiE0G5NB31RybB3lshJHcqxHkmU7e3w9DtnQ2o3hzIsKZVDxuYiFAd0vUUtkzDmeIopbKUz6mzT7H+RDdcfKTRUypgD7zgwgGf5ZUCpKj3Dg32CuJWQXzJLXfTM0sCFiswMzCS3rG67FYn2xPo18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jqox0o3j; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jqox0o3j"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dcbade417so9787231a91.1
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 09:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784651732; x=1785256532; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AuhxLdZkUAzj+3fp5sM4PbGIsm6IR7y62dQzuPnM91s=;
        b=Jqox0o3j+jTlbAEgM0637jAidZrS6QkRX8IGzimKt1y6mLrRLNDnFw3on69mGEfDVt
         ZQiFY8WVL/YWv+2lnZtQT3g95okedkvpQiffniNnSgIH8rNXYRftGs3v4AsCAlY+ENYM
         G7B34g8VYfvZuVwhVcf8fThKna02FvFxwLrDncml566ZzKcbJ0o19PwT/MxC9AUNRyQ3
         NnL7dZzVq4C04r99fuBzKl0GOvzirOdPkvyKGneBE3TgYASskc080yP+pDRgJzGgEeQq
         4eGUOu/dvJIlqJK+wO1dJnR0MgOVzb0/KunKkPXxpNSHM84ApNeXgwgOBRC7vxMcmm0V
         SgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784651732; x=1785256532;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AuhxLdZkUAzj+3fp5sM4PbGIsm6IR7y62dQzuPnM91s=;
        b=GINumTeAmdp9Sxafo64xdNRZnv0lNsVlHsdDp3pIFSnYoobOaRfizUH+Pj5hWyVZ8t
         79beM/v7uEfBYE9tatRE1au1sYq/caAJtJbpAhUhWLs01H18en+mwRxuX6xmT9htKooi
         Vwm4+DykhAbuv/OKKQT6Q2TafWysaTZSvIppyE1I+sBKOheDs3ZqIuW5uuwYbtit/3jb
         V9Yzx1yHQJq1UpAST2DYqq1KOJ8QFd05fiTBJ1Akh//8+t1oOmLosAANQaoEZM157ZwI
         ea6ybBPBRPxehIw57fBwkbvGsuo8UklSUxVByxthQLkfVa47kFvBVI8Ow1OKSdCXVZKC
         7CyA==
X-Gm-Message-State: AOJu0YyML9xHwNhyeNMZomXzBNUe/ezievRePkNbzamsVVDO3jGZZ3D8
	5BG357xLI3Wj7gwKfF6cHzp1XDmounx7xdaRdpbpUCs5ccKpcADLmdpR
X-Gm-Gg: AR+sD13Zhz67y03Ph0wwz78aTlyiHusEGIxINfzYAqqj1ql9UKaAV+Q9ontSHmNL1uh
	xNMzSnE+7Ic84iXJUS4JyqLJcEneP8c4l6DmwOMCfHc5VOJXWIJiMAhwaxk7mHTGEwx7uXHE2Tm
	pdmqnH98/6xiECfNgNFWyTUFLCsQgz7OIXP3bfNbfKdZWkyfw324lr3W/3JHAt29ETbrXYAD5ix
	fzwGnylQ4bqdeHYK6hUpbz5nRvyy1yGm0V43x+PagnE5p1AGWAlIV/erTSauSSwwHPggSQkloNw
	/kVnT3noyLOeCyUC6kqXy1E8csGWDYo5b7a5blv2uwXSzzkCzEJMZlbHGyKKF005e3xm7oTZYr5
	mjWQj6PBfZYzhjONhPSh2OTRwrPxop4eHZgLEUiGxSDtRYwx9nhWys7udeaOJPeAWbmCGIFYN5/
	34YnQhgEZqld4DPRaQjHEIUmRlHr72
X-Received: by 2002:a17:90b:5806:b0:381:f7a:2e0d with SMTP id 98e67ed59e1d1-38e4b585280mr18042303a91.33.1784651732574;
        Tue, 21 Jul 2026 09:35:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2cbb7c5sm41304921c88.10.2026.07.21.09.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 09:35:31 -0700 (PDT)
Message-ID: <245b6733-128b-487a-bbe6-d4e6ec4c3490@gmail.com>
Date: Tue, 21 Jul 2026 09:35:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/843] 5.15.212-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260721152405.946368001@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 08:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.212 release.
> There are 843 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.212-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same "perf" build issue with 5.15.212-rc1 here with the following signature:

   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/symbol_fprintf.o
util/event.c: In function 'machine__resolve':
util/event.c:700:32: warning: implicit declaration of function 
'perf_env__get_cpu_topology'; did you mean 
'perf_env__read_cpu_topology_map'? [-Wimplicit-function-declaration]
   700 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~
       |                                perf_env__read_cpu_topology_map
util/event.c:700:83: warning: excess elements in struct initializer
   700 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       | 
                   ^~
util/event.c:700:83: note: (near initialization for '(anonymous)')
util/event.c:700:81: error: invalid use of undefined type 'struct perf_cpu'
   700 |                         topo = perf_env__get_cpu_topology(env, 
(struct perf_cpu){ al->cpu });
       | 
                 ^
   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/color_config.o
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/event.o] 
Error 1
make[6]: *** Waiting for unfinished jobs....

-- 
Florian
