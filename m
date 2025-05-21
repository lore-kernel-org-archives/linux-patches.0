Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC912451F3
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867873; cv=none; b=FPe1q8ZcHRC76XKWQWygQgIUt8j1jAt3zkHFYi8UpPypmpegUJSM/FbmuLyM7ZtAm0jpK9LuHOyXVjxtewcRqupmhVPDsxn8YR3qJv6bq6Ie7WzcnUX6KBYlBkXf6vGYluoQnB44kb21sHzR94rXNdH49jqNvn7M4M7nCdVEm10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867873; c=relaxed/simple;
	bh=uPQU9YRN+KUbwCcHdG0+C2skJzAiOOPQTYpRYK0gF6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcSZiPGg/qGorghVKERLxDzgOwywRormIISEdmZjmuVV3RJech50geb3Zw0i0rwWqvNoUczD5GkAsjysmVjEU9tNRp9Z2Vw7DtkkOn6nf/1LF1BJlY81zV1CJ8872V3ZUfXr1RMu8eX0HnEUv0PyOdQk56lFJv1Xd5X0SIoFIwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H4BXbzGU; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H4BXbzGU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867871; x=1779403871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uPQU9YRN+KUbwCcHdG0+C2skJzAiOOPQTYpRYK0gF6I=;
  b=H4BXbzGUdw2oFs4bOwjRrJNQJtP84G0YLawASA6XudP7MsHufb3Wz+bm
   P8qCyJVPe7n/NGiTHw31qqqOnBxUMOkIzcgLEXalgLKY1K/qQ9Yo5GHUH
   V4sa2DOE11mBafENKuZBUd0wdePCy/iLtdRa2gNWO12d9ps1xDAcomUKZ
   B6pLtQnPe/FwXryHwWo8F0OXui+jF9iMam/7Xmoo69V/YI+9bbCL1gCA3
   /16T0MtlQ4svaGnWcZTlkd7LE85U3cUjCziqSU1/fb+/GbmNzBtoutAyk
   tp9W3eqJB625xerekscCS6Osvhs3Us0/1KigCG2djb6qfCLQtaNsCWcwC
   Q==;
X-CSE-ConnectionGUID: 0J8VWpnQQi6r6ll8S4OKLw==
X-CSE-MsgGUID: hhu0U+IcSQSIAxL+49HRKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677772"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677772"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
X-CSE-ConnectionGUID: Q1IRm/hiT1CboqPRR1ZSZg==
X-CSE-MsgGUID: 75PdtZpKRKWDedYLqoTeFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352189"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
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
Subject: [PATCH v5 22/29] x86,fs/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
Date: Wed, 21 May 2025 15:50:40 -0700
Message-ID: <20250521225049.132551-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
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

Change domain_add_cpu_mon(), domain_remove_cpu_mon(),
resctrl_offline_mon_domain(), and resctrl_online_mon_domain() to check
resource type and perform only the operations needed for domains in the
PERF_PKG resource.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 41 ++++++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c              |  4 +++
 2 files changed, 45 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 64ce561e77a0..18d84c497ee4 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -540,6 +540,38 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 	}
 }
 
+/**
+ * struct rdt_perf_pkg_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource
+ * @hdr:	common header for different domain types
+ */
+struct rdt_perf_pkg_mon_domain {
+	struct rdt_domain_hdr   hdr;
+};
+
+static void setup_intel_aet_mon_domain(int cpu, int id, struct rdt_resource *r,
+				       struct list_head *add_pos)
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
+
 static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 {
 	int id = get_domain_id_from_scope(cpu, r->mon_scope);
@@ -567,6 +599,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	case RDT_RESOURCE_L3:
 		l3_mon_domain_setup(cpu, id, r, add_pos);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		setup_intel_aet_mon_domain(cpu, id, r, add_pos);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 	}
@@ -666,6 +701,12 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		resctrl_offline_mon_domain(r, hdr);
+		list_del_rcu(&hdr->list);
+		synchronize_rcu();
+		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
+		break;
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 1e1cc8001cbc..6078cdd5cad0 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4170,6 +4170,8 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		goto out_unlock;
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		goto do_mkdir;
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	err = domain_setup_l3_mon_state(r, d);
 	if (err)
@@ -4184,6 +4186,8 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
 		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
 
+do_mkdir:
+	err = 0;
 	/*
 	 * If the filesystem is not mounted then only the default resource group
 	 * exists. Creation of its directories is deferred until mount time
-- 
2.49.0

