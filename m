Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EED684E0F
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302525; cv=none; b=KfHoW7K5f+HQIUA0s1nSLUDx3egoywER29RD9Mnh7teG3En3feA9D6MyPbn2m7I4Q6+ekiMgtDmDGwxeDq03I1aqmnUtjc4rHPxw5AIlX3v6Rad0+Jty7bIk93VRK1IqvHsNEyjgMbHJXL6ezTBlaNTRkf4b4TkcSTDAL0NNA7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302525; c=relaxed/simple;
	bh=frPDqt/jTGsMhuXRZP5I2aou/N9zQ6TaB6jottwpuBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khB+DDfZGdX8tmz7FQrXtW1lYnCrHi1K/cTCLtZ4+3O+5xBMe6Q5fhjjb0/nI4dQbEZAYoNj9QzCpxS1pL8diSjO9aymCLHLan94J68xaI8PD/+FddT/n0V4jee2/ICIPXz09UHvCievRWwYGz3quzGUkL9vuDcGn0Y13rdgu48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F9Aej/jW; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F9Aej/jW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302525; x=1744838525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frPDqt/jTGsMhuXRZP5I2aou/N9zQ6TaB6jottwpuBM=;
  b=F9Aej/jWmd38r4iq8goolHDYnen8KhBKBhIS8pGoUNwCb7NkOXs5iJN2
   Va43rgfyxSltKfssKPxxpa9C1YRoCtbWkbnusXx/cJoMj+5FEpk/DShqq
   g0BZYPQcNmpVjciH/krjSZivZqJp2vN6u0MGFUavJzAujJJZYCQBBOqyY
   uZjuXkSexccfRKugyB0lvVJXl1ggU+9RGvIl8yGqFR+RcQt/+7PyPbAzS
   JWw5KRFVBCVVfCTLSpkfqPfcsuUX9m4hNpvc6Hb8ZIAjDqxWhE1+a0Xua
   JKJ0kYn/nJmBOwk3rA8+FBokJbKY5FEThudJcjdLLwIHtHYS9El8SJrHX
   A==;
X-CSE-ConnectionGUID: 5q1mkPJZQUmqi5je8YYQJw==
X-CSE-MsgGUID: J1NePCSkSfeBIqf2dlVzxQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19328735"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19328735"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:05 -0700
X-CSE-ConnectionGUID: 3C4dj8qRT9udti3c/IsKIQ==
X-CSE-MsgGUID: 6DxEzHngQvWvdI0IksPHlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="27071896"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:22:05 -0700
From: Tony Luck <tony.luck@intel.com>
To: Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 42/74] x86/cpu/vfm: Update tpm files
Date: Tue, 16 Apr 2024 14:22:02 -0700
Message-ID: <20240416212202.9452-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416211941.9369-1-tony.luck@intel.com>
References: <20240416211941.9369-1-tony.luck@intel.com>
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
 drivers/char/tpm/tpm.h          | 1 +
 drivers/char/tpm/tpm_tis_core.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 61445f1dc46d..895f2dba266c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -28,6 +28,7 @@
 #include <linux/tpm_eventlog.h>
 
 #ifdef CONFIG_X86
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #endif
 
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 13e99cf65efe..c940fd18988e 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -210,7 +210,7 @@ static inline int tpm_tis_verify_crc(struct tpm_tis_data *data, size_t len,
 static inline bool is_bsw(void)
 {
 #ifdef CONFIG_X86
-	return ((boot_cpu_data.x86_model == INTEL_FAM6_ATOM_AIRMONT) ? 1 : 0);
+	return ((boot_cpu_data.x86_vfm == INTEL_ATOM_AIRMONT) ? 1 : 0);
 #else
 	return false;
 #endif
-- 
2.44.0

