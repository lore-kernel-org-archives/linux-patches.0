Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034680;
	b=Q+PqQvxxOjV/3ifOVWJoauxAZKXLfwTcjCwL/TmMbN0T+KUr/fIbL2oKLgwgmwxK3cJx
	 RUUXG3kbvaNZsYT6f/rp07tAP+jOiw9891ldbqItX0vzF2841BxNF/Dcyz914Y9Bou5tO
	 X/qnkq/yLQ1TsHWWWi5L3NlyCjxgPn8O9JXRdGDyJI+Zj4Fov6MnN/oew+P33wJ9EDyyW
	 srcH5xfiG1mzdOUusXl3dYtlAvCxX8Sug7e5EIdK7m/oJh3zhNFukK4H07dr1rR0nzxX4
	 4wcjgvVcOwAQ18YPX8Ay8OkXGWofgLERP1DyHDLdD5GEPRsiTjGwXUPzjjYU+k1gebA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=edXj/8fakJKFqcr7FGq/w25d7Kszx19o1g0/oIXnPBQ=;
	b=G5001HrFxf3Wmm0Roei87AKseQIG8RasZ50iFuq6v+EWMJH11rvFWycpD9SEtR3FEewg
	 oXMzcEjMP+lRHQ8JVaPJLAk5z5VYW9zm3w27rTIdhNsPEYGIC3YptV05tjd8i9QQB8ul2
	 E32L4+PVG3AIcje/uQfAv0+k//sA3r2GQwt488qdenjc6IdHYinbkwh5iZ/r7WDv8x/rM
	 BqLmcmu0THYFV/Hxv9JRLy+MmC92gh4fCEzjDgbG4kUd4qHoQ80Zj4p0ubu+r+uPDacdU
	 0i53OMoizDzHRe9RinFM/6zG7d/AVqr/MDFxRgVoUXSIDmiB+5qbbyD/nCZrVY4hlrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IDGQ6/zQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297A5606A325;
	Wed, 18 Nov 2026 20:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IDGQ6/zQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FAD1F000C4;
	Wed, 18 Nov 2026 20:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034680;
	bh=edXj/8fakJKFqcr7FGq/w25d7Kszx19o1g0/oIXnPBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDGQ6/zQiuikcWdIGrexdo+JgCkSa/zxn6Df/k9K9ws82GjlTBeKH4ZXteHxcnE+v
	 1qddqXLlZH355XUstGcP9wIP+WKR96XIbjHyIfygS3/nXxMjE015DMWa7WkBN14+aS
	 7YVfsUjldysz0CKARCg2evlNMbPEQua/LjiyNbEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0455/3318] s390/crypto: Fix skcipher_walk return code handling in aes_s390
Date: Wed, 18 Nov 2026 15:17:57 +0100
Message-ID: <20261118150330.446616452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 15fa028589c3a2545f0bff355eff06d5844196bf ]

The return codes from skcipher_walk_virt() were not properly checked
before entering the processing loops in ecb_aes_crypt() and ctr_aes_crypt().
If skcipher_walk_virt() fails, the walk structure may be in an undefined
state, and attempting to process data could lead to incorrect behavior
or accessing uninitialized memory.

Add proper return code checking to ensure correct handling of the walk
initialization and walk advance and eventually return to the caller
with that return code.

Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
[ sashal: Dropped the upstream hunk for fullxts_aes_crypt() since that function doesn't exist here, and applied the five remaining skcipher_walk loop guards unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/aes_s390.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 8a30cf504099a..aaf0afff80900 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -231,7 +231,7 @@ static int ecb_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 		return fallback_skcipher_crypt(sctx, req, modifier);
 
 	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(sctx->fc | modifier, sctx->key,
@@ -335,7 +335,7 @@ static int cbc_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 		return ret;
 	memcpy(param.iv, walk.iv, AES_BLOCK_SIZE);
 	memcpy(param.key, sctx->key, sctx->key_len);
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_kmc(sctx->fc | modifier, &param,
@@ -461,7 +461,7 @@ static int xts_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 	memcpy(xts_param.key + offset, xts_ctx->key, xts_ctx->key_len);
 	memcpy(xts_param.init, pcc_param.xts, 16);
 
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(xts_ctx->fc | modifier, xts_param.key + offset,
@@ -577,7 +577,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 	locked = mutex_trylock(&ctrblk_lock);
 
 	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+	while (!ret && ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE)) {
 		n = AES_BLOCK_SIZE;
 
 		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
@@ -596,7 +596,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
-	if (nbytes) {
+	if (!ret && nbytes) {
 		memset(buf, 0, AES_BLOCK_SIZE);
 		memcpy(buf, walk.src.virt.addr, nbytes);
 		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,
-- 
2.53.0



