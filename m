Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B173309EFF
	for <patches@lists.linux.dev>; Mon,  5 Jan 2026 20:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767643511; cv=none; b=WCRvmaIu+I/aB3jSuz8sJKG3QAFFoHXopkmNN3PKDo2AauqR4KaL1JBeQwXJgmubLkthUbkfyx1XZCRvet9DwKDv+Bjbq7lU7rS4Sxrn9KikwRoKJigFE4Ku06Lvafc9RF/KsO1T5Gq4Z8agiWIjcF2VNbddH8vrrtptBm3Zwvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767643511; c=relaxed/simple;
	bh=8rGsJOPoBK6tzfPienNbkfw8m1KJbEj8VludccOvIVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S9tMdOyxmIyrBhAvrYQWCad0WrOq9bhiEZiRHr7GRLVZpr6wei5jpCOHKfgck+VM61fyuv2icr+jlrtgyUAD6gPH2sd24dGSaF0JEz7/nsYFxhR+XMtktJ3WC1EXOgYtuoKpaeHMI/EWiSlvvUgwcDT3CDplkqdvhQLmi+ExVdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Sc9j04Ck; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Sc9j04Ck"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 105F240E0281;
	Mon,  5 Jan 2026 20:04:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ixJ1r1cTCp7o; Mon,  5 Jan 2026 20:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767643495; bh=Dizkrm6eKzU3k+y+8o/ZOQp4ibWNEXt7wSSHn8M/kQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sc9j04CkXPFhkuMW3fZBOng7gAzkL8k7n7xCVjCKVEodG5sbIE56J2z/UYU7XrQsB
	 FQaEx5lxkMeF0P8U6MeZH+HPkc7VtSWEr1ns2Jv0fXvzdmRkevodqYEZ+ORiPu9Bvj
	 IBbl5kMRRiIDFirNCCr1OCmH+Ux0A7y+jLDJsr0KKU3rcTJ9/0yfbbT4AkGA9WXX8m
	 5aYiMEfzndlqbrnVrOxHTTJgtuATcrXKKzxLiulIjUIELL2Hab5F5fJGXnYt9bdgYq
	 2nQRIO8GCU6eenEsEx05Jl+boBc+eI8UZcGYVONr0XJjs9mQyhSssCJyVw9kwaiyhh
	 hOkE+L0ohnuqPODV7LWsIiaVOhJSMVxW3F9xcUbzikliyFgh7iadNOXVQnSKzwaBsE
	 FH2yospj7sH5ziCsvFZWoOpmwc1SaE9HnG0uwUC8k2dvoEbZd7NebW+BMqn2EOD++X
	 ZyLkD4KHzVN0OkOPE24tKp8VzCo4b61ra052laOTszH0Ft3rsVJufq0k3z+cXkEu3T
	 Z5uLDTemHjXliwxwAjt+vJJev2uWbBQzdPANUjXBgkEW8ZbYZ+I9zfsNO9dppSViOs
	 EkXoJhDt5EAJvzH3FbxYkPxxEt3k5bTeArz8SKSEGARXdrOJhHqdsAarpC8jOXSmbZ
	 s+fI48AzUkxpnH1UJiAwvuHs=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 5172640E01B0;
	Mon,  5 Jan 2026 20:04:42 +0000 (UTC)
Date: Mon, 5 Jan 2026 21:04:35 +0100
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
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Message-ID: <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aVwTcX7V_HN2j6SW@agluck-desk3>

On Mon, Jan 05, 2026 at 11:39:29AM -0800, Luck, Tony wrote:
> Learn something new every day. Yes, <linux/once.h> looks possible here.
> 
> Though I believe I'll need the DO_ONCE_SLEEPABLE() version since 
> resctrl_arch_pre_mount() grabs a mutex and various called functions
> allocate memory using kmalloc().

Aha.

Ok, if it works and passes testing, I could wait for you to send me an updated
patch and drop this one.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
