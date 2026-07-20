Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66777443E22
	for <patches@lists.linux.dev>; Mon, 20 Jul 2026 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567804; cv=none; b=FAl1ofnXjyFAdfBHNmnPBset9RDCrelaBzdBxZr8hrP6XkgLhp7ztPWvQCmeFzY2C6mpidiiWyRm06aXIFWoQVgy7PsMU4RuE5/u2FFJYG9IMe6K7LAZjRlmb8Hdjjl1mdnMZz5rg3UiusNcrvje42gnTh86TzgFroOwUHuRcoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567804; c=relaxed/simple;
	bh=nao2HWLZehQbm0rN28c3zYIJYbomLD1RNpptvQW0iYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICEv8izEpp3XbL9I/KJBu5OGp6PP4OBmETHQZ/t6m1Hd+Pke8k8SrHUgHhJklj4OA/GIApZGKoCBLycNMstZein42KbK57F8dxqWO23OOjR5Vdux29S6aEZ/aJWxC7ixMT50zxl+/y9GzNfewhncYc+fKxOYvjHdw+a+Dkz3UXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GVIAX6Wk; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GVIAX6Wk"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6B30040E016E;
	Mon, 20 Jul 2026 17:16:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ZclmwnJXlQcz; Mon, 20 Jul 2026 17:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784567786; bh=zu9rOyx3AE9fgXMGGbfHCWywA8SZbxgml7IxlUm3jVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GVIAX6Wk2/78LvuL44FhnmpuUgUACs+g6UiydxFbu6HxnPR6TPfrJRgWEJu1UJ1cC
	 Uv7G614ZguN0GQ200bJATxQz0OJLfzZZ45idLdecCxua+hMtyGBM3S/mtkvthCFxf8
	 RpiRi2jdbl6Lnqrz1NCxYknEQIMvFrMLY6rfw4qalNnNbhkytW+w/ZKdZretk/g8mt
	 GAaHpSI/wlOVEzlFduoo1k3WgZ29mMcto2jcOEhPt8L8FhrLL6sbfRSLCY+5aEiVzN
	 ix3jnywdedO7/0iD8HqpHTyBg0IUpryuHZw8pEIwFyhJG4t0daFWwDklUwz5iSqgEl
	 k7W6OExI9l7JOzdAcSKLjSM2Xwbx9Fzx3sMuH5QTqUXAV2CO1shy8WUMoJrejRNY+U
	 +5JFNZBq2n3oFZcB27GCS8J1JtMtaL0wMmBYNGg3gqAJj/NDKn7ovLL1+UChds8LNK
	 GRhaw6WnNjgkYDrxP3DC5PBfsrdUCYnf8ITgux7pTj2wzQ9NXKaGFygpbSx6XtlaEC
	 5Pabv6IzN3TDPeAhh+tzD6gXxCH8H6o9m+oBcm1wV9f3aMtyds6zU14sQsQsibrOhD
	 /LPgD6WbhjNRRnZv1lBUGo2N5mF/kfYvrqnuR2HKPefZNwecZTv10Tihh9uohYN0xN
	 /2V9t2UUn5/DrnQlJqI4Vpic=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CD3A440E00B8;
	Mon, 20 Jul 2026 17:16:09 +0000 (UTC)
Date: Mon, 20 Jul 2026 10:16:06 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 00/10] x86,fs/resctrl: Improve resctrl quality and
 consistency
Message-ID: <20260720171606.GBal5X1tcq71REnG6E@fat_crate.local>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <9d657f1e-7329-40fd-bda2-9ea0735947fc@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9d657f1e-7329-40fd-bda2-9ea0735947fc@intel.com>

On Tue, Jul 14, 2026 at 10:49:52AM -0700, Reinette Chatre wrote:
> Dear x86 maintainers,
> 
> Could you please consider this series for inclusion?

/me looks.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
