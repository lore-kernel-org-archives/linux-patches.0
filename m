Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8098B3A5E91
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907015; cv=none; b=Rc30oN7TrafLB8SQhdK193wachvesf6w0YuCnqS0BDWPzCzZzSUpCldhwsUVkLsZwq0zl8a+4BVILQaepdVy28vvcLS7ZLVo9/vY1h6ezdIo0GhuCEikPC5C1iOvJFDuC6uToEsPRi5CnwVQn7LzKKROCvkpVq6USzpF5LkM32s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907015; c=relaxed/simple;
	bh=3ImAyxvnv0f1uzi+zUm8GU+iSobtAJ3OcTnC0JjVOWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlX2vpFwKZETsAF2odLM7ukNh+Escxsnn03y/TzqclVXzTQiZkYdHebHQgCLIzk5aT10uPmEvYQq6KtfEfh29EEziWD20/y3VWPWTlg/UZhzVdFq8fSecGPZfUTjWpeElDcvaNBLFpxMtS7avwVYkskwdqwp4s0AyKCjFvDNTuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NeYlzwwe; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NeYlzwwe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774907014; x=1806443014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ImAyxvnv0f1uzi+zUm8GU+iSobtAJ3OcTnC0JjVOWc=;
  b=NeYlzwweg+ZeisT9ISir8i5T86hmTrRQW4qu46TIE+Muhh/KsP/QWdNz
   ngEaIgttMmFfkrSwyFiQFo71tb5sM5fAJnm7FDidXk9M2H26qSr69VVtk
   oQSFw7KnMziTh3dOIORUMRFXIe11x5dqTS9uZx3emyRqpBAqs1v0aQi/j
   XSK9kVj7wYvwJgAGt2zQtHZ9mHdAMc1QuNnPZhAWTV5+x0vPWAJeiSFF8
   Z30k9nVhrH9hZgHHs9HsiGR8pYvkqBNYqSrn45boixo0liOzjXU+Cedm5
   /TT9e4K72ws1/Gt+26Pye/D11PvgB9oCO5/WjRmA3ve3k96KgqWoTlCFQ
   w==;
X-CSE-ConnectionGUID: 5jx4oSPPR92vWiMP4YEP1g==
X-CSE-MsgGUID: k3LJbQloRuCKpD6FfGzIXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79772145"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79772145"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:33 -0700
X-CSE-ConnectionGUID: pYlJ3XnnRDmuHyEIN1wK5w==
X-CSE-MsgGUID: nofELbRVQJuLhNyKnTUgUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225185942"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:32 -0700
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
Subject: [PATCH v4 3/7] fs/resctrl: Add interface to disable a monitor event
Date: Mon, 30 Mar 2026 14:43:18 -0700
Message-ID: <20260330214322.96686-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330214322.96686-1-tony.luck@intel.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Architecture code can ask file system code to enable events. But there
is no way to clean up and disable events.

Add resctrl_disable_mon_event(). Adding/removing events is only
possible when the file system is not mounted. Add a WARN_ON() to
catch misuse.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h |  1 +
 fs/resctrl/monitor.c    | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

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
index 49f3f6b846b2..50eb5534767c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -990,6 +990,8 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 			      unsigned int binary_bits, void *arch_priv)
 {
+	if (WARN_ON(resctrl_mounted))
+		return false;
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS ||
 			 binary_bits > MAX_BINARY_BITS))
 		return false;
@@ -1010,6 +1012,20 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 	return true;
 }
 
+void resctrl_disable_mon_event(enum resctrl_event_id eventid)
+{
+	if (WARN_ON(resctrl_mounted))
+		return;
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

