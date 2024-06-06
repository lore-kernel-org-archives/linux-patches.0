Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6A195985
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 12:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717677809; cv=none; b=CTj9Pk/FraUnQJWuv8bGbsK/faBw+CPDYnQeWLdaAglFucFcXMDpNSb1qwi9JhAAu7n3Np2n6TzRm3jDhUxRS39atLA1CiYiDA+odl6vHk32beX9LYDq8dqspme0SOjIjqPJyjgXfdhYAVO2FnzP8VvR9Fo56owGXzVZVtjHlXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717677809; c=relaxed/simple;
	bh=yeaLzEzJvuDa+m3/Uff7Po27zqgumLOSQUtaxyu5en0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0COBPEz2tbbQbMVQ20S652WnTHgnQ4zY1WcpnhyWIbGr8pSFX49hpcRNtd4a1GZCCDhxyaTHoY+ZqAeF3VdMs4a2ISlvvoLsQQNAlEjM4GvG+9NQQD575qZ4LDOv5R+83NMNAvAEhvxm4EJ91BTLG1OKOkZUM9hti2tG4QHsO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DgkphBEY; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DgkphBEY"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C07EC40E0177;
	Thu,  6 Jun 2024 12:43:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cftr_SWYD-Q8; Thu,  6 Jun 2024 12:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717677801; bh=p+KyFhBaucRcYTGBApiIZCCM19WHZeYhUd5Yam8pwIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DgkphBEYlRfV6LQse3Mv3DAu/Rw9h78h10oBjOtWaLPSAE08OFA7rrRgVe0aEbmJI
	 YcTm1/p3ISnTcSo+Bm1LLB2zZNHeuCdd3nf8aDviK9JoEz8b3uj4+SbxlLuYRwS4kt
	 WJrJ5yClBwDCqYStlX07ay0zoWXftsEZILvDF2/UYsHWzMi+oziWxXrSXexw0IQLZg
	 c6ElT7xGfaL21PBeBXc+gAU2i8rNkGoI8HhfMvU0BngplCCcZFhMwXfAt1oJ15IS27
	 YzS0VV6jsJgO5RL5ky5ZjYyle6v4eF99iscRO+eQHHl4Dxv7G0XnV9fD5OxNetA2n0
	 U04JIzNXoLV2iIxK/hrcs5zfmAjsGdjJaBZ0GM5f5A3leKOklSAETEFJPzjsQObUEJ
	 q+kW4KM+Z1HZa5GL7C6Jh9p+JEpH9xntHRBqaaNE8rqwnVXi+Fhj5jM6wlZrzbw0GP
	 Jrxj0N2HeoIXa2n7b0ISgQMenlPMVVIp1Nwheu5csP1ryTX4wtZA6gR1YNSwLCnzmb
	 6tvek0VgpXoXJNOdb4ORwMFk8Gp/o/Qjvx+jwKebdIvrStL3V1mH2MAwVajjQOf9Dg
	 OjMpXRWL48CEe4otcYw+ZfcXgsqoLLstfxbSjPooen8P/C+1RmD0/om14U/8hpnFQw
	 Va2PlqVfCCkAye/3XsQCkvfk=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2D01540E0031;
	Thu,  6 Jun 2024 12:43:09 +0000 (UTC)
Date: Thu, 6 Jun 2024 14:43:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 3/3] x86/resctrl: Replace open code cacheinfo search
 in rdtgroup_cbm_to_size()
Message-ID: <20240606124308.GCZmGu3Aj3_spSd0WS@fat_crate.local>
References: <20240605161427.312994-1-tony.luck@intel.com>
 <20240605161427.312994-4-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240605161427.312994-4-tony.luck@intel.com>

On Wed, Jun 05, 2024 at 09:14:27AM -0700, Tony Luck wrote:
> Use get_cpu_cacheinfo_level() instead of open coded search.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 02f213f1c51c..cb68a121dabb 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -1450,18 +1450,14 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
>  unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
>  				  struct rdt_domain *d, unsigned long cbm)
>  {
> -	struct cpu_cacheinfo *ci;
>  	unsigned int size = 0;
> -	int num_b, i;
> +	struct cacheinfo *ci;
> +	int num_b;
>  
>  	num_b = bitmap_weight(&cbm, r->cache.cbm_len);
> -	ci = get_cpu_cacheinfo(cpumask_any(&d->cpu_mask));
> -	for (i = 0; i < ci->num_leaves; i++) {
> -		if (ci->info_list[i].level == r->cache_level) {
> -			size = ci->info_list[i].size / r->cache.cbm_len * num_b;
> -			break;
> -		}
> -	}
> +	ci = get_cpu_cacheinfo_level(cpumask_any(&d->cpu_mask), r->cache_level);
> +	if (ci)
> +		size = ci->size / r->cache.cbm_len * num_b;
>  
>  	return size;
>  }
> -- 

Those last two patches can be a single one which replaces open-coded
cacheinfo search in resctrl.

Or is there any particular reason for them to be separate?

Because it is a single logical change...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
