Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D813C76C61
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 21:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751577095; cv=none; b=C4Rx75vCTcQ+hxTcuj8H3OpsbZ0Fmqo+JRvlWDixTqJvq3eWoIZ0xovjH/0FR/2VZwrgvOK7G8yfu8uX4NMEvFpX4/unP8dC9oUFQha/W1RBuMp5HSXE6HOWhbrDnmV0yzbwyGii+7kEwfXihUwHRamJjaNcVAFKxP68pMx3Tpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751577095; c=relaxed/simple;
	bh=mxRRqjnzcQtyf+2S6JOeUnFmAgOyfn/pD+s0VZ1xpeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgiP0PPF+sklC4/3zfeOOS7H5eY2RnlM2vyP93400bUe4w7xjACQNBBKhjhpIqZ2eT3eZSiMi4Yalfhk9W/VDDJbYytoHcgiVyT7+154TF5Mja3b6hh6HPXdnfcVG5zP5M9Rg53s5N10MWmJFacNy8hf3s9PKc4p1WFIF9TspGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fNP2qVGA; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fNP2qVGA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751577094; x=1783113094;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mxRRqjnzcQtyf+2S6JOeUnFmAgOyfn/pD+s0VZ1xpeQ=;
  b=fNP2qVGANR408Ay53bOLQ+fg8Md3KvDhqxF+I9f7cXxiWmRwL6NLkWad
   F+QvoELsn5+YiPwbls4QGYWx3aabyQ/TZv2ufdCBQ7wuuz/crVxmdwgfS
   nbLlnV1wnCUzc5qiK3IKkqvmxGXDqc8AAWBj64swVab4Ax7VzF9oIOHFR
   WpQCxQFJS2qu/gcVybSfWGRDwH0in8/RxMuVGsfNgxQHNSBaeHxr7quEk
   YatgoCopiFfWJRAK7Ob8JwVJt+ji4cNSCWFvNV0qT4xIEwfsD+IuPcFvw
   LzfQQSqYichUG74zXEfosrBKIppMjABfklYvlkOsUK0YDqIiFVl/Su+KJ
   Q==;
X-CSE-ConnectionGUID: iWWyxrQnQfyyWwcI2NcxyA==
X-CSE-MsgGUID: Q9CO908CQMKJLWY+ioG3tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="76463940"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="76463940"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 14:11:33 -0700
X-CSE-ConnectionGUID: 50Mth+NLTmCu0BdpfFa8pg==
X-CSE-MsgGUID: RwB3cp7XT5StmIVn2LuacA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="153899546"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 14:11:33 -0700
Date: Thu, 3 Jul 2025 14:11:31 -0700
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
Message-ID: <aGbyA-TVAdG5uUBk@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-18-tony.luck@intel.com>
 <aF7dt2iQpvuahZil@agluck-desk3>
 <eb6f7bc0-23ae-4100-9a34-fade6c650460@intel.com>
 <aGblc2VimjIiy_bY@agluck-desk3>
 <bb9b5ee5-3367-4193-9e07-747b1ab50637@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb9b5ee5-3367-4193-9e07-747b1ab50637@intel.com>

On Thu, Jul 03, 2025 at 01:31:19PM -0700, Reinette Chatre wrote:
> I do not think resctrl should enforce dependency on a driver that is not
> valid for a platform.

Fewer stubs than I thought.  I can merge something along these
lines back into the series for the next version.

Suggestions welcome for the name of the config option. Do
I need a "_CPU" in CONFIG_X86_RESCTRL_INTEL_AET? It's already
very long.

"help" text is a placeholder. I can change that up to add more
details.

-Tony

---

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 11f25c225837..56615b1d3fc3 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -175,9 +175,19 @@ bool rdt_is_software_feature_enabled(char *option);
 
 bool rdt_is_software_feature_force_enabled(char *name);
 
+#ifdef CONFIG_X86_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
 			 void *arch_priv, u64 *val);
+#else
+static inline bool intel_aet_get_events(void) { return false; }
+static inline void __exit intel_aet_exit(void) { }
+static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
+				       void *arch_priv, u64 *val)
+{
+	return -EINVAL;
+}
+#endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6b6ecbd3877..ceb3eb371a3d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -512,9 +512,6 @@ config X86_CPU_RESCTRL
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
 	select RESCTRL_FS_PSEUDO_LOCK
-	select X86_PLATFORM_DEVICES
-	select INTEL_VSEC
-	select INTEL_PMT_TELEMETRY
 	help
 	  Enable x86 CPU resource control support.
 
@@ -531,6 +528,18 @@ config X86_CPU_RESCTRL
 
 	  Say N if unsure.
 
+config X86_RESCTRL_INTEL_AET
+	bool "Intel Application Energy Telemetry"
+	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_DISCOVERY
+	help
+	  Enable per-RMID telemetry events in resctrl
+
+	  Intel feature that collects per-RMID execution data
+	  including core energy consumed by tasks. Data is aggregated
+	  per package.
+
+	  Say N if unsure.
+
 config X86_FRED
 	bool "Flexible Return and Event Delivery"
 	depends on X86_64
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index 97ceb4e44dfa..26fc957fb3dd 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
-obj-$(CONFIG_X86_CPU_RESCTRL)		+= intel_aet.o
+obj-$(CONFIG_X86_RESCTRL_INTEL_AET)	+= intel_aet.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
 # To allow define_trace.h's recursive include:
-- 
2.50.0

