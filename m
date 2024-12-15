Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CA5EBE
	for <patches@lists.linux.dev>; Sun, 15 Dec 2024 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734275730; cv=none; b=af08QTdoM6ih6VczvbP8EUl/ATxWoYN/84eI5Ej4ngVbkODpLdxX0FOMJRYZsxYGJyMKooULS6YVRTk0tQM2KC/W+0q9O/WW2dZQqPr/xrhcM9Mggl/E7K3qcmF9G+49UK/hV0ZR26zoIhahhDehg2f0Wkun2fX4gpE6uNPsLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734275730; c=relaxed/simple;
	bh=nVj1ePUHSdiZszOOne2uSy2yZ+V9p36MnbwMiwYdqHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hqtf9tGEPR/3GpyL1uAjZ+J+KTujvc7M4eEMupHV6jwyoW89nYJE9KNvwyxkZQWzZ+flna63MzceNXciWZUzm4bE1Z/P4IwpgQApFGoLboiv09855UB11p5rLPEC/eE9mZslI852yXd9zZKwKqpSN7eqdzYZbZRf/EK9/KCi+V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Llh7GTJR; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Llh7GTJR"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2efb17478adso2758171a91.1
        for <patches@lists.linux.dev>; Sun, 15 Dec 2024 07:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734275727; x=1734880527; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=zMH1t5TJeAAC5X5Fjv+rFhIKRWsX9ukOPLgoXh+myGU=;
        b=Llh7GTJRQoQh9EDxnornl+B8pHVAFggJeNJMoAoqPXIIqADPGPzObBTAXQwK9aJCKx
         vK7B3pVOOop0n+23GDOHGJdnFI7EzqJ0cyqZei9kKPvC5l6h4OYuEHhsJqydv8vLZ27r
         LoraDphaHk0Oo0Uzy8s+H0JptE18Iv0y24XtBWAzIG5PkhP9Yulo5ZeUSwdITiDcUcnj
         vQlR6NqeO6u4DMafC8cqzroGRqWW1tGBDJ0mglBzTLY+A4tumpcSziMINicHsIVQgZ2P
         YRGGe7+FqmnrXDdVRtk9b0FBSTRN+t1waQvcc9RKX89dbYySpVh8MUttZ3zN6WxXF2JO
         IgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734275727; x=1734880527;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMH1t5TJeAAC5X5Fjv+rFhIKRWsX9ukOPLgoXh+myGU=;
        b=VQ9jQAUIF6InrLQ9quhUFNf9+FNm5QWae1BNJNN2l0mILy7JZTDDSytiypwuN2atza
         jWgksyH7SjuVb5UB2uS2ErEbVnEMhf+tZmNMp3pHSQcaG3qkKE4FVjFS5pcaMww07pj5
         9XXxRyNDOQTjovGKx3Ny4ugLQerausf0y+OB8xkMaDmWPqwHKx6Rn0lM2cx95o2czfoQ
         /VRR0eMZKtD6/Z9+ZPJckjjeO7CNzJP20mGKEII9KFDELyUPIR0bFtFZqdDG65ki+R+1
         lgI74L1wzzBD61/CrOXeKqrY7YzigTC0cjbpKaf9Ct+P0JCu4vmw8hejlU2QRoAeT8y1
         Hkgw==
X-Gm-Message-State: AOJu0YzoU70hm7ksLAuk9RlN+f/JoHdyPK5XT3WYRXF/RCS1aiIf+Gqu
	jXQCpJMVlBbRLANG4p0L1nUPDvwfYXeMPjYD6z7n/kusnWlMca2c
X-Gm-Gg: ASbGnctG1KpJTRlQuzz3b28LupGbW40JhFeOEstihth5TmnJ2biYWdMiWmuYnfRIrR2
	p7lRuR0WY69zlXElPx0N7scVaZ3tb/YNOLNXZBuHOI+YoPbDOuynQ0xx7y8X1D40POyIY/E2xpE
	fvVTuG09Lt6BJ8xNs7oJ8KLLmA3G3amI7htSPaZXyULz/4gHIX8jSWrFZF8D+0zhZzHRrsWHeXv
	dx/nM3ycuCPWc3PeHG9XIgNlpckQeetcHQvPaAsswTlK6tvQQTkGhB8j6jvaqdNnAJIUaI2OMrO
	gG0R6D6CwnboK15WBtYbgimhb9Bt9Q==
X-Google-Smtp-Source: AGHT+IF5aP5DBq5UO81Y5ZI/XhwDXUIXR1lYDrmTONuNGxGgROiWSOt3c57AZdleQXJ6Jk3gG4w9Xw==
X-Received: by 2002:a17:90b:4a04:b0:2ea:3d2e:a0d7 with SMTP id 98e67ed59e1d1-2f28fb67655mr15392839a91.15.1734275727446;
        Sun, 15 Dec 2024 07:15:27 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f142d93470sm6385465a91.4.2024.12.15.07.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2024 07:15:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <68b0559e-47e8-4756-b3de-67d59242756e@roeck-us.net>
Date: Sun, 15 Dec 2024 07:15:24 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/459] 5.10.231-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20241212144253.511169641@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 06:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.231 release.
> There are 459 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 147 fail: 9
Failed builds:
	m68k:allnoconfig
	m68k:tinyconfig
	m68k_nommu:m5272c3_defconfig
	m68k_nommu:m5307c3_defconfig
	m68k_nommu:m5249evb_defconfig
	m68k_nommu:m5407c3_defconfig
	m68k_nommu:m5475evb_defconfig
	mips:ar7_defconfig
	nds32:allmodconfig
Qemu test results:
	total: 480 pass: 479 fail: 1
Failed tests:
	m68k:mcf5208evb:m5208:m5208evb_defconfig:initrd

Some details below. Reverting

ef1db3d1d2bf clocksource/drivers:sp804: Make user selectable
d08932bb6e38 clkdev: remove CONFIG_CLKDEV_LOOKUP

fixes the problem for m68k:tinyconfig and m68k:m5272c3_defconfig. I didn't check
if it fixes the other failures, or if the revert affects anything else.

Guenter

---
Building m68k:allnoconfig ... failed
Building m68k:tinyconfig ... failed
--------------
Error log:
m68k-linux-ld: drivers/clk/clkdev.o: in function `clk_get':
clkdev.c:(.text+0x1b8): multiple definition of `clk_get'; arch/m68k/coldfire/clk.o:clk.c:(.text+0x44): first defined here
m68k-linux-ld: drivers/clk/clkdev.o: in function `clk_put':
clkdev.c:(.text+0x23e): multiple definition of `clk_put'; arch/m68k/coldfire/clk.o:clk.c:(.text+0x114): first defined here

Building m68k_nommu:m5272c3_defconfig ... failed
Building m68k_nommu:m5307c3_defconfig ... failed
(affects all nommu builds)
--------------
Error log:
m68k-linux-ld: drivers/clk/clkdev.o: in function `clk_get':
clkdev.c:(.text+0x1b8): multiple definition of `clk_get'; arch/m68k/coldfire/clk.o:clk.c:(.text+0x0): first defined here
m68k-linux-ld: drivers/clk/clkdev.o: in function `clk_put':
clkdev.c:(.text+0x23e): multiple definition of `clk_put'; arch/m68k/coldfire/clk.o:clk.c:(.text+0xe0): first defined here

Building mips:ar7_defconfig ... failed
--------------
Error log:
mips64-linux-ld: drivers/clk/clkdev.o: in function `clk_put':
clkdev.c:(.text+0x0): multiple definition of `clk_put'; arch/mips/ar7/clock.o:clock.c:(.text+0x1f8): first defined here
mips64-linux-ld: drivers/clk/clkdev.o: in function `clk_get':
clkdev.c:(.text+0x654): multiple definition of `clk_get'; arch/mips/ar7/clock.o:clock.c:(.text+0x28): first defined here

Building nds32:allmodconfig ... failed
--------------
Error log:
ipc/sem.o: in function `perform_atomic_semop_slow':
sem.c:(.text+0x834): relocation truncated to fit: R_NDS32_9_PCREL_RELA against `.text'

