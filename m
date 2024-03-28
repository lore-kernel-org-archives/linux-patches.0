Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581F512F38E
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643314; cv=none; b=SJgJYNi8/2onUJTaQSPYk6H7h6PNDJ39cULkXotDCYui6WphapM4kIyK3BOKJ1YmogsYpeku+WNU1wOhTqsadiMr386ANWhTHCTuRCje6I/lZyA3p/YtCkG4rbLK1742pVDWQg/AsF+Z2aFpqcI3OLz8SPyGxT8WePc9IyW/YzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643314; c=relaxed/simple;
	bh=D4u+14rLptzvw7vl6botFXd6uhzNw369NTgf6IDkOUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gbkn17kfIW3zlN8MwNdNlkVb2qb93+Shjxip07NQqCklIXu7XUS6+sTpNwTs5wKkJ3HHyaMfkyrVz0bCDz7Lk6OHm5NNn4H7BweuIa5EBOVe1IpUjeeBIP4PnQ82r0WObZWjW7NlRtMzPeHBe7WUozXAwVvOtkunPwoLbnycTo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dxBn114t; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dxBn114t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643311; x=1743179311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D4u+14rLptzvw7vl6botFXd6uhzNw369NTgf6IDkOUs=;
  b=dxBn114tDTOXXHsn7Olv62wSovpxQ5lo4kd1ArdTq+d6dMoaZ6P757OA
   S7evVWJZCqFPXC9sYMJB94oy5HKpy4gzb0WdgIifQGc3TmkzTlBxBKlJZ
   EcH+C2CKN5+ZJyZvGuXQVeC53NH9khUrDktlGM60JnHSbASGgc06UWMg9
   4EHJlug/a0lJ3g210X8xB4p3ziD3ELbldKelw3hbNQI0l6pRM7LbmjYUS
   Uj+YQDSd9P5lvXE06E8SOl4T8h9XdYBwVkjVNDO3yk4nk7imF0hT1KN4A
   gBfe93CX0Ws4xJuhkl7FwpIBa9Il3WpR3Di9Xjwx8JttIRNka+zaUAkqb
   Q==;
X-CSE-ConnectionGUID: IYLMwP6VQpSquSspf+fVRQ==
X-CSE-MsgGUID: 2GS7hboJROKhgKCXwQUCpg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294765"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294765"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726077"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 39/74] x86/cpu/vfm: Update drivers/cpufreq/speedstep-centrino.c
Date: Thu, 28 Mar 2024 09:27:33 -0700
Message-ID: <20240328162820.242778-39-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/cpufreq/speedstep-centrino.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 75b10ecdb60f..ddd6f53bfd2a 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -520,10 +520,10 @@ static struct cpufreq_driver centrino_driver = {
  * or ASCII model IDs.
  */
 static const struct x86_cpu_id centrino_ids[] = {
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL,  6,  9, X86_FEATURE_EST, NULL),
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL,  6, 13, X86_FEATURE_EST, NULL),
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 15,  3, X86_FEATURE_EST, NULL),
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 15,  4, X86_FEATURE_EST, NULL),
+	X86_MATCH_VFM_FEATURE(IFM( 6,  9), X86_FEATURE_EST, NULL),
+	X86_MATCH_VFM_FEATURE(IFM( 6, 13), X86_FEATURE_EST, NULL),
+	X86_MATCH_VFM_FEATURE(IFM(15,  3), X86_FEATURE_EST, NULL),
+	X86_MATCH_VFM_FEATURE(IFM(15,  4), X86_FEATURE_EST, NULL),
 	{}
 };
 
-- 
2.44.0

