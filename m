Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777951DF97C
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 19:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768074173; cv=none; b=Q5K8fHJGrW2KaJCSSYd6TXq8UwPoCPwhQqQvtCxAtExbZ1mpUGCVYpFtmDOOW7K8LxBpQv2YQUDEPr8Gi2KjLAV5BS1tbRb4aWcc9ypQEsQO22/T0OgqIVF2uMVMH3g5s78GMiAhKjxMjfQMQSph5BQLYNpCeNVaccH6BQnYt6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768074173; c=relaxed/simple;
	bh=1cjg1gZD6laXPAvajkWS94xoDLT+57IZ63zsAnfW0RA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JvmubIpYLhsdR2NUByU5Nn38nOgR9werBwBC8/j/z6r/DliFXiUqeS5u9SswDa6e07MK0sajkk4YVPohbkvpzoze4lsXzi+ah/AaJNu55As9T2lFeQewcFo19beN581sUK2obTNjzuoJQtBYBj9OPomVvcgEqh86nynNcpn85pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=E6mzv7aO; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="E6mzv7aO"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 41B5C40E01B0;
	Sat, 10 Jan 2026 19:42:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eIwtjm2ZjQqS; Sat, 10 Jan 2026 19:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768074166; bh=pCUvxmPSJCTuaCAu6iQQtkKK8lzoj6oHflr4OLcakoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E6mzv7aO4oOjuWTvF0w94xkNLEKgNwA+vNutvcQiSTl384CQmyVhceOlCjnwVEeSz
	 hqVC7d3eS5W4j4UhbFUO7lmxzJW06WOysIds/yCx+/cm3P6qAH/Q1sJ1lScnbd0VoC
	 oPXun3xbtRwO3uspHM0PK8eKmPT3ze0fVA/HDEGkuU4sMuqt64JoNd7nRjWvQSmf8j
	 WDwjhCf42diR3FEB0i7vjJzmPjDOFe6Rnr3CJeQ/Bdw2pYImQ4k9bQEFJBS2lwVmqN
	 Xg0/TZDC5eBRp5WdsF+TOGxa9RNzVfGgn0dvskxiUFPdPIz6zmGKKPRZ5rAloXQUOS
	 diNuAtfq8aYqH9y2AL3F1iFZUGAGrnq32pfIn9jwaqt9/GEsYNUgAvuFK/tshJGIC/
	 owWlkZEAU9zRKT6Ja4QIc7X7nQaJHwMLc6o7R/vSrklSvVC9P3Hq0yiTKThfGgC1Tj
	 6V2CBp3MuoiEcwW0Hshlzq4jL61Kpt/wtAU1O8VbgIXaxbjIDqEFZRgjEyGUx4JNFC
	 RbUl7nFQC4XTelPvF6EClVJtLX2K3mYqXkxfuTSUg1hD1FqtzQUt0ROMHbWNjCw8Of
	 IWxofIymKnNnqs11xowbrl7en7x2j8jk6jchcAFz0IXVIvG8vJqCmYVNkUNLEvDqlB
	 ruycf2K9toRyDVanZUMMRZjw=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D71B940E0140;
	Sat, 10 Jan 2026 19:42:32 +0000 (UTC)
Date: Sat, 10 Jan 2026 20:42:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
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
Message-ID: <20260110194219.GCaWKrmyJCU_y3vfDD@fat_crate.local>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-31-tony.luck@intel.com>
 <20260110105758.GAaWIwtlX9o_oVXIM_@fat_crate.local>
 <aWKk5BYP8BJjYhs6@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aWKk5BYP8BJjYhs6@agluck-desk3>

On Sat, Jan 10, 2026 at 11:13:40AM -0800, Luck, Tony wrote:
> Please drop patches 30, 31, and the debugfs hunk to Documentation from patch 32
> while I look at options. The debugfs bits aren't needed for normal
> operation, just for debugging if things don't appear to be working as
> expected. No need to hold up inclusion waiting for a solution.
> 
> Telemetry based events tied to RMIDs are new in Clearwater Forest. I
> have line of sight to a second platorm. But extrapolating from two
> data points to decide on a stable ABI seems very risky.

Ok, makes sense.

I've pushed out the branch, you could have a look and lemme know whether
something's still amiss.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
