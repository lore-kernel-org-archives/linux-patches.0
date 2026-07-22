Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE6435FF6E
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 00:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784681451; cv=none; b=YD06i7Pp9xC78Bco0i4l7O6xnY+oyGuh22eCIEQxyrdulcZYCFJ6fyvH3zaDPY7bgrZkEFB17WCPVYM3+MY5y94I9abquOKC30MmRaviL8H2y9EGtF2NevLqvXvQF3f9foiwCo6YeYF4b4fpuoIEVj49T7ocg79Dy2e/j5Hj3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784681451; c=relaxed/simple;
	bh=9j7O7UDO79Gckmj3gEL1sroHWxamjc2KkKWEUD2r1TM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2YcxwDad8v4FlUzkIVcV0lN4LrhGG4NGPafUt7PRKdP9twz4Xer2Hhwq77cLWrAZuh1a46GLu6YMtX5jRRn3JnSS+bSvq2y+x9CryMGdHzwvhujmoCGi1Bmc9TbznAQy8pi1DW4DMunJBKwMtm1d7SWKNYDnxrixjqCVi8sV6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OySLw/kQ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OySLw/kQ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6225C40E014C;
	Wed, 22 Jul 2026 00:50:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lWWm1OxGWege; Wed, 22 Jul 2026 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784681435; bh=FO7U0vna1FVbogWNUUY7oOJhoG0wwq55Dq9fZ2Ciu3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OySLw/kQUnrAmsRagRa4nzlRsGG4UkOtJlZF1uHaKvnDxj1JUX7fe4RWz22al/4sy
	 jsDQvCuETjtdl4gp3IsB0u1c+NKIGXEV6RPT3Gq2H8g7N+Nzdhd8prwvoaTRYsD0/j
	 ckDhS1qqVpvOcn0qBl0GQdIPUQqUUJtvZRKQX+0CitiurSFlR1yHXjAQw8ka91ngGg
	 zda3/G6J8svWuA0+GJyPuc+/sbSPl5+Rk8z0qrGu9ham7NqyeK1VD6+G2FT+B+4/50
	 XsUk69v7B9LwA/bIxw0pdKDcfWzZo4u05Pyi685KLi/WJ3STRwOY+2RDBy1TLLyYqk
	 n2Xwhq66GExFWPtDPMHISqeM+eC6a8BDVGS5Uv9XUVF1gY9IGpDnRY0lgFRI35D5cj
	 sfjOYZp0ABggv8dA/E3DnBlbGzdd53ga/w3uKMKVtKZhWWNIDGdvSG3diu5CsiuAE9
	 +tRKyh7WKhlKVHi9WkehN/oieMtM1938NBbr0GZ2DLAN3wqUi8a0Ifz2O5MpSDDBy4
	 wFW898n3zEnSRzpoyF1P4i80scK6cntFJovaGseISefGHmUe0IgX6uEglK/mii7hb1
	 8T3gZ/Pyo34aNOrzXSOoIDADo5tkFpatLkBX2PPVz2NpCNfdlDbdR/58x8U2S0ilD6
	 D9DMSyADYBQtdk3q+lCsAAJs=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B60A740E00C4;
	Wed, 22 Jul 2026 00:50:18 +0000 (UTC)
Date: Tue, 21 Jul 2026 17:50:15 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
Message-ID: <20260722005015.GKamATx-zEYGcRs2X4@fat_crate.local>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
 <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
 <2184678d-1b67-4d2f-94a3-c4bb22823cd6@intel.com>
 <20260721231502.GGal_9dvrdG9NdUkA4@fat_crate.local>
 <86f26d3c-92a7-4365-b6b9-2b31da15ce1b@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86f26d3c-92a7-4365-b6b9-2b31da15ce1b@intel.com>

On Tue, Jul 21, 2026 at 04:50:32PM -0700, Reinette Chatre wrote:
> I see how such change could be considered absurd. I am ok to drop it from
> the series and just keep treating it's report locally as a false positive.

Nah, but I'd like you, pls, to rewrite the commit message and explain more
prominently

1. resctrl does not support values than u32 max_bw

2. what this is really fixing and where the potential issue can come from and
   what the situation is today.

I'd like to have more background in the commit message why we even arrived at
this patch.

I wouldnt've even done it - we have bigger fish to fry - but if you think it
is important for resctrl, sure.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
