Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023617;
	b=mFaSozBwnITM9cynUt6vxh0mSp8DvBhDtNiX5DVX8AsBD8Ttc4pJImz2apE/IctYnnOx
	 twixd5Comuw7p64/vTJa9LNZDnpO3Y/ROOqOPskuY1bVY4FZduM2eUlB7vMA3uvhAel9G
	 tYIObTMbNiYwDhcrPZbFrTw1NX9LBCloJb4Kzl3rlkPPIAGQIS0qcjqslMr6FmzvZSCAO
	 DkMChFIUSg47hjbmEPI6YDCwVu9eMIi/M9vJnja6xBfl3V8Z9fqkAjzaLVZUMqUILhxSl
	 6Xc/d7weuGv9s8h1WTlafty1xKxvPY8e5iaE8N/NPcLgm2ZmGKSejArY+huHho2SJ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=acMzv60cZinXdJ6qcG2LXaH6M4bMUIzz36+TsJeSAKM=;
	b=OeVkGbfCDrcQ9x6G5ZHyIJFYs2AAl1HEkGSUuV7j95VdpWZZSDOXiT0KNaMufwO1us1i
	 LdJEzaLTLreOQLcIJo0uBDOTffiNVLhWueagFzENxW46NVYtIwKg1K86dtDKoCXsza1p+
	 s4X48YasYUkJeruUNygh4ClQ0Z6gg3XYKd1+60rZ+tLhzZbCIGkd5SYnRVrNHOqUzfxgk
	 W+9pVjIK1om7EJTJbTigwbDTZ8QEDGB+038LPYQgT4UlPyYglT64EfjqO5uMKpjbfajD8
	 1rnjBlSc61WWhbrHT2GAVTW/h9e6bV/wdL3hSCDBL/wtL80vlEJaJNkYiboKporcL4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1sEpciXP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F31606A31C;
	Wed, 18 Nov 2026 17:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1sEpciXP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61321F000C4;
	Wed, 18 Nov 2026 17:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023617;
	bh=acMzv60cZinXdJ6qcG2LXaH6M4bMUIzz36+TsJeSAKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sEpciXPVINzGPDrVg+eS4gsx7PPE8uVFB5XcJx4CU2O9F0YPyRlFiz3svcKhcewL
	 ityRaGRYSEXUNU6ykEelCejDCrtUjJvYhfv+vjCRfiUXXSdZXuaffDSI0NVk8zEMLk
	 s7/SSWxTPWkohIVdnhCC9zHRXaKafQxy4d5jkOY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0382/2151] crypto: qat - avoid OOB read when stripping RSA leading zeros
Date: Wed, 18 Nov 2026 15:35:17 +0100
Message-ID: <20261118150135.993352300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit ac508238898058f0b09b18a7891fb31279617781 ]

The logical AND operator uses short-circuit evaluation: the first
operand is always evaluated, while the second is evaluated only if
the first is true. Because the first operand dereferences a pointer,
it may cause an out-of-bounds access before the bounds check in the
second operand is evaluated.

Resolve this by checking the vlen prior to the pointer being dereferenced.

Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index afb7e3f44a5f8..173392fdf5bc4 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -987,7 +987,7 @@ static int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1018,7 +1018,7 @@ static int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value,
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1044,7 +1044,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1067,7 +1067,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 
 static void qat_rsa_drop_leading_zeros(const char **ptr, unsigned int *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



