Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CCC131E2B
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643316; cv=none; b=snmtYR8gUJo5RKHuC67MCTIxfmvQQrmgCWbYiNuXFhxhMMuLUpg8salr/tx/3R2i8SkAnbBaYbuffbOaTNYpnjkZmxXucKSu6r0PmmXxUahMFMz8nK0sOu13k6/I3dqoTfYvrnatqiAWoWlreGsMTfDTSi1WubKqpaIjFLUdVio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643316; c=relaxed/simple;
	bh=xK5hwg6ILPkC2v4d4nuHc6WucRElJH7HgJqquuK12yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6cdm1GMhKNZI0s0QR1Z7tLRF+aa1WyQn9zuq5AbS/dQ01Z0DL37XGpjXUj75mlDTUtHH9pmPDSkl1LfCKii1yIGsj7dr9WyBS0RHvlAt7Y0M8IPmeBG78i4CAN4h0H9ytUSWOUmdrnHWoI7IcLjRYImZa6bwo9hb+JDIWLONfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QPZZQ41k; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QPZZQ41k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643313; x=1743179313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xK5hwg6ILPkC2v4d4nuHc6WucRElJH7HgJqquuK12yY=;
  b=QPZZQ41kQsv4AWahKnQRC+Yx0UaKnk5hS4o/eBCZNb3BpqlFZ282k+K2
   IjaTJbsN6BYDNt4b0KIXn7jt6THP5vTmj4uUedh9ce3bUPlLzdY1UMFZd
   Vt5svh1lbtwoGkMSHq1G1UQd8DGU5jDn6R6pvrr+pk37A9hilgiAEYRej
   VS0r/du/KS7qbYsk6mE5ezlLrKbPoqWBkfJRwpK0UnycdnS/dq4fzMd73
   XAbdQU8v0F1xj250k3lER1pSReGGWW7ptMhWXs/A2b2r6mr2m4QYVGaWz
   tU+PgLOaQXfTK7sQulJgMcDFrCfLig93dglUg2xO4i7gf8fkrFsddW0tf
   w==;
X-CSE-ConnectionGUID: RhVodmWXTHejmVkxGXbSuA==
X-CSE-MsgGUID: 2dR0HqGyTeuD17sFYzd2Yg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294771"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294771"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726093"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 44/74] x86/cpu/vfm: Update drivers/extcon/extcon-axp288.c
Date: Thu, 28 Mar 2024 09:27:38 -0700
Message-ID: <20240328162820.242778-44-tony.luck@intel.com>
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
 drivers/extcon/extcon-axp288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
index a703a8315634..d3bcbe839c09 100644
--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -108,7 +108,7 @@ struct axp288_extcon_info {
 };
 
 static const struct x86_cpu_id cherry_trail_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	NULL),
 	{}
 };
 
-- 
2.44.0

