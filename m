Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7474634EEE7
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 05:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589231; cv=none; b=JUMQiWpx1wu9rUYGRDdG4zKkY/LHrMZmblqu5sTEcO+5pGZmnJrS+53D3KhQdKZgqnP8r1PmsMEXpDnTSpd+qkz82bn3Jj4YldzjkANx+w+bEIgug/HFhwdZKIIC19eIUelxHoXYwWkdZZOVeyAj1DyChGBDWdxUiE+7y0f9q4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589231; c=relaxed/simple;
	bh=5AMAVz+R2Tmq6M4p91XzYB2KKexccD4OMPP386P5bDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDoAEY/HMbFkS/XDkWQFDPnEsbukiI5LfcUUgcHmOON0AR/SYqk+7IR3I5jn6saVAOu8QgXO4XslQ4pNdFC9KrZXjG0M+LDL9Ni3bNOvVrtFFKAQygmQK+ovGw7tLOiub0biYlclzWbGT2x/EsmQSu2ZDODIyDX/lGC1r4C2YfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ha7/pBVU; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ha7/pBVU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774589231; x=1806125231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5AMAVz+R2Tmq6M4p91XzYB2KKexccD4OMPP386P5bDY=;
  b=ha7/pBVUh4swY5wLkmljJxgG5eehjfS3PLZLfAx3jprlgUV3h6WSG7jA
   ddrSB+WsJJz082MH6Sgz1cXXbLijPusGDsUMtVK/pH96VOjhCAYCjYqZw
   aO6PQqGWyZNdAyKm/QYrLNwOZWa+rfVlNdSEqi6NvRJ4smtpRyP/nlTjN
   Md3U7a0ixwpX2fXdNqvfMa5Z1Q5zNVI49u8VKGoMJCUzbxPZ7eDFeTkhT
   UowS5sdR9u23HqCFfqvClRnAzFN/7AYmlgTwd2XWZIhg1tHdGyHvH4opH
   /+mp8WsS8gD7zar6LQQ2REfpMN/uuM+ip20R+zujaaMuVFLrblQo/Mr+D
   Q==;
X-CSE-ConnectionGUID: d6/Tgx6lRuam1C3tuThWAQ==
X-CSE-MsgGUID: 5TZOXgAoRlSTsqHx8+2K9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101117965"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="101117965"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 22:27:07 -0700
X-CSE-ConnectionGUID: cQ90kdWeQJOa58J0zTqzLw==
X-CSE-MsgGUID: oJTR3WQJSkCDJy0xOPG42g==
X-ExtLoop1: 1
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa003.fm.intel.com with ESMTP; 26 Mar 2026 22:27:06 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dave.jiang@intel.com
Cc: patches@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com
Subject: [PATCH 8/9] tools/testing/cxl: Simulate auto-assembly failure
Date: Thu, 26 Mar 2026 22:28:20 -0700
Message-ID: <20260327052821.440749-9-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a cxl_test module option to skip setting up one of the members of the
default auto-assembled region.

This simulates a device failing between firmware setup and OS boot, or
region configuration interrupted by an event like kexec.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/cxl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 81e2aef3627a..7deeb7ff7bdf 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -16,6 +16,7 @@
 
 static int interleave_arithmetic;
 static bool extended_linear_cache;
+static bool fail_autoassemble;
 
 #define FAKE_QTG_ID	42
 
@@ -819,6 +820,12 @@ static void mock_init_hdm_decoder(struct cxl_decoder *cxld)
 		return;
 	}
 
+	/* Simulate missing cxl_mem.4 configuration */
+	if (hb0 && pdev->id == 4 && cxld->id == 0 && fail_autoassemble) {
+		default_mock_decoder(cxld);
+		return;
+	}
+
 	base = window->base_hpa;
 	if (extended_linear_cache)
 		base += mock_auto_region_size;
@@ -1620,6 +1627,8 @@ module_param(interleave_arithmetic, int, 0444);
 MODULE_PARM_DESC(interleave_arithmetic, "Modulo:0, XOR:1");
 module_param(extended_linear_cache, bool, 0444);
 MODULE_PARM_DESC(extended_linear_cache, "Enable extended linear cache support");
+module_param(fail_autoassemble, bool, 0444);
+MODULE_PARM_DESC(fail_autoassemble, "Simulate missing member of an auto-region");
 module_init(cxl_test_init);
 module_exit(cxl_test_exit);
 MODULE_LICENSE("GPL v2");
-- 
2.53.0

