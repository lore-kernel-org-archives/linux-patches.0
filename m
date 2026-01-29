Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E171340A57
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 02:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769652650; cv=none; b=tKWn8p0XLmxgM0umI5ka3IZ7xUp5ESPwHgaLIdN1PkMyr4XoA3Sb2v2Y/0nig2p0vJcBbvIu+iCfF6MbXramQ1sXIdhumt2LvEebed8kuZYHtQBP9uW9wieQr6v9RHhqgsbFvxoIneJ5MxvXPW32C+D4LrGxym2e2B+bW9bRzBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769652650; c=relaxed/simple;
	bh=zFWk1e3r/M1fMXJm3gZiS7LuAom9jGmiJSVg7tfkmC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVmbkh4Qnqi4ive2ano1dAfQ3eOjEWoYwB+beXgB9iF5S7+zyHkGn0kqS2z3c1EHB8cFV0XKvwFGbklSQC1MCbOQrqytm3my22UPkJyPKUYhsPQkHL86KDPHigSfgRE80jciRKmmHyW3G98PwerGojjtEdH59wYTBL7cSqgd8Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=hEOguBf8; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="hEOguBf8"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-432755545fcso337701f8f.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 18:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769652644; x=1770257444; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mdo4aXnLBT/iiMTMoK69hkdn68r1wpFyn2j8vkuRgng=;
        b=hEOguBf8N5FEy+kDbgefpFBv4Ui7BVtCaka8JunOutgotDXDeiMc6tijSkEf5Nv/7X
         WogkFYa4WgxM5URkedVrtlRwc/e0hNMvbh1fy8wVZzVlvzI5orlblCgrXKUtEaapqDk7
         0MbSelA5k4h455/p0YXLhSeEIubox9+lVtA0sOHNl/MnIsEvEyfn5UtRoFmaZaPVAzcW
         GbsDbd98Y1K5Ihk5tdalnL6BWY+pCR/l/xqJna0ZVmHkvIGESZg0lH1LVV5otuTs6/xB
         rmJvqLk++oDLEiHMdIP4WPp/PIZQ9iUjO3p6wSd+3yUY0HjKW1bu0ki5jvhJejMhQIaV
         ZxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769652644; x=1770257444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mdo4aXnLBT/iiMTMoK69hkdn68r1wpFyn2j8vkuRgng=;
        b=IeZN99Pmxnzsd952CGfGx49i8Ctf/C9NjKZQtJWpEUXENVHpmanePkPNciY2tzo7SL
         toxzehPpChZ9cp4Xl8H3UB6qocl5bo1+0lPMTuedojRmirE2lYXpsF3xnXExJucfbI5R
         RrgSJ6rvl4GPKLIFgp/fZ1vO0hB0KSDHQQqMUVsddlBsh8VFNHvW09UqrlrkTSHlz5OU
         +uo086GAuYSh/IVfFEeK+lGDAjitgwjQO0uH2bb+A6X41UUSESWGSK77s7eADCaM2Myt
         njNuR21HNn7Mw9Cu8K9sbWIow3h520nHXetxd/U3m8Y5dHaj5d8XK+2T9m5aPHOmKrow
         floA==
X-Forwarded-Encrypted: i=1; AJvYcCXlrytC5OUVexc6fj9VU5wEJJabuHTeVfsMG5I0b0WTgJF2SY4x1n6/DZaQaC4a2SSurWkUm+vJ@lists.linux.dev
X-Gm-Message-State: AOJu0YzUlVoD9mcw6RGhMPdTygKyUEiVCjRYl4seuPOPBThCEhzVO1ZI
	hTwpy4WKehzQmRpYjfdTdcjQ9G1aQo58BhDjOOxaLE9kfNdr75DDlcLQlRpZBXMWzTE=
X-Gm-Gg: AZuq6aJJGcTIJgHOtGKQ+9UD328T8d7o6AgMjrEYqgRx1IT4g0hBhkdEPd4Z6pRoB98
	swTBHxxJH5HksGeArBhrG0tlNAS+GiBJxt7QOhQIovKCE3uoB5r6nczynFaMBuIEPbMv7ZwADQO
	/4PjtMBe7LjB7BporWcfENkAEtF4Se1mSKbfrw/qxa9GF+/wvIrh4iLwHvqcOSal3XKDoJ+9idZ
	XEkyrs74000gseucdcbZABkCJd4NZCLAxhYmOL7R9Ht7RS0sZ/+7JuYM31Gg4WpZshWwxdLZvqG
	+VWQmO+C+zp45T1KQChi6MzE00jKfDtQdrpWeY5s1XpjvOuyqfqhVhCGLIHBShDVLnRQEM2HyUC
	es2QRWTUh0H0QAWtcDryTxsi4fHoHtL2UP5aGPR7N13avXK3MJ686PlkU6DLN7WgBeuGrH8ULCW
	HHTRV5wU9qsSStM5eb
X-Received: by 2002:a05:600c:8b2b:b0:479:3a86:dc1e with SMTP id 5b1f17b1804b1-48069c73ce1mr90022925e9.36.1769652643751;
        Wed, 28 Jan 2026 18:10:43 -0800 (PST)
Received: from u94a ([2401:e180:8dfc:3cc3:8fe9:e99:6cdf:244e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379c50fccsm3650437b3a.60.2026.01.28.18.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 18:10:43 -0800 (PST)
Date: Thu, 29 Jan 2026 10:10:36 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
Message-ID: <potwu6hrwb2gnasbsl55jzamqrh5rieyld6xokftzhm2q6bhpn@i6wipgeac65k>
References: <20260128145344.698118637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>

On Wed, Jan 28, 2026 at 04:19:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21450963930/job/61779347519
