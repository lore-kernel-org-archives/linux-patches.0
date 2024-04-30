Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168EF41C89
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495893; cv=none; b=UtMd93gk4pENmYHzD0BZ+UxL0lYyzhsNAixB0709pdaOVaB9a+rUJocKkYHN6TrZw3f6c5odzhsnyYQpMo47vavRQKJwS34vP60ZDDtAd1bet5kZ3HC6Ax6NZL0ks4/9i0SbfJjxg5/DiX0k5kZLrNpcvFeiiyB+KHSiENY2EnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495893; c=relaxed/simple;
	bh=FNDk+Y1KxLeWN61tKBHWfeTJDDwq/i1NWZWqLk1y3G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE0VaABbyghqq7Mg99a0GAmFIuUBT0ir+bJz+TH08lFeA3s4XfaMq3ICW4AqmeU5qIi7IUha7VWsWgYb8P87FMNZ3LQVLxJdJyM5hQqEFOuFPDb6YR2DeUzAi9hQCsRDNO2v+p+tRGv/ZYjVrhf36F5hP+sbbaKXt/hGSg6BcSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gxWWH0Lu; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gxWWH0Lu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495892; x=1746031892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FNDk+Y1KxLeWN61tKBHWfeTJDDwq/i1NWZWqLk1y3G4=;
  b=gxWWH0LuI1EMVCSrUfRil56PcDsy/jOUDq1qhRhOaV+bp1b2rrKz/ZCI
   S39WiRAlQBP979ziw5HC0krCoW7jv/f04hOUW9sNjCfz4aOUhrWFTXzd7
   lCSlVrRyrCgxO3aN9PCZzsZLSdTsB+qJF6CcyQxTF8B+weREZZY/wtmI4
   ZU5YyVA3PUc/U/MPqPx6IyIYe1jaVEzp8lTEmTAgp9IaooqcPtmPv8wjr
   XNIWpAT7eGEpRZl46DTkDmM2hX2xHhbIXnKfJPCtij79NuE8W1CNR7BjD
   uyaUfdGiuAZj+24TytS6OkHxUcnJyPbodCROUBDUZdgYdq/jPQHSWqCso
   A==;
X-CSE-ConnectionGUID: ZJbpsOaCSbWDXxsX89tirA==
X-CSE-MsgGUID: WLUAC5z5Tbyn8WAIJKkivQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075598"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075598"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:20 -0700
X-CSE-ConnectionGUID: hOLFabK/QM6mzNVA7la6Vw==
X-CSE-MsgGUID: JkT0Kl6XR5eXpq+tbWcE/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515408"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH v5 01/47] tpm: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:14 -0700
Message-ID: <20240430165100.73491-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430164913.73473-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm.h          | 2 +-
 drivers/char/tpm/tpm_tis_core.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 61445f1dc46d..7b38ce007bdc 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -28,7 +28,7 @@
 #include <linux/tpm_eventlog.h>
 
 #ifdef CONFIG_X86
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #endif
 
 #define TPM_MINOR		224	/* officially assigned */
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 13e99cf65efe..690ad8e9b731 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -210,7 +210,7 @@ static inline int tpm_tis_verify_crc(struct tpm_tis_data *data, size_t len,
 static inline bool is_bsw(void)
 {
 #ifdef CONFIG_X86
-	return ((boot_cpu_data.x86_model == INTEL_FAM6_ATOM_AIRMONT) ? 1 : 0);
+	return (boot_cpu_data.x86_vfm == INTEL_ATOM_AIRMONT) ? 1 : 0;
 #else
 	return false;
 #endif
-- 
2.44.0

