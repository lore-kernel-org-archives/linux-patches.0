Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D911C0DC7
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982535; cv=none; b=AVMG3smr30gTfut6pJSM2o5SAcFp9+2iiHNLgiRbYUiZzdcOwjG+FnXlCCL5OZkDzKeTJlAlH1eRv5PgylKSqMLMDqL0C/XX1ef6FtV95RRSHgx0NWieKsXUeQ8HzHT5R8L6hhvQJ540V6LSrXYKc+sh4GCpfi0xj4sWB3v9nQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982535; c=relaxed/simple;
	bh=WV3qnx6+50b42Jf/GqLJUpAXvV6x1yHw3SQJ/gD5Xpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoocJeqbLTxEpljHCMu20IuuIeyig5kKMVmDwz/Gp5iDGrobPRSfg/XItD/W6FtRNRl7cgNHy6ZGnrOGr7jweNdkoE27PQjUcEo9fi3M+m183Tvrc2bOrUVlj+pgrYUdLYoLBR43dr+ZasZOy+uWQuRlS8bDTck2pgQerI2kY2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kt7GdRdH; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kt7GdRdH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982533; x=1745518533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WV3qnx6+50b42Jf/GqLJUpAXvV6x1yHw3SQJ/gD5Xpk=;
  b=kt7GdRdHsHOOY7qaOGElvz8VxILrmtVaQ3LyIP2S7g4n3jRdBqXeMCzF
   v2YMVE47jJnvifPZ+TsGxUlDzjOYJb4Rcxr5Oym4X7hdPu1UB+ZnxHebV
   pojadrOYncboP3eobTnXlU9hOQpaSXMklw5909gLmrcT4UEYvrE8f3WBn
   +M6WljBWllEydujHRGc4vQuLlLgqJNPHcKrodaTWKQ70lZ+qKDeYP1K8j
   FrAqyzMezNmbTvufMdDCZXDoxGcTIXc/foA8g3Yepfsa4lfR8XmSCi+0L
   CcrnH7gXyQ2LkXnmLUueDg8kgCgnBcmv7R4LyzYFeikkPs3mKwNRTCVao
   A==;
X-CSE-ConnectionGUID: 6o/K+ERISg+uaJ4yyPmO2w==
X-CSE-MsgGUID: uuIuKa7hTGu/yTLYdCSe8Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503635"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503635"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:32 -0700
X-CSE-ConnectionGUID: /kp9bVCaR8upNewIGuN+zQ==
X-CSE-MsgGUID: YH0aH2rbSli9v2tjJwTT8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="55750205"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:32 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>
Cc: James Morse <james.morse@arm.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Robert Richter <rric@kernel.org>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 52/71] EDAC/skx: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:31 -0700
Message-ID: <20240424181531.42159-1-tony.luck@intel.com>
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
---
 drivers/edac/skx_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 0a862336a7ce..af3fa807acdb 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -164,7 +164,7 @@ static struct res_config skx_cfg = {
 };
 
 static const struct x86_cpu_id skx_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(SKYLAKE_X, X86_STEPPINGS(0x0, 0xf), &skx_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_SKYLAKE_X, X86_STEPPINGS(0x0, 0xf), &skx_cfg),
 	{ }
 };
 MODULE_DEVICE_TABLE(x86cpu, skx_cpuids);
-- 
2.44.0

