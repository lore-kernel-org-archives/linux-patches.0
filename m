Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D671C8FC9
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495914; cv=none; b=lri2i8vhR2kSk4JnyHXrQryDhFqSFWivQQPn2GciQ7Pricx5J5N7QJt5YZCAi9Go38CXZikXQT0tbCIqH9/g4xlPNfM3INBOQrAzHYU28uGdlWHRGw1DnM/aNLa5y+9qZyZ9ZZ3OHuQCc4ghptK0cb5y8wUF1Rm5ovHO7hVC8Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495914; c=relaxed/simple;
	bh=zirzD5gjQx1LhVNoHM15DovF6WfvcOF7SWq+fCxGhz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERmcpZpGzIPL5kJuIXRn3MZR64DkXkVDVs816pRT3sV2ugfWUn8WkP3mQNYXslploM1XH9iaxdDf42oyQCEqSxGxVu3yWvI7M/Rbyb6iIxAY+u+rj/weYyBTYfgzXPxOU97CVSUbjlf7uAqZVRAnd+HydY2DfIshxWK6O6W/TaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cdAyQtIk; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cdAyQtIk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495913; x=1746031913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zirzD5gjQx1LhVNoHM15DovF6WfvcOF7SWq+fCxGhz4=;
  b=cdAyQtIkc6Jz9dtW6ixs5ZaCxPsS+1uYcazI/Ymd5dzyK4nik/7T/u0L
   0SB7lcSX2AkOibKbNFqh1Nc9wWHvKe0C6WOrTZwBuSG6UiBXb9f6ehRg8
   yr7VRhgfuGtnNtDr+nEf3a4MQ1P5bcBRTkKiDLkn0NrVn8wQygbWmhj4j
   LkWGq9Wz9OIF0Xtx14rZrM64kWzMTOxmkjFglT078DrwCwyYHqsO+hBXw
   1MsSe1oOeQrG/I4SindtQoqVkRRml0Zph9xpa1smReC1OYKNZ7ci+9V9z
   gE6nw58+mTWEK8KPS6u+ChYI53nw6JO23G/W4I4We9zMcPqoAbT3BcLxX
   g==;
X-CSE-ConnectionGUID: Pz0LdlMzQ++NEiKVI3d7bg==
X-CSE-MsgGUID: 8H6uMUeaSo6jicJcLIv7EQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075776"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075776"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: USri+hiPQxO7n9ePjoY4rg==
X-CSE-MsgGUID: lUTufSDUQwmwx8wkkwYPlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515530"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 46/47] x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
Date: Tue, 30 Apr 2024 09:50:59 -0700
Message-ID: <20240430165100.73491-46-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
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

