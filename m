Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE45196C62
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717685927; cv=none; b=FjqiXvEhmbJbfPdVrnm7GPr5+g8YUA14QrVMrvJCWf0nYCE7thrnYtjMetR1LCwhp1JO3llV6OxOjEK/3d+OG+kZeikqLMh13dexn9bO53wpcb2HkNy+SYm1ja3MqhfwZI9woJ3+UossyFEapyBxupa7ULlpaI+EqiA8BBj9ORg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717685927; c=relaxed/simple;
	bh=0o6p+V1J6yLyKmZ9jOGsFhFyWTDmMqsXGUWl5SigVCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkItMKPM7M9/Te814YC2Emn9g7Y2KODDezKiNppzlhSajb9pRysgz4lYk5EnFEOuVpSKIM4aFFCz9ZwsqGD2HRcikHxMzDXik7n7iXexbYqAQpRskS79ZnT4Y2KOrRwSBJXfPvHTms5KhLhhOemNX4PFLSj6vkyLJhZ+ce3ZKV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jIiukAas; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RGKYD4dw; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jIiukAas";
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RGKYD4dw"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1DC1540E016C;
	Thu,  6 Jun 2024 14:58:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id k1_UB62DkMC4; Thu,  6 Jun 2024 14:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717685922; bh=3576AH5H4x9z3mYbuSXmwnA+NGdBLod9a4iXIVW20mw=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
	 References:In-Reply-To:From;
	b=jIiukAasiH3iURcai8TU5ANLrc2BeEzT7n8SlQHFaBOUaJCryIq4mLLRJMfuZOcET
	 ffT09P5KfWr3hhP9kL3nJaihzmNgAYM4MfV0qTgSRyZtO7bZMWYfKCaoIImwYi70if
	 OyeiWOCLfiZjaa5mkcT6Nab2DB99IfPRWhrJS4Dg5JZI1ZxFJKdNK8AWhKgRKcJvq4
	 tXloN0hqYWu5FRT4+dKTtvXk2dEeHNDbyK/xwHHLvmUGLaV9/oieJqfCl24/WH8GBA
	 CA9BTyRAlr0EcZfzxMAJm4/lKJ8tqycnlt0SzOxP6dSD79AuliXxL2bO4PJS+R+FmC
	 iwQcbdfQQlonWQywtfcKCckD3nnzVZp9ZfI2kguiTbvLMfnNUS21GkIxhgAVTSoO84
	 UEzOve3BY3fL4kVw4NNWXf+H7+aZO2jKLrJ0vPI6hG9bKGJBQyJ3YPSlIx1KX5HMMj
	 sBsYnNBgCVXlDonFA7fflcDyR4rvzy5FUwZpEQ+H1NgOjFab7Wn8IRgYeedI+Bm9Nk
	 sx4RgBpdQP4nG2m8ETnl3wCR+UC68h0Xvwpmm3LB8zk4J6rKv2HUCmnB0p89Di17zP
	 iOXebFkvwmgICi4EcpukZIMxxxrdQlrSPDzDmx2fddC2kdKRIibcBzKfKjgaZ6muRB
	 dC+kDxOCUaBatoK3q+iER1j0=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E645C40E016A;
	Thu,  6 Jun 2024 14:58:40 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Thu, 6 Jun 2024 16:58:28 +0200
Resent-Message-ID: <20240606145828.GBZmHOlJhp2j9ETtiv@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>,
	lkml <linux-kernel@vger.kernel.org>
Received: from mail.alien8.de
	by mad with LMTP
	id 3LAtG5jLYWYEWT0Ac81XFw
	(envelope-from <bp@alien8.de>)
	for <bp@alien8.de>; Thu, 06 Jun 2024 14:45:44 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 54FFB40E016A;
	Thu,  6 Jun 2024 14:45:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bAO1HlD8nstW; Thu,  6 Jun 2024 14:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717685140; bh=3576AH5H4x9z3mYbuSXmwnA+NGdBLod9a4iXIVW20mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RGKYD4dwI+oFIMSBvC0a2DcqQ32IvOhvt3auQnLh92NVRawpcPUuFh4jiM03uLyeZ
	 QAnodwI1FbKYzaoIZdFNga0HIx/3tKqSvCLaxTgnm+Q/nTIw1PK1D94r+9IktTrgLv
	 Fp1sKuD8NqXV4NtP/yx80xW0a06uXlItejWw5E6yURsqNuJEDg0dtuPNppISt1gPAB
	 8M2CM4y5Gg9Qb2uy1VdNk9/XinlWFZTSojU+A42hW2QR7mTxPGp/ibTHs6L30gG28X
	 fzjoIShp8TzeN1B5aUpFZk7V4GXZxBWa7TJCC3poW6M4VjS1d9G7OXTZp68MTHvSK1
	 vwG0C+gs3s8IR/68Kxbkt+qlXiDEDXSMQVme6juOeWA1LX9yo6YZH/wmH2yqyo2jQb
	 e3e0dRsPne40l3npE9tq0XU3CIwO8BecSotz/0EBJrApoKEiElFD1m87z438RsXHEX
	 N094nw1br4PQ1X0CMKoCUg51aChGvmJ+qrJHBHg2BPEpJiz7Y1mYLq13McD1VPGDtN
	 xBg99Goa7WaXXEszx1fEiAbx6RSregWNdkKWaWGNjIiw7bNPv0a6qlGVeW0KVx3oKJ
	 eTdAoaDamnDlQOEwFOhN8zCOG4eRPEiKqh55FTN6jTgMXuouo+CkraTbHzcmanoPRi
	 29boWIdFkQrlhMWpz+Z/ovJg=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AA79540E0031;
	Thu,  6 Jun 2024 14:45:37 +0000 (UTC)
Date: Thu, 6 Jun 2024 16:45:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Christian Heusel <christian@heusel.eu>
Cc: x86-ml <x86@kernel.org>, mlinux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] tools/x86/kcpuid: Add missing dir via Makefile
Message-ID: <20240606144536.GAZmHLkLuK9h6Pwqop@fat_crate.local>
References: <20240531111757.719528-2-christian@heusel.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240531111757.719528-2-christian@heusel.eu>

On Fri, May 31, 2024 at 01:17:58PM +0200, Christian Heusel wrote:
> So far the Makefile just installed the csv into $(HWDATADIR)/cpuid.csv,
> which made it unaware about $DESTDIR. Add $DESTDIR to the install
> command and while we are at it also create the directory, should it not
> exist already. This eases the packaging of kcpuid and allows i.e. for
> the install on arch to look like this:
> 
>     make BINDIR=/usr/bin DESTDIR="$pkgdir" -C tools/arch/x86/kcpuid install

Stupid question: is DESTDIR something that distro packaging machinery
uses? Dunno, some Linux packaging standards thing or so?

I.e., I wanna make sure this as generic and as easy for packaging as
possible.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
