Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10F122687C;
	Tue,  8 Apr 2025 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125134; cv=none; b=PyomeDXWOOZ5+31qsHRG4QDZLwTF/rlDrofq81EdC5R6Ha4XQGQgrqsstOMDtx3xfXQ9Ohle0kmciIFOKrBrBOYINuL1UkxlcQjHYN6mZpJOw/q37Agr0P3cx2uXB3FpXlq9cgIKObBNFA2ZqVqOiqeD6x39J3/ca7yWI41yUZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125134; c=relaxed/simple;
	bh=0ZzJMOm4gd5YwODUB1mHoQAdPK+k2rtT33KdGDBf96E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ch7R8zq35Vg80LmMy13A5uYImlqs74YLgz5xp+be+P67hACKx2FV3Q7SOjGQrXqnmr2u+DX5KYlaZykjr2B5aJjHACxu9O4oAG9U57MBAPKFvv4Sog67S2n1yJozC0zTcm8jZ1i3oXzC44suHLG5RTvfP+jnHOwVRcWRtH2T7ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BN5fhfj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BN5fhfj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4224C4CEE5;
	Tue,  8 Apr 2025 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744125133;
	bh=0ZzJMOm4gd5YwODUB1mHoQAdPK+k2rtT33KdGDBf96E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BN5fhfj3DYcY1wjF1f70zw16LIUQtEQFCTWmYx64WDu3eep4pP5PgSgLu6EgHf0SF
	 xmrZU31BKM+MHsdtlrjcRPVOF6Vd9V7yeJN5D9mYpgxUKNmN915V6mFAaoL4gdtJUp
	 7LoF3MZekXNm/ezhZUvGXTVJxl1HCSK7+oKV37ec0uCOzJwq8OfvHdO4S7vqNDfh1i
	 e9IVC8EtGKtiMBXaKYkXh3OxXGhKegCxY9ryw7qNCS6yOxM0kYM6X+njfKxOIpfQRG
	 rCn9ScpUWHwJKBlg7dyukoDqRCWbhAF/uYAKFKbvVtar+mmpfzz8yrxwtw90Uv2Wz8
	 /W/cdmYCz+kRw==
Date: Tue, 8 Apr 2025 08:12:07 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/499] 6.13.11-rc1 review
Message-ID: <20250408151207.GA3297942@ax162>
References: <20250408104851.256868745@linuxfoundation.org>
 <71339b92-5292-48b7-8a45-addbac43ee32@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71339b92-5292-48b7-8a45-addbac43ee32@sirena.org.uk>

On Tue, Apr 08, 2025 at 04:01:05PM +0100, Mark Brown wrote:
> On Tue, Apr 08, 2025 at 12:43:32PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.11 release.
> > There are 499 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This fails to build an arm multi_v7_defconfig for me:
> 
> arm-linux-gnueabihf-ld:./arch/arm/kernel/vmlinux.lds:31: syntax error
> 
> and multi_v5_defconfig gives:
> 
> arm-linux-gnueabi-ld:./arch/arm/kernel/vmlinux.lds:30: syntax error
> 
> (presumably the same error)

The prerequisite of commit c3d944a367c0 ("ARM: 9444/1: add KEEP()
keyword to ARM_VECTORS") failed to apply to 6.12 and 6.13, I am about to
sit down and send it out:

https://lore.kernel.org/2025040805-boaster-hazing-36c3@gregkh/
https://lore.kernel.org/2025040805-goal-richness-0c23@gregkh/

I don't really know how to make it clear that two separate patches need
to be taken together.

Cheers,
Nathan
