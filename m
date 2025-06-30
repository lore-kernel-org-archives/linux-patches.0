Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDCB21ABA8
	for <patches@lists.linux.dev>; Mon, 30 Jun 2025 22:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751323619; cv=none; b=JLOTv1eCfdT3lyaKzZhykvnbm3/g71IVa95fJA0+K+qauTl18Y25LDdUXSJeezNWlowAuN1T/C2dP6RAag/z0FzXlnFnCs+QTzeJfWIf55Nui1tpQTqro6kW13JIjSuw5fVbUXDlek9C7NzOovaBSEB2HsQXM4uCkdcedWbUCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751323619; c=relaxed/simple;
	bh=6j2k/yDLl7AFcEJ7cfJPNKmXl31QcHaeZXcdt96J1Fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SK29Q3uIUT8/kBu2nqvB86pyrSYZI1RmfU+m7ZPnr075k/TUSC41YK1qQWTVd9uVwe2cl5jxeNEGy+Erz4BbIoANjnSqLLLfUiyN/N79JtRgmdU/0YnYwMA8Yl9u1U9JwiY+qoK5g0lwOG4YTB8q8HAYrBebA7KRtyBmeavyU0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XQ674KCs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XQ674KCs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751323618; x=1782859618;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6j2k/yDLl7AFcEJ7cfJPNKmXl31QcHaeZXcdt96J1Fk=;
  b=XQ674KCs2hCd+fnSIK73k+qkvsr3T6u9bKrnz4LAl6uwaGBO/CmWDkYT
   qcsG/hG+uSmPO53+p+AH2C7a1EzQZkVFNvBOPdJYQI84eZzDH7hZSl76K
   jAX/SLj4X9KmiyOMcUPJGvTondKag2wlAdf5Us5ySY8wMnyWfLCQqqalD
   UCezWk8k3lEu6whdGviEWSkI4dohJWkFnvAy8W63Jeb8zguPfWf82Bgjx
   fw2CqOfMw9su0hY3hAuZZNM6Lpzi1MGe+sBXXo/eoen5CYF3xMel4NIkT
   l1/8wubJ0vtj5sz+h0p18j2o4QVrzxsodwmEwx/bjCGEoJZz8GLuCyqwo
   Q==;
X-CSE-ConnectionGUID: s9jsqTtVRBKKzmGu6SctAA==
X-CSE-MsgGUID: Ob1vzDocSlGeqKJbFpoFPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="70994439"
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="70994439"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 15:46:58 -0700
X-CSE-ConnectionGUID: 4pJGDbMPRuKTEUEzHvfwWg==
X-CSE-MsgGUID: 61U+zpsvRQaLTcAZlu0jTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="153335299"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 15:46:57 -0700
Date: Mon, 30 Jun 2025 15:46:55 -0700
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
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
Message-ID: <aGMT35DktIVkzwjx@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <6485574e-1405-49c1-90f9-1955ac2777ce@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6485574e-1405-49c1-90f9-1955ac2777ce@intel.com>

On Mon, Jun 30, 2025 at 10:51:50AM -0700, Reinette Chatre wrote:
> 
> Tony,
> 
> On 6/26/25 9:49 AM, Tony Luck wrote:
> > Background
> > ----------
> > 
> > Telemetry features are being implemented in conjunction with the
> > IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
> > counts for various events to a collector in a nearby OOBMSM device to be
> > accumulated with counts for each <RMID, event> pair received from other
> > CPUs. Cores send event counts when the RMID value changes, or after each
> > 2ms elapsed time.
> 
> To start a review of this jumbo series and find that the *first* [1]
> (straight forward) request from previous review has not been addressed is
> demoralizing. I was hoping that the previous version's discussions would result
> in review feedback either addressed or discussed (never ignored). I
> cannot imagine how requesting OOBMSM to be expanded can be invalid though.
> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/b8ddce03-65c0-4420-b30d-e43c54943667@intel.com/

My profound apologies for blowing it (again). I went through the comments
to patches multiple times to try and catch all your comments. But somehow
skipped the cover letter :-( .

Here's a re-write to address comments, but also to try to provide
a better story line starting with how the logical processors capture
the event data, following on with aggregator processing, etc.

-Tony

---

On Intel systems that support per-RMID telemetry monitoring each logical
processor keeps a local count for various events. When the IA32_PQR_ASSOC.RMID
value for the logical processor changes (or when a two millisecond counter
expires) these event counts are transmitted to an event aggregator on
the same package as the processor together with the current RMID value. The
event counters are reset to zero to begin counting again.

Each aggregator takes the incoming event counts and adds them to
cumulative counts for each event for each RMID. Note that there can be
multiple aggregators on each package with no architectural association
between logical processors and an aggregator.

All of these aggregated counters can be read by an operating system from
the MMIO space of the Out Of Band Management Service Module (OOBMSM)
device(s) on a system. Any counter can be read from any logical processor.

Intel publishes details for each processor generation showing which
events are counted by each logical processor and the offsets for each
accumulated counter value within the MMIO space in XML files here:
https://github.com/intel/Intel-PMT.

For example there are two energy related telemetry events for the Clearwater
Forest family of processors and the MMIO space looks like this:

Offset	RMID	Event
------	----	-----
0x0000	0	core_energy
0x0008	0	activity
0x0010	1	core_energy
0x0018	1	activity
...
0x23F0	575	core_energy
0x23F8	575	activity

In addition the XML file provides the units (Joules for core_energy,
Farads for activity) and the type of data (fixed-point binary with
bit 63 used as to indicate the data is valid, and the low 18 bits as a
binary fraction).

Finally, each XML file provides a 32-bit unique id (or guid) that is
used as an index to find the correct XML description file for each
telemetry implementation.

The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()
to enumerate the aggregator instances on a platform. It provides:
1) guid  - so resctrl can determine which events are supported
2) mmio base address of counters
3) package id

Resctrl accumulates counts from all aggregators on a package in order
to provide a consistent user interface across processor generations.

Directory structure for the telemetry events looks like this:

$ tree /sys/fs/resctrl/mon_data/
/sys/fs/resctrl/mon_data/
mon_data
├── mon_PERF_PKG_00
│   ├── activity
│   └── core_energy
└── mon_PERF_PKG_01
    ├── activity
    └── core_energy

Reading the "core_energy" file from some resctrl mon_data directory shows
the cumulative energy (in Joules) used by all tasks that ran with the RMID
associated with that directory on a given package. Note that "core_energy"
reports only energy consumed by CPU cores (data processing units,
L1/L2 caches, etc.). It does not include energy used in the "uncore"
(L3 cache, on package devices, etc.), or used by memory or I/O devices.
