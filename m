Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5736720D4F0
	for <patches@lists.linux.dev>; Wed, 28 May 2025 21:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748468294; cv=none; b=VUo7C+vJfWtHXSflWtUx+5//2LRjd7Hb8z2dZwXgA/GY9fztwWVCPuFX7aNsEvuUb2+h0ccMGnjbNvNaXwVtWZbHkLwZhoUymVySkWGd/s8Ft07r/HB/9r/Ww9QcW4+wY6ynFlEPtSsSPPGIoRsX2YOb3d1ncB3rd70ku7hYg/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748468294; c=relaxed/simple;
	bh=fquSITk+E1xqk35FlWKKdQEdyzF7bcsbzu1Yz6hkfPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUkgQ6dE+W5aB9K5+nP09FLRfqu7fu6oVzBsvXqCrYs4JKreGiHnLjMa39LqjTM6h6t+ltaCdEyCnPva3qiArxsP8rYMlfQuN+xXfhAWJnlmDJHr5qWYkbbQOaqgpu/kAzs7llLXf0zYBbTKeK0lowO6LVG1V4GQ9IzO2qwyry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LrKzjOUQ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LrKzjOUQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748468293; x=1780004293;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fquSITk+E1xqk35FlWKKdQEdyzF7bcsbzu1Yz6hkfPQ=;
  b=LrKzjOUQw25YcqyV2ZrAXgePe4IP+mqsOsGLChNkXcsYZGFTRX/kdJo4
   dLOFelMULt2WTA6V1onDLdJLEU5YOgAYogYbFv32FKvU0c2oU1aK05h6d
   6KR0cVfhEMtSOR1B0xGZxQHkKKPHCKW6IXxcup7HU/T0j9VFlQHgh4pTy
   o4ZtxDNNvfojXX4IrHViTAyAEE9hScxJ2TSwlRTg648QTb35JMbyIKGSe
   Uqb/ftPv4S8vYknrVaHD99fVTJQI2156rsMNdWfNh5yw7iJOjN+QLMUqN
   6OBaKf7GXnclCX5rz2R7tV6cH+gqxpqdFR1cbBI8fM42/4ADTMvsIXTH2
   A==;
X-CSE-ConnectionGUID: 4cejwIIjRayXd/478R6i3g==
X-CSE-MsgGUID: TxFyHaqJT2eBwdurIJh3kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="61147465"
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="61147465"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 14:38:12 -0700
X-CSE-ConnectionGUID: sCJVDOP8QJeHyZRL+EEBgQ==
X-CSE-MsgGUID: 9veFNIHpQZaB8LuVbpvGrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="147245874"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 14:38:12 -0700
Date: Wed, 28 May 2025 14:38:11 -0700
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
Subject: Re: [PATCH v5 00/29] x86/resctrl telemetry monitoring
Message-ID: <aDeCQ-v9OHzHauPi@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <b8ddce03-65c0-4420-b30d-e43c54943667@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8ddce03-65c0-4420-b30d-e43c54943667@intel.com>

Hi Reinette,

I've begun drafting a new cover letter to explain telemetry.

Here's the introduction. Let me know if it helps cover the
gaps and ambiguities that you pointed out.

-Tony


RMID based telemetry events
---------------------------

Each CPU on a system keeps a local count of various events.

Every two milliseconds, or when the value of the RMID field in the
IA32_PQR_ASSOC MSR is changed, the CPU transmits all the event counts
together with the value of the RMID to a nearby OOBMSM (Out of band
management services module) device. The CPU then resets all counters and
begins counting events for the new RMID or time interval.

The OOBMSM device sums each event count with those received from other
CPUs keeping a running total for each event for each RMID.

The operating system can read these counts to gather a picture of
system-wide activity for each of the logged events per-RMID.

E.g. the operating system may assign RMID 5 to all the tasks running to
perform a certain job. When it reads the core energy event counter for
RMID 5 it will see the total energy consumed by CPU cores for all tasks
in that job while running on any CPU. This is a much lower overhead
mechanism to track events per job than the typical "perf" approach
of reading counters on every context switch.

Events
------

"core energy" The number of Joules consumed by CPU cores during execution
of instructions for the current RMID.
Note that this does not include energy used by the "uncore" (LLC cache
and interfaces to off package devices) or energy used by memory or I/O
devices. Energy may be calculated based on measures of activity rather
than the output from a power meter.

"activity" The dynamic capacitance (Cdyn) in Farads for a core due to
execution of instructions for the current RMID. This event will be
more useful to a user interested in optimizing energy consumption
of a workload because it is invariant of frequency changes (e.g.
turbo mode) that may be outside of the control of the developer.
