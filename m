Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130C340858
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718126106; cv=none; b=rO0INVHweYQySMIVv/2/mqfHnJnTE4HXq1+enmzuJQXBzSx9Z5Wi2fz3VfcuI78R5fC/Hrcp+KJaquQMmY2f73Tsp2kvyg6r6jzm/ycpEBttfDf1bL6sJH7TSQAmF6FI0nZHxFmpCLqtAuFG9LFgSVouSlx3IvHZKVolDvKso14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718126106; c=relaxed/simple;
	bh=K/I146tcC4iAQjRxNjYDWda/7DMkakFd+77UtYpoMoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VwL7qbf/WSYjjmEZrq7XV+zPlP/0T+3LI95MWz9MNLYmovdNmiOk4GnWrhyy94DblSBWBIQKeArl5Vk+vVLrldIkFqx/QM190QT1g0NBqBo7MG+BmB4dPmlsaqyc+CjLPIip1osHfhvdquViXncdI9UQtGuD0v3BgBN2Ftl3kFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PBkmswCM; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PBkmswCM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718126104; x=1749662104;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K/I146tcC4iAQjRxNjYDWda/7DMkakFd+77UtYpoMoM=;
  b=PBkmswCMKVLet+UsMG5nhfjUdIu8ftylF8Iv47TavVKxniBIch2atlQl
   nCq6euNLr3YvXPXr3/4YfEPY8ww1/C45LCyYy12jQTmvZIjrze3d52LTG
   oQdhcqO8Z8jhZYjcpub4AZ8F9zRlU89qom9CCt0be+wmSf9+91kxQXNKU
   aslJ3H4DraggixdwEGzbemXJZN6RXyCZzBdt4/qMap+EFL5rkUV9Kzsq6
   pkHjKq4GPEHINS035cSQMuAp1ch7AFk/1x+XfsKmnTXWiPy4sifBF511x
   c9AX9vvGP12v3pN1Zzm/AxLztxClvXkY4kQFOwvK+u8XVv/6lYsbjNMOf
   A==;
X-CSE-ConnectionGUID: uj/qqF4GTfehYxFjMTYxoQ==
X-CSE-MsgGUID: Iu0BsD+TQg2mm7ipru1y5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="37376398"
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="37376398"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 10:15:04 -0700
X-CSE-ConnectionGUID: QylkOKhcRJSU9a0Cu6uFrQ==
X-CSE-MsgGUID: NtG3lkUVQJuZyCGeKFw/rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="44055568"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 10:15:03 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH v6 04/49 RESEND] platform/x86/intel/ifs: Switch to new Intel CPU model defines
Date: Tue, 11 Jun 2024 10:14:55 -0700
Message-ID: <20240611171455.352536-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---

Ilpo: I missed this one from the set of new CPU family patches
that I sent to you earlier.  Can you apply it please.

 drivers/platform/x86/intel/ifs/core.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 7b11198d85a1..33412a584836 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -11,16 +11,15 @@
 
 #include "ifs.h"
 
-#define X86_MATCH(model, array_gen)				\
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,	\
-		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, array_gen)
+#define X86_MATCH(vfm, array_gen)				\
+	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_CORE_CAPABILITIES, array_gen)
 
 static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
-	X86_MATCH(SAPPHIRERAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(EMERALDRAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(GRANITERAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(GRANITERAPIDS_D, ARRAY_GEN0),
-	X86_MATCH(ATOM_CRESTMONT_X, ARRAY_GEN1),
+	X86_MATCH(INTEL_SAPPHIRERAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_EMERALDRAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_GRANITERAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_GRANITERAPIDS_D, ARRAY_GEN0),
+	X86_MATCH(INTEL_ATOM_CRESTMONT_X, ARRAY_GEN1),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
-- 
2.45.0

