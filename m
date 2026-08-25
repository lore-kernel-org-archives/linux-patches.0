Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14EC31E823
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681740; cv=none; b=KBJ8FY7+BAmpQkYCGbPcQJkosKodTRql/kbJ2cO36z57T9yntURH4OSLX8jHuKJ4mLaSY9ygDfIEoKGF4jZT8Pd9doIfnotcc7cxHANdm7E8Tea33y/i9hz8ibmacGEYl9OzCv/wWUUc88FYvbLp7vi95not88tS4e6G3igkXkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681740; c=relaxed/simple;
	bh=HpXSFglQBwpdFwyc3DEg6LqxExJmQQCYCkTKib1d9Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikUiY+qV597Ke+UZyQLIoIrnHeW7L2zUuzy1pbjBdN6NpvVLL2+QOqZCOGgGs4iqJJ0AgFzyj0grxNaV7H0z+RYeEWdvWeRpLJLwNBKFYVqMoX36CI6A10Sm2WgS/TlEZ4rJUZ9LcxUuSaAdHfJIAgRnyzIh/411mu8irBqvGYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uzf2SCon; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uzf2SCon"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787681736; x=1819217736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HpXSFglQBwpdFwyc3DEg6LqxExJmQQCYCkTKib1d9Aw=;
  b=Uzf2SConFzvh43StwN9t0q14ef0uj3Q0Em0a/VdpVQleq32F2kWUfFkp
   kWrhSVx9XcDUriaiEPYHMebn7Gh38JByk2LNwRAEc1aC6hu8hBaZ7jweZ
   2O8SNm3x8g9SYYUuqLOBLdM2UummKulemrI3PXu8pn+URzcs4cmNiEAvW
   /zBa0TnKOvGXnoITHRWzBpkHI8l0XRJNqpbF373xEGth6w3b+GD1Pchbk
   AGLzebmp4D99Lz1ElhsIh0w7qvf965FoOLX+BrEsWs0siFG47I06pPBpS
   5wZT2WLFuOBTXVIyzed14Ac78uIOKQ+tHDlM/5sxcyst8Mx8Y6bYZs7f6
   g==;
X-CSE-ConnectionGUID: 6ii7ebVTTUKY2uuQtzxOEA==
X-CSE-MsgGUID: DEax6ekDSqevqTjKvL2ddA==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88174205"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88174205"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:34 -0700
X-CSE-ConnectionGUID: j6tLA+LfSlyXS21Zo2B6PA==
X-CSE-MsgGUID: kOwfoDxQQS6AoEaIUWoJuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="265559598"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.141])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:33 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
	Breno Leitao <leitao@debian.org>,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 2/7] x86/mce: Enumeration updates for Intel bitfix filter reset
Date: Tue, 25 Aug 2026 11:15:21 -0700
Message-ID: <20260825181526.13203-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825181526.13203-1-tony.luck@intel.com>
References: <20260825181526.13203-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IA32_CORE_CAPABILITIES enumerates the bitfix filter reset feature.

Also add definitions for the threshold status field in the machine
check status registers.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/mce.h       | 6 ++++++
 arch/x86/include/asm/msr-index.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index e575b702063d..0d5bcb6f1750 100644
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
@@ -41,6 +42,11 @@
 #define MCI_STATUS_PCC		BIT_ULL(57)  /* processor context corrupt */
 #define MCI_STATUS_S		BIT_ULL(56)  /* Signaled machine check */
 #define MCI_STATUS_AR		BIT_ULL(55)  /* Action required */
+#define MCI_STATUS_TES_SHIFT	53           /* Threshold-based error status */
+#define MCI_STATUS_TES_MASK	GENMASK_ULL(54, 53)
+#define MCI_STATUS_TES(s)	(((s) & MCI_STATUS_TES_MASK) >> MCI_STATUS_TES_SHIFT)
+#define  MCI_STATUS_TES_GREEN	1	     /* Threshold-based errors below threshold */
+#define  MCI_STATUS_TES_YELLOW	2	     /* Threshold-based errors above threshold */
 #define MCI_STATUS_CEC_SHIFT	38           /* Corrected Error Count */
 #define MCI_STATUS_CEC_MASK	GENMASK_ULL(52,38)
 #define MCI_STATUS_CEC(c)	(((c) & MCI_STATUS_CEC_MASK) >> MCI_STATUS_CEC_SHIFT)
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 18c4be75e927..13d3efc87b14 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -114,6 +114,8 @@
 #define MSR_IA32_CORE_CAPS_INTEGRITY_CAPS	  BIT(MSR_IA32_CORE_CAPS_INTEGRITY_CAPS_BIT)
 #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT  5
 #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT	  BIT(MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT)
+#define MSR_IA32_CORE_CAPS_BFF_RESET_DETECT_BIT   9
+#define MSR_IA32_CORE_CAPS_BFF_RESET_DETECT	  BIT(MSR_IA32_CORE_CAPS_BFF_RESET_DETECT_BIT)
 
 #define MSR_PKG_CST_CONFIG_CONTROL	0x000000e2
 #define NHM_C3_AUTO_DEMOTE		(1UL << 25)
-- 
2.55.0

