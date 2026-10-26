Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051855;
	b=WuMQQefiXCiQCDrKxflGvI/ndtNriRrzXMgRHO/d1aEmRDJWIWXD+nbu2RE+QYe7zDM0
	 ATxGZGM1oxwqaJHvlf3W6QNVRObZ5CmpHWDuDxqjW8nO8Hbj5lEyYaRPxp+XokAziujfG
	 4FLbi0tzAvt6p9JUftPUDfMpBAVela5zFeuRvgFTBS+bHuSP0OCL77mPP9gCB7bR48Cbc
	 Cz65aa/p19GZNAgyB0cWj9DR4wwadGm1P7h/uN3pdalidSrCBGY59rwOH8x6zoHlpkBaT
	 Gvq45uGrCXt1AYvohQ9MvyQByn4Q3x6/XX+E4Cd+Ztr8r7CNaafTz66WatcRbHSKg9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051855;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vvsz2i/tJSXRruC19/aYm2BsTqbmtaTOP4nm04uvRDY=;
	b=W5rqLqr8sU4P3adxE8v1db3+6QcpT88PyQrM4ZWatxPlBGoh7Vy/FswxkRAwIy5V5AE5
	 KSXT+BGMh/PBcTL1F6dIuPPgQRoIkjzpXucxuRYyQ9xLHbg9tUImHqPFB8vjLlYmrIrNR
	 1svooqQ5zRmCOEIffP2Y8xBEOClfmeaUxkcfyfJw+y5H67ZUqlAfOQo9ChpfEYuNBZfgO
	 9HMiicXQaHJDfFcyKRZQ6ciq1rIMKjcHNtZdMgg0IT0taZL6waW3f1RAOj9IZnWCaGu0K
	 SPlQG1cyeScp/AAjN4dVkPj9MEenwpAekASX0hHSCRCsGsiWY43MLiQX8tNhKALq2aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nFGMXcpN;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8730C60A2623
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 21:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8730C60A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nFGMXcpN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793051854; x=1824587854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XU5cu1gFtiSbEl4wlEPXZEU+UqphTi+pfTOPwr484Xw=;
  b=nFGMXcpN40bJE04iu1BWCixUJju2zBWVJeWeAkwHRrzROT6+cm337XNO
   a0IURXIXxrVgSFQi0cs2jlfsrZWa4jqAPUiqL8GEON2fiqBILyEyY3cHR
   rXmx0gMvqqyl/gwWx6R7sLo2kc3l+OJJv35qRydgAugOrWzC/8JUML7ez
   zRRCPBoc8yfQGkKK4+b6vhrAFxSil3DM5IBSN8pttafGsyA2b31rZpo/J
   8I2TpMJwNZQxSVhQl7rtpgWDyQR+t39z1l68r8ea9/w498tbH1AzYykpL
   f2SK4DOu4tEIc7BMyKn/nAX+qmsV9oXr1hvpl+j5gEqGRCUkhkRBWaJal
   g==;
X-CSE-ConnectionGUID: A/Vttf5LQta/wvcKfW5NbQ==
X-CSE-MsgGUID: qDSVKJI/Q4qDGO/WYDChgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1766435"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1766435"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:30 -0700
X-CSE-ConnectionGUID: qtSJOMT6Rh6MLljWKEOWug==
X-CSE-MsgGUID: ODLNEzs3QDCyJxmOo2MWcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4240292"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.204])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:29 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 8/8] fs/resctrl: Suppress creation of cbm_mask info file on asymmetric systems
Date: Mon, 26 Oct 2026 14:57:18 -0700
Message-ID: <20261026215718.16810-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026215718.16810-1-tony.luck@intel.com>
References: <20261026215718.16810-1-tony.luck@intel.com>
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

Hybrid CPUs with a mix of P-cores and E-cores may support different
cache allocation bit masks. The per-domain masks are described in the
info/L2A/schemata/L2A/max file.

The cbm_mask file contains a single value and cannot describe an
asymmetric system.

Skip creating cbm_mask in the info/L2A directory.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/filesystems/resctrl.rst | 4 ++++
 fs/resctrl/internal.h                 | 2 ++
 fs/resctrl/rdtgroup.c                 | 5 ++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index de162280a0fe..25e9e5e5e738 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -91,6 +91,10 @@ related to allocation:
 "cbm_mask":
 		The bitmask which is valid for this resource.
 		This mask is equivalent to 100%.
+		Not present for asymmetric L2 allocation (L2A), where
+		valid masks can differ between domains. Use the bitmap
+		control's "max" file under "info/L2A/schemata/" to obtain
+		the per-domain masks.
 "min_cbm_bits":
 		The minimum number of consecutive bits which
 		must be set when writing a mask.
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 4bd09b1541c7..d93d349db08b 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -261,6 +261,8 @@ struct rdtgroup {
 
 #define RFTYPE_RES_PERF_PKG		BIT(12)
 
+#define RFTYPE_RES_COMMON_CBM		BIT(13)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 46d39332706e..5cf6a257bea8 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2196,7 +2196,8 @@ static struct rftype res_common_files[] = {
 		.mode		= 0444,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= rdt_default_ctrl_show,
-		.fflags		= RFTYPE_CTRL_INFO | RFTYPE_RES_CACHE,
+		.fflags		= RFTYPE_CTRL_INFO | RFTYPE_RES_CACHE |
+				  RFTYPE_RES_COMMON_CBM,
 	},
 	{
 		.name		= "num_mbm_cntrs",
@@ -3024,6 +3025,8 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
 	list_for_each_entry(f, &rdt_resource_final_all, list) {
 		r = f->res;
 		fflags = fflags_from_resource(r) | RFTYPE_CTRL_INFO;
+		if ((fflags & RFTYPE_RES_CACHE) && !r->asymmetric)
+			fflags |= RFTYPE_RES_COMMON_CBM;
 		kn_res = rdtgroup_mkdir_info_resdir(f, f->name, fflags);
 		if (IS_ERR(kn_res)) {
 			ret = PTR_ERR(kn_res);
-- 
2.56.0

