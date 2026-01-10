Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4349B3242D9
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 10:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768042714; cv=none; b=YUuHXiu+oEOIhKF1M66XAYxhv9DvQq4MNrUrVEcbyR3Aqk/WL1f2AtdfKo4QTvYHIIP+cO4yO6eyJeM/J6zYOK/UahXCL3LGE4BBy83W2iCWRDWlyOoleNrtwgpy/No5IVlwzTQ4YQKlE9NhDd8310eynuu9M2d8kQ3cifFRkm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768042714; c=relaxed/simple;
	bh=3XdbUJDe+0LqYz062wAK4YU03aI6zrsn/ID500AHkMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmjCLx1/jRs82PC6JKocccm/dtPViqVUAzL+AeJvXZ9EM93OYdtAqfsB7JSCoO+pdDmqPAMM32ORWfNa5P3oNb1dGmuGyR77eVncg7dd/8UOwBQKxvfawT6nL6DZBN+NWSaBsAeBjq5roJQrY205p2kevL2IDA8hMtPcVV4jams=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QIqebi6h; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QIqebi6h"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2546740E01BB;
	Sat, 10 Jan 2026 10:58:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id s-uA1Vp98zkk; Sat, 10 Jan 2026 10:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768042697; bh=+934YTZ9NLRSojxoJAPJ5CK67kXHfXN5tAnROirXSDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QIqebi6hDp8NhnTxxkNpfMfSlKPTT285sWHHHyWvdcxMfFxDLmfVmndqxTj9MWDh0
	 7QhYisqCYIN+CtG7jVOHEzDT/EKaC2uhuCnh1+Oq97Zp7JWjc8JOnPHtAaAjGRCGgM
	 TEgjGzH2VIW+ej7KlKYqRUP2ky27Xz8y9tLiEEv8b0hL/RXllQqvJMfXvDZzphQE98
	 0PTqpjKVyvNDKcLmuEs5FbBh5cVch4eDrd6wpZ9xm+zg3lHN+tyQV8oEcl2r+4ZXFb
	 C/sBLQ+ZbLporjmLuKv+cORhpTHgnYUlwkw6xc9XRoU+CuwzULAfZ3+y+iKc7mSPVK
	 eeTVZ8riHBAPqOSW9g64RYvyi1Xi4rZb49Ld5uB8xa02794Gm3UydygXwUt4iz3hdn
	 Akraj0mqm8o+yR8bp0QzJzFzwXXoMq6SgHM5caLVqUiAON9qRLtQs4eePQ3JZFcSju
	 6c+pweT4obtmgtJlqKi6u7+5pryF23d3AS3Ihp8W0Zn7CWwWF5z+sCs76QDXU9S057
	 yOvnsLoMhHNOFFhWTKPJHWZjjjhZazr7Lw7TZ5LhsPmvndvukD/fu95CE9JRubfhRj
	 f51xr6IqMbvF1r5FO93HqTVtrpStV+PyqZG3tHf3DTyXwohRX7sAWsqakZqt1uzIo8
	 5TL9mHQrLZevbDgzw3ZFlpUg=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 7A17A40E00DE;
	Sat, 10 Jan 2026 10:58:04 +0000 (UTC)
Date: Sat, 10 Jan 2026 11:57:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v17 30/32] fs/resctrl: Provide interface to create
 architecture specific debugfs area
Message-ID: <20260110105758.GAaWIwtlX9o_oVXIM_@fat_crate.local>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-31-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251217172121.12030-31-tony.luck@intel.com>

On Wed, Dec 17, 2025 at 09:21:17AM -0800, Tony Luck wrote:
> All files below /sys/fs/resctrl are considered user ABI.
> 
> This leaves no place for architectures to provide additional interfaces.
> 
> Add resctrl_debugfs_mon_info_arch_mkdir() which creates a directory in
> the debugfs file system for a monitoring resource. Naming follows the
> layout of the main resctrl hierarchy:
> 
> 	/sys/kernel/debug/resctrl/info/{resource}_MON/{arch}
> 
> The {arch} last level directory name matches the output of the user level
> "uname -m" command.
> 
> Architecture code may use this directory for debug information, or for minor
> tuning of features. It must not be used for basic feature enabling as debugfs
> may not be configured/mounted on production systems.

I, like you guys, thought that debugfs is "safe" in the sense, stuff there
can't really be an ABI but just recently at LPC I got schooled about it and,
basically, if anything in luserspace starts using debugfs, it will be
considered an ABI.

And this thinking has been there for a looong time now:

https://lwn.net/Articles/309298/

So, before you put anything there, think again because you might end up
supporting it just like an ABI.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
