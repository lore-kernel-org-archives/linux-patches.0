Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB5F4963AC
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633737; cv=none; b=ixfVEkUAnD1NfeNg+Mwoh3Toyc2Sq++T4HAL+4WzotEYBa77Nx1pWMQfNeJUp8+VciMN1NrXogLmaLecFRSEl2mS6uUR1iHtwgk3/igN0uagMY+lbcngSaA+j3GCtPrY+vOroaMv2lVOQuLrebDbW4G/EzN4aQhRy+qBgVndbTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633737; c=relaxed/simple;
	bh=pTDhq79ddpggY0n+KqOqU6TsTZ4sAikNtUXGt1GAhlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyvDyLSfouZYGrVeZeZNdQmSz4xUEmGb6hcnUw9v70De0epZXZnIwOhL1ImjSMZ328DcfNHMEAV16TqgoE7KBQ6HO4fsI0lHMeXKyYxpGfdZ5C/36RM3zShYhn0ohFq2kdrUCv3Hprkcrtoe3tyRsk8XVq8+oFPaRvmnfTFl/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjwp8J52; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjwp8J52"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633734; x=1822169734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pTDhq79ddpggY0n+KqOqU6TsTZ4sAikNtUXGt1GAhlk=;
  b=hjwp8J52ddjpwjDB7Fy/Z4+Ojyx3Uco/GIJ0hPprfHvDwvi9Ci0rgnPE
   CxGIH7MG6sIGoyU+D+j4e5mEdVvZHZMu4GuCMZmqU+53QR+kGTjMeztLK
   hU9w3AMbBqddfXagw5LoJlx/4altXLNDFt7goKatPHxvptLIDjwZdRpib
   8xQMd7XJJBe8f5247GPnOIDo3vyd5amnaeHar5hROVoH0lnv4h4tZ7wlB
   c2cKBAaNjI1XukqcA/VYHXk1izOWCQkc7Nmo1C1ThL8CxjMi9oy5r68aO
   cCvyj04khsmz0iy84m+TfDGtz2QL/KlqB4MPgQr51UZ3MSVF2rptGSoie
   Q==;
X-CSE-ConnectionGUID: gjlFwQ41TMS/4btnpJ4KZQ==
X-CSE-MsgGUID: ClT6NaPBS+mlnH9kU2Bf2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387242"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387242"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:19 -0700
X-CSE-ConnectionGUID: 7byRebtfQFy3NSzZYLVlBw==
X-CSE-MsgGUID: WTQQtDslSBOQLvW0EkeU+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685493"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:18 -0700
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
Subject: [PATCH v13 10/25] fs/resctrl: Remove redundant calls to resctrl_mon_capable()
Date: Mon, 28 Sep 2026 15:14:54 -0700
Message-ID: <20260928221509.68002-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl_mon_capable() indicates whether any monitoring resources
are enabled on the system. It does this by scanning all resources.

Redundant calls to resctrl_mon_capable() in hot code paths should
be eliminated. There are two prime examples:

1) mbm_handle_overflow()
This function is called once per second from worker threads running on
each L3 domain. resctrl_mon_capable() is clearly redundant because worker
threads are only created if the MBM monitoring feature is enabled.

2) is_rmid_match()
This is called for every task on the system so making it less expensive is
appealing.  resctrl_mon_capable() is redundant because the function also
checks "r->type == RDTMON_GROUP" and this type of group can only be created
on systems that support monitoring.

Remove the call to resctrl_mon_capable() from each of these functions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v13:
	Moved change to is_closid_match() to its own patch.
---
 fs/resctrl/monitor.c  | 2 +-
 fs/resctrl/rdtgroup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 362737e13cd3..02e81fc82b14 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -888,7 +888,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	 * If the filesystem has been unmounted this work no longer needs to
 	 * run.
 	 */
-	if (!resctrl_mounted || !resctrl_mon_capable())
+	if (!resctrl_mounted)
 		goto out_unlock;
 
 	/*
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 96a4978ce6b6..7cf809380c53 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -691,7 +691,7 @@ static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 
 static bool is_rmid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_mon_capable() && (r->type == RDTMON_GROUP) &&
+	return (r->type == RDTMON_GROUP &&
 		resctrl_arch_match_rmid(t, r->mon.parent->closid,
 					r->mon.rmid));
 }
-- 
2.55.0

