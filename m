Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B082B9D2;
	Tue, 23 Jan 2024 00:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970693; cv=none; b=HwSoJ58qASVLsn8Rtybc6RdjHD71AyVxlu1E/rEApLo7gAP4rKG53SivRmYCyu85wcInyRQNkOzXjIn7uctIChZkOsR/KsOCh0qCWP4CXIFsa8670UkzbccNKbHrr8QA1TiIdNkjGkpy6MkT9pHVxfUPjAI7DNwMjUhGKwddIe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970693; c=relaxed/simple;
	bh=P+faAJQBajYwoFFcq83PJyjfi6kb2DhnVtok9YXDmsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWCcHvV7NzOBY7/OloUII1hDdWH0lS4VhOWnfa4MP+TooCqWy0BjJ9Ki3ApKbg/vU7wXR7xrm69Sw8npTdjmfDYWK2kX8GpogzyFdsKKGEH9Zbyfd9XTIb0zr70skw10LrUtlMIIIFd8tQ+5HtTUYZkhH1nGlPu9d3dep7AJsiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeB/K8JS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeB/K8JS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB6FC433F1;
	Tue, 23 Jan 2024 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970693;
	bh=P+faAJQBajYwoFFcq83PJyjfi6kb2DhnVtok9YXDmsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeB/K8JS03ej4VpOBPjX9HegcLoTKmjD079oBhSXk9L3DrHw5KUj3V+aE5NGNdcYL
	 9FlrhiMGnjK/DGG9eRbfMZsNevP6LYgC0/v7CwwAna1NZW96HWn0qWIqPC+T2JAmrJ
	 LZMm4vwNQJMnd3LNMf1DBFQjRGcoW+xXCjjfqhRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/417] crypto: sahara - fix ahash reqsize
Date: Mon, 22 Jan 2024 15:53:45 -0800
Message-ID: <20240122235753.672506710@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit efcb50f41740ac55e6ccc4986c1a7740e21c62b4 ]

Set the reqsize for sha algorithms to sizeof(struct sahara_sha_reqctx), the
extra space is not needed.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 4b32e96e197d..6e87b108df19 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1163,8 +1163,7 @@ static int sahara_sha_import(struct ahash_request *req, const void *in)
 static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct sahara_sha_reqctx) +
-				 SHA_BUFFER_LEN + SHA256_BLOCK_SIZE);
+				 sizeof(struct sahara_sha_reqctx));
 
 	return 0;
 }
-- 
2.43.0



