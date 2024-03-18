Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041E72C69E
	for <patches@lists.linux.dev>; Mon, 18 Mar 2024 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710771643; cv=none; b=MbW8tsZwllXQ/fgyv5jTYRJWn80Ti7arI9BZRpaiU18DSAVp3siH8D0WtV5oS5V7OUcn1WeIWG1opNNgsjd+V8wYDrKlJAQEJlDu01issuP3VZB2tugHbxnAK2ZfWxWo33DcSYH7Cs2drvu+9RG9UPrqk1w+WuUVBGsW2LpnXGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710771643; c=relaxed/simple;
	bh=EVOz7HpKxshJQzoKffuIeq0NqaAk2uilDLBhZBSSX88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AW4+n7lUweVHyMWv0y//UUZHmaKHJKsZWrFlP2AvTPgfr4i9/h4S+K5wQzM029G7xS3GM9pMPjJkns+u7FYPqAuI8MoGGXkAQSiRklbGxonvz+3MxXLQh9Vv/bc0fSYyzMsDj6ltoA9Ba/irjFnRZqVk4P7ZQigIhG/ml+7Wc/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=En8dYKb7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="En8dYKb7"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4752240E01A0;
	Mon, 18 Mar 2024 14:20:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OvM1e62OCdz8; Mon, 18 Mar 2024 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1710771628; bh=xbujwM1+KktwbMpDTc9ki7t3eXg24aeWGNwP7mqwkjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=En8dYKb79vzkZ87N0uILJZMTqEvjFlX3u7IID6Tpgp48PaEFhIZDIl73QpT/r13SV
	 sVe4RkY33QWPVvxEod0kKB1b2rXXeIu1vaB1/kiNVJ4T4GjDtdw7whAhooR5kS3v2P
	 uPJIBryDl38dl0Nu6Kut/qP+OhxtJ2Oatgh5FOzjc//B2Y0GBiX5JuiRacnpeTWxK3
	 TTKgjTMeCeh0n6N0bhEx7h4x/TNwFzFrHV3Iq1I57IXE4h0uAtpH8lRwZyUkU/6HO1
	 YcDDglzazbkFRoxit2GMql3yWeB5xb6vOegD1Fs4eJsmWv69SB2C9KbZ3jzoikY7Q9
	 fL6zocuyGvf9K+RVigpbw7/9rkUqyRhcxsbrT125JP/v/t0Q2prC6efsJ8K0m3PGBe
	 U3lP2HuKmqRJ/At/mw2i+qtDoyIAHEVBM+ANTAf4owRUJ2Ma6GLJ9ZOM9/9/c27B7J
	 tc1ZGqfx5QtQwxTvg/cOG23jdf5rGBZ2mLjzVuuwStXRZhO1R/6ZjB6njMyCORTsyp
	 XUOUPZyT+8T7pCzdM+UNDECUHvvpDMYZ5gmbTG5Injdnfpen5p8YkN0iiI/d/aYgqp
	 ePBCVqIhG+m7CT1G/KTX0CocAqbcZVBRhMjIeLmt4xmcAiuJxEKl6Sfw4y4Op9z0mg
	 T2yxdh//Tuv7auaLEdKUlewQ=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5B1D940E00B2;
	Mon, 18 Mar 2024 14:20:20 +0000 (UTC)
Date: Mon, 18 Mar 2024 15:20:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sasha Levin <sashal@kernel.org>
Cc: Emeric Brun <ebrun@haproxy.com>, Omar Sandoval <osandov@osandov.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 5.10 085/122] x86/ibt,paravirt: Use text_gen_insn() for
 paravirt_patch()
Message-ID: <20240318142014.GBZfhNnupMQ4XoDLUm@fat_crate.local>
References: <20240227131558.694096204@linuxfoundation.org>
 <20240227131601.488092151@linuxfoundation.org>
 <ZeYXvd1-rVkPGvvW@telecaster>
 <4d33ef17-72a0-47e0-8591-20b0bf9bddb9@haproxy.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4d33ef17-72a0-47e0-8591-20b0bf9bddb9@haproxy.com>

On Mon, Mar 18, 2024 at 11:17:10AM +0100, Emeric Brun wrote:
> Exact same issue here, also since 5.10.211 and still present in 5.10.213.

Sasha,

can you pls pick up this one:

https://lore.kernel.org/r/20240305112711.GAZecBj5TMaQDSz6Ym@fat_crate.local

?

See upthread for what it fixes.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
