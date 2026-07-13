Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A534C1448E0
	for <patches@lists.linux.dev>; Mon, 13 Jul 2026 18:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783967441; cv=none; b=uKkQVvOBhFbo+CZweNwFmeFNZ0x3Up3WOvWYG/NE9f5pBzFEBkVAIgAZlqVVCbFz8qs99oy+DX3egKZz2tuuLgOKnRcjC2i0yKXTfzCuk1QOYk/ESVEReA5DvV4wTTa/m92X+Pz7xlfza9abWk9zJzogKEjeaBPjoMHbk7lnHkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783967441; c=relaxed/simple;
	bh=MJ0Pq+SWLJVSOQZjfkMNqKzx36ylfNSgD3xqmq+kzlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRllO+tc+53Pvy+86GrTnRHp6sUejl3PeBqTf1oAhQtBSSarbwtTUpkgI51/vJxugr62TxQ5kWQWScspjVixsVNhhLGY6HZ2p050YUeZdBEfqJMhSbJkW4qf65sfCqIorJWq66t4CUxNRggkQJe8RKxKJKXoUSwK4iqYNg2RzUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Y6Wl9D4u; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Y6Wl9D4u"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 10D2940E00C3;
	Mon, 13 Jul 2026 18:30:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6_Us8RjqxQtG; Mon, 13 Jul 2026 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1783967418; bh=1aX6z6Dahl9SNm+kVMYFIcRT/WOTIsXmmBm/68tQU6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y6Wl9D4uE0WszN3/hBmEmHNfclEwaFI772Mcp46z/hkDKasxi3AcJzeuveQ+mdwyW
	 fWTxxQkwirJCmIk8A4RYSWriMA9hlIHTpF3gDfYiN9Jl0eeioGKKo1f5ktALwzVXox
	 uoN8TjBuMEPL3PyXWxBZmax4a4hQJW+BsAnOSKpbik2KVOvcV40AmqUyVdAB/pT8p1
	 e5v++WFog2FsDB5o2Ib5wq0O2dCjPrfvHo2Mt3CV7gLsozX684w2HnUuVETyZcol0f
	 YOOt7uWLuCn+M/PpsuRZpBJBAUO110r7JXGYgohajKtIDS+pbagSdGqDP22d1byyIb
	 4b4FA51/jK/lWwo7/oRZChzDeQG9Xa8YNBLCxWINTd5/+WtwIjZIlgqufrsBlQW33t
	 tbcQRFGRyPBNzBFrrVCmHTtHnxcjowwIPaD8O5vjE22OFns1jitOeE1wg/SsDSaQCc
	 7OGgguqHn95y/bFnjwg1FghWpCaJKAB58shJ2lddyqN+Z4rgNBQQRLEKcTvaVxehw0
	 ABVpQ9s9wYpIHoMW4BSYltTGxCRtLyA+2VBSb/G+t38dlihoSPxLQR7ZR69URxRxg6
	 /1RzbCJZV3IyD+Wt+Ez86Ak0urhgSFGvpEkCZc8CrZT35QqpPpldr+Vgu7zAKdzoOJ
	 luv3xiwpBrzQ28qXUBSYTX+c=
Received: from stx.tnic (unknown [165.204.77.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8C48C40E014C;
	Mon, 13 Jul 2026 18:30:01 +0000 (UTC)
Date: Mon, 13 Jul 2026 11:29:58 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 0/7] x86,fs/resctrl: Fix long-standing issues
Message-ID: <20260713182421.GAalUtVdzT-QmG-nhJ@fat_crate.local>
References: <cover.1783963505.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1783963505.git.reinette.chatre@intel.com>

On Mon, Jul 13, 2026 at 10:39:36AM -0700, Reinette Chatre wrote:
> v6: https://lore.kernel.org/lkml/cover.1783377598.git.reinette.chatre@intel.com/
> v5: https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/
> v4: https://lore.kernel.org/lkml/cover.1780456704.git.reinette.chatre@intel.com/
> v3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/
> v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
> v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/
> 
> While reviewing the AET series [1] Sashiko reported a deadlock during mount,
> and a use-after-free when an L3 domain is removed during CPU offline. More issues
> were uncovered as fixes were developed and reviewed. While the goal is to
> fix all issues the races surrounding pseudo-locked regions are not yet
> solved and have been removed from this series (last appearance was in V3 of
> this series).
> 
> Applies against v7.2-rc3.

Ack, now that your fixes are upstream, lemme stick those ontop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
