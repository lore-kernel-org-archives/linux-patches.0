Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044003;
	b=283ShgQmPNsb0bCGHJb+gHNtnNEpZZkuaBzZbYGXevUNXKkJbWiTjkUx/bEGSVrloL6m
	 2XVZiq4LwPzEvMGblGxSXvbg6XQUT+BcYSGOWWkDDbc3f9H6Swk6Nf0k1IF2+1+nYijNn
	 AkfNfpVTwabasWpe8MAwb7OOKyx/f34d2Vm6c02wqAsCxzvqre2kkO0+8Aou7e2uqktUn
	 1i2IeTTdrtXDwPvv7EkYPEXKVFMULgOrQxvR7F4VM7ljEn6QQrpEeDW03OkogRaoTz7IN
	 2DGY/MzWl+TA/DbnTA5uygf0kBO00yCx32Ith/1jRAp9PDgF6aUsr955QEN1SF5Q2+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MPDzfv7VSrkCXb5204tmC3VrEy5MJlYhwclugF/baRc=;
	b=2TOkUXqt0Fo75VsfBeqlIlqdIgklYPUKaZ6H4y/49mRwk8P9Ns+schpvhmnUyy800fmP
	 NePo1oZtnPPwVsysV4ui01/oLow5IEjlgf8WgDObyoqKAcI2B80QJecUgh21HMOxqX14o
	 rm5Rusgt1oM38VVh9CAw7TFIwyXWssi3ogD85Jqg0GhwyxX7ugHKJk7iRrLtMQem4/fTj
	 IbMtpDrvlMXGemDlidosWUNR1CGdUJWN8P1oVw8SyTVLJN/cDRVB1IL/u3JZdD8e2Cvnm
	 iA+H/JLviqbsrJhwK4f3WbV0MfeQyinYh4m/V+mZ8gnryxKhhFGZasEZaIGg0v7u0Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G39e2+t5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A84D606A32F;
	Wed, 18 Nov 2026 23:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G39e2+t5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1DF1F000C4;
	Wed, 18 Nov 2026 23:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044002;
	bh=MPDzfv7VSrkCXb5204tmC3VrEy5MJlYhwclugF/baRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G39e2+t57cQ3JBG4CtBBvY+vCWp3sTjGCOYlHFvl34ayc1cP0sLwMjM1O4Y5cu1n8
	 bevyHEjTOFrueD+b61+icyGRNlR6bgchaXcClnTkdoF8KgB4iB1pGTJmVVS0nu+gu4
	 8jOnr6i8ii0JweHvFwFwGIFg0Pbe2P6oVIch0Yvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0410/2857] s390/crypto: Fix skcipher_walk return code handling in aes_s390
Date: Wed, 18 Nov 2026 15:24:04 +0100
Message-ID: <20261118150216.149562171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the hunk for fullxts_aes_crypt, which doesn't exist here, and applied the remaining loop and tail condition edits by hand to the existing functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/aes_s390.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index d2bd676502741..b6760f032e51d 100644
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
@@ -465,7 +465,7 @@ static int xts_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 	memcpy(xts_param.key + offset, xts_ctx->key, xts_ctx->key_len);
 	memcpy(xts_param.init, pcc_param.xts, 16);
 
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(xts_ctx->fc | modifier, xts_param.key + offset,
@@ -581,7 +581,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 	locked = mutex_trylock(&ctrblk_lock);
 
 	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+	while (!ret && ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE)) {
 		n = AES_BLOCK_SIZE;
 
 		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
@@ -600,7 +600,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
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



