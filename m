Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AEE20FAA4
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982555; cv=none; b=qdel1wKdxbyS/0vj6DW8lgvd5Q80qNAUOq8IxkbGGBV/gG0RAajfmO5w2OtV7GuwrNqQUt5rRP57oT5W+bzM3cDcMMsQPUV7hHKdeVzhlazPNHrKdk9p9VgUJUtWmtuC76XnShhlq/sSZp9bAxyZdVoGFrn+5Bzc04r6hgKe4ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982555; c=relaxed/simple;
	bh=zirzD5gjQx1LhVNoHM15DovF6WfvcOF7SWq+fCxGhz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyrUFi7VJtUtBV/yEOvSY710Kzw7iGEe5xOZ+9ztrYw2pe8IOFcO3/eojt+5ncI5kCgajSt7aFaRLCwjgD/jaqYRAtRyzSkSeV1DHMzVr83oGQFbBzVtx2Ihn4aR4NhM/g8aZyY2XlaG8FwsA5VW3yc09vk5OF6HaRaTkxUy470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZXVjhE63; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZXVjhE63"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982553; x=1745518553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zirzD5gjQx1LhVNoHM15DovF6WfvcOF7SWq+fCxGhz4=;
  b=ZXVjhE635U7ZVP8lIcD3fiuRFv4QsPLjqouMiZCp2Cc35Vik695qyBAv
   UnIeukHmkIJQG2I9X7bvx+bxz9WQdgUk19ciSfyv0zN7VHqu3NINlpEhu
   0xQZaPZX8e/tYjvAqBo88wWUAajGjbOxwDPpi2dBrllms0X9KMkApdAtz
   Hjw/mCwJD2xU55gIB0YDmZZBajqjeJYL0JDfMRGGP6bt5HI6bjkF5fc8y
   D6cy2W+dC2bFWcDBHWmCR6oQE7S/SCpaQno+7hCttDbsHFsqSomzBWVve
   fdWQXy042sQp1rwULrHPui96txsufCrJoXXJ9DJwqC+gxgyOf8Fe7h2JE
   Q==;
X-CSE-ConnectionGUID: KcSbjjHqQ9aBzzjEYosY9A==
X-CSE-MsgGUID: L7H5QvlrShOjD0iJqws6pw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9756078"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9756078"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:53 -0700
X-CSE-ConnectionGUID: 7y2dXEhIQLWfyjsTXUC4rw==
X-CSE-MsgGUID: 8gEDJ61bT6SI6zGMF1H9aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="24751206"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:54 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Tony Luck <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 70/71] x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
Date: Wed, 24 Apr 2024 11:15:52 -0700
Message-ID: <20240424181552.42505-1-tony.luck@intel.com>
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

These macros have been replaced by X86_MATCH_VFM[_STEPPING]()

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/cpu_device_id.h | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index cac33812c609..92b54e320294 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -187,26 +187,6 @@
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
2.44.0

