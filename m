Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E1832AAD6
	for <patches@lists.linux.dev>; Tue, 30 Jun 2026 22:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860316; cv=none; b=AHbzEwKRAtf7GMqRTc8R3fQ7JK/dj4dfq21IHglX6lnKuQmORYmOCl4sKYd8QMHsC13h3jchuzR7fINda9Y5QdXKm9lH/BC3gbXDN4RM0iYAwawNBH7yz05VAykqSSErDuMfQPoTurAxsLtJOY3BsUtVhexJGIqmYqE5BrnVLf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860316; c=relaxed/simple;
	bh=791AXn6ZdlDHsRSVTLBMXBUCy1S6Hd8VAxHVFvo8z1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqUE4PXKGGrccSiOe4+w+HpZ+Mf3JB7+IOeXqNYEMbBR3eceqhVknhZaMUnFpO8fugs6wxwbr8+wu1dpH1i59955QZ3C1l6ly52CZWvfsAuTURACpxys0XhHvutoanl/OvFuLnXgRYRftXfgkcS8M+x303yVCZjx/pf808LFkzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=K8kb0IYC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="K8kb0IYC"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0B2C840E0140;
	Tue, 30 Jun 2026 22:58:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lsHeNsCnIlDB; Tue, 30 Jun 2026 22:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782860299; bh=Ubi0BsD0eazxekrREFaIhAGn97b7jWVrLzo0p243HGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K8kb0IYC1fhXEfCK7gLl/7E/jwOKm/KDi5+qbmTHZMTjKFm9hpmSB5BmNZGN1OKL8
	 KGrVf07IRkdgY/S/U9VME1ZC/KNwnC/rLkV3bZ1rLSuBPehpgdcB0cRZw/a6ZYDu5b
	 TEqyruxoNyO9DPKz1aeAHtO9vR1D+Xt1+lv2eBmNIEN4TGhSLHnCHYmfFuXpjVHq4O
	 Vt+rhCbwY/SrWnOdJ2C+rG9hO7n/D33W3shcZs3SpDL7eC2Qr6EEySSZK7au279QWU
	 tGk1yMbv6NoscsutdC0JJpl26ety8mrjzrR2ijgpR8xJsjag8Hr+5ZoQBjYNXrGLDQ
	 PmyjHtxnniz7x1iBZo9Alpfm0Ni2efJRxy36kjQfQ51Q75XDZPVBfteJPBiLVOLnL2
	 BHUeQ4Q+z0bbuyX1GDJAgrQ4OLJRmCX4Wml3RXLOB3/Hkm31g1m/ZWV6jjVHncym31
	 t36n7kpjlDsEEf5WAinytkd3mVH2tmKkCCCIkkCk9VVM0/RXr7VQMlBkw8/67O4hHD
	 L1pkcFlTVrB+WvyhK6DCAyKlAwcr/6ES0TxX60LqICfkVZyxZ/GzCb9o3u+h/vAcvs
	 3wV6Yrgce/mDSpTTA8egv5LLLppgMwFzkLN8ilK+APwL72+LlHZWnaH43PQ9eRrcjY
	 4bdv6sjKVqNtfnCqqotLR+W4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7644340E00BF;
	Tue, 30 Jun 2026 22:58:02 +0000 (UTC)
Date: Tue, 30 Jun 2026 15:57:59 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
Message-ID: <20260630225759.GDakRJ93cg21As0xnf@fat_crate.local>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
 <b58d51c1-67f1-4640-b00a-1a99dc93ccef@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b58d51c1-67f1-4640-b00a-1a99dc93ccef@intel.com>

On Tue, Jun 30, 2026 at 02:47:45PM -0700, Reinette Chatre wrote:
> Hi Boris,
> 
> On 6/10/26 12:21 PM, Borislav Petkov wrote:
> > On Wed, Jun 10, 2026 at 10:48:06AM -0700, Reinette Chatre wrote:
> >> After considering the latest Sashiko feedback and deciding to stop adding
> >> new fixes to this series, I do think this series can now be considered as
> >> "settled".  If there are no concerns with this series self then I would like
> >> to proceed for it to be considered for inclusion.
> > 
> > Ping me after the merge window pls. They'll have to catch the "next train" as
> > it is too late now.
> I confirmed that this series applies cleanly on top of v7.2-rc1. Could you please
> consider it for inclusion during this cycle?
> 
> Thank you very much.

Sure, lemme take a look.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
