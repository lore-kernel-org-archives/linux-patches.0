Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792447680;
	b=DUepqBOqOrcn9qJ2eSzSQtLvXHcZwQ/vRmRNlO0If73E7+BhC8HsYAopa/WDSaPIrl+3
	 Ywltvvei9QTKPwuE3MC7mWP7VIx0h3+6eL8u0xy0bWqbvTRzA0Qq0BCzlANuT8nqbt+In
	 qs0UBGEBaUI05N7kltw6YX0iXtLIHY9NaDyzpme9UyE1MymMqonByvvLzbBIuOoYL8jLf
	 9eHbBK4wiY9JoLtYdOLOiOSBz9/HaG/5RQuzMg2/r6X4ORkRP5SGbSsY01yYssYMQ7Any
	 rSbmYd7qRwuN62jnKiXK22puJVx1ar5FJdyKKXRKrdh2WhYDwiyxGt+dYgbfvHVUnEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792447680;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uHo4I+MUXofQLQo3/uT363PT9y5PVIvUGs1uTiA5dqg=;
	b=OHL6ejod9SOvGr4D+k3bA4gm29y/pzAZSRz+CAwknsb/L2upDl4+jDZM3A/u3vqHYf++
	 Uqn991ovIxMoAqBzfZZd2vyCTqUYVYiCdGI3U5jBnzRdIWaHu5yiskJJebMomN7RSHFCj
	 xeL7TMdQwDgx/hJnEReYrfGHQUnVAbVJUlWXvEjjD6kSE9h14AVcACOJU5grZBz6VlWf9
	 AXihlC/IBFNdvgOL6mPg25neLLHLX2exfMOZ9rumOEyXDUn7riXbxTvQM8TbYb9HFW6g3
	 my5oSFMvpx6dH41Z7zPJxTSUQL/Jkb68y7BhVbJrvP6zqhpyt7kg5RwHXgDeQyMq9Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=R8ux8uYN;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E778B606A328
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 22:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E778B606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=R8ux8uYN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792447680; x=1823983680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=16nP6v8K6/vVLmLOs/khHzw7RIYPqiEzSUyZ6NNHkcM=;
  b=R8ux8uYNNTmDpfcCeY6kli0hqNoxHicCGUtp8zw3pWx7osFdjFh1F4+E
   2Yeg4NgvXBl92/dEb+d1kqbQFxCdGCTiYmEnT5Ymn13ITimlmoJ0ZJ2fx
   Y8KAf9j/Rj+Qt6i0MguypL+do8mNW0GV2MmGoXxw0/qqsZfnpXnonn4fa
   6d7DdLLqlHhEwzeAMpcwDn7nHpgKSAMQCCvBn3FhEknXgd8JPDRIC5nXo
   jH+G1b0+G7VDz3wUI+dhBMfj7lg2HehZz1Z6aNm58omQleHBKT7HXohzA
   Shqtdzi9Xl1TyloARAuY5WBNkOBPw8SsdZFQjMRP6HdGD8VSwcJElxnkW
   w==;
X-CSE-ConnectionGUID: Bb3+qEudRoSBoCxwfIWQRQ==
X-CSE-MsgGUID: H3MSX2U7T4q6jb90iT7bag==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1144190"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1144190"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:59 -0700
X-CSE-ConnectionGUID: lEAxAciYR1yZ7dGGn0RUog==
X-CSE-MsgGUID: /JFtXlvpSBSk6kmLW6KfqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2708333"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:07:58 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH v2 03/10] arm_mpam: resctrl: Do not fail CPU online when domain setup fails
Date: Mon, 19 Oct 2026 15:07:37 -0700
Message-ID: <660ffee2c7d069aed25c2757c51e12b28318bbc7.1792443633.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1792443633.git.reinette.chatre@intel.com>
References: <cover.1792443633.git.reinette.chatre@intel.com>
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
resource group. Drop the warning when a CPU going offline has no domain,
since a missing domain is now expected.

Only domains that were set up are exposed through resctrl and torn down
when their CPUs go offline. When another CPU of the same domain comes
online, it sets up the domain again, and if that succeeds the domain
does not include the CPU for which setup failed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/resctrl/mpam_devices.c  |  2 +-
 drivers/resctrl/mpam_internal.h |  4 ++--
 drivers/resctrl/mpam_resctrl.c  | 31 +++++++++++++++----------------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 48adc49b833c..d17d7a72dba1 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -2249,7 +2249,7 @@ static int mpam_cpu_online(unsigned int cpu)
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
index b07e5dd895dd..dc442851fd7e 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1615,8 +1615,8 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
 	return NULL;
 }
 
-static struct mpam_resctrl_dom *
-mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
+static void mpam_resctrl_alloc_domain(unsigned int cpu,
+				      struct mpam_resctrl_res *res)
 {
 	int err;
 	struct mpam_resctrl_dom *dom;
@@ -1631,11 +1631,11 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	comp = find_component(class, cpu);
 	/* class has no component for this CPU */
 	if (WARN_ON_ONCE(!comp))
-		return ERR_PTR(-EINVAL);
+		return;
 
 	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
 	if (!dom)
-		return ERR_PTR(-ENOMEM);
+		return;
 
 	if (r->alloc_capable) {
 		dom->ctrl_comp = comp;
@@ -1678,7 +1678,6 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		}
 		if (!any_mon_comp) {
 			WARN_ON_ONCE(0);
-			err = -EFAULT;
 			goto offline_ctrl_domain;
 		}
 
@@ -1694,7 +1693,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		pr_debug("Skipped monitor domain online - no monitors\n");
 	}
 
-	return dom;
+	return;
 
 offline_ctrl_domain:
 	if (r->alloc_capable) {
@@ -1703,9 +1702,6 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	}
 free_domain:
 	kfree(dom);
-	dom = ERR_PTR(err);
-
-	return dom;
 }
 
 /*
@@ -1757,7 +1753,7 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
 }
 
-int mpam_resctrl_online_cpu(unsigned int cpu)
+void mpam_resctrl_online_cpu(unsigned int cpu)
 {
 	struct mpam_resctrl_res *res;
 	enum resctrl_res_level rid;
@@ -1772,9 +1768,13 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 
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
@@ -1790,8 +1790,6 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 	}
 
 	resctrl_online_cpu(cpu);
-
-	return 0;
 }
 
 void mpam_resctrl_offline_cpu(unsigned int cpu)
@@ -1812,8 +1810,9 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 		if (!res->class)
 			continue;	// dummy resource
 
+		/* The domain may be missing if its setup failed. */
 		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
-		if (WARN_ON_ONCE(!dom))
+		if (!dom)
 			continue;
 
 		if (r->alloc_capable) {
-- 
2.55.0

