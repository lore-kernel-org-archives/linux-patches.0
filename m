Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847E213C3D4
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302575; cv=none; b=uhUm21wIvi3ZuzpLknepSAkGVt43WisADwOjE4AC2wFQdn4XhS9F4LuwRorYPGklAUbkhiZa89+aIwNnex32NNl8BqRwlYENdloxDDFRU5GbcMewm0VByHGfn62qKdslb+KFduJQgU9NfOQ4qXWb51/ceIoaRbQBo8JHHYB0COU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302575; c=relaxed/simple;
	bh=Sq4ynF39XabE7EmzBSCEbGuiDJj2SkiQjkD2A7qQhtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+msuLdUzLJsW4NRaQFuG51Do6YmmqQlqVAzhpAkSv2Udfq70aT9993AZ6MMnt1LVbsWtN+1J0Yi+n8s0SKer8T2xHwb51tOnXBKatacRFSPuTGkXqPfrzaRwvfVH+JFQvLvecx3xUfmPXkaiLNMpzzabFhQW7H9QshI3pkhHL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GLMQ+nD6; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GLMQ+nD6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302575; x=1744838575;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sq4ynF39XabE7EmzBSCEbGuiDJj2SkiQjkD2A7qQhtc=;
  b=GLMQ+nD6YO2vf7OlB76OpdDL4xFLuIKvjZrAWlLSo4O5fLIKPe7ebuwM
   F7EAaLJ5dsm24WWXY4pZ6W54MkNq3iwcAJbjXBbS4MjynycLsgJPrd77L
   sCWVbfW1BDlPblhllRQbIw++zR+Kn3smkWkYAJqgtKv8LD/mvwXz+HtPH
   3mt3knL4pqHizdDJoJ7vx62nyE346MfhpfFf6O27s71HR+qUfnsKIlVff
   GfoESEbbvXHwUDiN6YvB0tbrNstmX2F7RByVMnzMmI8l+WfwWrkOSX3ag
   K/Ixqf3fL6qN+A5zjEC4pVt/dYjW6QrIZxcE/Nc37KCu6DtmKda5EJrwm
   A==;
X-CSE-ConnectionGUID: Zn5dGDFIQXaoKROAHgoJAw==
X-CSE-MsgGUID: qVxZ7IQ0RwOm21OZcZedkg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="31254734"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="31254734"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:55 -0700
X-CSE-ConnectionGUID: 1h7TqpNrSdKZVpFS5/VKrA==
X-CSE-MsgGUID: gZQ/2VAoQWe0i5F8pe5KBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="45677895"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:54 -0700
From: Tony Luck <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tony Luck <tony.luck@intel.com>,
	linux-pm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 70/74] x86/cpu/vfm: Update drivers/thermal/intel/intel_tcc_cooling.c
Date: Tue, 16 Apr 2024 14:22:53 -0700
Message-ID: <20240416212253.9989-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416211941.9369-1-tony.luck@intel.com>
References: <20240416211941.9369-1-tony.luck@intel.com>
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

