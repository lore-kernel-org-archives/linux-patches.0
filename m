Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD7819CC3D
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 20:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751573879; cv=none; b=snl1D4jwbz8BcqM8qn6OElLNf8mEQ/0QIHif0Vn2aFYqlCrKYkujYHYFy2VFGvaS8VDrcC+XlIqJaDtgsjdV4LDdYuW100sKsOCGKH9FYBNvbdrMNXJp4g42iBA6/LEINv0IGvh/ZjbiIOonnX8CZfQwIfWhrW/n32umpPec/hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751573879; c=relaxed/simple;
	bh=5Zc5AYO/w4IUy0DP1VkVLeKbvMqQ25BFVpD7sEhMVrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SaJvCvxF5J4wAL3hfxv2lppvxmjWHdpGLbvE3JMS/kZQN5+MzjpBY+TgNomsx+r3mtvaoxYesKvtPvNHG5axYfGyXdl0Fhqr64aZ+C7xyVHWgZ/OG9IWQcaxCsrHRuuvHeoFt9UxNdPPpdsp83HUFe8oL4brzJagQxzcNfnTa5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QG7y0/9e; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QG7y0/9e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751573878; x=1783109878;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5Zc5AYO/w4IUy0DP1VkVLeKbvMqQ25BFVpD7sEhMVrc=;
  b=QG7y0/9eU5lOF/d9QD3aC87Yh9bJiCDRBPOXYDHof5OI0YF25gUpEHEd
   idoYpuiar64FDkkY77no60zWNEr/Le52HCLg+n1GdC4g0xhBjwuTgIpXz
   x46dxR5E1mplKzt4dNjVwBq6HAf+KbHYlInH6yt74UQgun2a4ae02y8rk
   NetW47TcLfbYCggegbrB35T4mSdopFno6qwuGbzxacXxseYaoY2u0VFWM
   +KyDkBR4+OAJ56iEv5nUOKpxI7UMsq5T+S6js1rW5FdKprQKft5aFRG35
   E7dI/Q8QfGf5JzMMOpRW2yr5zmUWGptEk5p/fu93ZCSlEndXj+c59nYMF
   w==;
X-CSE-ConnectionGUID: /JamlvDuRB6Ccx+FvHhisg==
X-CSE-MsgGUID: kUV58oqqR92L4uLUxksSKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="71482988"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="71482988"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 13:17:57 -0700
X-CSE-ConnectionGUID: ah1uz+S5RxiXgleAzZFvkA==
X-CSE-MsgGUID: 1ugZKt8JRj+M8STKY0E6Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="158813004"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 13:17:57 -0700
Date: Thu, 3 Jul 2025 13:17:55 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
Message-ID: <aGblc2VimjIiy_bY@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-18-tony.luck@intel.com>
 <aF7dt2iQpvuahZil@agluck-desk3>
 <eb6f7bc0-23ae-4100-9a34-fade6c650460@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6f7bc0-23ae-4100-9a34-fade6c650460@intel.com>

On Thu, Jul 03, 2025 at 11:27:19AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/27/25 11:06 AM, Luck, Tony wrote:
> > On Thu, Jun 26, 2025 at 09:49:26AM -0700, Tony Luck wrote:
> >> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> >> index 71019b3b54ea..8eb68d2230be 100644
> >> --- a/arch/x86/Kconfig
> >> +++ b/arch/x86/Kconfig
> >> @@ -512,6 +512,9 @@ config X86_CPU_RESCTRL
> >>  	select ARCH_HAS_CPU_RESCTRL
> >>  	select RESCTRL_FS
> >>  	select RESCTRL_FS_PSEUDO_LOCK
> >> +	select X86_PLATFORM_DEVICES
> >> +	select INTEL_VSEC
> >> +	select INTEL_PMT_TELEMETRY
> >>  	help
> >>  	  Enable x86 CPU resource control support.
> >>  
> > 
> > The list of dependencies to "select" keeps growing. "lkp"
> > just told me that "INTEL_VSEC" depends on "PCI".
> > 
> > An alternative approach is to just add:
> > 
> > 	depends on INTEL_PMT_DISCOVERY=y
> > 
> > instead of all the extra "select" lines.
> > 
> > Pro: This describes exactly what is needed. The INTEL_PMT_DISCOVERY
> > driver must be built-in to the kernel so that resctrl can enumerate the
> > telemetry features.
> 
> How will this behave on AMD systems?

The call to intel_pmt_get_regions_by_feature() in the INTEL_PMT_DISCOVERY
driver will return that there are no telemetry events.

If it is a problem to force resctrl users building AMD only kernels
to load the INTEL_PMT_DISCOVERY in order to use resctrl, then I can
look at providing stubs for the entry points in intel_aet.c and
create a new CONFIG option to allow resctrl to be built without
Intel telemetry support.

> > 
> > Con: "make olddefconfig" will now drop X86_CPU_RESCTRL until the user
> > hunts down and enables the chain of dependencies to get RESCTRL turned
> > back on again.
> 
> Reinette
> 

-Tony
