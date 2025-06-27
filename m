Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B20B15E8B
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751047747; cv=none; b=N8E2mbm7bodyiIJT6wq52870bKTJblDV8fek/HzTpXA3x1XfXTbF2hwvS3jelftKB029lujahojRsDD7UqZcB3PfjjTEjWknugi4kud/Y5aqSjSzt8FlRvXP2pxIhlsltF7o8Hk5OYhDejpkSerqZAcTVDHNuWNABKDwY70NSvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751047747; c=relaxed/simple;
	bh=B6UiHmOdGVqCCPiadsY/GxL/iB+ka8aM/e0rF51MsIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIBPBHJZXBW+v4FBDhoYnmO/jHoJiEBnrC3zbdkrtu0iJ89b7oS6tgxmRuVHxGaORwk48FJl7LD2Ss4y7PGix1qi6IwyTdedeBs7A8luZjvB3+9FW36c5uWGLhxvDHJ+labRLBvrUoxThnS0DLgU0HY/8xa+S2QOomzEwuOBKG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L6jxMXYu; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L6jxMXYu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751047746; x=1782583746;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B6UiHmOdGVqCCPiadsY/GxL/iB+ka8aM/e0rF51MsIQ=;
  b=L6jxMXYuxOo3SzQgrY/1bGagQCbmb8nsMqlZJRkRgHrt+ETGqIFKAHu/
   EshcRUnIGbQhf0aPLpVRAcM0Nxss5+uHDUp0nlCYzTwUeyey6b5FuOlUJ
   Rqk32xJ4d7/++nyCYMZTwr7TZnZlCwUdHHpr0qG314hxj+tJIIyW2lKn0
   NRfTw+1Tu45ZcE0f2juvzqNNv9zT3kTHSTznoWQHHHy5+0weGnUJPuGce
   AiEKJCouNZPAeGxtcUISLK//puTMwAcnG9IZIlHqwwFX/Or2jrBkjdXH6
   Vscj4Lwn7RrYeIxmW/FhLjmKdfNGmRDZMQU7L4wMvGVvY2bkDO2ThYa2W
   Q==;
X-CSE-ConnectionGUID: 0kcuQHVNQseFRCOhA4VPlA==
X-CSE-MsgGUID: DHF5dgd2TxeuHHtpMzsHwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="52597469"
X-IronPort-AV: E=Sophos;i="6.16,271,1744095600"; 
   d="scan'208";a="52597469"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 11:09:05 -0700
X-CSE-ConnectionGUID: fU4ZRM6DQTuNlHswO2on1Q==
X-CSE-MsgGUID: s3ZfSGAtQiaBCqNEr8PFow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,271,1744095600"; 
   d="scan'208";a="152484039"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 11:09:05 -0700
Date: Fri, 27 Jun 2025 11:09:04 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
Message-ID: <aF7eQBURanNnxer4@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <aF3lRKURweT4mhAj@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aF3lRKURweT4mhAj@agluck-desk3>

On Thu, Jun 26, 2025 at 05:26:46PM -0700, Luck, Tony wrote:
> Bother. Just got e-mail after posting v6 from lkp. Apparently
> I applied the fixes to avoid "'d' used before set" in
> domain_remove_cpu_ctrl() and domain_remove_cpu_mon() to some
> other branch than the one that made it to my final version.
> 
> Please imagine the hunks below merged into patches 7 & 8.

I merged these changes back into the series and pushed the updated
version to git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
branch rdt-aet-v6.
> 
> -Tony
> 
> ---
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 3ec8fbd2f778..39cee572a121 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -651,8 +651,8 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>  		return;
>  
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (!cpumask_empty(&d->hdr.cpu_mask))
> +	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
> +	if (!cpumask_empty(&hdr->cpu_mask))
>  		return;
>  
>  	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
> @@ -696,8 +696,8 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
>  		return;
>  
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (!cpumask_empty(&d->hdr.cpu_mask))
> +	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
> +	if (!cpumask_empty(&hdr->cpu_mask))
>  		return;
>  
>  	switch (r->rid) {
