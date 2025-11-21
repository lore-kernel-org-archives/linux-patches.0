Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333581E8320
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 18:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749330; cv=none; b=ah9/hEVqwxNxeuVRH7rSNTbq7wvV73cbSfuMob+9XM/p5b18o22wJPSnkyT/FQ8rs1XVgYnPv79Cl/EW/7hQYnhnO5KtwiPOHLRHVoLOg73BkGVDL16sBjZ3oAM7zexPqMfiB3De2wOTo/HD1KWiOPeGiD6u/8nSVAQ2HHpx40s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749330; c=relaxed/simple;
	bh=fKLWeU+mvv+lELFB7zRAfgFbuyBdL30rpqdulQlpDpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nC0ms+D/T0i2gBPh7wyQH7giQmMrq4LGlF2Ul71ulRta50jriGUT0ITpfKFvM4BVeDLB324WCxYGvUccQbXjIyD8IyD1TYN8f+IfZCWKxS7oSJId+jpgfHgfb747YOidDoXRDCFhgWVL9tdoDlDrpHx1k6pwW9f/zu/1oKqKCvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LLxOAmlv; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLxOAmlv"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-297dc3e299bso24494685ad.1
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 10:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763749328; x=1764354128; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ilgbmsIJ1j0KJltWHFpHfevy610h2K+d7d+0zN3F/9M=;
        b=LLxOAmlvVP/hITK9c9PFtsgz87O/EIzTj06nDjtxeNDCAf4iIpoZk6RJCJQydvYIwc
         p1tb0uI8XygtUmliydxtRRxpegFAG5M/iwkaWc1uZiI3DO0MFol2xJPTBW2ZjjimhAaK
         ML1vPzPblfDTvy3OxdoQiERsoOfzE0/9e6xt13xP8bq6LRudzh+d3nW1Jw/kY6A3mpzz
         WwQB2w/dkHWjP/TFiybGHLybau5fXG497yG8wRt4Tmeoy58odp6LchXW1CCLTeRbbAO1
         jCePmQnIFTWsiu+4PiepXs+mNbGHwpQXOxPki58emzCkO17RNqbGLxJA79FX3LYfLe1Z
         TieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763749328; x=1764354128;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ilgbmsIJ1j0KJltWHFpHfevy610h2K+d7d+0zN3F/9M=;
        b=RIfrhIkhjO+ugdgKY/rTUbllhX+bWIwsQUoJeu1YapG55N6n1iPHdtqJVN4JaNhQWq
         Y8d6wAKZbVtKtlbWuKm3UsRhoBMBbxC57KgsMsijC2YKhey6Std3e5G+anlGLox5wJKR
         /BHdG1Tqp0YCNowYIw3uDF32zg9SBIVdVwR2HWaTBfNclTdwo6FydbLv6ibwVf/U8DkS
         nc/0iVCORz+ww/CbyWgWEwApZIMBBssnK9KPfSty+hXxs5H+XVqmL/WHoJOU8Zi4kM41
         84JPm9ojCWFYHba3w+PCTxviqZ5HQTOh7HK+KoYaSPFGbXeHkLh4phSALvQe6l4U4L3/
         AhZA==
X-Gm-Message-State: AOJu0YxKJrZG6jRhgd1VCrLOW/0r0k9wKayUyCYDR7aRnzs6fPa8Via3
	RI/Sa0AVB4vOnNhoUAJ6WtV5LwImg17k3HlfWo6sA+4ldR6irmBtbjhQ
X-Gm-Gg: ASbGnctCAVg7VV3gcpuupRvuYUypLLOdQrPGGMARo983axbQt+C/s9R19AxnQzsfQcg
	CTpH8DUSNcd/1+BwiA+cMMCBLkcTE1esJyty521WqF/BCIgDGwO6Fe+H6B4ph9pJBj9EOK4Tod2
	gNmnBkoF38QOIxq4k7MD9jP4tl1d/zi5e0ulgqcXw0ejZI6N/w0n9UiSujL1ilHRU8B3QVA/e4c
	IBp85bDVKYMVl4XrpWONk8yjl9od1WWPI39Xdwm7EYas+j+uKsb3cS0X0YvIrYt29ESmXGBWOfh
	bfyoLs0wP1U9/jPhWuTMI84+86Tm0ucb2gWL25YElLXThPJ7lasYL8Ikc/h7VDQHTH7vP1nHPdQ
	PZKWVL2z9wh1hghedkrE8r+kxzC4jNKG/5cg/sF1I5qdfkCaot3gk7ADaZXxx7GnNwhl542akV8
	JPxrLtJcQ+RiRpHpupOAKiyO33PsB5UBkUfa+vLQ==
X-Google-Smtp-Source: AGHT+IH8hbBlzvqYRFzIPKqJyiL2DbZcQ1P0RcoVriGzy64BNuTiJSmpQhVZ+EIjGJFvqS32RaZ2zQ==
X-Received: by 2002:a17:902:d583:b0:295:4d24:31bd with SMTP id d9443c01a7336-29b6bebe2eamr42752635ad.17.1763749328420;
        Fri, 21 Nov 2025 10:22:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b107ee9sm62524545ad.1.2025.11.21.10.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 10:22:07 -0800 (PST)
Message-ID: <4a3f450f-cf7a-4c5f-861c-10d15b9e6733@gmail.com>
Date: Fri, 21 Nov 2025 10:22:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251121130143.857798067@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/25 05:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
