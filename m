Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EEC130E27;
	Mon, 12 Aug 2024 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479221; cv=none; b=Xah4GBR9D4OX3tHaJNJYy091V2bsksnRNHPGeMUhZD2mphMmPoGWsglnzF3L7IMYpHGGmOVjJK/K1rcH25KtfXRApjO2zejZa2wY9Sf4mCJ14H3FtMImNU6aYy/9yoBdHfJLnfIv9El2pS94uVSKbgtUtarQmmSmu4LRhHZb35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479221; c=relaxed/simple;
	bh=CYX5/52p5n8Wuhfig0DGe84oqkz7Vk2nBX/e4o9ri+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OU+fgIh4SxAWZMvtxF/okf+YJ7AjLuUw7qvEphKqewIhHpZhf+E0vdg55G+eUPEMGhRS96/PbOB53dPokvJAYVb9fvs9OgJlH6pSvQ2+pXcdcLFwH+bxO7L7pTIm/pbwcNm3nAkb5zCsy/DTROgfaKdkgkDXQSyYIAPCNyh1O5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEkyr/6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEkyr/6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B56C32782;
	Mon, 12 Aug 2024 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479221;
	bh=CYX5/52p5n8Wuhfig0DGe84oqkz7Vk2nBX/e4o9ri+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEkyr/6kdYQ6Q51yn3deUDVd30CbkBUN7rp5i/HP/i1mVUoEoGJA+sLom6ScD3Bxh
	 q4QKx0d5RFJIksgjCT5xSN7jjpV0IsGcJ0iorXBTqSfqZfWyi/dtMBvxVQsY+DcLHY
	 c+sRz2oQ4GAmHwWdZkBo4eBvgrhLyV7kkDFs7rZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jithu Joseph <jithu.joseph@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/189] platform/x86/intel/ifs: Store IFS generation number
Date: Mon, 12 Aug 2024 18:00:58 +0200
Message-ID: <20240812160132.233522780@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jithu Joseph <jithu.joseph@intel.com>

[ Upstream commit 97a5e801b3045c1e800f76bc0fb544972538089d ]

IFS generation number is reported via MSR_INTEGRITY_CAPS.  As IFS
support gets added to newer CPUs, some differences are expected during
IFS image loading and test flows.

Define MSR bitmasks to extract and store the generation in driver data,
so that driver can modify its MSR interaction appropriately.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/r/20231005195137.3117166-2-jithu.joseph@intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 3114f77e9453 ("platform/x86/intel/ifs: Initialize union ifs_status to zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/msr-index.h      | 1 +
 drivers/platform/x86/intel/ifs/core.c | 3 +++
 drivers/platform/x86/intel/ifs/ifs.h  | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 621bac6b74011..24b7bd255e983 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -237,6 +237,7 @@
 #define MSR_INTEGRITY_CAPS_ARRAY_BIST          BIT(MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT)
 #define MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT	4
 #define MSR_INTEGRITY_CAPS_PERIODIC_BIST	BIT(MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT)
+#define MSR_INTEGRITY_CAPS_SAF_GEN_MASK	GENMASK_ULL(10, 9)
 
 #define MSR_LBR_NHM_FROM		0x00000680
 #define MSR_LBR_NHM_TO			0x000006c0
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 306f886b52d20..4ff2aa4b484bc 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2022 Intel Corporation. */
 
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/kdev_t.h>
 #include <linux/semaphore.h>
@@ -94,6 +95,8 @@ static int __init ifs_init(void)
 	for (i = 0; i < IFS_NUMTESTS; i++) {
 		if (!(msrval & BIT(ifs_devices[i].test_caps->integrity_cap_bit)))
 			continue;
+		ifs_devices[i].rw_data.generation = FIELD_GET(MSR_INTEGRITY_CAPS_SAF_GEN_MASK,
+							      msrval);
 		ret = misc_register(&ifs_devices[i].misc);
 		if (ret)
 			goto err_exit;
diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 93191855890f2..d666aeed20fc2 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -229,6 +229,7 @@ struct ifs_test_caps {
  * @status: it holds simple status pass/fail/untested
  * @scan_details: opaque scan status code from h/w
  * @cur_batch: number indicating the currently loaded test file
+ * @generation: IFS test generation enumerated by hardware
  */
 struct ifs_data {
 	int	loaded_version;
@@ -238,6 +239,7 @@ struct ifs_data {
 	int	status;
 	u64	scan_details;
 	u32	cur_batch;
+	u32	generation;
 };
 
 struct ifs_work {
-- 
2.43.0



