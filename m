Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B7D1F471F
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 06:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771999403; cv=none; b=KhioYXW4pjpZEc4t2gxa6CzmPQFymeS8hfO9WSr5XikwkcvDUlmM/tcxU+RmhB+EjhkYtJ/IRr5rlOh/I8lTAvTmbqLkMmezYKoPekAtMZvGVXUGVWSSb9ru6sLeIcfqXR4yet2qI8zlaBwKGVDZ4ubG0GL73bTrJGaja9BQ7xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771999403; c=relaxed/simple;
	bh=L7v49LM4lCsZ+L4lXv5UKTamNxG8cMhiIDrHbw4AA+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AED/2BlJ+EP/kpWBkHsSiZT4mFOOpUPrOAmkvNr3Vv6Mt7kPw0s/nbYf4YBueIjqJibDqOBHRKRK2qnHTvlltOs07OR/MpR3VMQ2qoXi1p6cyXRo8IzXPfkqJsDjmpgAQRYTuWof0ps7dmFoEHi3fWPhQOfPTHPDsS+eY65AvdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xis2XnWi; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xis2XnWi"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso70271775e9.0
        for <patches@lists.linux.dev>; Tue, 24 Feb 2026 22:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771999400; x=1772604200; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VWLAwkGbf7uUhd2DqbFT3Eii2hgXjNWXQkU70sx9YHs=;
        b=Xis2XnWiDqp5mgF07i2XiLYj4MJ4y7T2np5bHya4jXTN0FzPMdZOVk2HnW5YmV8FbW
         aJFNnwPLM3L+MaybmlfsJ4i7H+OCeWoBET2Tmc2QXZ5veUKSrr4E2efSpi6Ic4MsVg2Q
         VKiKYVi+YBhpLcSiFGDlCnnNdyJFuzDrJE/06gUfkT+heAhjYvQ9bA57UgShCRGP/PsF
         oTmdMhKWXBrUAaSW2gSGMjW77dQMaOmttU27g5uvIoTSpmKl6CuRU2N3MWQsL+ikQshE
         Qllt7VS9sMV1L7Qb2ovcRru0tqgMVFNoPuXomyRmoT/6LrhfD6bhMrlNOM9xkZZD7hZV
         +tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771999400; x=1772604200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWLAwkGbf7uUhd2DqbFT3Eii2hgXjNWXQkU70sx9YHs=;
        b=LoCehwSyzVWNIvz7iKTKJK0wRvrd5CPZwZEcfKTb8SFZ2+U4jNGkNCM6NkT7+yY2DF
         rABjgu2C6bpuNQiERGYWT6M3NWueeF9CdCO21l5BrRFuXzo+gMkpRWegD8N8W12UgSCM
         VxAF/i0ui8GgrcH1U7c26oUlgiGKM1vcGOY3MavBNqSyZZPczGrKQyE026gKaBVO6cGn
         QPFf6UvmupfWLNI2bKATxlNup/z+a7n0QZHCZ85TndnuXeMjLvYKvpZmAi+iiqVDBlph
         CLuT++gzs532UxiyWjt3noWcSF9vP+taU6nuOzKnABQJdiyehR5rSrhV63qlpVav+iwA
         zLmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCXDIkd2/SocfFm3VPZAvVOX28Rh6YM3nWiwFgWgbGoTKwZCWOHuO6bEPEJsY29xbi5SWX06+a@lists.linux.dev
X-Gm-Message-State: AOJu0YxJd3oaSzQNS3Q8SHEfOt4+GiA/DvnDS63716yli9XAHfpuMadI
	yTNm9DgSAfW+duKuCEFiCZSQDEtmhBX71Y5BIC1G1WJEmHSjxCf5fnwm4Uauoayw2j0=
X-Gm-Gg: ATEYQzxkN8n1HhnCI/zftY4pBTSklxlwyhuIfey66RUUJ3PJN4xIQHHlfPNygcprWT3
	mLajK6mNvZc3yLv4NuHnRqdkxGVpmbA3hFLiSagNw+dJWjZn60eJkT3Ozn9u4QUP5qVx8QixCH2
	+Vz2EGn7LEfjiBwlN9ojsEwsAHEFPzM439eahigTEUkodm/gCCb/si5lG7n4te4yyJItWxOe3su
	bZygDxkduXehU8BR0galkRtPp24i5LLQXPDt0bqF3RsygZRxPp51pX5r3GCIRxIzdsnuV9TZd4n
	VLe/CZZn3t20EYJleznsgx/1NIOwFiZEr8x4z26NQi+XVfVxDxRNiERdL7yieo2YeYaKCUfHi87
	8t0/zhY8k1Bd3pNNEFeyd0sETRhS868zL9eNb31t7Xgcz+kC3XPS+kI7P1jmETasHYsf9a43cNZ
	TkMnaFOqhIKaXgr6eptJge5qmYhcdf6t9wLTZ3HZw54DmaCIp4eS7zXKp7XyrnJ5Zaajtm1aM9e
	agDay3aMIWrFX+HViVC
X-Received: by 2002:a05:600c:4e4a:b0:483:71f7:2797 with SMTP id 5b1f17b1804b1-483bef2c0eemr23684675e9.14.1771999399921;
        Tue, 24 Feb 2026 22:03:19 -0800 (PST)
Received: from u94a (2001-b011-fa04-7b92-b2dc-efff-fee8-7e7a.dynamic-ip6.hinet.net. [2001:b011:fa04:7b92:b2dc:efff:fee8:7e7a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74f5dae6sm131631065ad.21.2026.02.24.22.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 22:03:19 -0800 (PST)
Date: Wed, 25 Feb 2026 14:03:11 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc1 review
Message-ID: <xidiil74eoo2ivxxekipdwi53slry3naevkmeee4zsuxl7iw4u@nd23dorketj6>
References: <20260225012359.695468795@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>

On Tue, Feb 24, 2026 at 05:11:49PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 01:22:34 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/22381308704/job/64782419806
