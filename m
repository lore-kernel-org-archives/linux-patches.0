Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F654278E63
	for <patches@lists.linux.dev>; Sun,  4 Jan 2026 06:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767507309; cv=none; b=VJxfQvWZ4YmdDV9IPH910IRpSzXVRvi5aaw2PnaXfA7CTzkvkWvnpjLM6Cdyd5qre/bmVU3dShZ81L6bLQqbZdVzYBss99LllGE5Y83zfxPuh+rceeqHnJJRVQ/6FM1sEapVrfXaNNWxaJZ41c2MHcP/VTNTQB0DFFcRnilYx5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767507309; c=relaxed/simple;
	bh=XW2494OGrflsXwD1svbIl8gYZ0Mbv6WvyGYDZVD+tO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xa9f26TMdHlPlfV6Mf/qWOnrWthj1iajr5Pj0aQeKDooYMe3+CcrEfgwFJPhwJ0AuYSTIgTygbWsatqtaVEpOTPBVetUqX5xnChmJdaGg/Y+2wCH8xkdyA1G0qpxMfqVDStYOsqi1aIn2DwtNRsNCh4efg6IFYm7K2fK3LohY5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fryQUcYs; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fryQUcYs"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2542B40E01A9;
	Sun,  4 Jan 2026 06:15:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lPDjRQX8xBzJ; Sun,  4 Jan 2026 06:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767507300; bh=WYCHUhqquoisFvi090qiZpzCbJw9bxDo1d9PZoVD9Fs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fryQUcYsrmBffN0Nu+9kYJeVYuBxxtbsVkP2By9jogcezb6asTBhR73PBYo+80Bml
	 eGrrJPdUyO5A3HCPt6XaYsjtPisbhtTPyZxR1gunIFyHhMvy+Zi97xbdA/DxsS6j75
	 GlFj2R5ZYXHma4rBjmv3+fs+86nRBR4W3umIAV1UUBZdiwjc/8hmmD83Ukl7TLMyMj
	 Tmkynipi8RfDUC5/OxrlQ4xQP3V6px5jdoAf05dbuKXC34+mg54zPxkxtdPeTUb4zu
	 0gr4auej3CtlEsAixRAzketAK/ltWfo7prbeZ/U1Foi3nAnyv4Hl30bQWALapHtuHQ
	 k+Eh2BLs1xioNQ0wh4d5xQ7GHa8kVT1SWy2kkkkBfT/fETquJvANmP9z2quTBFgLa9
	 RIAGIpbTd2d5H4CmuluhAlkvbYQLbf7X6hw3hM4+sN4fz2gzi64dCPHZQDpW47ztnN
	 6IOIriJyzxCIZVzjZIto+JRvs2NdTTl/u5qscwLopEh/wYcnryzU/t9GkaqraZaCX/
	 MN/WxrbLGuBgABffNpB2pgW+zFKwRjCmwie9R/gofELeVBmRcNwPCHHVEIZaM3j1ae
	 Cp7jcRec34Z9hlwYqyPOvLhV7oOhEoFRMa8+ctY2i91Fggdielq1vq7mdiIqn8V2Dl
	 AhjEftk8AYG1nFFKkTNFmYCY=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id B95F240E0140;
	Sun,  4 Jan 2026 06:14:46 +0000 (UTC)
Date: Sun, 4 Jan 2026 07:14:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v17 00/32] x86,fs/resctrl telemetry monitoring
Message-ID: <20260104061445.GBaVoFVad6sQQaapK1@fat_crate.local>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <b085963b-5bcd-4859-9011-f31840929a1c@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b085963b-5bcd-4859-9011-f31840929a1c@intel.com>

On Wed, Dec 17, 2025 at 02:16:52PM -0800, Reinette Chatre wrote:
> Dear x86 maintainers,
> 
> Could you please consider this series for inclusion when you find is most appropriate?

Sure, lemme take a look.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
