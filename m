Received: from andre.telenet-ops.be (andre.telenet-ops.be [195.130.132.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918011E9072
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 12:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512162; cv=none; b=DHM0WBqEEKsXYsm3+V4S7t0KNjDU5xzCH0tJiymO+64lqtMhQpRdDVBATFl19KhdX5j3Lw7sPd8pFdxuOV4jPU0TmIM65XUx9jWDvwU5ILYZHf8YmC0VgpRKa16/04hNY6moaFprY6IldHLrY5yaEWic5ex6o1yubTIzDoM+NIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512162; c=relaxed/simple;
	bh=XB/ma5czQuICzNFrraRxoB0KoIC4DnukcfKzkvlvMMU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OH1UxWqgKf/awlGt/gGcC3lUQMFYgIr7Qr4QROPfmAcbFVaPQOGJbyMgG3WgmW6K8/K/jAse093hmP6inY2OKjrceCh+/5tryH++j8d8CiRs9BjCL3RqN2XY/ZkQ/vgkQbP2gr1H7lDQy7HkTLM8XvkA7LO/HzRNVU+MCyHhDrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:a141:3544:6743:cb10])
	by andre.telenet-ops.be with cmsmtp
	id T02X2D00A5HsszL0102XVT; Mon, 21 Oct 2024 14:02:31 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1t2r7H-004FNQ-Ob;
	Mon, 21 Oct 2024 14:02:31 +0200
Date: Mon, 21 Oct 2024 14:02:31 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various compliance
 requirements.
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
Message-ID: <6c773870-6eb7-394b-8be-7a414c99b5f1@linux-m68k.org>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

 	Hi Greg,

Thanks for your patch, which is now commit 6e90b675cf942e50
("MAINTAINERS: Remove some entries due to various compliance
requirements.") in v6.12-rc4.

On Fri, 18 Oct 2024, Greg Kroah-Hartman wrote:
> Remove some entries due to various compliance requirements. They can come
> back in the future if sufficient documentation is provided.
>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[...]

> @@ -888,7 +882,6 @@ F:	drivers/staging/media/sunxi/cedrus/
>
> ALPHA PORT
> M:	Richard Henderson <richard.henderson@linaro.org>
> -M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> M:	Matt Turner <mattst88@gmail.com>
> L:	linux-alpha@vger.kernel.org
> S:	Odd Fixes
> @@ -2263,12 +2256,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> S:	Maintained
> F:	arch/arm/mach-ep93xx/ts72xx.c
>
> -ARM/CIRRUS LOGIC CLPS711X ARM ARCHITECTURE
> -M:	Alexander Shiyan <shc_work@mail.ru>
> -L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -S:	Odd Fixes
> -N:	clps711x
> -

This also removes the mailing list entry, causing submitters of future
patches to forget CCing the mailing list.

Why not just drop the cancelled M:-entry instead, like you did above?

The same is true for several other sections.
I have sent a fix for the sections related to Renesas drivers[1].

> ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
> M:	Hartley Sweeten <hsweeten@visionengravers.com>
> M:	Alexander Sverdlin <alexander.sverdlin@gmail.com>

[1] "[PATCH/RFC] MAINTAINERS: Re-add cancelled Renesas driver sections"
     https://lore.kernel.org/all/0a189e2c4090a1b308e18005d2552e335bac354f.1729511337.git.geert+renesas@glider.be/

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
