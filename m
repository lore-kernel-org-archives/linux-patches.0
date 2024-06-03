Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113E413791A
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717434089; cv=none; b=gpweudxqGyPzyRVHB4mUaPrlA4eqMTzmhoCHG9PRQum2KyiiDcPRj5q2kPfiTCV7+l54SSG4DXzBDpqR7NWff1JxHpCPAcE9b5OScmuwO5VI9m8aHWCpKBgsjTOqgpMUVnLNp4UBUE03e5UVK0AWMrwZEWZPpx8As2E90gUUGUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717434089; c=relaxed/simple;
	bh=3SI9j5SVRu/Hmpi2nSsddaJaEryZv9zB6NLAEMk+BQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwDT4MuhgjlALadBzP6z6OwAShKP2L7cKlqNIi6vZD2I7AAhA8SuR683W4UlEUN2BC0oqXNwg3KDqAc4YY+U+jE6xC9TPy0BZA+4xF4GnRF6HlWxG+lnAsjP4MRGKGMVLNsKXiePwsA3YiQoy3XNmR9KvwvQoLQ3hnR52SqSnG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=KPwPBfMr; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="KPwPBfMr"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 39CBE40E016E;
	Mon,  3 Jun 2024 17:01:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id G8OYUZaiYqwq; Mon,  3 Jun 2024 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717434081; bh=+4BvNpPAGG+MtFL51umjmfWWWtuUucP0ZyFjXxPrsnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KPwPBfMraQkLhVtJLD9NPMIr1yTdqJcSqE+p8SBYe8k6YSXjRh7XkQFiAsGvQ2Cf7
	 9UgEQvvZjHQcCMn8Fppi9UGBPupjWG11nMU7tyxKewRtr5e6pGBJdWopo8ScPJcwEJ
	 yJxXGX5kSTe76dCFQ+kJrl4J/hytkU+qO7ESYX9S9m4S6F05m9TbHoPiUTx450DHr6
	 1Fn/bPiraKjIr8ZE8csES0PnsK1zsZWrS/AAPQWXzUnIE6e8UPAUWgwhYvOhZJtsR3
	 a+5reUZIAeWJA+ZbGE/w74gK+WH6zOgdceX+erkBG/Jbyb+OyoCGOv3/zhVbdZnXEU
	 SaBHYaCpFumhgN+BZw3edDTTqfRc6o+9Ma4RlFHP9YsfzACk4Pwl1D8eQxhs0vt/SR
	 LGN0oWANbm5+Dln6TFG14cD4UNHiT6g+rGDxb1MtyrFCIWSrXRtkETDFleKgHDWWd1
	 3xO4oGsBkkaYuxpnCvMli42SEoYIRPAbRyo3Qt/QF+ED0apKdVqt9Ikd9gHontv/6L
	 /NI2Pm6fBXQnRdARSBwYmGQhPgyi56/LqtJN9VA95R4VZi6/JT4iRezpCAYjyBiIS2
	 tIYN1tESXS/md6w/zpw2H6xLLE/vjFgZX3UsVZ+YRnDQvjoV0yzjo+1kxMPTokUi7H
	 fMjBpYGAUJv4WZV+c2Dc5+WY=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4BE5340E016A;
	Mon,  3 Jun 2024 17:01:07 +0000 (UTC)
Date: Mon, 3 Jun 2024 19:01:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Tony Luck <tony.luck@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/3] Add and use get_cpu_cacheinfo_level()
Message-ID: <20240603170106.GHZl320tVKXp2HyUfb@fat_crate.local>
References: <20240531195720.232561-1-tony.luck@intel.com>
 <22569491-1b29-4b3d-8e9c-a5d10b73b6ab@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <22569491-1b29-4b3d-8e9c-a5d10b73b6ab@intel.com>

On Mon, Jun 03, 2024 at 09:55:24AM -0700, Reinette Chatre wrote:
> Thank you to Andrew for picking up this series into the
> mm-nonmm-unstable branch. I am not familiar with how patches flow
> from this repo/branch but I expect that this inclusion will require some
> high level coordination between the big repos since resctrl changes
> usually flow upstream through x86/cache branch of tip and I
> anticipate some conflicts and also needing to figure out how to deal
> with this new dependency in planned resctrl changes.

Which is totally useless coordination if Andrew simply leaves x86
patches to go through the tip tree and there are no conflicts.

> Could you please provide your guidance on how to achieve a smooth
> upstream of this work?

I'd prefer if resctrl patches go only through tip so that there's no
unnecessary headaches with merging and coordination.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
