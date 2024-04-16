Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD906CDC4
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302401; cv=none; b=T273QAcXR1qBA1y99pCvht+eKm0Nzl/oSq+iqN3KnYIZvT7DsL3iPMOxKurfTjOkhKa4v6rSrGDAG8CTZNZHEMOnYIHHZjNNKtS8+RT9dKPLaLI+VLsnpU9/YSKEIaTRMfCS7dv/Fi4kugFynnHkufx6Ljl+C2Kuufl3HytblrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302401; c=relaxed/simple;
	bh=CwybUVe8crx1l4CZK03c9vCx8DvC8Bgt8uPcKdw9g+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMc42MJoj+nLwu/7MG9ZePHN7hFpe67aktMLDG9mMOq38DopR6jGrDiQitfKuGDR9lQlyvOpl9J+58xtrVbN+6fbvh76kwYZmexEbfDtGN18nlPaFMoMIxhF22YsGseEZr2Hnae2hw454dtU0j/pHTFrnQU4XJCp1V5jKQx8uG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GmH6QiZz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GmH6QiZz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302401; x=1744838401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CwybUVe8crx1l4CZK03c9vCx8DvC8Bgt8uPcKdw9g+E=;
  b=GmH6QiZzuwu3BkgYxxFBTlF3cqB1Wk9oQagpNQUq9iOC+H6p4uCxwiK4
   m4aQzbXdJSQtIMO8QYsT4+cP4h8izoEhsRR+u8tFbWM9BTY2UCctM64yO
   s8H7GB2wWbJO1IWTNG7vtyjEDC5NgfTVc3cd6RWxjjS5wDI3Nt+/+rkni
   9LcUoBpRmvCUzWJYf3Apcdpg4zAJ9y8rbJJg9vGgXMsZu3iuTrsVszqsk
   SjJu1fTfaQgRiradHb4tWEICP/54obAgtZkGxgQp2HUiVhMq7xpQ5jUwj
   uCpvx8M2if6pLGK81EdJiWiAwjR/8bnPU3XZrGSSSEDvbZGSjU665NPO8
   w==;
X-CSE-ConnectionGUID: Ri0huA6hQEm6YH0+zfWOdQ==
X-CSE-MsgGUID: vZF1q8TcRqCE+eCVQB/e6g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914690"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914690"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:57 -0700
X-CSE-ConnectionGUID: w2qRgShKTTufJxObSaJ2zQ==
X-CSE-MsgGUID: YL19oXZbR/i4bqkwfFkLPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871886"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 05/74] x86/cpu/vfm: Update arch/x86/crypto/twofish_glue_3way.c
Date: Tue, 16 Apr 2024 14:19:07 -0700
Message-ID: <20240416211941.9369-6-tony.luck@intel.com>
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
 arch/x86/crypto/twofish_glue_3way.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 90454cf18e0d..82311249048f 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -12,6 +12,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include <asm/cpu_device_id.h>
+
 #include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
@@ -107,10 +109,10 @@ static bool is_blacklisted_cpu(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return false;
 
-	if (boot_cpu_data.x86 == 0x06 &&
-		(boot_cpu_data.x86_model == 0x1c ||
-		 boot_cpu_data.x86_model == 0x26 ||
-		 boot_cpu_data.x86_model == 0x36)) {
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_ATOM_BONNELL:
+	case INTEL_ATOM_BONNELL_MID:
+	case INTEL_ATOM_SALTWELL:
 		/*
 		 * On Atom, twofish-3way is slower than original assembler
 		 * implementation. Twofish-3way trades off some performance in
-- 
2.44.0

