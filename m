Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7684031985D
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547915; cv=none; b=YM4o/ZeYGLps45WbtoRZFbQec1Hx59oc50rTEZMf+5A68Q4DyGwOXGzzOk6DdqS87kVzJVYjddUQacBOtT1JeJfpd3oJ5omyUek7CPpp2IWkBNvlyDoV0ZJZZK+xldgt2L1aRaHMpAb0+mvG0YaKmgvo5Gn3nRwEY/OgZKQ/i3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547915; c=relaxed/simple;
	bh=ucjESAd9trJMZWbtlPk+6IV2WpT9Oqade/fpZgVuRZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQaD02drwg2NosJqpIT+6YedF6Ie16wR2G/Q0lYKnEfaaxXqn1ggHpJieE6WymIzM22uzdIitCTLo3c+DlzBlCj3QtubUUogWrjjF/6OBSsB3k62CXDK/u3iVrBfN/00R6sjaTK0OZO0ngNjQX+Rl7s8/bsMuuV9XzD3HCVHUWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZWcuWy8X; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZWcuWy8X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547912; x=1813083912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ucjESAd9trJMZWbtlPk+6IV2WpT9Oqade/fpZgVuRZA=;
  b=ZWcuWy8Xwhh/KjB3ZoOf4gkw63zMD/cPs3LhzRU/u4rKVZG007IWns1e
   0BY3BoSReYwfHLWPv9D4MoPLl3rgM0onNXKLW5fB5xbxMT5+jQr9h4I5f
   q5KihpgHAMfAVlts+7anNPEiqNVCIusw9bpm7PcT/arYqabW35/keAhgn
   OSeEW9ILkVd2TxY5PebGPIaWzGLwp0cntTSUvZkPGX4UJnHEifiPCSP5j
   PBMUAUpnZD6QjKioGTZ3C8DFwcZ4Qitmy1qV1va4e1PbjQGtKuy3sT1/Q
   96oabDzNXLQ6c1vmDT5D+5rjgIwxDgnJfv1/TyVpLJZXRfh4S1QSkyadu
   A==;
X-CSE-ConnectionGUID: ZJ8JLH4gQgO764MJhy6a1g==
X-CSE-MsgGUID: Q0M0NXgvTfO4pLHFOuQuew==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789978"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789978"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:10 -0700
X-CSE-ConnectionGUID: YZjXIaJgRnSScE8bH2VPIg==
X-CSE-MsgGUID: d2CDrl4aRpqOxqH+Jyh2uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620631"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:08 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 07/16] x86/resctrl: Honor rdt=perf option to force enable AET perf events
Date: Mon, 15 Jun 2026 11:24:48 -0700
Message-ID: <20260615182457.14725-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel command line option "rdt=" is used to force enable or disable
individual resctrl features.

Linux only enumerates AET (Application Energy Telemetry) once on first
mount. But that is going to change to enumerate on each mount to allow the
pmt_telemetry driver to be configured as a module, and allow unloading when
not in use.

The following scenario will be a problem:

1) User mounts the resctrl file system.  all_regions_have_sufficient_rmid()
notes that a perf telemetry region supports fewer RMIDs than expected for
the event_group and sets e->force_off = true. But the user had specified
"rdt=perf" on the kernel command line so perf events are enabled for
this first mount.

2) Resctrl file system is unmounted and later remounted.

3) During this new mount cycle enable_events() sees that e->force_off is
set and stops enumeration for this event group. So on this second, and
all subsequent, mounts perf events are not enabled.

Fix by checking the state of e->force_on at the start of enable_events().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v8:
	New subject and commit comment
	Fix by changing test at start of enable_events() instead of
	changing all_regions_have_sufficient_rmid()

 arch/x86/kernel/cpu/resctrl/intel_aet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 89b8b619d5d5..07e9d6d4959e 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -60,8 +60,8 @@ struct pmt_event {
  *			data for all telemetry regions of type @pfname.
  *			Valid if the system supports the event group,
  *			NULL otherwise.
- * @force_off:		True when "rdt" command line or architecture code disables
- *			this event group due to insufficient RMIDs.
+ * @force_off:		True when "rdt" command line disables this event group
+ *			to avoid system limitations due to insufficient RMIDs.
  * @force_on:		True when "rdt" command line overrides disable of this
  *			event group.
  * @guid:		Unique number per XML description file.
@@ -228,7 +228,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int skipped_events = 0;
 
-	if (e->force_off)
+	if (e->force_off && !e->force_on)
 		return false;
 
 	if (!group_has_usable_regions(e, p))
-- 
2.54.0

