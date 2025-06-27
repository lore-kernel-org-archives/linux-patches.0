Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A852EAB9E
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751047610; cv=none; b=Jx7H5yDIINsBdTdEXyaFNW0MsFCOr4PJ3vmpGzHSVFp44giyPPHsI/NhIbWf4NevBmrpiR+4nAQKqmn0CVMzlg92wTHx2NCDruC7qjv4pfvGhd4i1xyHT9vzSpbRMwMyENBN1g00HazML+drFDkwsSq81xCfa4xcHd5UgoT0iWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751047610; c=relaxed/simple;
	bh=yiZP03mbg6rnyBd0F48oi88cRthyd9sDfrfBRlNT9uI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0rvxFSMaHltHG2TLFfzmukEh5YuAvT7NDZUxjbyIzsVIV+d/HX/CX1CJ/11AjcRVigpwb4SBomxc7A1YLKGuOUC0IyXwnvWu2ry1ult80Mr0NTtYU4dy90ezA8KD9EMQPMNkfUyfSz5gCbR7vCI7WL0UCy+SM8ms8jU63/S968=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=br/JscOv; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="br/JscOv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751047609; x=1782583609;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yiZP03mbg6rnyBd0F48oi88cRthyd9sDfrfBRlNT9uI=;
  b=br/JscOv54HnqTkb1ojUJtRurMemDdy30BS1V3Gs7bWLEzpPOA6Itd21
   262QF/CyQuTxuPyEXoQgy3kWZj75g4pIvlIz1dcEDSJ49rejo3dqA1KLb
   X0+QZ3MTMJquAFfeGxaiv1m2rgX0md6YpNW1Ydx/kGVIgMFEewzsduP+n
   b4EztnVCZa26YwWDLHaDvhsaIosUKlfywzMp4vSkQE0DSl+QTkhgiUIHA
   Z5d9dNsuFsY+hRAnK3qtoUf+fapCPdaL15z6dwu//5DbA2jFrfNxew6+b
   2TqtDqjtwTo8UU1cyuYNuw9o/85+wPRKKGhfY5AWvnF4xLdV1HdqZ5Ma7
   Q==;
X-CSE-ConnectionGUID: 0+xtfD7sRaK4hPzZq3odIw==
X-CSE-MsgGUID: yH+TwBtdRb6+iJ9Ng0a7NQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="53240819"
X-IronPort-AV: E=Sophos;i="6.16,271,1744095600"; 
   d="scan'208";a="53240819"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 11:06:48 -0700
X-CSE-ConnectionGUID: HIIOHZhGSyu29Wboj1w+LQ==
X-CSE-MsgGUID: yls7oSAXTeC/As6xhCRJcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,271,1744095600"; 
   d="scan'208";a="157152693"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 11:06:48 -0700
Date: Fri, 27 Jun 2025 11:06:47 -0700
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
Subject: Re: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
Message-ID: <aF7dt2iQpvuahZil@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-18-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626164941.106341-18-tony.luck@intel.com>

On Thu, Jun 26, 2025 at 09:49:26AM -0700, Tony Luck wrote:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 71019b3b54ea..8eb68d2230be 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -512,6 +512,9 @@ config X86_CPU_RESCTRL
>  	select ARCH_HAS_CPU_RESCTRL
>  	select RESCTRL_FS
>  	select RESCTRL_FS_PSEUDO_LOCK
> +	select X86_PLATFORM_DEVICES
> +	select INTEL_VSEC
> +	select INTEL_PMT_TELEMETRY
>  	help
>  	  Enable x86 CPU resource control support.
>  

The list of dependencies to "select" keeps growing. "lkp"
just told me that "INTEL_VSEC" depends on "PCI".

An alternative approach is to just add:

	depends on INTEL_PMT_DISCOVERY=y

instead of all the extra "select" lines.

Pro: This describes exactly what is needed. The INTEL_PMT_DISCOVERY
driver must be built-in to the kernel so that resctrl can enumerate the
telemetry features.

Con: "make olddefconfig" will now drop X86_CPU_RESCTRL until the user
hunts down and enables the chain of dependencies to get RESCTRL turned
back on again.

-Tony
