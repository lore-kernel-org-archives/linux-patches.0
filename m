Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059830;
	b=YHrmfpr1EeAmqQOpmeZKQd9GuND9A9LVjvULWvbs9XFIatXKXJDN/PzDVsX9p2M+WIzz
	 dkcujEvNVoLHxrqu9HuImrlzgeM3bN6VrAdeECEoDIkT/hwWy5wcXPWSKr8qHI6JV0hU0
	 +UMUnEwYT7q0Pd+cbgntAjUsZYLp0fQlh8Abq1sTM+WzZzeEY/ZILln1ZgYIbhwwhv+H4
	 iooeniNUvea68NMgDH098khYIqIwjZtmcvZIL0Xrnjwc2FpkmSzJTlQSN+M1Xm6LWEsyY
	 wESBE8xWBIjfqkdy3w/BaB4Za4whFE4A5Brp1mSOnnfTS0lHBSIQZ+X1iAcmJZ4ydqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tSYWmreZxto7PeUXrGY5RoVHdJ9D9O4W1zSmG0pMM+8=;
	b=VFCfS5Sj0VW7P6GV6N9uF/ye1Cq1NNStAvr+EFRlbbazjwxpVg0BvPSiSrqXehrv0MBz
	 5MTEL7wQrwdWlT0vOF8hg/6chwytUWjOgfX5tohsXXcc0G5KTfmW9VmfoNScI5ARE2iPr
	 KJZpZ5Jc0+yqplIBOEX263OAUDJEzcZjPvr7V9ZCC2yQpyO3zCo6HvzrLz7zsNNdBQHQs
	 CQdtGawuC1jvcTbDj2SEVqUmkxdeZTd2XQAlHHBmiFutknCZFzO3G6dtzgADwtTPo/Wrd
	 rPXExZVZoNyICN8kxQI9QXzPzi8Xv6nDQ0MYX09G9b4XSK/6PmPPYz9zDrZsx7v0YWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wl0Xbxkh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B0B606A320;
	Thu, 19 Nov 2026 03:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wl0Xbxkh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE681F000C4;
	Thu, 19 Nov 2026 03:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059830;
	bh=tSYWmreZxto7PeUXrGY5RoVHdJ9D9O4W1zSmG0pMM+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wl0Xbxkh1aYnkpsgNIQDMbLuh8u6oO6H2uVErqn34nbzrNLF1jFUaTchi5QgyvQDK
	 EfY4zxL3upSH33MYGRBBPpdlEdxC+zp8WlJVkWIAxnXPWaOHrK7+5T+W3HKpnscqUL
	 NdyXUQsjF2GuqIT+kR2YpcvjuF16oZrPdZ4LJBQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0983/1848] crypto: omap-sham - fix crypto engine cleanup
Date: Wed, 18 Nov 2026 15:50:21 +0100
Message-ID: <20261118145958.065710248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5a57617441b81..b2e1617474553 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2223,6 +2223,7 @@ static int omap_sham_remove(struct platform_device *pdev)
 					&dd->pdata->algs_info[i].algs_list[j]);
 			dd->pdata->algs_info[i].registered--;
 		}
+	crypto_engine_exit(dd->engine);
 	tasklet_kill(&dd->done_task);
 	pm_runtime_disable(&pdev->dev);
 
-- 
2.53.0



