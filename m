Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A551236C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302323; cv=none; b=KgNKZuO4GbZXx11OVMGhd3k/w7cyqMlTWlamAdppcyWVLejJ46xRJa2+Q2J9/yN65fIsA0u0HmuAQm7PLCorVnhSMY0YUBXVO3nEw131vdsdx5exeCw+qC0DTjJYwcCXgG433DVRpzrzcAPm55KE2NIJ671EBzITMsHAtfzwuTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302323; c=relaxed/simple;
	bh=l52UwOln67jrR8ODwmR/4YoGpTkPhoGJPQm5Jvuu3yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dfa/74l3Uch1y1Mo1avULRrtt7are+8oB6OX1OxxcFpFceRV43YHbttlJW9n0XKR+GImo+QnouRELSq0r2Rtd4k6dVKEA6ZnckY9Vm0lutai+nBxZNtQ2qklLcAO1BHzArQBfDjj+2ZyGM6+FabPDEGFe//RpLRhO24BtYibG8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inGqrUmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inGqrUmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A0CC116D0;
	Sat, 28 Feb 2026 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302323;
	bh=l52UwOln67jrR8ODwmR/4YoGpTkPhoGJPQm5Jvuu3yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inGqrUmnIYvTekFN48ktPbO7FQZyM7nUo9cBMBAOWWVAzJVQBY6kgKOZASQOkuTtS
	 jugQuik1vaNrEDTreSgxE2FV9ZyVmNdvJSbP/oQsqGmKA530aPLgN75LNjd5F86plq
	 HxnCs0MaD1cgPBZ3UBUyO3cJ5NVTYIKkwyw5OX6vl0Z0JurA1tBjJNaSNLT2gh2CV0
	 kMuV/Epc3TIZzThr6wcv8G8NhSp0fA/rduy0IRl4o3dnncSB7DXbMCRrBBcEtC6I/w
	 hMf0sfx1PWlM0/Fv8mtQgf7WEjAS0aCbYd9ndvZDHB0bIlbvlPED0iV1Y1kXIb+VWq
	 7FIMSmyCBSgrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/232] crypto: hisilicon/trng - modifying the order of header files
Date: Sat, 28 Feb 2026 13:08:15 -0500
Message-ID: <20260228181127.1592657-42-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit f5dd7c43022799ac5c4e3a0d445f9c293a198413 ]

Header files is included Order-ref: standard library headers,
OS library headers, and project-specific headers. This patch
modifies the order of header files according to suggestions.

In addition, use %u to print unsigned int variables to prevent
overflow.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3d3135057ff5 ("crypto: hisilicon/trng - support tfms sharing the device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/trng/trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index 97e500db0a825..ec1eaed32d3bc 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 HiSilicon Limited. */
 
+#include <crypto/internal/rng.h>
 #include <linux/acpi.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
@@ -13,7 +14,6 @@
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/random.h>
-#include <crypto/internal/rng.h>
 
 #define HISI_TRNG_REG		0x00F0
 #define HISI_TRNG_BYTES		4
@@ -121,7 +121,7 @@ static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
 	u32 i;
 
 	if (dlen > SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES || dlen == 0) {
-		pr_err("dlen(%d) exceeds limit(%d)!\n", dlen,
+		pr_err("dlen(%u) exceeds limit(%d)!\n", dlen,
 			SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES);
 		return -EINVAL;
 	}
-- 
2.51.0

