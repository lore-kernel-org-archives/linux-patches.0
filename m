Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054164;
	b=20C+aH1JbXZt0V7tGjGzxYW1zhqmy84OlFPru7lt9fzgnka0ZHdAgdBSXWxe7mSTzLze
	 TzI0vSAJjzEZdcVhCsZqqw3Bp3A+/3BVS0+nrroNeROhDJjQoYIpqQANLgdAwPjqkDuDh
	 IW18ytAndBh/LtpNhUpDXRndx4y5q8s3Mzgk0kV6DsEpo+5jfLq0GqbxnGw72f2XlPur0
	 NS/syulFhMwBmt5LRlxPek+0IBGb4tWDXs4frBKxeMx+Dduj8x9zo09SE1oeaJgDVpDoQ
	 4XYDI2CAISKSN4umiQ6G/e49NjUn3dbWQ8Ua/70H8htIFN2lGHgjwR6ytEBoJkVTYVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hJ773FK45zx4vuySWTvElUpmB3pdO/LsSs4D9wjWWO4=;
	b=F9AdGXxsvRGVt1TJaKHCRgVsnbBFSRdzgM7soajndgOan4Z+GKFEOBn1ZQ3Y7038u1/E
	 JDinjNnqqzIdJ+3ZxGst5A9rlfD3v3+cz9qe8NsU3CCtpsFUiS1Pm440mL2SjOSsnPtxV
	 xSXLfMd791xJ/cJthlngnrn5nNexPR172b/BPoAC4QixSbctxo5LGwfS2oJsNBHaUbBIs
	 G2r7YoNL4fquo++931xJYhMIMt+PNCpcGCZcsy1QCtlqtPYrF5WLiAtGvF9yx3VQjN+BB
	 2/hlPmZgm2VqqDXGYDKvkUKum7ltWDTG87qlgpk1JORXJNPy5F0RlHqU46tHk1Jv5DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZYxFnyh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4943C606A325;
	Thu, 19 Nov 2026 02:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZYxFnyh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5A31F000C6;
	Thu, 19 Nov 2026 02:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054164;
	bh=hJ773FK45zx4vuySWTvElUpmB3pdO/LsSs4D9wjWWO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZYxFnyhMjidXz3/blvkRdrRc6Ea4qTPYz4b75UG8O62pzubCrhEzfEqeklfY8t8H
	 oXP9acOjNeuJmKSd+fmFmmyHFS3ZSyfoHNn/hcxg4jYRrymSmFuYp/BEGkONXB7K+1
	 dnEM2fCF5+3tJ3ZAqlUMuFBtExRk6cSnk/OMah/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1177/2214] crypto: omap-sham - fix crypto engine cleanup
Date: Wed, 18 Nov 2026 15:47:33 +0100
Message-ID: <20261118150059.050226050@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit be51ea091c6563158531e8c74e040552fdb1e28c ]

omap_sham_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: 133c3d434d91 ("crypto: omap-sham - convert to use crypto engine")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: adjusted cleanup context to match the existing inline unregister loops and tasklet_kill() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 4ec6949a7ca9e..49fe472c82c99 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2208,6 +2208,7 @@ static int omap_sham_remove(struct platform_device *pdev)
 					&dd->pdata->algs_info[i].algs_list[j]);
 			dd->pdata->algs_info[i].registered--;
 		}
+	crypto_engine_exit(dd->engine);
 	tasklet_kill(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



