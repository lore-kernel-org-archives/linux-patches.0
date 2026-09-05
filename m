Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A44A36195E
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 20:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788640095; cv=none; b=iASFzALapPYSA7KdG+fIpPJPEcwRI/5/z+uwwjj2M8H7pPuUjlBhrusuKKhQ4Lsew+0kp1dOM+mAf+f+oa6yCbdRKtPvWa6vWrB8g8XRsETVql13HrOaM2200GTiybBw+JlTxvodn4WiO4EBMEr27XLNWfnuIDtE0yJivfsyKe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788640095; c=relaxed/simple;
	bh=KMbu42rQIzGse5Dp2stwDECxLjDm4w6DAw+5ABPMD/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5+8P0Yfr84E3vr0euDxbgyNbLgGC44+JubC/V2stRS95PKckMhxmpImSF/aRVwbpVj6VtyETZ+fkCVzLoD6IoezV6et4YFut578/R0rkkDVGNXfSKX+iK83gOdW4K6eubR0DSSr6UBJdeXwbjQJHs/lHTcfY37f/kTRyhBRmyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=lD27ZgUU; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="lD27ZgUU"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4hclJh4YWZzKv7h;
	Sat, 05 Sep 2026 22:28:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788640084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZGfVLFKEf+uMOs1gGVTaLNyzv1C6T+RdHBAN8sTXH34=;
	b=lD27ZgUUGWzBQ2wbds2+A8HoneNsPkbNtjqt9RkLHlHrQ0fiEDlUYMKnt4tkpUKy6Hfhnn
	aGoxySTJ3Q5xGSjbhUdkZ2QjhPIGUtxVZa2QlQfTiFUV3zyEDpR5Df7MttW7wbobuOsH7m
	R/MBLWf8LI23MT67QCAtWy+C1WRyW1IPD1HErSd3BcxdzIIhRo6g+BEKjQZUwhr8Uhwk5V
	NvY5lKeIdPIZWcjPAy76NMocRktl6sn6B0OmkNXJkL92YmdIW8p2RzZYTZXwZC2f08ePMc
	UlmphHDkAOIFpbERzfIYgIzh30TDBdyscdvRtF7/pmNkH59ivft9tiprl8C/ZA==
Date: Sat, 5 Sep 2026 22:27:57 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/713] 7.2.4-rc1 review
Message-ID: <apx7I9IkyHKamLqA@bb-82jq>
References: <20260904045803.810145556@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
X-MBO-RS-META: 5q6aroc3uxhb4r3k1wqwqk7kg9pht563
X-MBO-RS-ID: 65d00aa313a054d1f4f

On Fri, Sep 04, 2026 at 06:49:28AM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.4 release.
>There are 713 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>

