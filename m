Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAB813D27F
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245219; cv=none; b=mZjVk/ieIjSMDHJqlO7GnsvWBKJ0ZPwZRAf22+PYE4rnDyEtqnIL0O5b1QabTmGAh6faoD9eIE+OExmQpcbtUf3SgNLmAtTX8FYtHLjthWMgLg8TWCKdCgzboRubxpqLJJbW+f49FXdalHI3DrWpG00shNjBsJFmJpHtMaJVKn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245219; c=relaxed/simple;
	bh=ZlPHTm39lOOUOHNKeeb7Ctia3jKnfxDT65NpqhR4lvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1oLf/W1v9An7xGAPCg43z1ENW6Hj5IoJw4BmJnKnkHJxNYVT6zK89IpiWPeyEsUqeFSr8ttznZ47RNmq3J04qFogAvO6mLPTp/2JKMq3V2n8mzV/KrUxaJ8MjI5QcaxWblQgq5LplsMCgOGy25EUh/LNghbgDmLbzSaIX+pvls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lsdRD0Xv; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lsdRD0Xv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245217; x=1747781217;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZlPHTm39lOOUOHNKeeb7Ctia3jKnfxDT65NpqhR4lvo=;
  b=lsdRD0XvmkYgiO1lUMl4W6/Ylz8JawLHkineUw5VvpL/ZKLQxjCPKKrT
   3fgxL+KG3Nvf0DrsFx2oKnHtLftcKpVNRG2xLC2QyPfIVaGAgJALW/ZjA
   ab127jwT77D02W1fJqktAtEnbm68Xqd0dlPG4mbW8juC17hvpeAl0B6SA
   7WrYLG+z5Kpmp4m7wAh+JUa1s8IJPzm4veDj+um32IPhC4nuUjjoyg5si
   a/l0hovGKlVmaqrhh+IyBWPqYfl7gqjM3NrW0P0oy0GaGKE1V5RAjKtcu
   R+nPJKkIewlsGRU3j/D4msly8bHZu+mTSXwdD9rXnks0G8wHIoAVOjRbc
   g==;
X-CSE-ConnectionGUID: Ar7WUpszQCC0psH8yUfZqA==
X-CSE-MsgGUID: bimnryKhQtir1T2BLqLfmw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12200042"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12200042"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:41 -0700
X-CSE-ConnectionGUID: JniqsW9TRHmQrveKHwMIcA==
X-CSE-MsgGUID: 6xQLbY0ETrqwBxgyWud0HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593531"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:41 -0700
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
	patches@lists.linux.dev
Subject: [PATCH v6 48/49] x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
Date: Mon, 20 May 2024 15:46:19 -0700
Message-ID: <20240520224620.9480-49-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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
index df07d3776db8..4be902a1d74c 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -189,26 +189,6 @@
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
2.45.0

