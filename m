Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF92F878
	for <patches@lists.linux.dev>; Mon,  4 Dec 2023 23:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BmkiEVWd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701732327; x=1733268327;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rea7cSztxOU/Tn6j4cuH2tcjGKjYfBJMSKRByJlHmUs=;
  b=BmkiEVWdCFSnV6+YT8CxRdhBnGVjrY8pG4HhQT67N0ifLn+lN0RIfUjY
   0cN7OPnNKaecDWWGxiT5gG9S6l7BwHe8DcdP5fgYrcGhjg3KICX2Oa/L2
   QpKIAMK1vvfw7UuKIP1VqyLNuSU/jQ/4BEb8W78wJ8IL5vhzKyCMT9jNo
   YAOd5ImhFm+SQVtGsQysI6QegRPKPMNAq19Dt9K4ShACdcSlJRFG9vtgE
   2ARi/s8zEEWybPwybzPlQN5vjSHaqWQUZ6RupWib+uKT3MyamzqthYotU
   Ncr5LhJDWwaUGshwAwc0UcFjmK8VLy67bJrccih4u69V0Epie9At7rqrE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="397714458"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="397714458"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 15:25:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018011391"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="1018011391"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 15:25:24 -0800
Date: Mon, 4 Dec 2023 15:25:22 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v13 0/8] Add support for Sub-NUMA cluster (SNC) systems
Message-ID: <ZW5f4iiNaaPqndKt@agluck-desk3>
References: <20231130003418.89964-1-tony.luck@intel.com>
 <20231204185357.120501-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204185357.120501-1-tony.luck@intel.com>

On Mon, Dec 04, 2023 at 10:53:49AM -0800, Tony Luck wrote:

Boris: I've collected "Reviewed-by:" from Reinette for all patches. Babu
sent a Tested-by for the series, and Reviewed-by for each patch just
now.

So it's ready to got into your to-be-reviewed queue.

Thanks

-Tony

> The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
> that share an L3 cache into two or more sets. This plays havoc with the
> Resource Director Technology (RDT) monitoring features.  Prior to this
> patch Intel has advised that SNC and RDT are incompatible.
> 
> Some of these CPU support an MSR that can partition the RMID counters in
> the same way. This allows monitoring features to be used. With the caveat
> that users must be aware that Linux may migrate tasks more frequently
> between SNC nodes than between "regular" NUMA nodes, so reading counters
> from all SNC nodes may be needed to get a complete picture of activity
> for tasks.
> 
> Cache and memory bandwidth allocation features continue to operate at
> the scope of the L3 cache.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> Changes since v12:
> 
> All:
> 	Reinette - put commit tags in right order for TIP (Tested-by before
> 	Reviewed-by)
> 
> Patch 7:
> 	Fam Zheng - Check for -1 return from get_cpu_cacheinfo_id() and
> 	increase size of bitmap tracking # of L3 instances.
> 	Reinette - Add extra sanity checks. Note that this patch has
> 	some additional tweaks beyond the e-mail discussion.
> 		1) "3" is a valid return in addition to 1, 2, 4
> 		2) Added a warning if the sanity checks fail that
> 		prints number of CPU nodes and number of L3 cache
> 		instances that were found.
> 
> Patch 8:
> 	Babu - Fix grammar with an additional comma.
> 
> 
> Tony Luck (8):
>   x86/resctrl: Prepare for new domain scope
>   x86/resctrl: Prepare to split rdt_domain structure
>   x86/resctrl: Prepare for different scope for control/monitor
>     operations
>   x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
>   x86/resctrl: Add node-scope to the options for feature scope
>   x86/resctrl: Introduce snc_nodes_per_l3_cache
>   x86/resctrl: Sub NUMA Cluster detection and enable
>   x86/resctrl: Update documentation with Sub-NUMA cluster changes
> 
>  Documentation/arch/x86/resctrl.rst        |  25 +-
>  include/linux/resctrl.h                   |  85 +++--
>  arch/x86/include/asm/msr-index.h          |   1 +
>  arch/x86/kernel/cpu/resctrl/internal.h    |  66 ++--
>  arch/x86/kernel/cpu/resctrl/core.c        | 433 +++++++++++++++++-----
>  arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  58 +--
>  arch/x86/kernel/cpu/resctrl/monitor.c     |  68 ++--
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  26 +-
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 149 ++++----
>  9 files changed, 629 insertions(+), 282 deletions(-)
> 
> 
> base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
> -- 
> 2.41.0
> 
