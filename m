Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4A71386D5
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245201; cv=none; b=ZCXiz7rx616e4pKIANWBzlTDNrKl7OK8vLcrawaJEn/nPz7wEZL+nvYi60cCKtPi6/Wg59jz7iyHiFmO8guzV0tv0RjDEaV3lc7HipIvgEDtSFaSPQQpPgrZi/4HJ7FhK07B8/ep40xdMelKABL00vjymo8nqlqvYiSDq7/BejI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245201; c=relaxed/simple;
	bh=2WGXBVBs50TNH9MqDPwVlbQd0d4cA9xeNLapku5f+C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvG4Z4x5tCwzGxeEjtcqFj8o8JjtCUSsV1oZkPxeFOuCZJ/K5X8uPskTtKLYzWTYzX800QlMkvprB7UHxq1x6PKsh88wuD5iD9aB6xOt2YhUaM8NwcmecV+Su5pCbPKhnKE25KtF2brYvvScMIqtGW1o/o6e/fROFjjXscCS9fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OX1BLiem; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OX1BLiem"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245200; x=1747781200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2WGXBVBs50TNH9MqDPwVlbQd0d4cA9xeNLapku5f+C0=;
  b=OX1BLiemrJfQGdde3/y+mdsJ/j8qjfplMV1nM8SjDIhz+tLTx311YJg6
   RufSTHzCMTQ66wmcWL5mX6XNzaf4G0JhVN4vgbEz1fjkMtIVImBUj0YZn
   9/yyN+JsGeudarSu+Q3HWMKQaBUR1NvkJfvr9fPzwE7TrIRsX0Teu5Ugz
   6ze98Cien6W+l0zW9UgE6vK6634sA/hYOvVxwFGXTkNCUXuIN8NXQjXNb
   RPzNuvEw1q233Y8cRrQXC1zFtd5Qbevy5sOIPz0BL+VQireC+2B7avn/W
   wi28f3hHnx60+rkoGAT/rnUVgnwpzlfOlV1gT4OUnO0jp5Cl2+d3FENSu
   g==;
X-CSE-ConnectionGUID: kKrenUbnRgC9PBtvJVdS3g==
X-CSE-MsgGUID: la3xCF9CQf2G91ecLMvltw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199566"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199566"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
X-CSE-ConnectionGUID: ABs4mHaJTre9oLsrmJG6mA==
X-CSE-MsgGUID: NqXET3QaRMmFL6XPYJa7/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593399"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
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
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v6 06/49] ASoC: Intel: avs: es8336: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:37 -0700
Message-ID: <20240520224620.9480-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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

