Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2D03264D6
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044239; cv=none; b=suY6WTdwU3tnoiS1RXGzsX5fBFrr5C8Gw280op71W43l6VpK93xCbWHPNE6rLozudveTg2sjtUa/TThEQ0BY2mk7iNPPKKJfSzkNgwekjcFQ/Oi6adVhkOk5nnVue3Aa+NRL4nDefKm6DVuR9LV9FNSJOOBu3MLv0CjTtgh7hlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044239; c=relaxed/simple;
	bh=oQkNYBpCA5AlmfxOePF5QgebJUzdQ5GMSBoc3afjB/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqk6zjFZCbupgf55UL1PYM7b9B4LPIQJiNWYs8gQSnQjDJjtZoNeL9Eufh+N6aDGh41fsqx18C/9iBv5a960AQ4RUHrXbMCPPf7LOtyoFQs6pnjrTeARk/SkqFEqFBm/Dx/hJuzG4k/ppuPasCwGV/4y8xORDIq6B4TqI61OHig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jSTuKlse; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jSTuKlse"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044237; x=1805580237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oQkNYBpCA5AlmfxOePF5QgebJUzdQ5GMSBoc3afjB/0=;
  b=jSTuKlseF1LF1RvO2sYGSVvab50VKHWbMttj5vKDZld/1p3FS25lDk4B
   s3ypL/xAzIcAkppe7Woql/w3lvtiPQJmbr74raBAEEFAHX7ldI0PobUOO
   4GXhrbINtDRQJQ5mlymm8aV4E1sDx6MfDfVwra0zrgzW8IsmlXJD3sm9n
   FqLeO0jwcb9gwYTI3F1WpRB5/DGdeFXjnqipVRwtOUDfsA0GnwjlpNIfR
   8dhTGk6tk0jRjhcm8aV9JrUP8pN9WaHcU4l4VgsEEw5asA/JAogczPn0n
   I5HGfmaPpNhYIB7jgdTQAtg/RODu2bFjAQyFT6h61cQNPMGYI9eMeyD51
   w==;
X-CSE-ConnectionGUID: 2KlVNwZNTdmZejdNsEhX9g==
X-CSE-MsgGUID: mKVW2fokTuSL6IklJsnRkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758386"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758386"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:55 -0700
X-CSE-ConnectionGUID: HO/vQbH8QjWM/x/xTzQ2jw==
X-CSE-MsgGUID: yAJt7dBiRZahamLcz6rihA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:55 -0700
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
Subject: [PATCH v2 06/14] fs/resctrl: Change pattern used to track number of entries in enum
Date: Fri, 20 Mar 2026 15:03:16 -0700
Message-ID: <24b86569a2d3428f7fddf3572adebaec909e696e.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
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

