Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8807531A062
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652562; cv=none; b=f3Fz1yf9OcT3WqP495WSRT8AysAhFTaEmtPxHR/buH8rH/kyEFGA6QVNzI84lWlLGNhDvwsaQRYl++x0kfuZXOMo+4drpPxQrG0q7oEJEGnjTobTkhd75iiyuFQrS3+0y1nUqQBNqCIfrLkurZoXJY4MnWyThJVwlOJHUxvs10A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652562; c=relaxed/simple;
	bh=Km0j+Rqo4NuIEA773l2R+LZ+xd4ZDOhQuQfnLs2zeAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUCyVvMbXJtiUN9iwKWbMTDfRKrXKAycWYhywC+854CgxwqVqmjsG7VokzvFAUk+jZ9m3xCtrxq0Uw+vXkdap7zkP+kQH7Ba4ZfcUdNzp6pkXJ4TsSRf0Gum+I3juvSPVe+drRMT1+Dm4AnjhuAfcHDDnubWHKHINpxnywa72Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EW+O5ss4; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EW+O5ss4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774652560; x=1806188560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Km0j+Rqo4NuIEA773l2R+LZ+xd4ZDOhQuQfnLs2zeAQ=;
  b=EW+O5ss4naZVeZ7bqAhymL/IpK2EJU7W9Sq1MwKPKSpegJAoq1vWdgW4
   VmfeN/TtwlX+LWrT1Klj94+7Xf4H41jR2XQVWDAi0+u75/4nnEVqGtrRE
   4cT+GIgeQGoX7e5cSbejniAw2QXBTx+mmiGPssONXhOiQwAA9CT12BSLi
   lbTEaAjlS9HVIuuRcrQ8MrslgiuIS2Ek3JKl0+jxySrpr4kvSqs+v08H+
   t8SUdr81Vb0+UrJzQx2OtxhqFe4sCX8GS+LgyIVvOZZQ/7956ZF8+3G5i
   pbCdjaGkc5ooxfl21hN5cT5+rIUKHXoSVCq7MXhtPbCSgApmBM0rivUFF
   A==;
X-CSE-ConnectionGUID: RaUYPkMGSl+0WlKBkm5g2g==
X-CSE-MsgGUID: mxIParLaRkCn7e2Qq1pXYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75613261"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75613261"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:38 -0700
X-CSE-ConnectionGUID: z++Qj9jUQMCSjGfWCBFVTQ==
X-CSE-MsgGUID: ympgy13pT5WOCsibrfBmEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218816025"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.83])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:15 -0700
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
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 2/7] fs/resctrl: Add interface to disable a monitor event
Date: Fri, 27 Mar 2026 16:02:03 -0700
Message-ID: <20260327230208.18094-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327230208.18094-1-tony.luck@intel.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
 <20260327230208.18094-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Architecture code can ask file system code to enable events. But there
is no way to clean up and disable events.

Add resctrl_disable_mon_event().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h |  1 +
 fs/resctrl/monitor.c    | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..b312aaf76974 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -416,6 +416,7 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 			      unsigned int binary_bits, void *arch_priv);
+void resctrl_disable_mon_event(enum resctrl_event_id eventid);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 49f3f6b846b2..0def41c26edc 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1010,6 +1010,18 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 	return true;
 }
 
+void resctrl_disable_mon_event(enum resctrl_event_id eventid)
+{
+	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
+		return;
+	if (!mon_event_all[eventid].enabled) {
+		pr_warn("Repeat disable for event %d\n", eventid);
+		return;
+	}
+
+	mon_event_all[eventid].enabled = false;
+}
+
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
 {
 	return eventid >= QOS_FIRST_EVENT && eventid < QOS_NUM_EVENTS &&
-- 
2.53.0

