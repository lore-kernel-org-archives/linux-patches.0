Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CB617CA12;
	Mon, 10 Mar 2025 17:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628835; cv=none; b=oZVt47WOXpGhsGbvzudUgGytz/2gmNDD0vEmXUTDt+9pljoUwSCuc7dJrjQ2n8ZO545q9goG/4tu2nNWVMYo23YWnTFivn19u1d4FkAtgGVCiPr5v4o/t70UhOlyOQhDQQEtPbJxhObWtKBTL8yXHvEMyEHIolL9OdZ9bnukcLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628835; c=relaxed/simple;
	bh=G9yyuew9FZAiAKVtFkhZAtOkEHT+22edJWh3nTf4Nug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMLlNQwQ7HGJR2xdK2pkqXjkdG4/W72TJYDZH5qQGjgEct5n9In4E9XE5KNFMJ5kdkIet6qC979U326n0IOzVbzeDvVmc7Z4PekqzriHz7mYgG1CKUqEtxbq/2bnfhiFgBTtn6kLpqFbPgrBSpmdmLyhZdpFY2okuB990jSjbkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOwZp46Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOwZp46Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC208C4CEE5;
	Mon, 10 Mar 2025 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628835;
	bh=G9yyuew9FZAiAKVtFkhZAtOkEHT+22edJWh3nTf4Nug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOwZp46ZegKlcXNAGT8JZGc8JBXm+suBE7aWPMFoE/UFH3v964YN+SGlxVy0w6fKw
	 lsKJzl0ILCeG02ORQfZz5a3WcRYfk7dSQbnvILMyh2uu86cgcIBxeGJZUIsl2iBEm/
	 6mXSUzQjWxpxYg7HHbfPbHESqHHpv1O2ElPoIbdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Ye <yekai13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/620] crypto: hisilicon/sec - delete redundant blank lines
Date: Mon, 10 Mar 2025 17:58:52 +0100
Message-ID: <20250310170548.977349009@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 0413623c27a380d0da7240717f9435d24776b985 ]

Some coding style fixes in sec crypto file.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: fd337f852b26 ("crypto: hisilicon/sec2 - fix for aead icv error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index c8fa964238e7d..72e26a4bfb8e6 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1674,7 +1674,6 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 					  aead_req->out_mac,
 					  authsize, a_req->cryptlen +
 					  a_req->assoclen);
-
 		if (unlikely(sz != authsize)) {
 			dev_err(c->dev, "copy out mac err!\n");
 			err = -EINVAL;
@@ -1961,7 +1960,6 @@ static int sec_aead_sha512_ctx_init(struct crypto_aead *tfm)
 	return sec_aead_ctx_init(tfm, "sha512");
 }
 
-
 static int sec_skcipher_cryptlen_ckeck(struct sec_ctx *ctx,
 	struct sec_req *sreq)
 {
-- 
2.39.5



