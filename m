Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB111C0DE0
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495906; cv=none; b=Y5lVHl6NiM27AHNnxsoqUtrbu32bio3FozhDomOxI9PG4B7cwddsM4G5Eb2NYsxw01exfMQu/gBYKkuYz+to7v4mFNDzjR1y7ubREoexAGTPUYHru2Jb3gD+xPoZZu6P3NjKzIgdX13p4AaLtlzyk4gOcXCWEI/OQ3klkhlEL2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495906; c=relaxed/simple;
	bh=eB9PfcugR7Y4foLLI2s5L7tsFJT7F2JDjIJfJLy0Dqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUpLwBRwNmy4omUu68q5+MttS1xrNQAaWybO/7aJrc2bZ5nEkw1T4KyBSO4UhHhp5GEXpzujC95P73/ctpoC//kuS9uZXW+LqA2SaOpeU/iTL3ONq6ogwGnu85YmWsbVCAEne0RZSzkUWteAZKAP+ehVU+zzV+uq3IkCFr0ydzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XsfVvih/; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XsfVvih/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495905; x=1746031905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eB9PfcugR7Y4foLLI2s5L7tsFJT7F2JDjIJfJLy0Dqo=;
  b=XsfVvih/ioJk+bkH6QutPbKKpKmlmZl2GB/Hs7dkvtxdNqigGyU5hJWL
   mxTIYQZC6c2Oq6qCZTrcRWjfsudMxr0GFaQIS++KvGpxq9718QI+7FgL3
   ER+9EyKqeh11QgV3N9h+fnHcl/81BgVcCCYHdhFnumdhnRMzIBsT5op5v
   xtmpurdc+TYPxMRGbNiU4vMlE5QzP5cuWPC31PafT2102+mBgC6hqshda
   y7s3V7BzjnJ3/arCf9wwvKjdypNp3YJywU6rhbPfs4JGSbonuMj2vLzAW
   o+p0YtO8ldxY0LtVR3e7SIX1huFeyrOk0fcC1rXjvIHtOBl1CA0SIICly
   Q==;
X-CSE-ConnectionGUID: 1DRaQLKCRDqbNa+Mfb/ndA==
X-CSE-MsgGUID: 6OC0ZETvRiKFrfrHLOF+/A==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075668"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075668"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: 5fKwosolTLaFAsj/d0r4MA==
X-CSE-MsgGUID: QnvLzvnhQzekkftFO+N/ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515415"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v5 05/47] platform/x86: intel_scu_wdt: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:18 -0700
Message-ID: <20240430165100.73491-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel_scu_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_wdt.c b/drivers/platform/x86/intel_scu_wdt.c
index a5031a25632e..d0b6637861d3 100644
--- a/drivers/platform/x86/intel_scu_wdt.c
+++ b/drivers/platform/x86/intel_scu_wdt.c
@@ -50,7 +50,7 @@ static struct intel_mid_wdt_pdata tangier_pdata = {
 };
 
 static const struct x86_cpu_id intel_mid_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, &tangier_pdata),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, &tangier_pdata),
 	{}
 };
 
-- 
2.44.0

