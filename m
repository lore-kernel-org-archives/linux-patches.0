Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1A43446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302071; cv=none; b=rqyYRE1Bsg+Ac3NRxVhdxwrhba/hMDApuwHpsrk6S3lWQLmJdnDvdjMLXZEoxxPHB5nbaCy56JH+5OYcKZqjMkE6ddbLrc5R7mPQI98m0dRiF6VHgtimgmT+XCcRIOtH8B/7/lzUft+vKlicemQ7mHgHeJbXA+WHiGCtYFjx+Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302071; c=relaxed/simple;
	bh=l52UwOln67jrR8ODwmR/4YoGpTkPhoGJPQm5Jvuu3yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3rxVr01ksUvKMtxA8rKbURkzKhigfhbwTU9qL8ImkZXTJRG31NOMchFzoApRkrLERloYLXD0VFChGSCJ+MVKXQCHimVx3iSdHBnfd2bcGuLQc5BE55LEjvwyI1qE3IWc6pxHekv12uXGFi16iSa6XlOkMwYJJCCt9T6KqHdeNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmeTZFTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmeTZFTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B8BC116D0;
	Sat, 28 Feb 2026 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302071;
	bh=l52UwOln67jrR8ODwmR/4YoGpTkPhoGJPQm5Jvuu3yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmeTZFTWN/z3SeBdd7oNjmT1lbv1l8qEKuAsi9HnRe431nSyaK0FM8BSOcWLPLkoY
	 BxhUjqnB8bPf1j3EtFEsQjFhX6cW7iU0VexJ5WkLHGHD/3RuvvtFR90+G2DeV26CfR
	 QgelP6BAugFGoje4bXiAyfSogQ+9bf/lKscMKF3w8/AtpcW2Atr6bbRwMWWUw3UB+s
	 u0FOijJ5pSAdq7TQYjL4cdSqJhqTbkw4stiA56L7rL9/mk+VXFux9+1O0POm5e+rAk
	 gju2uKh7ACl1ttjfrqB5UA8gMiorNqrhwRM4ktPLP5jpFYO9G47f4SnRoYH76CYY0j
	 wnPrDfBhiqkAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/283] crypto: hisilicon/trng - modifying the order of header files
Date: Sat, 28 Feb 2026 13:03:12 -0500
Message-ID: <20260228180709.1583486-50-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

