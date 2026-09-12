Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964A5349CE2;
	Sat, 12 Sep 2026 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242352; cv=none; b=tf9V55wjc90c/0qbWz491tdunhV6cVM3REDsArF4N0skgtceOw8y4454NPmXkd4PVSpz1BZk9csIfSdA4eDFf7mA1oKyXmJgktVLLtGPBXFcv+P4anTmw9VJd6tj+93DemZHL4oDoloOtJrA4pwQVCdt85Da7NzBGURiXy2MjVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242352; c=relaxed/simple;
	bh=mrD8o4WTGwg3MY4ZxR4OYb00U0rCtODhZwbz/YW33ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSLyVNURQrrbIiTw0jhsOCzlxKWJhkkK327xOnyuKHjNJjaVdhWtOuFe3Ubw4O952B4Yo8iVWRiW5liyL3+aZeKp0gTY7KGduLMEkrllm/HN+ijF3nofDlOjRkn/fs3mpXAfBKtYkArgeoxqS1tW5RmIWamSZ2q9L7Yzo9hhzTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRMLVY7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRMLVY7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93C31F00898;
	Sat, 12 Sep 2026 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242351;
	bh=lhIwhbjXN5kNI/A2/7G8IunxX+LByVfDfHLSv6YsBv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRMLVY7uFD1tQ9WeUHtQFSphPt+K+KG7Gaia/Vwsy1BEyKQ/J0+KTyabsSqit34WO
	 hRLrzsKwKY+cIRDnziOS5WrqQaJsitD9GVR8U+rFY/6t8OkjUJoJP5lzTJzhTKsKl9
	 +GkOhASgA7z43+GpJnlbXZ3B+coOBEfY5VCanN8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Laight <david.laght.linux@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 371/798] crypto: atmel-ecc - replace min_t with min
Date: Sat, 12 Sep 2026 08:59:59 +0200
Message-ID: <20260912065525.659097038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 5b085b2a038a1458f9398cb3b3b03cba6e38e1e0 ]

Use the simpler min() macro since the values are all unsigned and
compatible.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: David Laight <david.laght.linux@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f240f9b588f4 ("crypto: atmel-ecc - reject hardware ECDH without a public key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 004d87cbfa221..e21466dfd0753 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -56,7 +56,7 @@ static void atmel_ecdh_done(struct atmel_i2c_work_data *work_data, void *areq,
 		goto free_work_data;
 
 	/* might want less than we've got */
-	n_sz = min_t(size_t, ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
+	n_sz = min(ATMEL_ECC_NIST_P256_N_SIZE, req->dst_len);
 
 	/* copy the shared secret */
 	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst, n_sz),
@@ -150,7 +150,7 @@ static int atmel_ecdh_generate_public_key(struct kpp_request *req)
 		return -EINVAL;
 
 	/* might want less than we've got */
-	nbytes = min_t(size_t, ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
+	nbytes = min(ATMEL_ECC_PUBKEY_SIZE, req->dst_len);
 
 	/* public key was saved at private key generation */
 	copied = sg_copy_from_buffer(req->dst,
-- 
2.53.0



