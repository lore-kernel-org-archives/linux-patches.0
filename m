Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794101420;
	b=RO14vjBuK0umUF+KoX/ld5r8Cjh9G9lFWlEMXNT+gE1yI4ES0R6XO2+hhcb+wyWfmLNE
	 KQfDfNY4dS5qgmU0Qh1IB/fSLZyqhIS3dakOYcjaCHLf+v5w1lmiLChtz4DONLZ43Ph1a
	 +eOxXD0MrloaVHH0dau2Ag5Gdh8pQ395zrqfLyII4013Ijj1As41INruSD8bpQjlvjniy
	 KvTPZyGlNoSlSQPg//WOwq2LfpT26hF18VmzExiW3neY7nkyCVG0X2wF0lBKz674YFcuQ
	 sec4BAXhlzPwy9f9d5tSVWQsMFmi38jcb5kgvtjfOpLtYPWnAnxpL3fTDjOMSOIycZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794101420;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=9Mc5tpEd+rEFEriA57HIWZrFdKcU8gh5hZIGJp5Pbms=;
	b=1JLb2ZlKITcOG4X3zFgrlPgPUAYgGBpezRYkvuXOUktQVHm7vCTIKme4MVsH+uMA9XKi
	 +qwY/D0KksQkd8qZH7tOgMJdi8VuX/K4ClaXPXS5vGozHB6Dt1EBj16Go1vamyvn8ePaQ
	 uxkLwOYqOsdFCly6p/eMKmXOCR3IA4ptvip3+ZRvEETZ7hIn87t68m6W4HnCrV7ibKuuM
	 XEJDp2W1Q9KySLQxwwfXJ3nMU/ebpfL5nW2EY3c3AyYOqZzOH3q8+PijhA4N2xv2JWYsd
	 wz8BiPzhvs1B22fcl32QG97dnOwSs1995R3YvodhPpcmi1/Jsw+sGr9yLSfFN6mQVmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FeACiYKG;
	arc=none smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BF6606A331
	for <patches@lists.linux.dev>; Sun,  8 Nov 2026 01:30:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2BF6606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FeACiYKG
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8a070755c8cso27527b3a.0
        for <patches@lists.linux.dev>; Sat, 07 Nov 2026 17:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794101419; x=1794706219; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Mc5tpEd+rEFEriA57HIWZrFdKcU8gh5hZIGJp5Pbms=;
        b=FeACiYKGLZwnCz9bsmDTyaqx8UxmrmvJ8V3WUD5SMpnIhGj63uHB+FCQZR9vi75APk
         Fpy4HY93jEW3tMJ2tZwbw0wsaND+bN5ECO/68yCSKmahd08H8mAZFmSkWnVR1hyf0mgW
         KaEIGHNcTPeZkRdA1k4ylWO3eE+iS6OEnx0l8iQsgQj4mNR+NjnRurfrRiPYRmOrY7Sr
         vz+ve+VHZ3NPB1WNODCofAvjF2f0UQoPRwv4BVYeRxqR8A/3+hftjnO/i4oq8J9ff53b
         dSLa42tI7z58INo2aLJG5i1hEbExmv/hQO8NtL5vp2TkLvcekGIg/N2rX/oAWNfCXMPR
         45RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794101419; x=1794706219;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9Mc5tpEd+rEFEriA57HIWZrFdKcU8gh5hZIGJp5Pbms=;
        b=2dK0RzZ1z6L6DGheK3vt8/rw0c33VGmZ2y9DxY6UL01/hQ2iy62+5PvO/U1Ux0sUI7
         Zx/wpRXiRevutx8CICiYCKz9UKoGcJli4PVGzgqtVn8/KX25F1E375zF/3bDspoDGa+L
         Nf9UkX4qIJ+f+OzmUfxLuK+YBJ1ijMUAytCfPBFbkkZe5w/RGfbTvGcdLNLTvFmV+TmV
         22OkXYCyE97WR8cQ7d/wLLV8dmEBsDs9mDI9BYUm5brsl+QPCxCiUK8OIm3mt2CmdXZS
         +jxGdor38LSc3tatwI+j6XoHcuWwmngiigq7GMcviPPzzxJ+ziDSa6PNhQ57breSgS2b
         DzyQ==
X-Gm-Message-State: APuU4Z8M0wz0nzEFbSdSdmZVIoELKoCobI2Ep1u64aZIMOqj2vwmUYuC
	1c/UoKqJYPxZe6p7cMjFxx/VYiXYMA9sfKtyQrD4H5Lr458DpePrj7dT
X-Gm-Gg: AYBFou3x3EKtWSveHE32VC1J1/OJPrKKfp2gkUZ7vg7zPwYKVEKIiQl5MktgXSz89At
	QzGLOMsLu/P8G8PXLZisP5RdJY4zGqoXNlznJX2vhehx3xQNyeERB3onFuhqoGXwNP9C2ga1v6C
	qU0RTx+IR+DWgcOfqoqj/EFuCgr0pWAb6QuB0x2xrJPz9wZvENbK0+L+DEjXLAQiET2iA4e78NY
	4T0f0bCNyJEB5ghjyqTGWumBuWK41y/D1tDx9dsh2tKIKh55i8fM2tdAPrWSNxg97PI/phAblMy
	5pe04sVWw8kRpt75uvpQADp5lZiXZ/MS2MarJKGZq1/QyGqfZxGLCdnoGlqhgI+FK9UZhZ+vWSg
	CXP85ujw+lULAZAuYnQx/SG8GFz0Vt1Ovwz+h4ChEDSEcirrZvryczZkpF4/quVUfr4dvkCMVnz
	n5RJ0N58nf1D2XBOcTMAbz+YHvNBGBvjPtt8vdMf6EcdNsHOrLVUb+GX+QtnvQfsJahbNi/pgRT
	IPOwD3Ax0mtx1wLcS4Fu9oSmv4EQSrY0iGLbqaIVtsAcCi419ianz7rGXzUT/BIDJ5vVFGgIvMA
	sQ6IVW03JqFvlZzMXIljK7dv4vK4c6YB
X-Received: by 2002:a17:90b:4a89:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3b12d6071a9mr171719a91.64.1794101419251;
        Sat, 07 Nov 2026 17:30:19 -0800 (PST)
Received: from [192.168.100.6] ([121.144.254.242])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b103472903sm2888812a91.4.2026.11.07.17.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2026 17:30:18 -0800 (PST)
Message-ID: <68e291d9-4696-498f-a7ea-087d87febe8c@gmail.com>
Date: Sun, 8 Nov 2026 10:30:15 +0900
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261107134939.434104957@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/7/26 10:38 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Hi, Greg:

7.3.4-rc1 successfully built and booted in my system once the commit
1564da6afd7ce5297ba24f2d1e61d6a79a9ff6db was reverted.

The error Barry encountered was not noticed.

Distribution: Gentoo Linux
Architecture: x86_64 (ASUS Zenbook UM3504DA)
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M

[    0.000000] Linux version 7.3.4-rc1-900-myllvm+
(user1@gentoo-zenbook) (clang version 23.1.5, LLD 23.1.5) #1 SMP
PREEMPT_DYNAMIC Sun Nov  8 10:04:35 KST 2026

Tested-by: Joungmin Lee <leejm516@gmail.com>
