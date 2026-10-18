Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D033E172B
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 10:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792319043; cv=none; b=HKtnBc2zoJKmGQrFinumzohZd9+TH5VJNgkwmZs+ChC8bABk6h3ACu3U7W1Tit4Y+L8mveC1jFfCSDMmVH5HlOQS4/ADeQ5tIRlkqPYjo5S6F1C54S1pu3dG3nMog+iVUQ5LICuZQc9gKXXyb7Y0bOuUbgagm97xuNR7ZF4Bx/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792319043; c=relaxed/simple;
	bh=mkFEDrApwNVHnpQW6fTa8SONt5XnpgCHj2+JtwTAPr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFC7lQ3IDtrHQfmwdKQQ+e8QIRGTlimWlb2+d5OolFaa9cifAIj4Evj480ibZ/Sz0buWYsmlejpca8T1m7P+22yjFGTB5lSORbbMIvv31mt3GGLcVcCWB0GobKtvSMTCM8m6OWOkDs0jA/GLB2l9Jp/poE/4SqCUZPJTrasWST0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=I7pQuRXt; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="I7pQuRXt"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4j6vsp0BZgzMlWp;
	Sun, 18 Oct 2026 12:23:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1792319038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LfcGtuFt14aLawmeFdDDC0cmMdWupykDob9ZfZ9H+l8=;
	b=I7pQuRXtPAlXwax2SnMrytZuYFenReWkIlUuqleDbJGu22nco81I2YoOfTugxwQ7DMOW1w
	SgOBPt2eANbzYsjK9aJfxlRBXBAF1EYDo4FJ20ipsQ483DypbRGr8Hm4W7Eg7Ko3oGnmxD
	R4qg7hoI/a1DEA2jGqzNW68iv58+T6WbkMjQZB9SSTQvi6oIbit2dGu31MD1zVBPSKIwRn
	eKuBH2mXbgPQ8uRWBNZNHu7mK9QzJiOScxpQWr2+/JA9zxCNvEr3fF0Q190nisPMQK4JnN
	ZUZJSFL2tDlbbImGSDJpwXBNGNw9eYnj2/Ax1m4S/o0B49TFrtelwdCa3mZ8LA==
Date: Sun, 18 Oct 2026 12:23:53 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
Message-ID: <atSeEcAqpKIl47lX@bb-82jq>
References: <20261017155059.698368299@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
X-MBO-RS-META: 81m6zz81ytpq7tnpnpmdjd9tnm7mz3m7
X-MBO-RS-ID: 560b2b1976b406a0af3

On Sat, Oct 17, 2026 at 05:54:29PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.12 release.
>There are 10 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
