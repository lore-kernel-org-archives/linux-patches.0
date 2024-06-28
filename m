Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F46B80635
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 23:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719617752; cv=none; b=Gq10HFBI11e5hM76Yg+Iz4VDkNuiMcIW3d09hbP3WB+AXVbDiB7FqbVxF12tc9fhcrgvUl+bvR90NwfXakchp45QchGtQiwWHKFtYQbfzrT7oT6I0cIEcEARcIdVh3hyFaUSuggiyzgeA8l20ceYGeUaYn7ns6pCD/rkOmhVJDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719617752; c=relaxed/simple;
	bh=nQh6PiV/uejYwwxC/7SvfuZ8z+tRvvLwVBKHdSI3S/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdSLvRcUtH5Fmffnl965a3BmR2IeV/8b5Ws4HI9dOL2t5m71Ric7nB3am+ZYsAIB78sEKwyD0D6xT9qZ1PqaQSAvlyErLwJUH7G9tvHU8edpCyXzF5Zr89O9gh1PkTSDsWEFa8TVjsQr7BJEM2476OUsYktGuGyy/1e9ZG1r8yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gTOnB3eA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gTOnB3eA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719617751; x=1751153751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nQh6PiV/uejYwwxC/7SvfuZ8z+tRvvLwVBKHdSI3S/0=;
  b=gTOnB3eAVpVawKHVqGRGVBu+inhEsmQAt9GlvgRIJQnIZJ4OvASqWjf1
   TSx3SQ45oAjM8Z297iPJc7F/GSPoYb76j2aaxJ7BwgbP7Rd6LebvNjhGQ
   pVtUemQ6Va/NMnln+WMhhv4hLUGiMN7qKBh6empJDv35YvsPPgYzH3/oo
   yEo24hciF06VvlysT2y8cJ5wrDoJddXRLJVPa104Qx61jnpOtPY0SsWsl
   0aEaVSWRieTIwxh1XC22wDKTADdhfU4mairy+sXc1gHPhw0xeKteudVZi
   8eK1NGv7dIXnpcdSFhFLtG6CZbYv669Tcc8EKKfByKkMlSEb1D2qyXEvl
   A==;
X-CSE-ConnectionGUID: IJ4jm+vUR76dCa1U1OoBHg==
X-CSE-MsgGUID: 8LpQuF/+TLyhKYx3DBZ92g==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="20575396"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="20575396"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 16:35:48 -0700
X-CSE-ConnectionGUID: h95JEMSJQIG5vIFOROq0hA==
X-CSE-MsgGUID: IZH4+3OERyidObRE9yyqoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="45300266"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 16:35:48 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 1/2] x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
Date: Fri, 28 Jun 2024 16:35:39 -0700
Message-ID: <20240628233540.77900-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240628233540.77900-1-tony.luck@intel.com>
References: <20240628233540.77900-1-tony.luck@intel.com>
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
2.45.2

