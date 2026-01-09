Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0B82FFF90
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 22:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767996160; cv=none; b=tVT4tkercZLk1p7cCDRgYrmIWW8GjuA7ahdPl1CaDk5CORk7Ym8EZjiOzR25V2TreOlGQSM7fnio6V+XFR5gbv/9FaUGG8abVF5bwAJ7l7XdNioNP9aXxszLyLP8kjTqOjXpdbIZDI13MjZVuCDp+DJlkHlXGnGFTS0GNCEdTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767996160; c=relaxed/simple;
	bh=1M+Z2AR1MclpODUU/Sz82e+q3DIfg44kgg9AXU8T064=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KleRJBA6TodB1fQhoSB621GKZrutQ4p1+r9kjEJk8fl9+f8UsHWPYSyDBqpzj0FCCXHN4FwLH+H35uzQbdo3sTcAaCerASeHeaakT5x1AZLqP/X3pOqHFoN2P3Rtp3DXipPkkW2INfDonLrS8o4s6k3/A5SIm/cNXdc/DjU5XOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eBh1gIb7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eBh1gIb7"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7D05B40E01B0;
	Fri,  9 Jan 2026 22:02:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jOxa4GasaXKZ; Fri,  9 Jan 2026 22:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767996137; bh=4J8DSCQxHlYwurGIdKRB3LlZgSrEHXDHcaSYp6C7DyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eBh1gIb7Yg2O/5yANND0vFRNmz2wK2SUZjL+r+wEmiOSOH3NOpnAVKMz9IFxsL0Uo
	 k46ohHpF429cRLNTsEzfOtX4mbpxgZ40w6K/foAK7NYipd0Lw7m0PHgp2dM5CRJRXb
	 vD9ku3mc8nKKSW4EBybMzNFVxa9I/COzMiRtr2bLT7tkuQphlMLHat+8czP5vpnl2B
	 URglF95rk3NmGq2M50zQ76V2gclk+4SG7bE6Rv25uKsuA1u9bm+No/aefMBXZA7sF8
	 DHEaAVQxe8tBkP8fPBr0/K58x2jW6Y6DYxIgRzZmyLySjrmbtnTSQ28WShCwlexYlr
	 1Z94HSTrJKizuW0JhnkJdlNbi4jlevyHA3Ys3KAp7wEphrYPpREQOumsl9QPb0JdEe
	 ZOag2h+uISRJ59qnRFWizomK2C4Ec+fdJmLheOJcIN5IY9atrXrEv0OSnNwIuLQmkR
	 0nDLw9Kpzat4W/Tl4iGBL2BXHIJ02Iu3B8QM/INkFqLcLCN+vbBFEvJQJLq3Ffe63d
	 zqrj3sc7T/ICOYDGiMF4Jl7mey02DZMFw4sF1e7MgEXM8QA723PgnHNGFDXoLBG48f
	 WyGusCc4XYPcTsWzYuogZ5Rz8RV1SOu3jJ9M2FHD6fzyELhSGBqC3KELWoqkEtsLif
	 XVtV+T/gt3Fio0OVbU9yBcHo=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 16EEC40E00DE;
	Fri,  9 Jan 2026 22:02:03 +0000 (UTC)
Date: Fri, 9 Jan 2026 23:01:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH v17 19/32] x86/resctrl: Find and enable usable telemetry
 events
Message-ID: <20260109220157.GHaWF61bNih09Om04i@fat_crate.local>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-20-tony.luck@intel.com>
 <20260109121616.GBaWDxkGvgJ6sd133q@fat_crate.local>
 <aWEydesWamRxWJwM@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aWEydesWamRxWJwM@agluck-desk3>

On Fri, Jan 09, 2026 at 08:53:09AM -0800, Luck, Tony wrote:
> This was made a separate function in response to a comment against the
> v9 series from Ilpo:
> 
> 	As this is at least semi-hacky, I suggest you move it into own function 
> 	and add a bit longer comment to the function (along the lines what the 
> 	changelog also states why it works).
> 
> Link: https://lore.kernel.org/all/3b0546d4-d0bc-f76e-e1c2-eef2b4abf0f1@linux.intel.com/
> 
> But at that point the "p->regions[i].addr = NULL;" was part of a much
> larger function. Since then refactoring into various helpers means that
> it now looks OK to move it inline. The comment about why it is safe to
> update a structure that was provided by Intel-PMT driver is the
> important bit, and I see that you preserved that.
> 
> So LGTM

Thank you both!

/me folds in.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
