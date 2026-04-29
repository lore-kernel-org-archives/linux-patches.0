Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9499D376BEC
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475211; cv=none; b=LfHmvlL12E874aOZnsr54XUqcjlBsSnsd+qD13VOAfPL2HYlckw0y7rKy2WOzbUFMzH5KhNqS/BsadFxG5+2bh+PsvI6HgkAXEIFgCDT3sf8uXG5Mbt03s8Y3y+97AiZTAlbUT3QA1YGFxSrCOmgU6o6X9de2RLGLk/g4L++g/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475211; c=relaxed/simple;
	bh=UmtJaEEjPND1GwglwNpwhcFwJ4D2HpzVcTyZRXsHAY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHEionw9POILTcchJfPqup9AnbryUnxCTbuC0okVZGSwbBdPifvIVmltu1X1SAAInDlD8Eea9e3CcaN69r/s8ds6MujmQiL3YnNxwPHM2lMmumKL/A3xhTiStucLz1qhfPmCJY1vQMS7yj8bB/2P7G7K7/lqDp62Rqe21RpoqN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+rvNs05; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+rvNs05"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475211; x=1809011211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UmtJaEEjPND1GwglwNpwhcFwJ4D2HpzVcTyZRXsHAY0=;
  b=D+rvNs057JooLxLXb00JD1gK6j9y9W0pKxOThRQggTcgYZNxX+IyiT0c
   0IXl6uPibdxkFtOpldKN/FfDGNYz4YNBSs9KhfqmGP4w7Pwf3Th9iR5x+
   ZFkr8NEAQWq8s5hUispuhGPxTJb9CCDDKRa+ayY67M8wpJIIAHtyL0YDJ
   67GrmWhZjofdO9M9+pZIPRLhfHE1ekCHMTVrnBzhkhGUN9LjmzNqjxChZ
   ZeNJwox9mC58vX8FshxANl3gH1E8VEYxVzhCJDg0/K3CDtmQi62v44w/K
   nhgoL+V5I25CbRy9bryAaMC+WAfki6v0ozPQCoKCqLS+PwKMMv/wm+PLm
   A==;
X-CSE-ConnectionGUID: 747zbdN5Q4OiLGpS/DUNtA==
X-CSE-MsgGUID: QRarUipCQAGgIxqPiro2xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424359"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424359"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: 2YVJv0fLQ6WIROL78YqxBQ==
X-CSE-MsgGUID: NYoze/g5SMOmApm8pvkWUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445009"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
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
Subject: [PATCH v4 04/10] fs/resctrl: Use accurate type for rdt_resource::rid
Date: Wed, 29 Apr 2026 08:06:34 -0700
Message-ID: <0629fe256d551829c9e41304a3f4e5bc3de97532.1777419024.git.reinette.chatre@intel.com>
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

Every resctrl resource has a unique ID described by enum resctrl_res_level.
enum resctrl_res_level is used in all resource ID initializations and all
resource ID comparisons. All functions consuming the resource ID expects an
enum resctrl_res_level. Of the four structures that contain a resource ID
(struct mon_data, struct mon_evt, struct rdt_domain_hdr, and struct
 rdt_resource) only struct rdt_resource does not use enum resctrl_res_level.

Switch the type of rdt_resource::rid to be enum resctrl_res_level to make
it obvious what values are valid, match the type everywhere this member is
used, and obtain benefits from tools that can flag any enum misuse.

Move define of RDT_NUM_RESOURCES outside the enum to enable tools to catch
when a switch() on the resource ID does not handle all the resources and
thus help flag which switch statements need an update when a new resource
is added.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v1:
- Use RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG as last entry in enum.(Ben)

Changes since v2:
- Add Ben's RB tag.
---
 include/linux/resctrl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0b28049378c8..99a4774735c7 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -54,11 +54,11 @@ enum resctrl_res_level {
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
 	RDT_RESOURCE_PERF_PKG,
-
-	/* Must be the last */
-	RDT_NUM_RESOURCES,
+	RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG
 };
 
+#define RDT_NUM_RESOURCES (RDT_RESOURCE_LAST + 1)
+
 /**
  * enum resctrl_conf_type - The type of configuration.
  * @CDP_NONE:	No prioritisation, both code and data are controlled or monitored.
@@ -320,7 +320,7 @@ struct resctrl_mon {
  * @cdp_capable:	Is the CDP feature available on this resource
  */
 struct rdt_resource {
-	int			rid;
+	enum resctrl_res_level	rid;
 	bool			alloc_capable;
 	bool			mon_capable;
 	enum resctrl_scope	ctrl_scope;
-- 
2.50.1

