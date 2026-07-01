Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310F036B054
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782925790; cv=none; b=dfCqTVNXcxQ3f3It4750Nc04IcetKaueIUr3xwZXpmaMEI2lJ6QwYtwE7sId1T2QledGrj045XC1rhGosUTCBvyiKCEdyiDnv1rKFE9g+vpAhjj0izb+5MwHqCCWS+zH7Iciuo2Ihcdox+qUlnX1SjKUAZhng+DVLjDOkp7ZVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782925790; c=relaxed/simple;
	bh=WtNQFezkkPkqXnO2yXDAtKrjV1NCikK7zamwXjiBKWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0CnGdZJYbkYcoaEXVpPi28oDOiGred78dkbzXmPRjK81izK89/Eq6WZXPL7PoF0hoqe9ldx4RHrLqH7BJy9Ue7pCHSVS1Wk/1gY2gfwm1cvX+smWfpSMpXf4od9tgKmoUWYvXUfJqrdUvdLu3fl0W1z+uqX5/RvP0DgDy6bMWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=S1d5rMUQ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="S1d5rMUQ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1E92D40E01CE;
	Wed,  1 Jul 2026 17:09:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BH5NYlK73xb4; Wed,  1 Jul 2026 17:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782925777; bh=lKmGGawJKYUrjCpkpzHXZxlh6HbjhIs312b9AUALduo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S1d5rMUQLYvlFJoFWJ+rBY11KM/bfWINA6vR/GdiiQxOJF5lDG5JRJ/Jwz4/eebDr
	 KjA2synxO/ZU7nOPQaiGi/MpJFXnP1o7dWxuubrU+UNPbLHfFUjRSkphJ4A257gUv/
	 cGuCSFJ8sQGRPtlyRyobJKfTR8QXtPwiFMLBnw3c03DsqltRBYDaFiAS1Y2FrCqoij
	 5wwUhKZlkPBhE2qzN2fV2Yz8PW7r/Fx6QdAmK/4sqoy9rrhIyupHKXSuzZQiu43D4C
	 wylxOLXek6zhj69pXPwUH/T476qyiLKggNk9nJDy0fqZGkXU2PDHSFemA7I4wQdB7s
	 0Ji+q5D0FWAzut84+V5OQ7B8hkBpuiKB/olPUtisIerE3R25eF8xEKqAoC+g9UWFF0
	 S/NqlpRWdcOVELrdOKopIhkt7aA6BWxRgtAbG0oiHOXP4INvitI9h56DcNsiWgh+N/
	 VnZDGxX87nhBqoAR56mFia/xSGRXVzT1hL/vjH4CQoTPX1d1V2Rb6rjnoCJF1kscCn
	 8J4sBHaVOTP4FyVHgODPtuQQ/SbeX2sdgm/eb3V1OkrCUYBRYwYRXVWVDQoShzBaan
	 /RQM07bfHgucpO/A+v+gx/xEONrCpVlo+l4vku79Tt+AdhjQmIeu8JixXv/PGxR4gt
	 pR4Rf80oE07tvQ8HNGtMH6es=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7FAEB40E00BA;
	Wed,  1 Jul 2026 17:09:20 +0000 (UTC)
Date: Wed, 1 Jul 2026 10:09:17 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
Message-ID: <20260701170917.GCakVJvegWA9R9liDV@fat_crate.local>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
 <b58d51c1-67f1-4640-b00a-1a99dc93ccef@intel.com>
 <20260630225759.GDakRJ93cg21As0xnf@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260630225759.GDakRJ93cg21As0xnf@fat_crate.local>

On Tue, Jun 30, 2026 at 03:57:59PM -0700, Borislav Petkov wrote:
> On Tue, Jun 30, 2026 at 02:47:45PM -0700, Reinette Chatre wrote:
> > Hi Boris,
> > 
> > On 6/10/26 12:21 PM, Borislav Petkov wrote:
> > > On Wed, Jun 10, 2026 at 10:48:06AM -0700, Reinette Chatre wrote:
> > >> After considering the latest Sashiko feedback and deciding to stop adding
> > >> new fixes to this series, I do think this series can now be considered as
> > >> "settled".  If there are no concerns with this series self then I would like
> > >> to proceed for it to be considered for inclusion.
> > > 
> > > Ping me after the merge window pls. They'll have to catch the "next train" as
> > > it is too late now.
> > I confirmed that this series applies cleanly on top of v7.2-rc1. Could you please
> > consider it for inclusion during this cycle?
> > 
> > Thank you very much.
> 
> Sure, lemme take a look.

So some of those look to me like urgent material that needs to go to Linus and
to stable@ now, no?

Any preferences as to which ones?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
