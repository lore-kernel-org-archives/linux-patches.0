Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6783A36B913
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 20:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787170149; cv=none; b=oJzh3jkql6myMQ6vRWW0Iaku5G+3d0X/n5yOjKcrGFxKlAX3e1Ldn4Cf5Zsip+ZkyVx0tMZe3qxPCA76QsR9RskUOAk9xZz0Jo7wFxwN2xPGNmt1oWPgEozpJEj6PrpNsJqKEG/uSQzjdyrs8VpE7K4NyUhqwW32IU/EUaPeFMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787170149; c=relaxed/simple;
	bh=ZZIPJwxrtmQGr3GSQRnlHtoqD2st14ULRguY77ikS34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWteqEErRFvMnNtlktstS+bfLenN1L30xhTaTXv5q6i1IQjc2/Pa8ErWQ42IJmKPfpt9/6sExcLXaYnBijDzwbJhg/daDzJCoTT2+CndgCpo73NYUWBSDKrF+pkO2SOG3LvrpFZ1IeQnTZU+H7jRjfvwVqLMEWs8ddNQcMYbGcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fxe2wWNx; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fxe2wWNx"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 76C5C40E01CC;
	Wed, 19 Aug 2026 20:09:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2z7vyBLpaaTM; Wed, 19 Aug 2026 20:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1787170132; bh=keLTOphb1fmvbQ7IE5uN02+95vMI+anZnClKf6xSCWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fxe2wWNxcr2JQMpGuD82cSUg3I+PDC26+EJCPThX3znmX8fDOjcv867am5ZI3odS/
	 U21fVGo2b7u7u+cH/kgUiLeZlGtzDub0LMUfXGiCK26b3lq8OC8/ByrvgWUg+Jv2Hx
	 vNdV7npvEY2eAtOmh92XYK3/FT/NaeyecMYciUgNZZwVOVIFgAghnizCLFsa5hPgtr
	 EbZ6fa+Tr6QtMysVGQG3Z/Huvsu8ZfooECJbMdmVWQ9oHXP+Xm96eu3xXq36ZQyYwE
	 pQ0YBdGnM5qCc/zSTcjsVt9EkzryLT6K7NMUI0QDQdeKElX3hIHOAXrIvdomEjPVA/
	 ciuJyG52BrifOUMEmYeZAluey52WS4jTpViQcaUaHBA4vqg2PlQ7ll4XENWGhJyefN
	 VI1zPyrxY3Jj0eoqiSXR6/tMjWtyRJQ2Y1c+toaUda+eLxuHclFi4g0yqsoFsGZ78x
	 gdDINYKXeN+SIqCSLsdPEuppntKb/KpswPZS5k0y4y7EB/Q92d+9npyVJLg2E132sP
	 KrxRafah8Jay+JH+Tt8HraidC9INQ6gmfu2uYMpQPbZRuDnbBeArher1yTi/0q/2cC
	 zSOy+013A+ImzjueruiqQSDZwiQJ4mUpGRc42Gpu5moW/Rti8WN8B5oYP09XDkAvZF
	 F4/iwYbNKOHmEryz2rgk+y6k=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A429440E0171;
	Wed, 19 Aug 2026 20:08:38 +0000 (UTC)
Date: Wed, 19 Aug 2026 13:08:35 -0700
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
Subject: Re: [RFC PATCH 4/4] x86/resctrl: Delete resctrl_cpu_detect()
Message-ID: <20260819200835.GAaoYNQ5Zn7o_s6SBc@fat_crate.local>
References: <20260819161323.11587-1-tony.luck@intel.com>
 <20260819161323.11587-5-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260819161323.11587-5-tony.luck@intel.com>

On Wed, Aug 19, 2026 at 09:13:22AM -0700, Tony Luck wrote:
> cpuinfo_x86::x86_cache_{max_rmid,occ_scale,mbm_width_offset} are no
> longer used.
> 
> Delete resctrl_cpu_detect() and the fields from struct cpuinfo_x86.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/processor.h   |  4 ---
>  arch/x86/include/asm/resctrl.h     |  3 ---
>  arch/x86/kernel/cpu/amd.c          |  3 ---
>  arch/x86/kernel/cpu/hygon.c        |  3 ---
>  arch/x86/kernel/cpu/intel.c        |  7 -----
>  arch/x86/kernel/cpu/resctrl/core.c | 42 ------------------------------
>  6 files changed, 62 deletions(-)

I obviously love that patch!

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
