Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779C4361967
	for <patches@lists.linux.dev>; Fri, 28 Aug 2026 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787931022; cv=none; b=TSQI/JGWim10WvPbLUu6NY+c0+zJ6g4xu7N5/RwP+QdP5oceOVyxraFlYdQ16SRWZk67tdcvpXlqaaShMpocY7BH+jjgHFVin9t+x+eusavp8cL+mKrhFxDcOJyCgWtOOyzRmchaDW75D2P9Lmyr0/W0ZyGffB7eqeb7GNYQmmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787931022; c=relaxed/simple;
	bh=rE2WTk3WpUZaBZoXXGYa7EFPCgwt3qyRp5FAeJqsQyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unMbrKRaHlVNilbfeFgzlXKtIRFgkpmDwHrrhDJAkefjVPtWe87DLPtJg5pMyK/oFTo6RgpVP0bzqiGVyXREWtkUqQ0dd1gfq3deDZwIxN12mf49fn4SVRYTSezTQHEimACPcuckgjyhlDCD9BMdlf4YwaK5OXQXNguihEZH+iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g7EjUWvC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g7EjUWvC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787931016; x=1819467016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rE2WTk3WpUZaBZoXXGYa7EFPCgwt3qyRp5FAeJqsQyA=;
  b=g7EjUWvCaddZ8tDYFjx83EFKmjlx4xYZvpxpLIiO1j80WkE9fx8jAIZq
   pJaDQREQIFwbazpShW4v7RUwWvvjr+tpBHFnZxsc6Wnv8k3tNkCoEd5ed
   C84A41AvbznPauCiqLnj5i3vpT+LqqBjGSHTL/G0rjkZQIQ8v4cQBy6Ye
   h32QtEqpfEhGTkUkxIUGmaU6S3TNirlSWZiAGl0oG28kilS4JTHcrIlRg
   3Q0wRkZJwVaWcB3aYEOlOCk111kYsEpLpl05IH12asqZEnNPrZa52CjEq
   E3Wlx7ZskhOAkUERKMDmKu9t+rFIFkjaaCxZbNnmFPBVMnxv30JymuzBQ
   w==;
X-CSE-ConnectionGUID: JIga9foGSUWcoPve5HkTBw==
X-CSE-MsgGUID: cP1Gj906QCGGyjVAez7QtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="99104587"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99104587"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:09 -0700
X-CSE-ConnectionGUID: P0i8nchNRgeXImeNtxYYKA==
X-CSE-MsgGUID: OYXlBstrTHeY0IuAffERkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="291682275"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.223.138])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 08:30:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Breno Leitao <leitao@debian.org>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 2/7] x86/mce: Add enumeration for Intel bitfix filter reset
Date: Fri, 28 Aug 2026 08:29:57 -0700
Message-ID: <20260828153002.10290-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260828153002.10290-1-tony.luck@intel.com>
References: <20260828153002.10290-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IA32_CORE_CAPABILITIES enumerates the bitfix filter reset feature.

Intel specifies two values for the threshold status field in the
IA32_MCi_STATUS MSR:
	1 = GREEN (threshold has not been reached)
	2 = YELLOW (threshold exceeded, try bitfix filter reset)

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/mce.h       | 5 +++++
 arch/x86/include/asm/msr-index.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index e575b702063d..9995176d6879 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -13,6 +13,7 @@
 #define MCG_CTL_P		BIT_ULL(8)   /* MCG_CTL register available */
 #define MCG_EXT_P		BIT_ULL(9)   /* Extended registers available */
 #define MCG_CMCI_P		BIT_ULL(10)  /* CMCI supported */
+#define MCG_TES_P		BIT_ULL(11)  /* Threshold-based error status supported */
 #define MCG_SEAM_NR		BIT_ULL(12)  /* MCG_STATUS_SEAM_NR supported */
 #define MCG_EXT_CNT_MASK	0xff0000     /* Number of Extended registers */
 #define MCG_EXT_CNT_SHIFT	16
@@ -41,6 +42,10 @@
 #define MCI_STATUS_PCC		BIT_ULL(57)  /* processor context corrupt */
 #define MCI_STATUS_S		BIT_ULL(56)  /* Signaled machine check */
 #define MCI_STATUS_AR		BIT_ULL(55)  /* Action required */
+#define MCI_STATUS_TES_MASK	GENMASK_ULL(54, 53)
+#define MCI_STATUS_TES(s)	FIELD_GET(MCI_STATUS_TES_MASK, s)
+#define  MCI_STATUS_TES_GREEN	1	     /* Threshold-based errors below threshold */
+#define  MCI_STATUS_TES_YELLOW	2	     /* Threshold-based errors above threshold */
 #define MCI_STATUS_CEC_SHIFT	38           /* Corrected Error Count */
 #define MCI_STATUS_CEC_MASK	GENMASK_ULL(52,38)
 #define MCI_STATUS_CEC(c)	(((c) & MCI_STATUS_CEC_MASK) >> MCI_STATUS_CEC_SHIFT)
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 18c4be75e927..cea60d3ccb2b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -114,6 +114,8 @@
 #define MSR_IA32_CORE_CAPS_INTEGRITY_CAPS	  BIT(MSR_IA32_CORE_CAPS_INTEGRITY_CAPS_BIT)
 #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT  5
 #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT	  BIT(MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT)
+#define MSR_IA32_CORE_CAPS_BFF_RESET_BIT	  9
+#define MSR_IA32_CORE_CAPS_BFF_RESET		  BIT(MSR_IA32_CORE_CAPS_BFF_RESET_BIT)
 
 #define MSR_PKG_CST_CONFIG_CONTROL	0x000000e2
 #define NHM_C3_AUTO_DEMOTE		(1UL << 25)
-- 
2.55.0

