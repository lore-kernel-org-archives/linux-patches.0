Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE63345CBF
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 22:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767996992; cv=none; b=kZcZCUZVQRn6A7yweb3kOibZ2tEzojMZ+sNY+1CtEU76PxcKdFTuorcuzDbK6aDcwjgklWC1kVHzBOE+5H21H9Nos90NxBOJOQc9wfll6J2hqAsXhIK0MbXWbj6QKm4+Kdu3YGY57EOKevzRhk6AQZzdCGJLjEYXpueosmI3utI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767996992; c=relaxed/simple;
	bh=cxk1xow6CQeAOgvMi8GBqisy/olozKnTmv9ScIK5g4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIx6FL/B0bQpqPA7PEoXAZvdOBMSiwBYMwRafXq2vQsrX1rqfiLYD6DThNFZKwm3YI/gfeKtJk3v1XCLf80OAqCe7MWSJXimCS3tDIK2bvm4CjYcuDCF3AVMQI78hdSTWHiU4/lutDexTp45Nq5ixwTyP4PYHU32LYNvT+MA770=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=em6tWjjJ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="em6tWjjJ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 45CE840E02D2;
	Fri,  9 Jan 2026 22:16:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TguyptvE2ilO; Fri,  9 Jan 2026 22:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767996981; bh=mCQza+e453B6lyWbX+tbqNYM+HVyVvM7cVhptS5lTrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=em6tWjjJ4g0Rft+nEkZdu695QwiIwGOjzFnASL/obEcEr23WnpGSTEMeiJRYrQ3E5
	 elsrMJIRIafiBZPWndxlLU15czkDJqhdxyXYPI90XBSSVdu2onU1X9fxXiw1IXYitD
	 U7aOOcghNOwEOXHIA/k2GZ1Hoi3HHs6CYvypN8g7yLUF0fbje5hITzLWxj0J+zi20P
	 F7VSX/saavY8E5JC1xGwP1KyrZH0QLTrFE/Fw8d4ZWyYZ+5XlLHHScbf3z+fUZsgag
	 YwnqnfUCsPypzfGxZKZrKNmht7YOWZuA3ST4yaZyXsEEdvsQ8rMF2WkaQ9YrMaxz92
	 QWHwc4Io/HVYX3YWVJCR9BiNcUDcDVx2hIOk/w5NhL9k3om6gJcNNyfh4a2uQEdIAY
	 Gp6eR/Wt1/tPPQt5SPrlvSKsdA4vMUdJSdpEJJ7ZeAzjDAbvNNNplHWKEJuA7nS7M/
	 Fvq1oAizOAszY3Hpz5CS+q7vlx/F6l3TYaYLghe0VLi1BOiC2GQlCr0pVRP8xl6J4o
	 vht+OA+Nnkn/tKK+fW5e732Frmk09fDg5aY2hxd5uLSqscA5f203n19TrHmR/vI0GE
	 G0JhWFuJc3oVFfJCZeX4IcQlWjeTy3+MjT2QyFEnzKrBljYmml2rZA/EyWoETepETa
	 b066X6UuQ1A5oYRaBxD/w+H0=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D26EE40E0028;
	Fri,  9 Jan 2026 22:16:07 +0000 (UTC)
Date: Fri, 9 Jan 2026 23:16:01 +0100
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
Subject: Re: [PATCH v17 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
Message-ID: <20260109221601.GIaWF-IRmxb7WgQOWj@fat_crate.local>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-25-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251217172121.12030-25-tony.luck@intel.com>

On Wed, Dec 17, 2025 at 09:21:11AM -0800, Tony Luck wrote:
> +bool intel_aet_option(bool force_off, char *tok)

What does that function do? Handle the AET options? So then

	intel_handle_aet_option()

?

IOW, you need a verb in its name so that it is clear what happens:

	if (intel_handle_aet_option())
		bla;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
