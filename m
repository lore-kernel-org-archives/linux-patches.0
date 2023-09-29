Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5C08F62
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 20:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696020887; x=1727556887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=oTbiNGIXHhUIMdMlWMW1h6e4WlB0GQpl6q76DSW/M+w=;
  b=nEuFcYhyuI8KZQSVlHGOqR48ilXpEiKShUsSwFBBgiVas2v5xJsSBJ+S
   pzWYQ5VOUj8+Jrim7kjs8HMu8fVQ0XlXeSq0QvxXD/VVJChMgTNLnFnRI
   ArhJBeuiTwBMU4C3BBi5fPIoOzl6gxvgsX+3u1umKGCYEIbzrDNeLYQOT
   KLfjQwLeG7QggUxCbSDQaFBK4B7UqPwv6jt/KG9veLrdJ2yUGizt6IMLi
   RS9Kn/CaRo47amSilCFPzJDQR9WiUYB5t33A1bfkBxVqCFDluIQCkCSTG
   +4/zUfJDnlQo5I6X6o7iLKXyEyrGAEVePnJ1cjtUJdjodTHOJCeaBREiT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="367433107"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="367433107"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 13:51:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="815704888"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="815704888"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 13:51:39 -0700
Date: Fri, 29 Sep 2023 13:51:37 -0700
From: Tony Luck <tony.luck@intel.com>
To: Peter Newman <peternewman@google.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 8/8] x86/resctrl: Update documentation with Sub-NUMA
 cluster changes
Message-ID: <ZRc42bU3urj5wqP/@agluck-desk3>
References: <20230829234426.64421-1-tony.luck@intel.com>
 <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-9-tony.luck@intel.com>
 <CALPaoCgPXPF_fn9fh15rW0JWUhxth5wOO51n+oHqibP+a6Qjfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALPaoCgPXPF_fn9fh15rW0JWUhxth5wOO51n+oHqibP+a6Qjfg@mail.gmail.com>

On Fri, Sep 29, 2023 at 04:54:21PM +0200, Peter Newman wrote:
> Hi Tony,
> 
> On Thu, Sep 28, 2023 at 9:14 PM Tony Luck <tony.luck@intel.com> wrote:
> > diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
> > index cb05d90111b4..d6b6a4cfd967 100644
> > --- a/Documentation/arch/x86/resctrl.rst
> > +++ b/Documentation/arch/x86/resctrl.rst
> > @@ -345,9 +345,15 @@ When control is enabled all CTRL_MON groups will also contain:
> >  When monitoring is enabled all MON groups will also contain:
> >
> >  "mon_data":
> > -       This contains a set of files organized by L3 domain and by
> > -       RDT event. E.g. on a system with two L3 domains there will
> > -       be subdirectories "mon_L3_00" and "mon_L3_01".  Each of these
> > +       This contains a set of files organized by L3 domain or by NUMA
> > +       node (depending on whether Sub-NUMA Cluster (SNC) mode is disabled
> > +       or enabled respectively) and by RDT event. E.g. on a system with
> > +       SNC mode disabled with two L3 domains there will be subdirectories
> > +       "mon_L3_00" and "mon_L3_01". The numerical suffix refers to the
> > +       L3 cache id.  With SNC enabled the directory names are the same,
> > +       but the numerical suffix refers to the node id.
> > +       Mappings from node ids to CPUs are available in the
> > +       /sys/devices/system/node/node*/cpulist files. Each of these
> 
> The explanation of mon_data seems overwhelmingly SNC-centric now.
> Maybe the SNC section should be responsible for explaining its impact
> on the mon_data directory. Mainly by reminding the reader that domain
> ids in the mon_data directory are node ids in SNC mode.

I cut out all the examples and just note that the numerical suffices
are nodes instead of cache instances.

This bit of the git diff now reads:

-       This contains a set of files organized by L3 domain and by
-       RDT event. E.g. on a system with two L3 domains there will
-       be subdirectories "mon_L3_00" and "mon_L3_01".  Each of these
+       This contains a set of files organized by L3 domain or by NUMA
+       node (depending on whether Sub-NUMA Cluster (SNC) mode is disabled
+       or enabled respectively) and by RDT event.  Each of these


> 
> 
> >         directories have one file per event (e.g. "llc_occupancy",
> >         "mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
> >         files provide a read out of the current value of the event for
> > @@ -452,6 +458,28 @@ and 0xA are not.  On a system with a 20-bit mask each bit represents 5%
> >  of the capacity of the cache. You could partition the cache into four
> >  equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
> >
> > +Notes on Sub-NUMA Cluster mode
> > +==============================
> > +When SNC mode is enabled the "llc_occupancy", "mbm_total_bytes", and
> > +"mbm_local_bytes" will only give meaningful results for well behaved NUMA
> > +applications. I.e. those that perform the majority of memory accesses
> > +to memory on the local NUMA node to the CPU where the task is executing.
> 
> Not being specific about why the results aren't meaningful, this
> sounds vague and alarming.

Removed the trigger word "meaningful" and re-worded to just explain
the increased liklihood that tasks will migrate between nodes, so users
must collect data from all nodes. Technically this has always been true
on multi-socket systems. But since there is a much higher barrier to
task migration between sockets, users may find that simple measurements
that used to work now behave differently.

New version:

+Notes on Sub-NUMA Cluster mode
+==============================
+When SNC mode is enabled Linux may load balance tasks between Sub-NUMA
+nodes much more readily than between regular NUMA nodes since the CPUs
+on Sub-NUMA nodes share the same L3 cache and the system may report
+the NUMA distance between Sub-NUMA nodes with a lower value than used
+for regular NUMA nodes.  Users who do not bind tasks to the CPUs of a
+specific Sub-NUMA node must read the "llc_occupancy", "mbm_total_bytes",
+and "mbm_local_bytes" for all Sub-NUMA nodes where the tasks may execute
+to get the full view of traffic for which the tasks were the source.
+
+The cache allocation feature still provides the same number of
+bits in a mask to control allocation into the L3 cache. But each
+of those ways has its capacity reduced because the cache is divided
+between the SNC nodes. The values reported in the resctrl
+"size" files are adjusted accordingly.


> 
> > +Note that Linux may load balance tasks between Sub-NUMA nodes much
> > +more readily than between regular NUMA nodes since the CPUs on SNC
> > +share the same L3 cache and the system may report the NUMA distance
> > +between SNC nodes with a lower value than used for regular NUMA nodes.
> > +Tasks that migrate between nodes will have their traffic recorded by the
> > +counters in different SNC nodes so a user will need to read mon_data
> > +files from each node on which the task executed to get the full
> > +view of traffic for which the task was the source.
> > +
> > +
> > +The cache allocation feature still provides the same number of
> > +bits in a mask to control allocation into the L3 cache. But each
> > +of those ways has its capacity reduced because the cache is divided
> > +between the SNC nodes. The values reported in the resctrl
> > +"size" files are adjusted accordingly.
> > +
> >  Memory bandwidth Allocation and monitoring
> >  ==========================================
> >
> > --
> > 2.41.0
> >
> 
> Reviewed-by: Peter Newman <peternewman@google.com>
