Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE17D3FB1B;
	Tue,  8 Apr 2025 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126343; cv=none; b=GC6+8C2ucS65K9Zpu0QfppPeP10MkdO4QBCr/FnbSW9EXeGkru5sRc+LILpu+Isi44RP2h/YY94O8/b1jEoXaWWbFyRI3Ab/azdaPJubkaYVvygHUBfNLLG7RnvZ5fDBiv8dKPTjwAnD1t2zjBeKYmDtbF+BProvzAoMh+/VjuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126343; c=relaxed/simple;
	bh=u741l1VQEn0lP1ypM4etmFVddvE3nno24ukni4RpKpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JjISLvHBB8x3OyTTdFaL/o2QKW5YZAnaKIeke5VYF91xqPOBhaCN/FpjnbMXXJjpHocbBuCa701V7Lt5SGLqeArbFrUAA8YMwyCt5lk8YtyEWLaQoU2tRjsHuDoNYoiyUpIY1UJ+kFP1u49V+TFEH8GAptyatoZsJ8cpyMRAm0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSEiTJaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSEiTJaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7136C4CEE5;
	Tue,  8 Apr 2025 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744126342;
	bh=u741l1VQEn0lP1ypM4etmFVddvE3nno24ukni4RpKpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iSEiTJaRlriF1D01gegE+wTgUM9zgHAgqr44r3f9wT/oZizQaIbm0yUQQTnNwBBw+
	 6BVlWv5R62TNZ9Dnr+J+FirqY5QhiS0P6V6FJ3a+nHB93yX2ZbJYrDXoW0xhrZg3fX
	 j3l9Su9ccA4KsCG7QQuSPZqAydu2amtkAGgd+RQY=
Date: Tue, 8 Apr 2025 17:30:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/499] 6.13.11-rc1 review
Message-ID: <2025040840-severity-pointy-e3a7@gregkh>
References: <20250408104851.256868745@linuxfoundation.org>
 <71339b92-5292-48b7-8a45-addbac43ee32@sirena.org.uk>
 <2025040810-unpledged-bunkbed-1e2f@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025040810-unpledged-bunkbed-1e2f@gregkh>

On Tue, Apr 08, 2025 at 05:18:31PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 08, 2025 at 04:01:05PM +0100, Mark Brown wrote:
> > On Tue, Apr 08, 2025 at 12:43:32PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.13.11 release.
> > > There are 499 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > This fails to build an arm multi_v7_defconfig for me:
> > 
> > arm-linux-gnueabihf-ld:./arch/arm/kernel/vmlinux.lds:31: syntax error
> > 
> > and multi_v5_defconfig gives:
> > 
> > arm-linux-gnueabi-ld:./arch/arm/kernel/vmlinux.lds:30: syntax error
> > 
> > (presumably the same error)
> 
> What is the error?  "syntax error" feels odd.  Any more hints?  Any
> chance to bisect?

Nevermind, got the fix now.
