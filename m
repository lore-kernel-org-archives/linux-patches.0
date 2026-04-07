Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EC63CF681
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577768; cv=none; b=eIXKGdeDQ60dO1eVAeSbzepWCWpkJNBdsIZ1CurSSkzb6aad8DVfYXgBQXPfy9PwpxRu8iXfkUWnTAurCo7kMxECDQTAK6JVyveFBuyAnqQCCE0fk7QEbzvyB1kcKRGNaYo1iDCJG/EMvekFGZan0I51IGOAnqczBWoH2dUYgf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577768; c=relaxed/simple;
	bh=arnafYuhnaMZc+KiEcaSFFq8ZsggDT06JfSKTL923xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcD90pL/xQi2YzbJIo6Gz8eHVWCTSNh8Zk2/oln/wkoAGdpTSXZ6uMoa4/mW7eb2hryvWM+hXWWlhAZt/IcJRd1fjDHZA8bmiDSfF23wrf4EKio60NOu0NrAexfMh8A08owLdCOZoTWT9f/qs7ooj1gQjbkAnZoQaE60SO2VFtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I9hTMLXG; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I9hTMLXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577760; x=1807113760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=arnafYuhnaMZc+KiEcaSFFq8ZsggDT06JfSKTL923xY=;
  b=I9hTMLXGxonBoIKpB/45MVa1f72GY06E2Jms6VcoRBphXkRBvC+SWO9N
   f4n9lsI3XDWd8v8D7x1M8M5JnnlHAZFM3cK1Fc+CqIcOj8aoxti8ZdobX
   ZAiFgw/Ipx/VwohgX8uV6TJWvJ9Urerp16zCXVhAFYqVYkUZxMsvLA40f
   vyr8EcdnEmQslp6O2XymFzvpLt/pJbdKklg1AxsurlmdX2n1bae0hOijD
   9iui6CvMQz04fRHzlql/T1qil+5MNscXKzssj7AwZcMoYEyQnsLBfLqZz
   7jSAN16Ms0JldR6qcYVNgU2MuMmuiQwIaliCW3SaE5S9N2RTtPFB/f9V0
   w==;
X-CSE-ConnectionGUID: xMlESO+9Q5O6nxaTSyVMrQ==
X-CSE-MsgGUID: 8gVRKEuaQcaduE/Ufioyag==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432703"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432703"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:19 -0700
X-CSE-ConnectionGUID: 7bd/vY/9Q5metcBEUxCBgQ==
X-CSE-MsgGUID: w9yQiyHIQvytEWAeAZJ5MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119046"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
Subject: [PATCH v3 06/13] fs/resctrl: Change pattern used to track number of entries in enum
Date: Tue,  7 Apr 2026 09:02:03 -0700
Message-ID: <0a7a65609a1d3b5b734716287fba59ef702e5b42.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CDP_NUM_TYPES tracks the number of different configuration types that can
be applied to a resource. CDP_NUM_TYPES is required to iterate over the
different configurations but is not a member of enum resctrl_conf_type to
avoid the warning generated with -Wswitch when CDP_NUM_TYPES lacks a case.

Add a new CDP_LAST enum entry used in CDP_NUM_TYPES definition to simplify
adding a new enum entry. Do this to create a cleaner pattern for tracking
the number of enum entries in resctrl in preparation for other enums
needing to do so.

Suggested-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
- Add Ben's RB tag.
---
 include/linux/resctrl.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..0b28049378c8 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -69,9 +69,10 @@ enum resctrl_conf_type {
 	CDP_NONE,
 	CDP_CODE,
 	CDP_DATA,
+	CDP_LAST = CDP_DATA
 };
 
-#define CDP_NUM_TYPES	(CDP_DATA + 1)
+#define CDP_NUM_TYPES	(CDP_LAST + 1)
 
 /*
  * struct pseudo_lock_region - pseudo-lock region information
-- 
2.50.1

