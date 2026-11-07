Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061981;
	b=uQMM5S11ytN/x6QZDkgF6TQlC7GzvtdHX3Y1REjxH7HV5xdRhhXCTedyLnsG/BZli9WO
	 +XVZ30o1vjFRgEeMdHR45IwPCbC4blDzcX5MJfCVZTsjyHYggpe56SoOvuu7HsmhxOhWa
	 ElaGQhomiitbfNg1E+XmoQc2MT+Tk18aB8j9mUIQV2dBFEuPHVYDCnZ8TCg258b91vm0S
	 B6uKja6PcdSuJBMtdgtp6maPGpGL4t/tMD04JmSYeq955+b3Q7wGedRW80IoOpdk5nEUw
	 RkBLMxeQdEDHxWoqauQLv0CNp9VQNNTHAnJI2nC3ol4rDbs7/kr7VBLdiOb9onV55hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MRLOnt6i5yNva4yYnjdZu4nyM9rJMLW+70z4IHiPBAw=;
	b=rA+X/vX94qQ+/flZ9zjCIuvG+KAPU2hd4Zr+LKwGNTb0/Dv5g2UB7FTN5Eu0eQzOP/rH
	 P2wQU6OKI+MNDHoshJ/Onz+8UAg/PtbDhB3a2jW31RdPnKertHnL8rddkFocs/iBtpX94
	 VXBrIEfPK7wEpFjeXnnZFqWoGBQpp8FHmm74jzBri4BYz4RrLFYYE2QorBw0l4vBvq3Ga
	 6GFKEhs0lLsEQgo6XLdqJBDazgakLBqN/BacOaj3CrbYbxvxrjlVPM7l9d+qUc2MXv43O
	 N6EIcQVGFP2cdhvLUKiTQSHoMIM2aIEPgYvW4Bt0hsP+Y2uPUCnlqSQl8+vFZJcAXJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3HvEOTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF5C606A333;
	Sat,  7 Nov 2026 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3HvEOTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645541F0089F;
	Sat,  7 Nov 2026 14:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061980;
	bh=MRLOnt6i5yNva4yYnjdZu4nyM9rJMLW+70z4IHiPBAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3HvEOTpevsD9dJvkEFeYt6VAz6hsXtwMs6WHaWZLnzFVwTqJX23QpSQLSMexlKj1
	 LuPQdrUBcbDVvSWAvEchzyniTATLTjCXI4WsImGrVlCZ3scMO5MZeguEkcpgUtGJDc
	 VBAC+1E2uIBPyYEyTUhYeDR0Dah0lRCBdgNtNMYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0974/1536] crypto: atmel-aes - fix AADLENR for standalone GHASH
Date: Sat,  7 Nov 2026 08:49:50 -0500
Message-ID: <20261107135025.003613472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 0dd8cded0e6f8c9635fe1d79d60dc7b2599b099b ]

atmel_aes_gcm_ghash_init() writes dd->total, the request's text length,
to AES_AADLENR.  But the GHASH it runs hashes the dd->datalen bytes passed
in: the 16-byte length block, or the padded IV when the IV is not 96 bits.
The data sheet requires AES_AADLENR to hold the length of that input.

With empty plaintext and empty AAD, dd->total is 0 and the tag comes out
wrong.  Later requests only pass because dd->total still holds the
previous request's length.

This is testmgr's first gcm(aes) vector, so CONFIG_CRYPTO_SELFTESTS=y
fails at boot:

  alg: aead: atmel-gcm-aes encryption test failed (wrong result) on test
  vector 0, cfg="in-place (one sglist)"

Without selftests the broken atmel-gcm-aes is preferred at priority 300.
Seen on a SAM9X75 Curiosity with 6.18 and current mainline.

Write dd->datalen instead.

Fixes: d4419548dba9 ("crypto: atmel-aes - add support to GCM mode")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 5d35f6de452b7..6a29656f3951f 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1272,7 +1272,7 @@ static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd)
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 
 	/* Set the data length. */
-	atmel_aes_write(dd, AES_AADLENR, dd->total);
+	atmel_aes_write(dd, AES_AADLENR, dd->datalen);
 	atmel_aes_write(dd, AES_CLENR, 0);
 
 	/* If needed, overwrite the GCM Intermediate Hash Word Registers */
-- 
2.53.0



