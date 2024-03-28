Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D51127B67
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643321; cv=none; b=rTxiLq72xwsD3CV/qPv9rV9r2eHgHxDbFZe6bkoSJn5ngiC/9I5+j1+q3+wujUm8DlucY4yt9o/H0spNWMSG8mbIxzuMqnwtPcbh6EIBIxShxjaW/TRfn9i9ZNtaerjMlCdkH1P2coqimpYYQhK514IXw0BauqEp5rtHCMEHoeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643321; c=relaxed/simple;
	bh=9BhqAi51AVfIYErDEjqL8B6KCNTQRdQRVBtL2GkhI2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmdPidJ8sA0wqCi+qOdmfnQWc7pXewTQDrcRi6/2RGpP53SxHgXWrPQFldCx9pKwFqSzIT4hk5yXVK4d8UBunKLRqG9MIlc5jGVRlozCidOJyWdbfiYdlrrl5veRs9/YIEXZ0JwHBPVXMPAa9T17M47F1Kj8Y4f8a67fMdvgVcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dmbBEMF6; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dmbBEMF6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643317; x=1743179317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9BhqAi51AVfIYErDEjqL8B6KCNTQRdQRVBtL2GkhI2U=;
  b=dmbBEMF6avmwKFG6jz9ofPIMqLoxAUrerxsJ6vXfkgb8ckj7CTj/YqNB
   jIyoqulaGgJEatt/LJktV7GkhmKfJ7FKm9D7ymNJ5hEY0sd+zZAbZDBIC
   qUxfEYnvUaBtSHhQuPGeUPd9YggQGtnb7VVNdMYtHF/Uqubkmlf3lKPuf
   ODk75atpyMeAtpOP7YmHAdNmb8L5t/Qjedsl2C5ZTknhZ9NFSNiTSR2cG
   0CfIrtAX0VNa22tQNaG2M6JSPG0ddiolvXrrEZZ2nViv0+SJDDh5IClIS
   wa4VSsDijR+HnjkdXDR0esLei1t4Xb2Sp5KrQV0/puPuiFA93jwjnUnzA
   A==;
X-CSE-ConnectionGUID: qrsf8PdTT8alTJHgnviLjw==
X-CSE-MsgGUID: 9PjVAM3bQUmpbe3DiKxsLQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294793"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294793"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726155"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 62/74] x86/cpu/vfm: Update drivers/powercap/intel_rapl_msr.c
Date: Thu, 28 Mar 2024 09:27:56 -0700
Message-ID: <20240328162820.242778-62-tony.luck@intel.com>
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
 drivers/powercap/intel_rapl_msr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index 35cb152fa9aa..733a36f67fbc 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -139,14 +139,14 @@ static int rapl_msr_write_raw(int cpu, struct reg_action *ra)
 
 /* List of verified CPUs. */
 static const struct x86_cpu_id pl4_support_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ALDERLAKE, NULL),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P, NULL),
+	X86_MATCH_VFM(INTEL_METEORLAKE, NULL),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L, NULL),
 	{}
 };
 
-- 
2.44.0

