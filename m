Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27CB502BC
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245208; cv=none; b=boBE+Dsi9QoYeofll6BqTkgXSBSAbSKW2R//YoGA/LfVSMh6xltT0xJw7EQVdY1MJVitMSnNJpmJhXVITXRI5kun3XLe38iii79+Cv85xzG/XiNRXK+p0xMKfxtUJe/ZRckY+3J830FlE3NUvS1pO4wGYlV3hwexne8IK+q+b3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245208; c=relaxed/simple;
	bh=rwri8jBEq7rYQ3kqqSBg1ylAIT9NhdjG7ASmrOmfXDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKH8w1fM11pToS2sXkauVKL3MgHFbczgEDrgebX2KzuqXb9VilaAl/WrNu7fvRTH915YsME3QqMXyIUpIPk6oqWMu/f8LD5/4RIYYLA3NLzRc5jItHOQwDzJc+ueyBMHyXjR2zxHkpCqtzTBlGnVH4qi3pws8znb6bKm09ZHe2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BZQaKc/M; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BZQaKc/M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245207; x=1747781207;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rwri8jBEq7rYQ3kqqSBg1ylAIT9NhdjG7ASmrOmfXDA=;
  b=BZQaKc/MeJM5P1vvNRIwdsvZ8Aj0k1RmR/fTvgVXv33qtdpUBtjkf4qe
   1O6BnFEIBqEl2COQdyoXD6Edy8wdgBNDTt53K6QHH168NrYgux6IUvWTh
   H/rYKyE3aPBXj7rzhdJpJfaYjj5jeNIPuOGOGEeyu7mUXqvh7rRt714Cf
   hqnwFVhxf2Lt9B7Od8zjo5ZIRO3UeS1EgUi+w/aT2SOzHiP93cC+UX8JX
   +DIdvR8d1L1EJ+2atcKbLY61GO+D1voTQ+wTdYutLjiZS2izPBawwfd+P
   +7fWPI5jm3ZechKG7lyW7h5cvTBQ6/1nloaDIu8ni5qTJN2ngjxX97NkX
   Q==;
X-CSE-ConnectionGUID: CmSlLdSXTwGT0Ho/K6HT9A==
X-CSE-MsgGUID: g1tm6EqVRmK1yukvt3suqQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199769"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199769"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
X-CSE-ConnectionGUID: FztG9Ou+RESzMOqFyPwPAw==
X-CSE-MsgGUID: Rnxll98ZSOSjAegawaf+GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593454"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 24/49] platform/x86/intel: pmc: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:55 -0700
Message-ID: <20240520224620.9480-25-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/pmc/pltdrv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/pltdrv.c b/drivers/platform/x86/intel/pmc/pltdrv.c
index ddfba38c2104..22cfcd431987 100644
--- a/drivers/platform/x86/intel/pmc/pltdrv.c
+++ b/drivers/platform/x86/intel/pmc/pltdrv.c
@@ -35,14 +35,14 @@ static struct platform_device *pmc_core_device;
  * other list may grow, but this list should not.
  */
 static const struct x86_cpu_id intel_pmc_core_platform_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(CANNONLAKE_L,	&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&pmc_core_device),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_CANNONLAKE_L,	&pmc_core_device),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_COMETLAKE,		&pmc_core_device),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L,	&pmc_core_device),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pmc_core_platform_ids);
-- 
2.45.0

