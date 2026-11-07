Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064029;
	b=BsyA5vTiC6l7zGby5pxTBbxhnFVF8qEs60i/Qn/cghAivS/0IPnsuy3W9gBaPt6/cJyo
	 JTfL7phQLW6pLcWV6BAOw6am0uaNP3rYPVD2naTnweCG4Xw+ssLL6xPW+Mk6aHNp9bm5b
	 1yBuj9NfG8pQfNoT3Q6dLbTB8FRFnUeY085CR4I7mWQ5fxLIDoCpU0bKSBhzRoM4xAOLz
	 b3eHYSreLULpmiX5Bue7zPAaE+wNoPFdCSXX7Wk1wyDIBwHYNkxI52k44ij1gHMmLJ8kT
	 gKEU4k/NrzGTy1Qnx0P8/qj8cPTSvnMjj+/ffoEL/pfj4uFmZXxT6yx2oluiVMCtB5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b8NzSoxUTfZpB8r7lbUQWi5dWJyD/jDXo5r+//lCAXg=;
	b=yPQYKaTqMFuV44Q2c7jv/0OdBtdif3HvNgUn6eOGuiiyFQqrFsTYbRRAtYA5dETws3ZE
	 74RJtxwui3Vw2sVcFeD44K33NFLwFLBDHEqRbCw+s6GGWIUflw2yResBqeffh93UKKDFS
	 E2ezbCFc/0uBjAMU15YCHzJf2FJweSzXUP0/4RAWode9w4yx0C1l7ye5aaYw0fQdAkwo/
	 iWUUqhhLxzu+X3C63utQthNNGMlQcxVB9fY5IJv2PUFNoSvhAm9d1uYIiwl9ccZrGJV49
	 RHPFpbEL/ztJ54TTiIM9I/RII7hfenHCNcaauV0r5HQZj2h3fVfTQkoMY1ljCldyJbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzYFyzIZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55C5606A9CB;
	Sat,  7 Nov 2026 15:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzYFyzIZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C551F0089F;
	Sat,  7 Nov 2026 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064028;
	bh=b8NzSoxUTfZpB8r7lbUQWi5dWJyD/jDXo5r+//lCAXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzYFyzIZ/2R0vF6FssIX44ugYGv0Cb6LgxsZapltIu3Gw7s8VVyfond01Mx3NkIKT
	 DmpOHBo/Ae3dv4eekYndZyWVjkFnUDy4tugmcdKPqGnBsUKmumEDkCG7mArQyCcCU4
	 XPNTofJC1EdrbcLDVYRTzymsEeryuGW8tTUOjUlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0203/1257] crypto: omap-des - fix crypto engine cleanup
Date: Sat,  7 Nov 2026 08:41:39 -0500
Message-ID: <20261107134945.157690043@linuxfoundation.org>
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

[ Upstream commit 5d69ed4cd4f9c68ff9a6ebb2e8a1079223a4ec6e ]

omap_des_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: f1b77aaca85a ("crypto: omap-des - Integrate with the crypto engine framework")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-des.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3b7104cb4487b..4b5a8d13f505e 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1082,6 +1082,8 @@ static void omap_des_remove(struct platform_device *pdev)
 
 	omap_des_unregister_algs(dd->pdata);
 
+	crypto_engine_exit(dd->engine);
+
 	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
-- 
2.53.0



