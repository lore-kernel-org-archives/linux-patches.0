Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055154;
	b=TMBjXz0zooH4DvTa/y6gQ8DbQg2jpMToFFot15ozIGhn35dMpPVqdUiM51XOMKfArWBt
	 /zqLCZ01O86A8w98ZumOHT/G9ICi+EVSgKYA25gvs7EzOntcm7dl9dld9ReYK55o3/6kQ
	 okQtkTVZCzMnkHHXWRBrOZWKstG0cOKHMXZje95QdWCpSAgCNvcDDGOT0L8c3XIxqoDPJ
	 Tv2YMrcSh71ASRWXOhY7RJHrenYJiHHn0W3kYeXiPxweigT6CyCIEdS9188FCFjCnoH0V
	 xXkVoEMRMVEdnFuVCsgbRZYwDhE4mcq8q+DPRUaz8sC2RijNT+gRaceAwLkk75JrsXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oc0w483V3lfhA93oXSUQ4DLnnsFPRe6OX50bY//xRkw=;
	b=sKyJHmLlwvFosl8yh7liRmZYi7bRolsM/DCIAZXfbOAH2H+IFmDKgWtnuAGLtqbohHTl
	 rK9n18L/R6Y8HmpH06GBUVPFkO6glC5cnTZIBk2OBERggOFBQOH0AXB1kf+zsWohdX+QS
	 av+b9rYqarnF2sY2xZ+4VG4JO+7N4nJ1NAtNn9ysSZaIrjzlVJmY27V+MkpOrpjo9WKZn
	 miT2KSTG2AstoW5eEmH0PulsU4v8ZnelWx4pQL84wxFJktySV5qTnMkmKKuxfBJH6IuFQ
	 UBEcy/6z4DjFZ+RJNAoJkvNuqF+D98HPq5o2vjCnlK2V0CXuNi01KEzPJz6O/mOhNTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwG6pYO5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6787606A325;
	Thu, 19 Nov 2026 02:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwG6pYO5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BC11F000C4;
	Thu, 19 Nov 2026 02:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055154;
	bh=Oc0w483V3lfhA93oXSUQ4DLnnsFPRe6OX50bY//xRkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwG6pYO5qzcHjHkelZdNgJZEzcWmtKmWEc6OeuDlZ4qscNczP1eal0esBFwSR4tBJ
	 vXdSc360LQ0C0iruJUiysrvYRqU6uqjrnIFutMHdy/WN5uA22xP5D06GqBhacQ3XV/
	 k3m96dgGHODW83g2Ux60rED+HQSpyzwQxyEmDVJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1530/2214] crypto: atmel-sha - reject initialization without a device
Date: Wed, 18 Nov 2026 15:53:26 +0100
Message-ID: <20261118150113.394200331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit a9a2152d292fd0bc73814eb4a127278ee7dd3f6a ]

A transform may be initialized for the first time after the last
device has been removed from the driver list. Return -ENODEV when the
lookup is empty, before the debug message reads dd->dev.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: ebc82efa1cd6 ("crypto: atmel - add Atmel SHA1/SHA256 driver")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 1b13f601fd959..6eea72ed92669 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -430,6 +430,9 @@ static int atmel_sha_init(struct ahash_request *req)
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	struct atmel_sha_dev *dd = atmel_sha_find_dev(tctx);
 
+	if (!dd)
+		return -ENODEV;
+
 	ctx->dd = dd;
 
 	ctx->flags = 0;
-- 
2.53.0



