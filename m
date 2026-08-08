Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26EF3FBB44
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786192458; cv=none; b=rJVwbR7Xt8c3MpgPjN1j3Xqp4JXQh8gE8d6/u4Vinvi2eorFnYSDNGSN4PLfDeS/EQUA+kj974Y8Ff782SJVYuf2v4SYRf7lm21z/P1vKPpx6GPDmyIzph7Pu8M71h4TDk4//L5LTOvv2n4uOMkfd4fZOAhkeeXatu8Trz8cXSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786192458; c=relaxed/simple;
	bh=VO45/OrpvyMRSv31o6DUyBFT40+x4My/isyMECLSRTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuIV0aXP0PFnjVCAQAgX+Y6CS7A6eYGNw8Hcb1u23d1mVmzQ+Q5/rBAkvUQOxLFCn5Sen5r6Yit4hN9tLHIeJm3QjT8FwpDdVdH4zwMldnIKVpjq5nKXOtOLB26cht3sQGg846V9PEd9c2aMZNK8yJNFgp67bQFJFG0LYzvwyYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=RuB31H2Q; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="RuB31H2Q"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hHL6d18rgzKnXJ;
	Sat, 08 Aug 2026 14:34:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1786192441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=asS7C+y/dFykJyfRfzEWCUFGhwziarJWy9DBfLDG4v8=;
	b=RuB31H2Qpm1Yiz7tomqvaCirRf1R1UfTL/fPXA/LLb8Lz+ZFKAzuz/Cl4X6+hUFHxPMdGu
	6seA01npyXGaGYOOJayi8UYdq5JpPXL1rGrIZGseexbRyeYqwkD3K3aCV4+WCKqY+W3fW9
	+9OKUeBrgt39j2n42Pl4MXvTk0rJedyXhe2xtFwCTDU5XjTkcvICm8sGrIBGMuMZWtU7Ay
	TsMg0lbEW96VtPGygmwzTG3bphLrjOvkPYjAwhphPoJS/0erBDfBGZ6PFaYQPaJ6G26ght
	DBoIcFeJhApXerQSuU2xt5WGEOx2l/OcVRTKI9WF2pW+FYhbdyLrRmYom/ETnw==
Date: Sat, 8 Aug 2026 14:33:54 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
Message-ID: <anchJ-8DBwucRYKW@bb-82jq>
References: <20260807143428.008222056@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
X-MBO-RS-META: abhyp8kwpzuwu4anak5mx8hccbkxxt6t
X-MBO-RS-ID: 4116689aac6728e52ea

On Fri, Aug 07, 2026 at 04:33:16PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.1.8 release.
>There are 438 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
