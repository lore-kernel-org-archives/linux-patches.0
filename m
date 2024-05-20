Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A006A3D3BC
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245202; cv=none; b=SYBZQEG8X4KtxOR/IJLhwVd5Dz8p41JgNKXlCZi4ANB6I3bDx3wmmecGs3D/NDcM7yYm7qNq8/vjFELF4HXPIgbxclNyvKhxgOOrwOYpTuCFVAz72nV1WR8pgQ3E7hwgVqwo0E4Y9bpg93BlbmEYuHpcrpghzB6J2+dRAs2ptt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245202; c=relaxed/simple;
	bh=v93/ual/g32vB/MEMraEt8b9ts3LdceCjM3EwpB5y20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohSdY1Oh5B8Q1A9U58Pd7dJJ0HKZyYXS/ebhhpsN18IM9K2zpatbDp+ze1zuheGXEpnY/dwaLro7V2DlH44xUMtKLiEFU5dV9FflMXfz9o+expaXe18uxzYCG9FDp9YFRvgnx+IIDBX3b+N5D4ljIAlBaXtmmaqhkxhE2qHwn3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iJOcjdCn; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iJOcjdCn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245199; x=1747781199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v93/ual/g32vB/MEMraEt8b9ts3LdceCjM3EwpB5y20=;
  b=iJOcjdCnTMBKE8VEgWhJ7T6QHAt3xNiEXn3Yua+7Imn6IJ9EdvMnzGrL
   5eAIO8Q/1ncagH6WSMLkP7ayptyV/MOAXJmSJ1DFVl98vKbmHXxnQW56W
   ba0JHGZbdBHeeVWWE2qyyrmqIYDhkLytHKJ8TbKjouMvB6DcCAF0/QG/6
   M1WnVhwRjmvC3gL5Xr4xqo1nH9N4a4xASRndd8QJ44/OR4Pd51rHxNBnU
   Ops3Betrj2FbAZZ06cNMI/hNqKrKQxuZ5ATpsHqFeT9gfuzJvVUxhyI7Q
   6pxuLyvyIodcxnRMSqcIgfQkCNHyh0EaGJAW2Aq62Hx+7BNP86tuBg1G9
   Q==;
X-CSE-ConnectionGUID: XQWxv+vuSwmLLmQPdq6fQg==
X-CSE-MsgGUID: og0VDC1UR/Cr17Dsc6cHeA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199531"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199531"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
X-CSE-ConnectionGUID: 8wuCngyrRqutNflgnQSAEA==
X-CSE-MsgGUID: /viPDrVoQp+zeZMF0zFKDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593389"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
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
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH v6 03/49] tpm: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:34 -0700
Message-ID: <20240520224620.9480-4-tony.luck@intel.com>
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

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm.h          | 2 +-
 drivers/char/tpm/tpm_tis_core.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 6b8b9956ba69..7bb87fa5f7a1 100644
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
2.45.0

