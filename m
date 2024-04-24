Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A8A1C9EC1
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982544; cv=none; b=baQzuQaTj90oP0ZHDZYf5afStAfID/oYFT5hPyHhI3eG6AgsC3GmU9IqSZdGOK5jSSj+tVINL3TkgiJvU1zDb0UQgAIYDL+hpOF+ZyqzuvVK9+x0t+yYCDpuuGasJ5MV6duwB9Rx6kfXIvP4dV3LonuVeuvj2SdpIq6Yo2bTX34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982544; c=relaxed/simple;
	bh=lGxY6/fpKVjagJiMiQslsjgDFgL5ZPdXodSr7eR0UbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I49b90IYhLTYvAD3lmmXsV49DveRmF/RFzJvf3c5mrEH00sAX/24iYRy8PaCVwgpO3Ofe/bkJ3TLP+TjKTBE63gkqt0VkRBCAYDEhGHIEPUAgqxinKFa94uVq9fbS1vPSGh2TTZBaPUbriBlQhDz6tSgPJ11Zh1a8Ncc8UBQSrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e8LnyUJO; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e8LnyUJO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982543; x=1745518543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lGxY6/fpKVjagJiMiQslsjgDFgL5ZPdXodSr7eR0UbE=;
  b=e8LnyUJOEhhs7Iuow34O40EgnBvNbvdePbMtPl2b7qOCsFP7LCFOOche
   52VVr7GqQEPZB3WouC61jKZHVTEpY601buw4Pg5QNXvioE7WMKQe7N7Q5
   reVcuaPU2pRpGeXtfFl5z04fq9gDYFfu6k9j11RtVM4jPqxSCEUvrKKxc
   UICiqLzcZ1h5QlI3Us6k8p3THvIyXomL1vgFOUSl+r3/Is8p+8bjpLl2l
   Y7kjAz39jT6+mdj8m0SgsqAV+qd7W/c0KNmonhb3vHJ5Iq4jkUErnYukl
   F25MkB7THKxO8T6KatdRhS3ExZpOcgnECOL5VlNLt0674JGzrJq1oRN4t
   A==;
X-CSE-ConnectionGUID: hcA+QxaDTeWdyV0QQQw9pw==
X-CSE-MsgGUID: mG6S5R0DRI6i71B3s9eIOg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503709"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503709"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:42 -0700
X-CSE-ConnectionGUID: Cad7/xTSRxy05dj+edwlJg==
X-CSE-MsgGUID: MPlg/ATjQAixgaR1TFMaIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="55750330"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:42 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 63/71] platform/x86: intel: telemetry: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:41 -0700
Message-ID: <20240424181541.42368-1-tony.luck@intel.com>
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
 drivers/platform/x86/intel/telemetry/pltdrv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/telemetry/pltdrv.c b/drivers/platform/x86/intel/telemetry/pltdrv.c
index 06311d0e9451..767a0bc6c7ad 100644
--- a/drivers/platform/x86/intel/telemetry/pltdrv.c
+++ b/drivers/platform/x86/intel/telemetry/pltdrv.c
@@ -177,8 +177,8 @@ static struct telemetry_plt_config telem_glk_config = {
 };
 
 static const struct x86_cpu_id telemetry_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&telem_apl_config),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&telem_glk_config),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&telem_apl_config),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&telem_glk_config),
 	{}
 };
 
-- 
2.44.0

