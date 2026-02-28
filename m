Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D4A39B94E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302525; cv=none; b=YW6EMWb294T4muoXD6uyA8LezYM1DYBGXml6j7lj0EAzb6SoUrLPuuTq7ubloxhh5BvGsqAVTZksPLaJTPPrO/A9Ax0kJjsx8FBOKXdkApAFzIG9ve+KSxFDYDNJyoBM9IKS6Z+6CbJSR7bFTMzF6N46HrmHBHn7ql8RMZEu8LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302525; c=relaxed/simple;
	bh=MUHlAQYSEysZEQexaNbrw0IwTulqIBoQY5XOa54i4GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq50ip5MKkr06Dr8VZ32UyqbU5V8DCuC9cjiOzw0NcLIm8PDqjKAO6lzXApat1lAyz/o6uxuwR90+0f1A1VdmOU82ePWrpLWINX1SaYwI2GZT2mbldBzpNjBXszn1RBRuVeNAZDtFT8N/qJRmkk5aCESxLXUNPgTD/EKsEOY5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9ZUdTT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9ZUdTT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA093C116D0;
	Sat, 28 Feb 2026 18:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302525;
	bh=MUHlAQYSEysZEQexaNbrw0IwTulqIBoQY5XOa54i4GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9ZUdTT/f/Cnmob4CeLvcdicB2tWfQ6U65haaBUWvWiCKDdnqY+8lyS3wwU0CBVdy
	 3o8XNQu5eblFze2Pongb8ImyVIpCYSvKGYIOY5ODkGrWceHImDXqDoIidV76fwPXVe
	 bou5Aci0cRIZx/eoSOqaWVPYSdwi3BdMRRU6Ppcs/0DPCTg5IVbxt3OoF7M/8/bTs5
	 s4Ob3D1hh1oliqi+Zmamp7ZzqEwFpJmEzuxZJTDki1se6I+S0FFXsMdcgVq8/+FO5H
	 RZZc5+9ypIHZ2Kex+AuuBqEA5v7/ZXq4fC78oAUm1UEQRvZ23HrBy9d1FiIWYa5qYo
	 DRO007GBYpnWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/164] crypto: hisilicon/trng - modifying the order of header files
Date: Sat, 28 Feb 2026 13:12:43 -0500
Message-ID: <20260228181505.1600663-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 829f2caf0f67f..71cf7c9e9a338 100644
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

