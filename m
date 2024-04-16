Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EFE13C3E8
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302593; cv=none; b=tstkFVp+232+jZXeESxHnvsZlfeHCHLV18TkZHnIrSMUGSQRmX3LC2u0olMPRevy9O+E7qbA7MJLaQTYYM+q4qfiHniTqcLFPDBjOWR80zDxVRUaUNBvL3CTUy3WzEGfCS/29imRpVv9vTQ1W5GNm/wIGnAA/+jvj2PdpRqgkPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302593; c=relaxed/simple;
	bh=lQ5OIiTxH3d7/GtHAwbCbRqsjUip1dqXcePJ5Z/9Mo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laKaHGrWPxCzQA2VEYdgn9XH/+6JQhJlxEywg9iVXR6I9sZm7KqcalzHA4zGPOL+WkEsQHcITYqne6ZoZ51gYuzAbIJL/0n/DRx4ISci477LULD92d1eEoKVQYb/ItCiZ4OlnBaovIZ6hlRe70v+4kwYa8nm9gaikdybWoc+SZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BfmIaRMu; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BfmIaRMu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302593; x=1744838593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lQ5OIiTxH3d7/GtHAwbCbRqsjUip1dqXcePJ5Z/9Mo8=;
  b=BfmIaRMudG3qE5FZq3iu0n5tWp0f0uzOIRIMxW+LWAZhQVlWOUeCGyaB
   OOxHMEzyUZV+ClfTYMOBN1tMthi9jRen8THtV7BzergNdh9cdKQTfCaw3
   RTxt6cl65Wx/DxXwut4acgzDfNSJG5g+WBJRYIMy4oVVNQXl4ZVjLXurm
   AfUg0s71D6FGa9TzfT8w3ceGnWUmtFpi355eBRYX3VcJaV+R0k8i9UXkR
   dSbypt083Je16wJH4Aud9rtHPr8eoEgICwQMcW7KAgRIylQTAhYqTo+6c
   q+Bcpzn1lHaZxifGaeGRz/j9Yy38SynHYt72uZyDJvetbwhjbgizW39FP
   A==;
X-CSE-ConnectionGUID: T4xr+88/Rl2zw1+/Hgsi9w==
X-CSE-MsgGUID: o1YWy6XKTae5/kvD9XF/GQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="31254767"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="31254767"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:23:12 -0700
X-CSE-ConnectionGUID: zRuizkB5TkyetIbfBPokmw==
X-CSE-MsgGUID: 8WXKnsQbQuqAuGLLrtIkmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="45678000"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:23:04 -0700
From: Tony Luck <tony.luck@intel.com>
To: Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Tony Luck <tony.luck@intel.com>,
	alsa-devel@alsa-project.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 71/74] x86/cpu/vfm: Update sound/soc/intel/avs/boards/es8336.c
Date: Tue, 16 Apr 2024 14:22:57 -0700
Message-ID: <20240416212257.10009-1-tony.luck@intel.com>
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
 sound/soc/intel/avs/boards/es8336.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/boards/es8336.c b/sound/soc/intel/avs/boards/es8336.c
index 5c90a6007577..6c86c581877e 100644
--- a/sound/soc/intel/avs/boards/es8336.c
+++ b/sound/soc/intel/avs/boards/es8336.c
@@ -18,6 +18,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-acpi.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include "../utils.h"
 
@@ -153,9 +154,9 @@ static int avs_es8336_hw_params(struct snd_pcm_substream *substream,
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
2.44.0

