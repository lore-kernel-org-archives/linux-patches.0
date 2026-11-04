Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831222;
	b=4xIqQvz4Gj37QA5eBlau5MQNWtcQuHZ5Jbx0u6YDmNHrf9/WCXUQUl4IWnifdwsQYT9v
	 aQXjZ2y5Xba8TGwf/ewQfVPptT9VZCtGffdOD8QlwtboqQ35RSSDx+uhVi4/hDhanyLxQ
	 MxeP/s9oHyBsPcUdm7OhnmYArNCGG0UiwhetL4A5YjcS0HdWJvvb7VRFsiegmUPke8YjU
	 hqSSJJDPIh6UfctPBQZJehEScARzkpWffceijL1y3VV4+gGC7K5ssOrhM9SybYySDQOB1
	 Zyrq/vLRiZga8OVuCQsIA01w/Qo9C1N1NrwLgLzr/munQN+amJ2lwUid6kBad7iBCOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MBe73FLlyBka4dDJ7zIhaOfYAB3GlYwsdKw4UTsIPP4=;
	b=YiKf3ZWr8SJCXD04jhoXAw46LDr2bXULnH6YFt1kEc4XPzge2RCvEO2qI2a5a6PadE+D
	 Z09djeBoE6+eHlWFevOmRP7FntEwoO840S+Xg0VJ0LuL1WiwGDGr7UYRWZi7KfLopXpGK
	 8m4vEZlgYdxlOURwAfE06XThB1lgnv5EmPmjKnVyv86STtjw+nE5MU3ZGglq42MZfuHrg
	 7q06zCUYwaqJ/Tf5YnqvGzWpx1mLYApkU6/7z8ZpqOersdO7y6jP9kLD7B/kmr2hVNj6d
	 sD71dXpNyo41QDBgO78unVYsJgT5Q+eoRAtas9YeNB3EdCqZPFqLgEX516zNwT64enQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcfCQxYi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB91606AB30;
	Wed,  4 Nov 2026 22:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcfCQxYi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ADF1F00919;
	Wed,  4 Nov 2026 22:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831221;
	bh=MBe73FLlyBka4dDJ7zIhaOfYAB3GlYwsdKw4UTsIPP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcfCQxYi/+8xiYL/dVDE10iYFwVJJUs4RtD3S731Rxun4sYfoaoQJZIbjkhyaFEYs
	 rna/eHQec+QR/n5A8/MxuPtkB1et7GdPegJiDWlcLG1kV/s7lEepJJEO80UJFzrkPu
	 FN91TQmX/LFn/0+fwrIp5CNh5hNk8CJ75mYm62nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0573/1005] s390/crypto: Fix handling of EBUSY in PAES when req is pushed to crypto engine
Date: Wed,  4 Nov 2026 16:05:06 -0500
Message-ID: <20261104211059.922729558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 3fec882c33d9b61983ee31456777f623dccd1a35 ]

When a request is transferred to the engine via
crypto_transfer_skcipher_request_to_engine() there are two return
codes signaling a successful transfer: EINPROGRESS and EBUSY. However
the correct handling of EBUSY was missing and has been added as a
return code indicating a successful transfer to the crypto engine.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
[ sashal: Dropped the bool tested = crypto_skcipher_tested(tfm); context line, which this tree lacks, so only bool cleanup = true; is added in the four paes crypt functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/paes_s390.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 5198a99ec30ef..d5abf606e6f48 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -458,6 +458,7 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool cleanup = true;
 	int rc;
 
 	/*
@@ -489,15 +490,17 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (cleanup && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -715,6 +718,7 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool cleanup = true;
 	int rc;
 
 	/*
@@ -746,15 +750,17 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (cleanup && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -1036,6 +1042,7 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool cleanup = true;
 	int rc;
 
 	/*
@@ -1066,15 +1073,17 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (cleanup && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -1462,6 +1471,7 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool cleanup = true;
 	int rc;
 
 	/*
@@ -1493,15 +1503,17 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (cleanup && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
-- 
2.53.0



