Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA7E18EFC9
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725384899; cv=none; b=BJocb26liZt2R9MJGyIqTPDl+BrRlWD12E8VUZOMluurSu9plv3+FE8fGZOScL2QvIHnH5ySApeQ/sFkY89AdlxRCevUu+L54xONjr/eV8CkLSE5mIXZ8HmZCLUOARsgxKL/POAh22ldjHkghuiDLSreZVadrOBXGQDHqDKW+K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725384899; c=relaxed/simple;
	bh=F0NryG1DH37C02nmWcPKTlW+pqUK8w2Hx6+h0tLzTqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx2Lpmn2TbNch37CPhFcG3jRO6kVH1q4aLn93wzrRw2D8P8t54iGrt1MdIOFOeuCbyqKasgC6t46/5E3TW14O2JSd35OhtSyTBGyp4hGme6KkQedkcZfrmr+Cq6rkzgLp0SF4Tc/bczX7ld+MG9PFpmfKB2jPgIGTBe2fxw8IQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LQqQUqFg; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LQqQUqFg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725384898; x=1756920898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F0NryG1DH37C02nmWcPKTlW+pqUK8w2Hx6+h0tLzTqo=;
  b=LQqQUqFgz6xs502tQMVyLEcvs+eVBM5xSDrQzPSprbNA3ZHGN4xqn/Qw
   7O4T6e8n1X3hSFOIQALQV/2sTVCVPetaNwTrCITjNG1zGjYw8mF/zWVQp
   vHgDydQ/V3fcO+s7ov6HTnq5ufliaFZ0g58zEGJTzDsqvGd0HcdvPrhiS
   EC+/zymRYNHEVEBSkC5gMRaWXFjWQe07l7EyU91TVtD9eEeuptSWv/Xg+
   XpUlre25ZtFw1tKd9RblbGegnu/Si9n4oWhRaqHLyjMjmqe4VQLLTJX5Q
   levPm6sLDYdDwF6r+57YITLQR1KJaW7IlOuwDV6EkhEuO1+oX/g/JzFKv
   A==;
X-CSE-ConnectionGUID: udkTWDrmTc+5uYeyNfiSpg==
X-CSE-MsgGUID: T/qi/j8+QkCHC104GENaMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="46528541"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="46528541"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 10:34:56 -0700
X-CSE-ConnectionGUID: 5JFcxQVmT6CVHHjV2Z5O8g==
X-CSE-MsgGUID: 14kBsSjPSDKR0RKNf0qNRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="65715877"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 10:34:55 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 2/3] x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
Date: Tue,  3 Sep 2024 10:34:42 -0700
Message-ID: <20240903173443.7962-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240903173443.7962-1-tony.luck@intel.com>
References: <20240903173443.7962-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These macros have been replaced by X86_MATCH_VFM[_STEPPING]()

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/cpu_device_id.h | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 3831f612e89c..e4121d9aa9e1 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -192,26 +192,6 @@
 #define X86_MATCH_VENDOR_FAM(vendor, family, data)			\
 	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, X86_MODEL_ANY, data)
 
-/**
- * X86_MATCH_INTEL_FAM6_MODEL - Match vendor INTEL, family 6 and model
- * @model:	The model name without the INTEL_FAM6_ prefix or ANY
- *		The model name is expanded to INTEL_FAM6_@model internally
- * @data:	Driver specific data or NULL. The internal storage
- *		format is unsigned long. The supplied value, pointer
- *		etc. is casted to unsigned long internally.
- *
- * The vendor is set to INTEL, the family to 6 and all other missing
- * arguments of X86_MATCH_VENDOR_FAM_MODEL_FEATURE() are set to wildcards.
- *
- * See X86_MATCH_VENDOR_FAM_MODEL_FEATURE() for further information.
- */
-#define X86_MATCH_INTEL_FAM6_MODEL(model, data)				\
-	X86_MATCH_VENDOR_FAM_MODEL(INTEL, 6, INTEL_FAM6_##model, data)
-
-#define X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(model, steppings, data)	\
-	X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(INTEL, 6, INTEL_FAM6_##model, \
-						     steppings, X86_FEATURE_ANY, data)
-
 /**
  * X86_MATCH_VFM - Match encoded vendor/family/model
  * @vfm:	Encoded 8-bits each for vendor, family, model
-- 
2.46.0

