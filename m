Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FE7202C50
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 15:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751903438; cv=none; b=Dn12EczCB0nmaemOEYanqJFyxFdp349hALjjpuDYlhAXg/GMFeV1jFio2SrNxpYOAE5bgV+0uUQtD8jSEBXVYeMbFQEaN+d2/RAN4eMVfmn74gTJ1DgSObpDWJ/QB4qVLxjYPz+mvCF50X+CdHU++A7XMv6u8yrcWaJDYFm0owo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751903438; c=relaxed/simple;
	bh=OE6ekrnC4M0MwVxy/wI21VNyfuRcjDfh+dlzwyWinDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQZaw4ajyGEbtwuXGOoZHxKLBxYQwPS6fw+/z+XY8EbhaIqP/R+U/PMroOEmP9CbvXl9B76cJywi0u/5ztLA4G+hsFLqIMgtw6BAvY1XxmFduW4qAmlSumbuL3YOy4oltxnigi1n4ASbZN7k9n8ymEkx7CHo0V6rpHikb/4Nfwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDvDwZtZ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDvDwZtZ"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-748feca4a61so1792897b3a.3
        for <patches@lists.linux.dev>; Mon, 07 Jul 2025 08:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751903436; x=1752508236; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uZ6Mv0OEaOEWA+/kiIxbnT++kjT9MBnuUPvznp0dthI=;
        b=KDvDwZtZ5Ej2YsCKhjrB3nsmNvCzLpmoQByksmvfDXysp1jCfPyl1hSllqigw4VmNT
         1PmWvTP1rWE7aGuduKbWW9uJ5J2Qyk5aEkBvSfG0CEu/rzIMMb4HB918psOK0mnc93k4
         pEvc4lmIDMXY/PSO2C+WP7FVYoiOCH+GNj02VaKR0cWHRrtA7seKHYdtRXj3NplUcCDP
         LrncixGzRxoBuPaBFBgfsk2r8gkjeb2C7ReFv00c0WtqcCg2O+WniYrEZRclru0BolPR
         nsGjF/+mP0I8sgDdGQS7rxs4VWWlMjvhvrcckNgwjFXqrj8FBxaNA1z0DKIjNG7GUo8m
         4UEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751903436; x=1752508236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uZ6Mv0OEaOEWA+/kiIxbnT++kjT9MBnuUPvznp0dthI=;
        b=GNXGgbxUShZNzzi9gvOlyKMZPL6QqZR0z1p40kiN/yerTUiTTtpYwX4pX9w63WKky2
         nkB6Ew2BMpML4ns8LhfgUwX/i5uCqNy48FCrYDQOqqxm56QIIFWrsoXzmyNSP9HUS7wJ
         c0QikSOXBHQTwU7CgC1++8EfRtTIP0o0+zhxfIof6c0s5pd+EDga/fgJOMyr+KJ583NG
         a4fTUPVKuxtHR3vgb7r6avLuPmrSmvJIT1i12XANdapgkgYMCCwt/iG8Co1y/w32drNV
         Y060FXVZTC726M/W+UjaRTL3mhXwujR4Z1Is0mNPZ7qI27ck2Lww7Fbk2wP/qiS8+xFg
         8rUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9v9xUWYSx12oW64ZU/rJy128a+RrZ9KFJ4g02u1TQ9+zTlwBh9lnKL1M0Kmy0M02TEmSwyDQF@lists.linux.dev
X-Gm-Message-State: AOJu0YxbWezen0HzXJVSI1dxZeiWz7gXDSHjnWwbRq9szxgMC6lGYq+o
	4+DxZbNeFlxRW9IPr1H7vcwSPxxE5237OYuRNFyoQYirdFzBZMVk4TJw
X-Gm-Gg: ASbGncuQUuk0EbcIWHG7PPXxh+hV27cTQh7mlmf3ix0C/rkuDhcZhkx6exocW9BOskU
	6z2hmQ/T46Zw/LSNPv3ENYu4v5g/GRIbwtKzFHATGnRcPi2ZuICCnNyTtk8e+UaDQET5/JB1/Ec
	9oeRQ9KR+nkfGm2tpW3EShhz/MEQs1a0iGOBmwDMF+ZnLpXxFB4Xn22PNKx9iEDzfy/B0mKmiug
	y6vK2PqtpAROP8nZUdF+4WrHtbRFN9sD+69q8peQ1tB2yclDmUYpux2Nfy+iJM3NVZPiaqBEi6r
	SrEQRVhjdOjN3XZeMY6XDArCP+yH9GKZCaM4rpf/C4Yrm/fYMz8Y1030ehtWOqkfHCV/yvL+ucI
	8ZtyM0vWmDw==
X-Google-Smtp-Source: AGHT+IGgkpmjbxpxYXCE/TsDZmOdCnZuD6FKwplAAj1F8D7VIhBlJe3WEWwr2tw871m5IwR8avA+vg==
X-Received: by 2002:a05:6a00:17a5:b0:740:afda:a742 with SMTP id d2e1a72fcca58-74ce86d45b6mr17451540b3a.0.1751903436355;
        Mon, 07 Jul 2025 08:50:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce429f5adsm9598045b3a.132.2025.07.07.08.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 08:50:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 7 Jul 2025 08:50:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 000/215] 5.4.295-rc2 review
Message-ID: <b648e51d-2244-4295-a917-fe1b0f391074@roeck-us.net>
References: <20250625085227.279764371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625085227.279764371@linuxfoundation.org>

On Wed, Jun 25, 2025 at 09:53:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.295 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Jun 2025 08:52:04 +0000.
> Anything received after that time might be too late.
> 

Building nios2:allnoconfig ... failed
Building nios2:tinyconfig ... failed
Building nios2:3c120_defconfig ... failed
--------------
Error log:
In file included from include/linux/mm.h:102,
                 from include/linux/pid_namespace.h:7,
                 from include/linux/ptrace.h:10,
                 from arch/nios2/kernel/asm-offsets.c:9:
arch/nios2/include/asm/pgtable.h:303:19: error: static declaration of 'ptep_set_access_flags' follows non-static declaration

In file included from include/linux/mm.h:102,
                 from include/linux/pid_namespace.h:7,
                 from include/linux/ptrace.h:10,
                 from arch/nios2/kernel/asm-offsets.c:9:
arch/nios2/include/asm/pgtable.h: In function 'ptep_set_access_flags':
arch/nios2/include/asm/pgtable.h:308:17: error: implicit declaration of function 'set_ptes'; did you mean 'set_pte'?

The problem also affects v5.10.y and v5.15.y. It is caused by the backport
of "nios2: force update_mmu_cache on spurious tlb-permission--related
pagefaults".

Guenter
