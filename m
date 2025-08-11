Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAED2E5404
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936269; cv=none; b=UrEOwwgw8tLwgRUcs6vIuUEzLtgYU2qbZChCBF+4RHkpRF2n/58s9BXVKaugOkGXiqpwK7K5h1CVnNCA6CMf6neOq252VtKrOKU/G0P80XXl/k5e1EiHOwCMTe272ruGU8mH3GJm+pwR4SoWWBG57/dXVMXZcMdxxB2KsNaXnvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936269; c=relaxed/simple;
	bh=/pAri7fod0roEkNmWrBw8vjJ/Nnx6xwnZY2N/OS7pIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLRokCOdNPbV9940MQHLhP5pFQqqobtMnyxL3vq86T9ZHAPFHC2M0VfAKVkhtYX1vnWRcJcaNttmTUzaCoXvFSiVeSggMhAuzF74NZXlXFfwYGaEeQupHCUqafuB2Vxqxh3m6kw3G2rJxGdHm91Tguu7odPZR32PWHLXDYDYmec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qa/qxUCf; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qa/qxUCf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936267; x=1786472267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/pAri7fod0roEkNmWrBw8vjJ/Nnx6xwnZY2N/OS7pIc=;
  b=Qa/qxUCfeMQzv48HMtEcAr+l0m4pbvdUthPPRY+17PscTfIefICX3cak
   m8IKQQNmyLMLL6ZjxsWdtTBtjITnr+5rb2DlZAL7mD78eGu3C9f73ORZH
   oFS5/4Lv8g082rz0xLQ1iGKa5bqg3Tjsw9G3QZfbIVsvDSYXhsjd+/VXq
   VWFxKAXcLkm0p93akOKyO2v9F883cXzBvq4zS9/HseEt75CqqJPITziqK
   umVsKTAmGzLzB85SsQ46v0YYm87AIvKXJYtLF+//jIwtif2TZa7aD2jge
   Pr8b/vby8rCAd1IbVYj7qWQl0pUAuPeNMy2A8Gp4hm8KL6D+ZVoqUWffj
   g==;
X-CSE-ConnectionGUID: p0O/ld58Q+O1jsbB7/a5WQ==
X-CSE-MsgGUID: nj0q3FV8SMypAGw+sdg8Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277465"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277465"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: f4mc2EIoQX2sudf39pbiHw==
X-CSE-MsgGUID: 4U6KxNosSPK4jXAre2JM3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825690"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 23/32] x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
Date: Mon, 11 Aug 2025 11:16:57 -0700
Message-ID: <20250811181709.6241-24-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The L3 resource has several requirements for domains. There are structures
that hold the 64-bit values of counters, and elements to keep track of
the overflow and limbo threads.

None of these are needed for the PERF_PKG resource. The hardware counters
are wide enough that they do not wrap around for decades.

Define a new rdt_perf_pkg_mon_domain structure which just consists of
the standard rdt_domain_hdr to keep track of domain id and CPU mask.

Add a case RDT_RESOURCE_PERF_PKG to domain_add_cpu_mon() to call
intel_aet_setup_mon_domain() to allocate and initialize the
rdt_perf_pkg_mon_domain structure.

Also add a case to domain_remove_cpu_mon() cleanup when the last
CPU of a domain is removed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 13 +++++++++++++
 arch/x86/kernel/cpu/resctrl/core.c      |  9 +++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 24 ++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index b2f0769f63f6..cd911591625f 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -75,6 +75,14 @@ static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3
 	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
 }
 
+/**
+ * struct rdt_perf_pkg_mon_domain - CPUs sharing an package scoped resctrl monitor resource
+ * @hdr:	common header for different domain types
+ */
+struct rdt_perf_pkg_mon_domain {
+	struct rdt_domain_hdr   hdr;
+};
+
 /**
  * struct msr_param - set a range of MSRs from a domain
  * @res:       The resource to use
@@ -174,6 +182,8 @@ bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
 			 void *arch_priv, u64 *val);
+void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
+				struct list_head *add_pos);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
@@ -182,6 +192,9 @@ static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_i
 {
 	return -EINVAL;
 }
+
+static inline void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
+					      struct list_head *add_pos) { }
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6f455454f38d..7a0d81b4c230 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -574,6 +574,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	case RDT_RESOURCE_L3:
 		l3_mon_domain_setup(cpu, id, r, add_pos);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		intel_aet_setup_mon_domain(cpu, id, r, add_pos);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -671,6 +674,12 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		synchronize_rcu();
 		l3_mon_domain_free(hw_dom);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		resctrl_offline_mon_domain(r, hdr);
+		list_del_rcu(&hdr->list);
+		synchronize_rcu();
+		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
+		break;
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
 		break;
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 5d49ed446b94..7db03e24d4b2 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -322,3 +322,27 @@ int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
 
 	return valid ? 0 : -EINVAL;
 }
+
+void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
+				struct list_head *add_pos)
+{
+	struct rdt_perf_pkg_mon_domain *d;
+	int err;
+
+	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
+	if (!d)
+		return;
+
+	d->hdr.id = id;
+	d->hdr.type = RESCTRL_MON_DOMAIN;
+	d->hdr.rid = r->rid;
+	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+	list_add_tail_rcu(&d->hdr.list, add_pos);
+
+	err = resctrl_online_mon_domain(r, &d->hdr);
+	if (err) {
+		list_del_rcu(&d->hdr.list);
+		synchronize_rcu();
+		kfree(d);
+	}
+}
-- 
2.50.1

