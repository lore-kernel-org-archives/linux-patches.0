Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDD816F26C
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982511; cv=none; b=athOz5aLk8H/tH+/LOIIqayD4mSFl+j41OaD5JE8TeJGnfc1H+ffmnhJF3MO0hSKjyv3aDYQNeoGwWPkJi6uw6xryw/jxYuGo4QCf1PXudiTONd58kQ6OEvb0nVTxLz5WNOC1OYco54zSMTm40LrtQBXE+ZMp3uX2ym9B+/axgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982511; c=relaxed/simple;
	bh=sNx6nxhHZv+F6DxdU5u7m6Mfq8h17NXlRvSdlpt7fxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdC1zoVLAP0iEQVoqWcuyJxSunXCwKvndaro5LDpznAEEULgVodqI4IT2C8pu/hIb894RgJ9q8OD4Kzs/k4CzWrNr14G5i+FTssdARiug9qG1PrjAwLN1JyP7f52RAqa+WjbosuGAJV1ZRzAOtLMUgMBHlX2CymNkNdHSaldgKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EysbLfDe; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EysbLfDe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982509; x=1745518509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sNx6nxhHZv+F6DxdU5u7m6Mfq8h17NXlRvSdlpt7fxI=;
  b=EysbLfDe5/5QlBTOBRhtU1PxhyVMIkcjeJsWl3x18ajbo6w2MmI/vkjC
   SxUjYqtultvO6p3vLt7KTh7284rNxX2+H6bO7NZLX6qycPnWpJOQNs6N4
   CboNAp9k66vcmvfi/hIj36p9jEap2liDRPxoHGHAUG3O/1/TlGlBrfsz1
   puiptA449noSLvbN6BUz8uEuKWGEAAUwwAMwy197wwR8WS9F8VN3lOOhP
   1Kpx46kr/o484mCG8XmMBW6cijvN5+b3cECz99KwPhAK3vTZLyHI0G6xY
   IdgdzGBbhetcgS0svOc1vRAHLdN/5soEhmm3PngKIwHfr9TyVk6DeQvVh
   A==;
X-CSE-ConnectionGUID: b3Cai9XERTK3oXDZnYUczA==
X-CSE-MsgGUID: XBvFgLDOQ8+rDFJBxknipg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481816"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481816"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:57 -0700
X-CSE-ConnectionGUID: 0AbnEi7OQd+FrmJxDs8yYA==
X-CSE-MsgGUID: yAHssfhiSBq62zGao0DWng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262611"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Tony Luck <tony.luck@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-pm@vger.kernel.org,
	patches@lists.linux.dev,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v4 14/71] thermal: intel: intel_tcc_cooling: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:14:56 -0700
Message-ID: <20240424181456.41424-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/thermal/intel/intel_tcc_cooling.c | 30 +++++++++++------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/intel/intel_tcc_cooling.c b/drivers/thermal/intel/intel_tcc_cooling.c
index 6c392147e6d1..63696e7d7b3c 100644
--- a/drivers/thermal/intel/intel_tcc_cooling.c
+++ b/drivers/thermal/intel/intel_tcc_cooling.c
@@ -49,21 +49,21 @@ static const struct thermal_cooling_device_ops tcc_cooling_ops = {
 };
 
 static const struct x86_cpu_id tcc_ids[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S, NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE, NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_KABYLAKE, NULL),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_TIGERLAKE, NULL),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_COMETLAKE, NULL),
+	X86_MATCH_VFM(INTEL_ALDERLAKE, NULL),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S, NULL),
 	{}
 };
 
-- 
2.44.0

