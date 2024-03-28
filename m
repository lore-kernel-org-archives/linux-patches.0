Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9101311A0
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643321; cv=none; b=QHapUjg1exj5NEvRgIZojHk8rU+Z3hl3pvO6Nhi0YlC7YylW+oxhj/YRHG5531mDrBzeID3euAHjgfuAjPo4elkBYufq9yPFD3iZNQtbo4GAFmEKTMhNHkHl2AqTWmTe19sX3JcmSldQwpsYJu7AEfUCQykiJ2jt5KPi7Sd+L80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643321; c=relaxed/simple;
	bh=OmgVdgASIzaKZCFFLOjUgf42irX5o1yF83cGe8kunng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9ySrYowL146GuLLYpvuox7Z5Scf2v9PoKa0drz1ADe/rqxvNhN/2CdiPebQ/qIxB8bzgNda9dUV1tp6zUXvCKfPXN5EVF34jeZIHjHhWRFhApwqcCpU3cyp+f8J7ftoar5zmrx5Ipsmyaj/R2AAP/+Ifi3baPAP0HtL72HlYKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=et7Ta5S0; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="et7Ta5S0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643318; x=1743179318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OmgVdgASIzaKZCFFLOjUgf42irX5o1yF83cGe8kunng=;
  b=et7Ta5S067IXxdnzA4hmDoF2KwBp5vz9t0pUGgxZBiqbEl0CQ6V0cVPR
   aISYMnl/tit7oiFCc9wDsaxwk9+WkQ0mVqYdc6JeNvAItpUDm7mEAjj4U
   +7ON9KdfrQWAoQ5HcTuj2zwgL9mPKJpbTLMIo8wG2RP3n7VG8veiFIU7t
   ezMi+mXR1wxH1/PLhEyhO5g43zevOMRFwpfivRGdxWdeslHTHfcTSxXvg
   +MFL+pjegdAlOyEG4x3PhjthD3gR+zNgazvEEGsiMEUAKPh2uXaIJAVyh
   hDqs7wn/kr6uncX/SM4d8YDO20xVbuqeEPWNNRzEnzbrqk6zG461ndJ14
   w==;
X-CSE-ConnectionGUID: kMn3y+MCT763CyrXZeVEaQ==
X-CSE-MsgGUID: W6H7pPNnQnyXRrG0EM5zZw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294798"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294798"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726170"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 66/74] x86/cpu/vfm: Update sound/soc/intel/avs/boards/es8336.c
Date: Thu, 28 Mar 2024 09:28:00 -0700
Message-ID: <20240328162820.242778-66-tony.luck@intel.com>
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
 sound/soc/intel/avs/boards/es8336.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/boards/es8336.c b/sound/soc/intel/avs/boards/es8336.c
index 1090082e7d5b..0f5179f75c01 100644
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

