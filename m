Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284361;
	b=zSV9bdX2NqEaqqCHM8X1aJ6Lju2CNiYAQIb6Cf/SKeNYM1g8yOEr8kTJLbk/SIKfhRCA
	 QZ8k3CsqxI6APs2mCRgAfLkWpiOQwlkK42sfcX5yh+gU8WnEqxvTUD7JcanADwOXTnsP0
	 /fQqLPnwTFxGeECukiet4bF2+A11hIu80ksMqsDTM4GXRhn9mbLwhjo1DFuvcLVr0iRjp
	 cBDRysNB+X2q6RTkNeMjFLtgumPz7DbRY6Xno+5WnZPerMZZv/Or+Hi+CPzGZAMd6xqxF
	 q3ANFodtxat+/tbaYyqoPlDV0EWZ1WmxftNzvRS/Z9nSvbFGuCGYT1bBXCOMFK8E6/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284361;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NwMOPrLb/bcQmTjZjVroIGum5+uDVEtuv4FwOAZFzFY=;
	b=uhdhVgleEUmlBYCNrxs5wsrik1KaiMLCBs5eAsO2Gc3kBAKMZuhR6XL1qOam/LiATxWW
	 O6udyhWd2+Zdh86/AlcKbrHzPV5x6p+NTg0NbYE3CugNMVBawWHksO16RTmvYlgIHkdH5
	 BX7F6r9qli4DpdSCERIOd92Dp4pG7FDcejnSEIwD2lLVq1ZS3naDu2m8gFjo2Qs/SlZ9v
	 ubi4sUQA8NC9tSGS2VZvoiPvJQS5rSmYX+aTCKukLJGrC3gy9yCidSjMKcG+QOr23d6vV
	 FpRMZtIGmD9YctgtP9lI9G85fcTP5/PgRKxpezvVj8pHIKbLyMQfLTitPgnJNYS51dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=b9CzBY2S;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A53460A2617
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A53460A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=b9CzBY2S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284359; x=1825820359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W67oR+7Gjb+19A/jz+rAvKq7QVQDoWZcbgELeMRxB7Q=;
  b=b9CzBY2Sv3k2RKbVuvVS4Cz1GfWeGqd0mWy19Izm5KswoL7y14LVaXA3
   OeexlrQgJverkoeVZJ6sKVaHSxrDRolpJwrsZk23sRQm2GiLphz34+e8G
   Us+dkHp9zRf/Ltj5ijqNTBCifPbVG4nszaIhQxZrDSNq1LKABk6xYc1mG
   q7rQl2TcgsRY2Uu42IiuE/eB0v1ZW2SzI4x2o2VLcSk5FRbZFs4X5ORUt
   Ev7Mg4vznK1HiCQG/KVsJL4zpxB2rgUaH2uTYd8gN7OEl6fOs9+hdNxDS
   nNM36ePrFfEsLK/RP9H49/sr8JOoFhyZksVaM+iKMMFp1ArADlMbjCGpI
   w==;
X-CSE-ConnectionGUID: UWq5l2R2QeatdCmpcWOSnA==
X-CSE-MsgGUID: A8epKK2yRpeSyFHK7yUgOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901319"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901319"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
X-CSE-ConnectionGUID: v0r35fzmTRmf+1s97C065A==
X-CSE-MsgGUID: VskZnj8bTNiDVZyhZXBI4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856918"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:15 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com,
	ruanjinjie@huawei.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	tan.shaopeng@fujitsu.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 4/8] arm_mpam: resctrl: Do not fail CPU online when domain setup fails
Date: Mon,  9 Nov 2026 20:19:04 -0800
Message-ID: <e0a6d37967c016019c82cbe368dd915902ecbca8.1794283825.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794283825.git.reinette.chatre@intel.com>
References: <cover.1794283825.git.reinette.chatre@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a CPU comes online, mpam_resctrl_online_cpu() adds it to the resctrl
domains of each resource in use, and sets up a new domain when the CPU
is the first of its domain to come online. A failure to set up a domain
is returned as the failure of MPAM's CPU hotplug startup callback.

The CPU hotplug core does not run the teardown callback for a CPU whose
startup callback failed, so everything done for the CPU before the
failure stays in place: the CPU remains in the domains of the resources
that were handled before the failing one, and MPAM's per-MSC state for
the CPU is not undone. If the failure happens when MPAM installs its
CPU hotplug callbacks during enabling, the hotplug core discards the
callbacks, leaving MPAM enabled and resctrl initialized but MPAM no
longer notified of CPU hotplug. If it happens when a CPU comes online
later, the CPU fails to come online.

Setting up a domain only fails if a memory allocation fails or if a
class unexpectedly has no component for the CPU. For such rare failures
losing a resctrl domain is a smaller cost than failing CPU online or
leaving MPAM in an inconsistent state.

Do not report domain setup failures from mpam_resctrl_online_cpu() and
leave the CPU without a domain for that resource. Make
mpam_resctrl_alloc_domain() return nothing since its failures are no
longer reported. Keep adding the CPU to resctrl's default group even
when a domain could not be set up, since the CPU is online and runs
tasks regardless, and resctrl expects every online CPU to belong to a
resource group. Warn on a failed domain allocation and on a missing
monitoring component so these failures are not silent. Drop the warning
when a CPU going offline has no domain, since a missing domain is now
expected.

Only domains that were set up are exposed through resctrl and torn down
when their CPUs go offline. When another CPU of the same domain comes
online, it sets up the domain again, and if that succeeds the domain
does not include the CPU for which setup failed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
Changes since RFC v2:
- Add Jinjie's Reviewed-by tag.
- Add Jinjie's Tested-by tag.
- WARN when domain allocation fails. (Ben)
- Squash patch that replaces WARN_ON_ONCE(0) with
  WARN_ON_ONCE(!any_mon_comp). (Ben)
---
 drivers/resctrl/mpam_devices.c  |  2 +-
 drivers/resctrl/mpam_internal.h |  4 ++--
 drivers/resctrl/mpam_resctrl.c  | 37 +++++++++++++++------------------
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 27abf60f4d67..a95326f2ef88 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -2247,7 +2247,7 @@ static int mpam_cpu_online(unsigned int cpu)
 	}
 
 	if (mpam_resctrl_enabled)
-		return mpam_resctrl_online_cpu(cpu);
+		mpam_resctrl_online_cpu(cpu);
 
 	return 0;
 }
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 1f86cc158100..84c7adbb1a40 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -525,13 +525,13 @@ int mpam_get_cpumask_from_cache_id(unsigned long cache_id, u32 cache_level,
 #ifdef CONFIG_RESCTRL_FS
 int mpam_resctrl_setup(void);
 void mpam_resctrl_exit(void);
-int mpam_resctrl_online_cpu(unsigned int cpu);
+void mpam_resctrl_online_cpu(unsigned int cpu);
 void mpam_resctrl_offline_cpu(unsigned int cpu);
 void mpam_resctrl_teardown_class(struct mpam_class *class);
 #else
 static inline int mpam_resctrl_setup(void) { return 0; }
 static inline void mpam_resctrl_exit(void) { }
-static inline int mpam_resctrl_online_cpu(unsigned int cpu) { return 0; }
+static inline void mpam_resctrl_online_cpu(unsigned int cpu) { }
 static inline void mpam_resctrl_offline_cpu(unsigned int cpu) { }
 static inline void mpam_resctrl_teardown_class(struct mpam_class *class) { }
 #endif /* CONFIG_RESCTRL_FS */
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index d0c7c741ce90..ec39f3909388 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1640,8 +1640,8 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
 	return NULL;
 }
 
-static struct mpam_resctrl_dom *
-mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
+static void mpam_resctrl_alloc_domain(unsigned int cpu,
+				      struct mpam_resctrl_res *res)
 {
 	int err;
 	struct mpam_resctrl_dom *dom;
@@ -1656,11 +1656,11 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	comp = find_component(class, cpu);
 	/* class has no component for this CPU */
 	if (WARN_ON_ONCE(!comp))
-		return ERR_PTR(-EINVAL);
+		return;
 
 	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
-	if (!dom)
-		return ERR_PTR(-ENOMEM);
+	if (WARN_ON_ONCE(!dom))
+		return;
 
 	if (r->alloc_capable) {
 		dom->ctrl_comp = comp;
@@ -1701,11 +1701,8 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 			if (mon_comp)
 				any_mon_comp = mon_comp;
 		}
-		if (!any_mon_comp) {
-			WARN_ON_ONCE(0);
-			err = -EFAULT;
+		if (WARN_ON_ONCE(!any_mon_comp))
 			goto offline_ctrl_domain;
-		}
 
 		mon_d = &dom->resctrl_mon_dom;
 		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
@@ -1719,7 +1716,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		pr_debug("Skipped monitor domain online - no monitors\n");
 	}
 
-	return dom;
+	return;
 
 offline_ctrl_domain:
 	if (r->alloc_capable) {
@@ -1728,9 +1725,6 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	}
 free_domain:
 	kfree(dom);
-	dom = ERR_PTR(err);
-
-	return dom;
 }
 
 /*
@@ -1782,7 +1776,7 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
 }
 
-int mpam_resctrl_online_cpu(unsigned int cpu)
+void mpam_resctrl_online_cpu(unsigned int cpu)
 {
 	struct mpam_resctrl_res *res;
 	enum resctrl_res_level rid;
@@ -1797,9 +1791,13 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 
 		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
 		if (!dom) {
-			dom = mpam_resctrl_alloc_domain(cpu, res);
-			if (IS_ERR(dom))
-				return PTR_ERR(dom);
+			/*
+			 * On failure the CPU is left without a domain for this
+			 * resource, which mpam_resctrl_offline_cpu() tolerates.
+			 * resctrl_online_cpu() still adds the CPU to the default
+			 * group because the CPU is online and runs tasks.
+			 */
+			mpam_resctrl_alloc_domain(cpu, res);
 		} else {
 			if (r->alloc_capable) {
 				struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
@@ -1815,8 +1813,6 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 	}
 
 	resctrl_online_cpu(cpu);
-
-	return 0;
 }
 
 void mpam_resctrl_offline_cpu(unsigned int cpu)
@@ -1837,8 +1833,9 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 		if (!res->class)
 			continue;	// dummy resource
 
+		/* The domain may be missing if its setup failed. */
 		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
-		if (WARN_ON_ONCE(!dom))
+		if (!dom)
 			continue;
 
 		if (r->alloc_capable) {
-- 
2.56.0

