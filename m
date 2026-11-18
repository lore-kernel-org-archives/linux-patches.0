Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029452;
	b=m27xnsMSO7/gEQAZWfiiOhFU9zp5KxY699YHQWsel+X7u/mkO6Ywflr/XvPV6eHXpiXG
	 Es80ASgw34VBJOiM9sSSyfAo6ABnO0nQZwCH/oWFIkxdoCFQKtzegtt++ltciU3YQU7D+
	 H8uflZ+9mEM+znHmJNrCwajh/EtJEpGIdygjuR2cis7ts5NVZ0+BUrVpgxWo+DNM9ai9s
	 wr2w4PjPuIfXf4wfjhYow1lcMVSKEaxTHYsnNY6g7PaNk8ZepzqtBAhPAjf6Gj7bK1zIr
	 r3HXGAHdwetNALQGCm/DrEB7lD7mUe5+D9Ug1m0BzcP4Xqslq7FlZ0mQiVsFlzSy26A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fp/hvtXgaUjxrG7cKgEV4RtTqB6tKZHK5KXKG3L+FtY=;
	b=vHpqcgZWUxRzMav5Ko/+plsD/3NW7mBM+0quLiglyQ4zKHfqEegMtDxFQxwEzGciv0T3
	 GW+lzwEZD/jdCF3amu2cpX0T1uTGIuH5co9iPrt6QRo8Yvv2czbHCLw0bM1aFTrUoq2Co
	 s9BvvxroIFT9Ayr+5vI8B0yScfl+8uC5oRDOx9T+JAGoaZrQNLw1kc4d5fEoMisMWdD8W
	 9MSRS46VIc2OZ09XVDLQW4Iun1BsQLhfo9EG515gNV7RyuT5UxTCzmssV7AJjRwwKHMxr
	 LXgr1biZcgFFWwVBVkLKOe16MCgCRpQkOb77SHYQRUZTzQRIHlIv6RsQhj4IAnrh8Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHZ006FX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A40606A31C;
	Wed, 18 Nov 2026 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHZ006FX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBCF1F000C4;
	Wed, 18 Nov 2026 19:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029452;
	bh=fp/hvtXgaUjxrG7cKgEV4RtTqB6tKZHK5KXKG3L+FtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHZ006FX7a033CFBij3/sjaObdXSolXPPfoonyHjmiktnFI2+y/vDK2CWgYdZwYGU
	 GVRag4ZBdA0K0X2uY1wzLttpcOd8Qk5MCNI55ghRTyPu+94bXvsf4HSmotZ+dCWlK/
	 u4pOxNBuAjJklxvSxwiAqGGVfKGzIkYuM3UNQ1Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0354/1756] crypto: qat - avoid OOB read when stripping RSA leading zeros
Date: Wed, 18 Nov 2026 15:41:21 +0100
Message-ID: <20261118150022.441757831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



