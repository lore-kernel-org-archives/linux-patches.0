Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DD0376BE4
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475211; cv=none; b=tx9T8Bh017T6CuvJel1XOaSiGD+LLRANvia1Aid3dhC6qGIjdkMiAXsl1vquK1Djh3aWHBttOpj7gzcakpI9YXZh+u1sO4QsJ7AVlsJBXgUWhJW4EWDr7XHk8/5QRJXYuPhbqLCDZEnr8/08zl7VI3yHQEhbH3NUlYLxREeWs34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475211; c=relaxed/simple;
	bh=arnafYuhnaMZc+KiEcaSFFq8ZsggDT06JfSKTL923xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIAWZnh069qwPUmGMOT8vcT3Nm3wFVMfApb0+da8VeYzhpSXjm+g7sjstIkaGflRbyAgYRYYmtOs4WyafHe/AVWqdHy4sASprPR3644OdalUZKURIk0MIQlbc7CH0oh67YxREadqgNXabU84mq80o0M5SYlBkepLZverlVlTMXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Izyk55Qd; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Izyk55Qd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475211; x=1809011211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=arnafYuhnaMZc+KiEcaSFFq8ZsggDT06JfSKTL923xY=;
  b=Izyk55QdHrzRkAQtutofpZKwru2SPIokuRDQrCbouXu8SFpOgjJs7qnr
   V8cEyOU1TgeTq/578P23m32skkBRWvbtU2aM4E88K+mOiy7rBo08KStJF
   NbP6U4YZhmaSkH3B5tXiz2Dfh3Z4L8kKOonuddqko0jSYxLjEccsSzvPe
   gm9HVdFpVtRBBC7KsORKmIAH4t+K39nKGFJtI0EdB5erLdhWEjGjEfC5d
   hMzuJ6KE5Evb01Ykit3xNXLJwoUi075/0BzyKwX7pVynXwxuvkiSFxR+b
   mA0md4oJqZC/HHsGqzNRzaseO0WIOtw5gMnsRmZ1HYE9+XCpkTKdfkQ07
   w==;
X-CSE-ConnectionGUID: +QxloU8xSjqtWEEmC1JYMQ==
X-CSE-MsgGUID: VkY8zlo+Rf6k2lCXVlvGtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424349"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424349"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: FxFtCcA5TW+tmR0yROpyPw==
X-CSE-MsgGUID: LINvcxw0TTOQeZH40ofhOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445006"
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
Subject: [PATCH v4 03/10] fs/resctrl: Change pattern used to track number of entries in enum
Date: Wed, 29 Apr 2026 08:06:33 -0700
Message-ID: <4a304e6c9ed3f5d92156b8045f5dd4ddba359dfc.1777419024.git.reinette.chatre@intel.com>
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

