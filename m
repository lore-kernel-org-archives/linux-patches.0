Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6A42076C5
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222927; cv=none; b=Zo8lhzGAo2qmsdpwyuKvwRKp/c+Z+mHD5MnqekChQ5wKe/8jgM5V8f4p0DkgSsW+kusSHyO/z6JdPOzOR4VTS+AmKTPnCd4msPWGx6DVQHHL9fmZQn6VESOYp2aLahYTI7nVB55gEHShLfc1J/FncyRvW/IMZ88C4Sw+5OySJVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222927; c=relaxed/simple;
	bh=x885zf274l9nnySJCLiGWLrrEaCGAoB82a5tbTdAiiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDAX7fSdiH1EOSHkBuFVEwhQiH/Kd+0GaC8e1gwwOhT1kK7fPnC5CMWgA7obyTkD2FslP5R+qc+EeYw4DXSMK5ukHs9h/p1N7Sr/3phgn6xzfnYBkIhMzUAAhXYeaa4WZm/oO1EYIRG8bMQB0ep0o7yDA7QO9ArgRXu/fVXA7tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UDqFWFQN; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UDqFWFQN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730222925; x=1761758925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x885zf274l9nnySJCLiGWLrrEaCGAoB82a5tbTdAiiQ=;
  b=UDqFWFQN5uS8yxDClFiutvUpFRC08q9/vlvoOZ2R9AL1/rZGWiq89U4X
   lqMSfJxdoKhuojIVXtOhatcybJfkQP8vKYgLgMmr2MlGDe1HK+m9tD4Cw
   dUzezeHzYeLKy2rqZWIniMZYcNNdgRop0rFewEMMX/04Xm/J6U17mwMOY
   jIDZ4U7vHFk9hwAVZdXYuWewmBVCciEkPZuKlR1gRZ9BGIUM95Qi8oMEb
   UEK4ofdmhkZzJzXSmOhLC0wTKmdhgv6k3eSZ+5TAYxXtxZooy+mE4Q43m
   Pu3p9mnXUInthaGD8klkMpZdw9kkd/1IZUUUZ8Kz9JgS1wY4nbBB4I1nK
   A==;
X-CSE-ConnectionGUID: YRtzJ4/AQeOdgTzlkbCeyg==
X-CSE-MsgGUID: LwcZ5BcVR3yB+xsg38B1ng==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="17515689"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="17515689"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:40 -0700
X-CSE-ConnectionGUID: Zc6/88meSeayWJ/uY6FXiA==
X-CSE-MsgGUID: dUhMnTlJQU6xnxVKlEJtBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81585610"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 5/7] x86/resctrl: Add "mba_MBps_event" file to ctrl_mon directories
Date: Tue, 29 Oct 2024 10:28:30 -0700
Message-ID: <20241029172832.93963-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241029172832.93963-1-tony.luck@intel.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the mba_MBps mount option is used, provide a file in each
ctrl_mon directory to show which memory monitoring event is
being used.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    |  2 ++
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 25 +++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 17 +++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index a6f051fb2e69..5f3438ca9e2b 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -609,6 +609,8 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off);
 int rdtgroup_schemata_show(struct kernfs_open_file *of,
 			   struct seq_file *s, void *v);
+int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
+				 struct seq_file *s, void *v);
 bool rdtgroup_cbm_overlaps(struct resctrl_schema *s, struct rdt_ctrl_domain *d,
 			   unsigned long cbm, int closid, bool exclusive);
 unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r, struct rdt_ctrl_domain *d,
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 200d89a64027..b9ba419e5c88 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -518,6 +518,31 @@ static int smp_mon_event_count(void *arg)
 	return 0;
 }
 
+int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
+				 struct seq_file *s, void *v)
+{
+	struct rdtgroup *rdtgrp;
+
+	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+
+	if (rdtgrp) {
+		switch (rdtgrp->mba_mbps_event) {
+		case QOS_L3_MBM_LOCAL_EVENT_ID:
+			seq_puts(s, "mbm_local_bytes\n");
+			break;
+		case QOS_L3_MBM_TOTAL_EVENT_ID:
+			seq_puts(s, "mbm_total_bytes\n");
+			break;
+		case QOS_L3_OCCUP_EVENT_ID:
+			break;
+		}
+	}
+
+	rdtgroup_kn_unlock(of->kn);
+
+	return 0;
+}
+
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first)
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5034a3dd0430..3ba81963e981 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1943,6 +1943,12 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdtgroup_schemata_show,
 		.fflags		= RFTYPE_CTRL_BASE,
 	},
+	{
+		.name		= "mba_MBps_event",
+		.mode		= 0644,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdtgroup_mba_mbps_event_show,
+	},
 	{
 		.name		= "mode",
 		.mode		= 0644,
@@ -2042,6 +2048,15 @@ void __init mbm_config_rftype_init(const char *config)
 		rft->fflags = RFTYPE_MON_INFO | RFTYPE_RES_CACHE;
 }
 
+static void mba_mbps_event_init(bool enable)
+{
+	struct rftype *rft;
+
+	rft = rdtgroup_get_rftype_by_name("mba_MBps_event");
+	if (rft)
+		rft->fflags = enable ? RFTYPE_CTRL_BASE : 0;
+}
+
 /**
  * rdtgroup_kn_mode_restrict - Restrict user access to named resctrl file
  * @r: The resource group with which the file is associated.
@@ -2371,6 +2386,8 @@ static int set_mba_sc(bool mba_sc)
 			d->mbps_val[i] = MBA_MAX_MBPS;
 	}
 
+	mba_mbps_event_init(mba_sc);
+
 	return 0;
 }
 
-- 
2.47.0

