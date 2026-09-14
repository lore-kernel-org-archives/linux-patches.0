Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711F147DD54
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789407530; cv=none; b=cYwl9DZCTImW2LpgOeKGuUpiDb945p94Thm8hfa8p2CJH5Xg2Kq7jp0rLAKMZoCZ/aA6fjIqi4vOfUW8+JpSZaQ4uOVXHe3bZuATtNTSY4D9qCytPojsOCtcq79q/7DA+OIAtXAMzUhlAfnXYvYGG8ajs0T4ypBHrs9zkh6C2Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789407530; c=relaxed/simple;
	bh=SbuWO6K3oJD2LhlEEwqlQxpEpDLEqVohKRUVF6OSZS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uXAouJg+De5fQ6KPDD6LB1iNa+Hec2mx+b7w/qaFF3gKtoMOwtwDwJx7CYR0R06RGAvntnNuNonmI7UVhdyvcLQN8dKJjtwQZxyPpzGkmV4ovHyZTTZCoFNkWsOJI0a0meejjk9lrJngmgZY/Sl80ZVd1RycQTCU6nSmGGLrWz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJ9kAm9b; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJ9kAm9b"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469d249c4so2392925b3a.2
        for <patches@lists.linux.dev>; Mon, 14 Sep 2026 10:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789407529; x=1790012329; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rnT0qav7UwFgOqf+kbm0vIaYG2Z1UVdPy7kC+ivpDo0=;
        b=eJ9kAm9bMDZm9NFLcRLSuJmfsDtol0wZF8w5kjvtQ3ny9XuOQSDepkNkl1ajbFz7HZ
         vWJW7JElz9kvmQ1D436s4WxMzk6eSVD+AcaZcSOB7m8nbVaSY5C7DMpOPan6V6vtZFZS
         kLitpjK36xa0AmEHioWHX81ZxxtCobI6R5HxDKjE9HYu3Cny4CuNOcHiOL2mK+or/3+Y
         5j4di2blG+PmFPF6YzWyCQQx4OkvryXr+d8Azf/7fwDKEKCX4PGk5n+G+N6Tn8BNhrNJ
         m2ePDohZotFLGkRSMu40JP3huuEU1acgGzpfXQyJVhDl/XWkY+GyuiM6nKc2tWNJzgYN
         gkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789407529; x=1790012329;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rnT0qav7UwFgOqf+kbm0vIaYG2Z1UVdPy7kC+ivpDo0=;
        b=eGe5+jhqWuA44tWDt3hSSvjuRvhtFsREFpUzooijLzabbvlk081Thyr3uiVtHUg7Vd
         w0LGP9h31wPEMHkVCdR3phZNZgkKnoTI4F5WDxv1iEjz1ugJj+zzLHW31MQ7cDWCEcrn
         /EvsIuWfuVkHk0pXbjQCIheSDQp5P3qSbaz4b/8OhzVVZ0kMlZJpxIPvp7j870mqrT00
         gL7CvXkdfUV7d0TMwQa+Y52yyeoGXQrJIV7GpDD6Y1egI14+8NrdWDUnyoX/r5PC/fbW
         lpzBHMBnjokwR9pw4yAPcvRNG5xr7TcZBX9TRNz7M8su7v+Ft90r3tIp/9WBn6Ro3TNG
         Wf2g==
X-Gm-Message-State: AFuF++kB8yNoX8AXQDIEMj4mpa8i2/1tuVhjPm1LHh74bOeN7Z/AtzNL
	xpvM+1rv2P2ouoPvWnDTKd+pyVnhu3xuriLUtst+VksxEDrkAvGkx8Km
X-Gm-Gg: AYBFou1TYaFBoyhPBUeG/JfGNOc5dqLFE6eYEHH3hgjsp6Gbj5pCLIPvtJBpGmkfScn
	T45Zb9d5jWsNF5jEARSZXv+WHM6a0vTcXz7uil86FT/wjEYjCm+9wpT+3jdrfkq1pnp9ph+80rc
	gxhXlqnN0544ZcncheigwONDsa7EZ8spBVVOOZYNsM65Qga3FAYRWFM8Pt0iDkbHlyBqI8EG3UM
	5FqTAFIieqQYsyfiVPCxe9kdViwIdTxyql1v/47OGZjlbWTSA5x5EwWqFTgZrQ9/njhAziJacQW
	kTuDtWbU1wq9fDPB0MR5em00M44+JoSihOrnPOKVfvJs98qVxxitGRPEAIGS5p+TYqaC1IYP4Rg
	Zkl5+cj6iZe5ynZIWVllRJUY/DeUZHXCsC7LRjWJuWA/vGdCYDuwKGGAOKxynYXStEKBt96/lp6
	DJi1t/GXfz9FDqUjsoAOULtwuF/hI2kR34QVnJSB92LOGCR9yrJ9k7DC+oKsiz+SPja2WZg6vRV
	Psw2M+OWPiT7byWXtgUuG/n4w==
X-Received: by 2002:a05:6a00:1791:b0:86b:43f6:67b7 with SMTP id d2e1a72fcca58-86f82e5c9admr6736506b3a.4.1789407528681;
        Mon, 14 Sep 2026 10:38:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b2a1b827esm5006038b3a.51.2026.09.14.10.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 10:38:48 -0700 (PDT)
Message-ID: <64dd0faa-fdfa-45a4-812f-638574beca26@gmail.com>
Date: Mon, 14 Sep 2026 10:38:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065548.086904252@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 23:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.188 release.
> There are 1191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.188-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build on arm/arm64/bmips with:

   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/zlib.o
util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c:14:10: fatal error: 
linux/unaligned.h: No such file or directory
    14 | #include <linux/unaligned.h>
       |          ^~~~~~~~~~~~~~~~~~~
compilation terminated.
   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/lzma.o
make[7]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.o] 
Error 1
   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/cap.o
   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/demangle-ocaml.o
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:143: 
hisi-ptt-decoder] Error 2
make[6]: *** Waiting for unfinished jobs....
In file included from util/hisi-ptt.c:24:
util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.h:13:10: fatal error: 
linux/bitfield.h: No such file or directory
    13 | #include <linux/bitfield.h>
       |          ^~~~~~~~~~~~~~~~~~
compilation terminated.

this is due to 6c4b82b50c46842683a3a39e1bc8291581e8b1cb ("perf hisi-ptt: 
Fix PTT trace TLP header parsing")
-- 
Florian
