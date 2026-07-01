Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B9236BCCA
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880044; cv=none; b=Wf9Bs70cM/HPmsGoS5ljoLdTsGIpkgY5D5lSaAI8xL8n37Whj9FJRG6X5x4jqdcVUZhZ8XTOqI9r6l6yRpCJl7KHYWjWXLQYHYjS6g+fyrwWpzmFWekC2ZaFxNKpVbW3GX23Jx7TYLUWtMhcEEwNwU+Tm24tu9Sml1yJmmTE+3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880044; c=relaxed/simple;
	bh=KIY6rIa++6h0t1vMMAUTyHUCrFcnVKunFwYbSFgYkvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHeCDZb9sHcthWFnTbBnE+mn68/PHLWhmIFBtffqOTwh6McNXRMkwEXwcExEaJS8bAP9ZiPWzaXHyIB0+zwnmZoyLbefrJKO7BFUjch3kOvIMqgoj3CFx+/NxJQ9IvC/muYawBGTvOFEEiHhvQxwKKL2mPEmDVW7Koa4bt2/Rhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hquu2UGH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hquu2UGH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880042; x=1814416042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KIY6rIa++6h0t1vMMAUTyHUCrFcnVKunFwYbSFgYkvk=;
  b=Hquu2UGH4HCkCRIS07LOwpWpjOoqjP8dnhgxVCBaIoqWEPt2/HS+eQG5
   63iz+6gFpYwYCRibvpfZfIHeeSbE85hAowJQW6wvJMRMQgfS4JFJ3IORz
   +pAVEsbPfWkva43JHyHTZWqsqeqHRBkTyf0r2k7jJnwM+DqkfJoJyXFip
   75e6q9E1l2XSGxZgvCiD3v8mTkuKas/VdJXwzTSKdbdrp5UiT3vYYMRU7
   mTyel+YXugG6mjgC/Qc1sbCOsYf2xGXJv9eZn+rLEme5goh28w0xzqOJ/
   oC4HNZVssx60o/6pk+fumXaAoHJ/QmpiVzUJg1JxJqM7DDHRiReM/zCgO
   Q==;
X-CSE-ConnectionGUID: IzoJ+/KoSKikk8Q7c5sRUA==
X-CSE-MsgGUID: KTJYh17wR6mpUITRw8bNQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514254"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514254"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:18 -0700
X-CSE-ConnectionGUID: sGkxB9alR0CVkPuo/BDKpQ==
X-CSE-MsgGUID: WsG0aolUQ9WdkMs8RlZ6Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080571"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:18 -0700
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
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 03/10] fs/resctrl: Change pattern used to track number of entries in enum
Date: Tue, 30 Jun 2026 21:27:03 -0700
Message-ID: <0a7fa4675fb997b6837154dc668baa5e83dcd7d6.1782857711.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
References: <cover.1782857711.git.reinette.chatre@intel.com>
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
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v2:
- Add Ben's RB tag.

Changes since v4:
- Add Tony's Reviewed-by tag.
---
 include/linux/resctrl.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 73ff522448a0..c3ae0e8cb522 100644
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
2.54.0

