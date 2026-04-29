Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E11E32ED3A
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475209; cv=none; b=q+/3UXGNiViKV83A4Ow0jTQgZPwcGKA9pS+H8FEoFPIaG23BJa8Psn5fisS0xr7AOrtCR6IFgHQEabBG5D2JF1TMtddiZbQqCl4z95qWItryqArZG5CsNM/mAWr4kdfwBX/REUeonjHEbrIwf8bYYvPmqFcq/5/GhSsG8UJjtH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475209; c=relaxed/simple;
	bh=dxMeQSQAI9H8hX2jXObajzEdPFMeYDHhhrSWJaEFRwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuK8BROTb78iiQrBK7FY16/qCtyWyHGDepRpdVfncCjienxH37sPg8HrwFBoCz17v1/0MDRtI/g+bcSq/QykWjrUoOXR9IrnMiL5Gw3xSBe656j0WK0OBUOHizToT/FDPjiZTW9ln6gf1/ckBbpwbf/qOAzSl/L9p5GYQif1Llc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZZ5RszXQ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZZ5RszXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475208; x=1809011208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dxMeQSQAI9H8hX2jXObajzEdPFMeYDHhhrSWJaEFRwc=;
  b=ZZ5RszXQz1tCmfBU50JlQtmZec9T1EojpjkyVk00OT1LWnOPEzriVXev
   ds0F5fkEht/ltCkWEKH/KS5xMLZsI/yTplHw3JLlnRG/cAjBT4CWUm3Gs
   47Y75hBFoFnmRXqZOIlTsUzKMO13qJMiSbcxsiqWTAcRpnPn2CY5tpLZZ
   +eRZ3y51bBKEH7Z02Qr7sNWnmO8+TSucDAfjR7qnbD/zbwhl2By8pA1RC
   vYhp25cREKr+YpWIqug7qJgJqPt5m3ZaBom6nUI6jIXszLioSIBbcwW4s
   k84zOJlcKYsS118Kh/GHmIU9JQaGXWBkWAQZWplmEZulW+iEZgDV/v47l
   g==;
X-CSE-ConnectionGUID: vw+e1E3OSQCBc2ZdoqeyGA==
X-CSE-MsgGUID: 4SzMZHCeR4G3MVdv4VZFzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424330"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424330"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: 2jPG30dGTtCWUIVVtWuQEA==
X-CSE-MsgGUID: Clb9BXYzTbSLagFaLO7T8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445000"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:46 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v4 01/10] fs/resctrl: Use correct format specifier for printing error pointers
Date: Wed, 29 Apr 2026 08:06:31 -0700
Message-ID: <79af88624ae8f8bf2d7103f52874851583a419af.1777419024.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1777419024.git.reinette.chatre@intel.com>
References: <cover.1777419024.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use correct format specifier for error pointer as coccinelle suggests:
    .../fs/resctrl/monitor.c:148:8-15: WARNING: Consider using %pe to print PTR_ERR()
    .../fs/resctrl/monitor.c:760:9-16: WARNING: Consider using %pe to print PTR_ERR()

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/monitor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9fd901c78dc6..8194fdfbea81 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -144,8 +144,8 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	arch_priv = mon_event_all[QOS_L3_OCCUP_EVENT_ID].arch_priv;
 	arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, QOS_L3_OCCUP_EVENT_ID);
 	if (IS_ERR(arch_mon_ctx)) {
-		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-				    PTR_ERR(arch_mon_ctx));
+		pr_warn_ratelimited("Failed to allocate monitor context: %pe",
+				    arch_mon_ctx);
 		return;
 	}
 
@@ -752,8 +752,8 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 	} else {
 		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, evtid);
 		if (IS_ERR(rr.arch_mon_ctx)) {
-			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-					    PTR_ERR(rr.arch_mon_ctx));
+			pr_warn_ratelimited("Failed to allocate monitor context: %pe",
+					    rr.arch_mon_ctx);
 			return;
 		}
 	}
-- 
2.50.1

