Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064030;
	b=coNtJSfjNpMG1OwAPa+BwSs1yz9gqEl3ClM3VgOT4N3ZWKCm+NC0/5nAI3z4U7aNU1UZ
	 jkr5Ew2O5vmyfOuUFezmVtRhVVQN6D+WFj8rfZ1h6wx3qSmAJKnzH8JiqD40zaZvXKTRr
	 9c3hePQUH0jO9PZQyRyMB/kYppYjKc19RG3TRDGrIE1qX+R4jizn+TbK2zKR5Otf5NHe4
	 BHSFvmxJkAN9L6EsShOodI/bMWkLKf2rNSNfQQFT0u66vgvx0HehovunfehUrkF+tbYBc
	 KRNhSHwy2Ln4FSKOWiP7sKTLw0txne8A/i5wXrID1figsmDwUDXIfXAKx1OV+QfdsQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dgw+nBP+gaOFTFtOaFvWixlMgUiZCJ+HL90ukcnLDsQ=;
	b=NjAeyrvVaPEczgy20Z+CvBw6aTuvoOF3htd/BDYDTg8q9QwmivqEr/n88vvzQycieNvG
	 JV9RgssENFC5Xu5eQfKSEsAuA4OpfYg0DUwdCHZu7wOX/O8C0DVI1qT+ipPLCvE0qx2v2
	 6adubZfVTNeqH6MnIAk2Ffx7qDFbGk4a7x1LYB+6l4xBTz2kVuw+b4YPVg1Z4Par2hbjw
	 6auKJ77nQgKYuNrXtHgxsr2C176KKoq/7BSd1e5aT1YAvOVf6DGnSL6HPLmW4/RBB2j9D
	 i8kxzEpiZtPPY8OOEH9G/rmeEfkfX6ODezvilLmLoKXjBtOZG+2fKbVTeUi8fFrIROg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Htcj8t3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D539C606A326;
	Sat,  7 Nov 2026 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Htcj8t3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833951F0089F;
	Sat,  7 Nov 2026 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064029;
	bh=Dgw+nBP+gaOFTFtOaFvWixlMgUiZCJ+HL90ukcnLDsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Htcj8t3ZFyPEz6DGfzZ9wD78SqeNMB/ROaONcoumSo2j0pZF55zPW5lnX8JGECrBU
	 TUfILuMY+btN8d7an7ZEXWwZW2fdV3qJMw7F8Sb1qqitTurdQwintq+HWl6x5OiNVC
	 tJ0epvZI11hNkCxG1ebcHWwqzDfLLWtC0NF2L6lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0204/1257] crypto: omap-sham - fix crypto engine cleanup
Date: Sat,  7 Nov 2026 08:41:40 -0500
Message-ID: <20261107134945.181636885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6d2dd0b88f151..207fc7680c8f8 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2129,6 +2129,7 @@ static void omap_sham_remove(struct platform_device *pdev)
 	list_del(&dd->list);
 	spin_unlock_bh(&sham.lock);
 	omap_sham_unregister_algs(dd->pdata);
+	crypto_engine_exit(dd->engine);
 	cancel_work_sync(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



