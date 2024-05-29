Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07B41C0DFB
	for <patches@lists.linux.dev>; Wed, 29 May 2024 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717010100; cv=none; b=iXPSlsh4lhDLsXGXyRgx9L2ut+HOGyltOc2KJLFNjBpKjbquJ3y+OEPcmQJsQKMwCzS/7V79JwyY2xufYa/xFuu1gYSn15SKTJ48yfeAkV9me0/mkRLHzD6AoYYNbDKH/MWEEy4RaeP73hZZcDtDWgviAzP5sgTNkdVdWrSUNA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717010100; c=relaxed/simple;
	bh=2WGXBVBs50TNH9MqDPwVlbQd0d4cA9xeNLapku5f+C0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ap9YrSQFtQEw3vjP9O/UAxadptQmCrKgrIK9aDXpKPQOvE8zi9eORlma0kV9Z7TpQ74lpUDbpgHXfrNdRnA/jb98ffah4CixMVRQpsm9xTXgf48VVLbCHqoBBpyLRhcoE9Ci2pHnX/NMHC5yVsLPpWuwV15IleVcLv5MLGwEJgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O+rBExm7; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O+rBExm7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717010099; x=1748546099;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2WGXBVBs50TNH9MqDPwVlbQd0d4cA9xeNLapku5f+C0=;
  b=O+rBExm76XbfZ1yzdp/rS4+DPJXckBoL8e0NadWGgErc1VRUl3kGy8z5
   WgPtxBZwj+pULWU5KQmOVDjBB5oTRXejXXTPoIlwPamh/9N7wguqEOSak
   HO8R7Y624fQXQ5QbQSKaaI4b+wu4/JCp/KTxCCXqunZ91zRXOxz1h3vME
   yOrWMl5QqFQjR+w2HCWbya9CD0WFg04hao25d1J8CRaSxXmi661sxAu3T
   C2C+/0tZFhf0sciS1mWSx3DzS0zHoE5GKZ9EmKZNgvDivFKBjVU6LI+Vw
   x8h5wsOtPXYKGu0vCQX+pxY3C9k080085tAcoEcxf4Ajm19efTtNntnvP
   A==;
X-CSE-ConnectionGUID: tt2rGFGhSq+ypi7fz7JRsw==
X-CSE-MsgGUID: ENdEhixARVCib/4SUexhkA==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="13212835"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="13212835"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 12:14:58 -0700
X-CSE-ConnectionGUID: 5QmcUxzmRzeRqcynh9Mk7A==
X-CSE-MsgGUID: IvecUSxRQ6eNjXYrbi8Qww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="36163263"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 12:14:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
Subject: [PATCH v6 06/49] ASoC: Intel: avs: es8336: Switch to new Intel CPU model defines
Date: Wed, 29 May 2024 12:14:50 -0700
Message-ID: <20240529191450.63414-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/intel/avs/boards/es8336.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/intel/avs/boards/es8336.c b/sound/soc/intel/avs/boards/es8336.c
index 3bf37a8fd6e6..c8522e2430f8 100644
--- a/sound/soc/intel/avs/boards/es8336.c
+++ b/sound/soc/intel/avs/boards/es8336.c
@@ -18,7 +18,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-acpi.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include "../utils.h"
 
 #define ES8336_CODEC_DAI	"ES8316 HiFi"
@@ -153,9 +153,9 @@ static int avs_es8336_hw_params(struct snd_pcm_substream *substream,
 	int clk_freq;
 	int ret;
 
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_KABYLAKE_L:
-	case INTEL_FAM6_KABYLAKE:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_KABYLAKE_L:
+	case INTEL_KABYLAKE:
 		clk_freq = 24000000;
 		break;
 	default:
-- 
2.45.0

