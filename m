Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590775;
	b=bDEv7xb873f8EiCdRWOCl86m5RNQGczEf97Q1fktD2WRbhxd24Pwcr4HhJYKiJvCUmSl
	 VLO0MsmDK8PPm7q7ovXY3PLMwCctHpiLand4/m05l0X9eGgQBfhptATVfue577aFh7ggS
	 HIvr50uRc2XW41cJGMyU67C7+di+bAMilmwO+ZbmYcXXA5xCrQO1X8PfEOcJ145D4UaQN
	 RW0S68134GuNrL6xSJ8DQerd5j3ldxPLiGw54xGD8ltOPh/M+Zi6jJz/DYgWTXApgVdV+
	 RwFPNAVhLUb8gWrWGJ2cFpcPzKirYPjpIveQp8jwDfv9cSbeZ19FsQOEH54cDirpEvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+oA0mEjk4k+ptOg2Tkulso+gh0GKEn+KkQcH0JhU8yc=;
	b=muoC+4cEpK25Jk5k9+b6XvQjkGpn5EvWY/EZrHwKmNaGcx09uuY/0XMuvcAD0dngE+xJ
	 ec8bh+GfqG731o9JFV3w1YHkNlXi1XTUK+Y5+NYb/LxHYzdRj/pU1LlZH4Nn+gceKDKK/
	 XLQQibDoCPiqj7NUR0rSb7pS29VWtwnqMvaQ7r4QCPtf5LKjB8TPkkYBaQUa1fRLbrzBX
	 /abXBg7sHzN1UnuybIRctHuWkgMDjFMm8qKKK/upb75aq4G0vdoCOTH8f9UWOWZgLFS9E
	 cS0icXU/lBaQvbTWJRySSUheMmy3TRS0OcNfTJwODfJPWQBzyqVJ0IELG6nCrxaHLyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0DmM0Ol;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42A7606E20E;
	Fri, 13 Nov 2026 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0DmM0Ol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED851F000C6;
	Fri, 13 Nov 2026 17:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590774;
	bh=+oA0mEjk4k+ptOg2Tkulso+gh0GKEn+KkQcH0JhU8yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0DmM0OlN4b8k3Ixzdisx3lWjfUW5haOQkc7owI6kgnkAq7eUTG9aY//rZvQ+WmdC
	 eoIVqrNgU0UjipqC0J05mC+74k9uTg730vHs5AzWBuVXT03Fy2cI4NFKlsJ5/nkfbe
	 NK8z0tFyPP0RFz4vuaS/PM0miFLWweAsuecEAf9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 671/686] crypto: omap-sham - fix crypto engine cleanup
Date: Fri, 13 Nov 2026 10:53:24 -0500
Message-ID: <20261113153844.414633558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 7b3612d097700..2cda2e05ab42c 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2200,6 +2200,7 @@ static void omap_sham_remove(struct platform_device *pdev)
 	list_del(&dd->list);
 	spin_unlock_bh(&sham.lock);
 	omap_sham_unregister_algs(dd->pdata);
+	crypto_engine_exit(dd->engine);
 	cancel_work_sync(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



