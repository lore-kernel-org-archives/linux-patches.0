Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792959531;
	b=NIr2oE0eoILiqweWHhUJUja0trNMOA8sgUwkUGnkst74Xt4R3dOcDVlRHJtCY0A/IBbu
	 NZS7wTGeX9n84GfQByqQ+4UxQ1UY9KX0IfSq0ny5KUrF5txrmSNuorK1DJxb69y4MNRPc
	 x6kJ3Cp+D7QJnuxwV0ITGtvsncCPBiS7EGRnZRaIaGz/tHyVb2v76AO+BTx27bqVZWBgI
	 /9Yy8yI7cdEyjW4DnJXgTdO2055sFZGP9ahcfI0llPFxyqaboGyJyd386JvK+oXe/lhJM
	 izmuTn11Pg78z/Fon6/2XHnADGoUoVp7q9MrgRbF1xEd5ZrYfir8bcHCHEqGanY+kjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792959531;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-MBO-RS-META:X-MBO-RS-ID;
	bh=3WngVMz2hu0pYsOnMfvKGBql1YtI6BFCAaqsx3coqmY=;
	b=u6/mdKdO1O6IjkD1BXoK5R1PcLLRYB1DNfh1iU6AVMP0UBrzM1iHwGzz5aMquK6PYLfb
	 bWOXMHOEbMT5EWbA9HjOMXnCha/tm8tiipsmQTPYlj+3aP3JMv2ay/Bsd99E/f5luPuRU
	 EijT+UarPvdWjP3bek/8gAH/ebiIozLSsFGxjUXk4r1C0Cx1AeqBVSRz9M3omTOyy7hlm
	 NKCbKtY8IiX9JVCxfh803sEtudCsWp9867mDTY29kD9/ctftj60JxcYfsRjHzql/kUIsY
	 y2bM6ifq/uQhrcekKqcH6NQWLOhdmSPWdvI35sr2AHgPLUAlvbYCqd3xoguUPLVZesw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mailbox.org;
	spf=pass smtp.mailfrom=mailbox.org;
	dkim=pass header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b="NSuRj//z";
	arc=none smtp.remote-ip=80.241.56.172
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11567606A31A
	for <patches@lists.linux.dev>; Sun, 25 Oct 2026 20:18:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11567606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=NSuRj//z
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4jCSkt6YXvzMlMn;
	Sun, 25 Oct 2026 21:18:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1792959526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3WngVMz2hu0pYsOnMfvKGBql1YtI6BFCAaqsx3coqmY=;
	b=NSuRj//zVir8M2K4kua1ptN1SsmDqaH/zH6ZGkpEZifufH8cpYNp4fOEqypDcpbcQ5uiXP
	W5OrH+/fu5a3XqF+a1/Wxdrs2d3lYHw6BB2M6NFVRGE4haLfqNNw+eq2Fs6XRxx3R+9oNj
	xxC3IP5TL/okeIwHlBtJHs1XWxU5puM9DKu5TC+ujJ4iaBUlKmP98Cl5FaJ91u3q2v9Fs/
	JS5ynUthUC7KBPUblqZxbeEJx5bpkXq54Yy07P0P1SUHDI0TVYBg2pkLVwhuvVw8URT+ai
	XHxPWH0K45yZwDIVirlzb6uawMXoYuxO6MYG3WqLYY7UhAFUP5/7LR9VUVngOQ==
Date: Sun, 25 Oct 2026 21:18:45 +0100
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
Message-ID: <at5j5efaqgB_JFgx@bb-82jq>
References: <20261025125805.309934791@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
X-MBO-RS-META: m4msyzkou6zgf1t49ac53om7pax7m86t
X-MBO-RS-ID: 576413d78debe3925bc

On Sun, Oct 25, 2026 at 01:58:45PM +0100, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.13 release.
>There are 231 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
