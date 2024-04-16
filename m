Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B336D153822
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302554; cv=none; b=i2PqXGHFwC5H5k/DXVVNhrAyPPJotSOMQbB/Ocpj3u0U80W2VtkI+ASmNQi04VfchenUzbA0v/Jo+GUEC5LDxC4vufioMWGxWw84riDjr/KMSQvlt7CKrdwlkf4uUF4Al87hfP/QypamerHCApjKxqfzpS9tMefSpumop9OpkYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302554; c=relaxed/simple;
	bh=zq3PVQPAcMWcn9vz87aBSrEUPTNktf+avk5R+71nh50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHjZuflRb5APGqXipsjVWPZP/KbT4LK5y1gHRoXeiDvWqsRBLPlgOVbh3Amn5FLiYY2Pl+eMh9HYmG7yeIid9A+wKIKLOwG1Sh6p+r37zZChvFD2xe/+Xe1IlrSpOlDmFgxmeojymZ2981U9u+ed/UKfWnxNiBij1VwDtM4lzrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D5M6rXaz; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D5M6rXaz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302553; x=1744838553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zq3PVQPAcMWcn9vz87aBSrEUPTNktf+avk5R+71nh50=;
  b=D5M6rXazRQuL2ZCanHYD2ihWMrRcVGmyedpZ93lAhiYdupap8zPKMXLI
   0at58M/PQgG4r5nLuY4IuBGKNCY8YwjeTSj/f6ZA79gGT0+a7ALaTyPsl
   KiyYT0Y2XXHBYhccYUkPbiOS5VcJRghECGMTARfOunoRmAyguQi0c9ZLp
   isZpmMCIpgWagSs6j3yXOuQHgMXwsElr66+PMrWeflHgU7f4nuBNH/l0y
   +i3ODXzu9qQeLETgTyi7Tjx50myWcMP99enCV91hY8V25Dh6Hc2BtOHJG
   pdaLR2b9rGwn7L9wUmG940ogdEpc+MOTU6m2fRxUxwOWwoblLngCY8Zsd
   A==;
X-CSE-ConnectionGUID: I+rYcN2VT+a76tXj6L0o/Q==
X-CSE-MsgGUID: hycYh37mRKuCcNeGZretkA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="26234951"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="26234951"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:33 -0700
X-CSE-ConnectionGUID: ObrEmu6yRa6ASzq7uV/Y7w==
X-CSE-MsgGUID: WltPAPugTKuO/iHxvE2aLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22267143"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:32 -0700
From: Tony Luck <tony.luck@intel.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 59/74] x86/cpu/vfm: Update drivers/platform/x86/intel/speed_select_if/isst_if_common.c
Date: Tue, 16 Apr 2024 14:22:31 -0700
Message-ID: <20240416212231.9776-1-tony.luck@intel.com>
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
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 08df9494603c..96f3b221b6c8 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -719,8 +719,8 @@ static struct miscdevice isst_if_char_driver = {
 };
 
 static const struct x86_cpu_id hpm_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	NULL),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	NULL),
 	{}
 };
 
-- 
2.44.0

