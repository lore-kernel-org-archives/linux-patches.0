Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A0D393
	for <patches@lists.linux.dev>; Fri,  5 Apr 2024 00:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712275967; cv=none; b=QGgPXh089cCc1oajHUPURDaEhsCWLIBDy7c7blwaTlVX2fGt0gcEpa0RENaQ4MNWpbDYRRpICMRSBoQnkkBR1AGN0rAr3d49m3F/443Ay5kvQDE2MTEAVV6zSTVnU7/5wCTJTobzT5mLW8Ee082HEscZ0spUxqF1eWmdEh4sNlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712275967; c=relaxed/simple;
	bh=VNIDT2Ez1OwlpABgvEUM00OjHaD9ie4SF2pU2VUeeK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SROigxsZSjIABDmGtxy/WBM780L0DHS9O3tazgfYhCWNiltR2QVlilVZ9I5jE7G6ThcIOjEcW4apkkhTcCCZyeSRbzSa31oLll8Y+a9Y/prp7pALrxy4JMMCOAQd8yxmxTmhg3iZ/1VfwjJ4uP8h1tR1+OCtg4l6L3e4od1M74Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hcYPuo8m; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hcYPuo8m"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D4B8B40E0202;
	Fri,  5 Apr 2024 00:12:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dmkss7ZBZlmH; Fri,  5 Apr 2024 00:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1712275953; bh=MZGBM0mZiyb3DAsesInCjOBkveB3vxGhrP2dDaS1rZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hcYPuo8mftIjpysfOKzwAene5P7OFZt79uz3YNqF38GquHJgssvFYnW1qvpGlZ6x/
	 mCbgxnXoJO6jPGCioFM0qoII40ASrnLNpFqBYwECP3A8uPUsT2nmuxEH1bkqlqwDfb
	 edCIk/sCXJWkIYdCmjtm476tY/O3iSU0KfdsGu0yDcWOyQ2BK0bSlW0CbIT4L5hWLY
	 DuwsV+WqKbtpPqbLr19l2FAw1m3oW3xepP8aCNVtOlQqA/MQrGeJs/hVh5CKLIPNgN
	 45RcRu5WjKvO5Uj4D3G7as1EeILvTbBXqZBEynAvFy5PFEn4OadLU9/wdxXpuUyc5s
	 qN8KyKArLNGlxAr8SBZYNjIpENmikIzoEMnyrflq8ge6NREuGKPV7rlLBaKIP4Y+po
	 9MglxJLJQznCO0fPOaSn4Tbfay0U67AqkuBbGQYnryiEsRKP6FDgVJGJce4wFei68n
	 iOkN37u1GQTGLDd1u1UvL7KdYOjF88kwFlsAqDivOgGCTyL+pMMuFQaH50cKGpWGjG
	 w2PXui/LYQdTJYMbFnVZGjRurBr73nj6XQ75Y+fsO68de9cWCcmpAhjvS/MAftekJH
	 qUWJXrv5MPRTOkQZyrGpAYkcKT2f6GfvBP41gVxKP3drZfJAj04F9s1qJEdaNMBKWj
	 3qpDT2lKYBC58nKnPe6ZKucE=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0FD8740E0177;
	Fri,  5 Apr 2024 00:12:26 +0000 (UTC)
Date: Fri, 5 Apr 2024 02:12:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sven Joachim <svenjoac@gmx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>, stable@kernel.org
Subject: Re: [PATCH 6.8 387/399] x86/bugs: Fix the SRSO mitigation on Zen3/4
Message-ID: <20240405001219.GGZg9B4-0afSKFJKVf@fat_crate.local>
References: <20240401152549.131030308@linuxfoundation.org>
 <20240401152600.724360931@linuxfoundation.org>
 <87v84xjw5c.fsf@turtle.gmx.de>
 <20240404095547.GBZg55I3pwv8pttxHX@fat_crate.local>
 <CAHk-=wiiK8qEZ+PkOzeEpguxB18XrfcHGcSMyHzFtA30PvZP2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiiK8qEZ+PkOzeEpguxB18XrfcHGcSMyHzFtA30PvZP2A@mail.gmail.com>

On Thu, Apr 04, 2024 at 10:41:31AM -0700, Linus Torvalds wrote:
> This?
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0e110732473e14d6520e49d75d2c88ef7d46fe67
> 
> already committed.

Bah, you're waaay too quick for me.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
