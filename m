Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471A83F1660
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787682562; cv=none; b=BfiL2BH1xDNTloUgQmxr3LEgQq6ZjlYRbTSj0mUSG/2+4+6P1RJ/xpsvSEhuo8suvwbM9GVVGm54AiaHsbZ5T6Dvgea3aVQoO4WqPUO0nstgomVSi/Pftvj2CGGQRKkXZPr+3AXZPclguXR0BE5Ks6IIO8+up3hYdsUalfPdb7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787682562; c=relaxed/simple;
	bh=JEl+Upxfeya2Uh32EIDP0IhCmLkYXbyVFIsL2BbCQTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k26SKatU9yTf98YEpzm4eHxfyj0BJyB1+CmHrmpUsObJdU8ei7z1wC0IzDszJvjplJgdIHRg8jl2fRsewTH9p9opecSzQanyCn5fK1QBPHnuBcUK41+0utRImoTDNWAXPxUNd4ygHLwvl9zyzbZCp91FBkZ0yeVLNldxMlAYn/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cS7KpsAo; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cS7KpsAo"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BE96240E01DA;
	Tue, 25 Aug 2026 18:29:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 88bu8M89P2DL; Tue, 25 Aug 2026 18:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1787682548; bh=lJia37a4X8Og99UqFaHPSHYA8ZBHdD+gVZP37KIKs6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cS7KpsAo2lMeK+GWuUVP70jXK0HPrVG1XqWv90sBrn/igvfU0KgVjEEW0vzjiki+h
	 phPMYzQmQvHwBp/Ygz69saQ/UKM0t5qGAXMNOO4GluzyQ6We523uad1VYVFMVlnSII
	 nU2wzQx39A1dfLcLQ0eA5vObvNfK6q/nXFEZ+S6w+C7eFKmDagNPIfNgXYKUD4CZMe
	 aRc5GdkjGPRx7BFNSP3unD4vd6b5t0NYz26B5y1RrPQZPQCaK4BepgraYvs3RUSFsu
	 cpW5oftEFIMNh/EREjCwRxG8ehMdRw+w3ZSqRE3ki8YxpnwiaZShoOqZ4uYM4/7iPr
	 ezn620FO5pZysGe/s/rY3ZRaxlJ1Mfe7cI+fEliYNWAZFHyqMjeDvViKR8T14XuDhB
	 WOVzCUIj8t5KWXEQV/SOXL3ZLzh5ZiOzHYFRbmLFyQSJKsSFk2WpMItvI+3OYpkld2
	 jMTsn7Uubl/oVmpEbR6hX8bn8xotPM8/RGoDRhKDHiPZ177RL/UPLre3laGxjDDZYC
	 nlFThyurEbHYLwBZUpPcNRRHdbG3gbji34bRnEO2ysMULWkvIPzLpmbRAblMqwziM8
	 D2XvIJ/nNxZqPZWdia/OsU9/AlEfTTnOd1xnoNIhWv6rivMwJjDtL9JaEtoJ4PFPEF
	 UMTW9/wxGk3Ig2lzC38YMPfk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 855A140E01E1;
	Tue, 25 Aug 2026 18:29:00 +0000 (UTC)
Date: Tue, 25 Aug 2026 11:28:57 -0700
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>, Breno Leitao <leitao@debian.org>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/7] Intel platform driver to reset bitfix filters
Message-ID: <20260825182857.GBao3e6Qv_Xg0LCXFM@fat_crate.local>
References: <20260825181526.13203-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260825181526.13203-1-tony.luck@intel.com>

On Tue, Aug 25, 2026 at 11:15:19AM -0700, Tony Luck wrote:
> This code was originally developend by Qiuxu as an add-on to an EDAC
> driver. But not everyone wants to run an EDAC driver,

Interesting, what's so bad about EDAC drivers that makes you move all that
functionality which is clearly RAS/MCE/EDAC into some random platform driver?

There's also arch/x86/kernel/cpu/mce/intel.c and that doesn't fit either?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
