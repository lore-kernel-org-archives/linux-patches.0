Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351C8101CA
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692985831; x=1724521831;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BMuydG6qd8dGt72QIXVZ69QQMN032z1ooN3auzKbqYg=;
  b=mBp+udD5FtJghVoOgGL7wNS+Ep2yHeBN25NK3y1ApaySgCIxyQ7mwPHA
   I+RViyc/4wYsBZQe9+VHVmA8g60joxvRDYQ0mINkyQh0eS1L1QBPmMAaU
   XJjBYdyGXDsI9gRnChhpMbIbkXu8oDseLYctD6NDBaVMoSpXSD/JvhlxT
   bHHC/O8qJWT6LQzi+ANPuWraPgM5eCOe4HPD82sw8yNqQCk6/RPIltJvt
   Rga42xQP5ET59mY1yZkyLU3HCOGE0OYHOTD/ZNOn/JgQA9SPHZW5XEwhp
   BfrqMOCwvj83iGbx//q6m3CPNTVZGO1TkKG68OKPm9LT0N3ljLQr5mkWA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="355097975"
X-IronPort-AV: E=Sophos;i="6.02,201,1688454000"; 
   d="scan'208";a="355097975"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 10:50:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="687401384"
X-IronPort-AV: E=Sophos;i="6.02,201,1688454000"; 
   d="scan'208";a="687401384"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 10:50:28 -0700
Date: Fri, 25 Aug 2023 10:50:27 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 6/7] x86/resctrl: Update documentation with Sub-NUMA
 cluster changes
Message-ID: <ZOjp45yh5oklE4UF@agluck-desk3>
References: <20230713163207.219710-1-tony.luck@intel.com>
 <20230722190740.326190-1-tony.luck@intel.com>
 <20230722190740.326190-7-tony.luck@intel.com>
 <f6ffd978-7e3b-2dfc-1860-80046f9a7a1e@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ffd978-7e3b-2dfc-1860-80046f9a7a1e@intel.com>

On Fri, Aug 11, 2023 at 10:33:18AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/22/2023 12:07 PM, Tony Luck wrote:
> > With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
> > per-NODE instead of per-L3 cache. Suffixes of directories with "L3" in
> > their name refer to Sub-NUMA nodes instead of L3 cache ids.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > Reviewed-by: Peter Newman <peternewman@google.com>
> > ---
> >  Documentation/arch/x86/resctrl.rst | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
> > index cb05d90111b4..4d9ddb91751d 100644
> > --- a/Documentation/arch/x86/resctrl.rst
> > +++ b/Documentation/arch/x86/resctrl.rst
> > @@ -345,9 +345,13 @@ When control is enabled all CTRL_MON groups will also contain:
> >  When monitoring is enabled all MON groups will also contain:
> >  
> >  "mon_data":
> > -	This contains a set of files organized by L3 domain and by
> > -	RDT event. E.g. on a system with two L3 domains there will
> > -	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
> > +	This contains a set of files organized by L3 domain or by NUMA
> > +	node (depending on whether Sub-NUMA Cluster (SNC) mode is disabled
> > +	or enabled respectively) and by RDT event. E.g. on a system with
> > +	SNC mode disabled with two L3 domains there will be subdirectories
> > +	"mon_L3_00" and "mon_L3_01". The numerical suffix refers to the
> > +	L3 cache id.  With SNC enabled the directory names are the same,
> > +	but the numerical suffix refers to the node id.  Each of these
> >  	directories have one file per event (e.g. "llc_occupancy",
> >  	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
> >  	files provide a read out of the current value of the event for
> 
> I think it would be helpful to add a modified version of the snippet
> (from previous patch changelog) regarding well-behaved NUMA apps.
> With the above it may be confusing that a single cache allocation has
> multiple cache occupancy counters. 
> 
> This also changes the meaning of the numbers in the directory names.
> The documentation already provides guidance on how to find the cache
> ID of a logical CPU (see section "Cache IDs"). I think it will be 
> helpful to add a snippet that makes it clear to users how to map
> a CPU to its node ID.

Added extra details as suggested.

> 
> Reinette

-Tony
