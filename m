Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023118;
	b=yf1xyOos0GyCAhJREvCste+TXvGR3CsjWQWWC2tJrUd6K09IT8/WnMJtD29ev9yKoUyv
	 uFAQeoNkaK3CiZ4fH6CCpBSy2R/ZHLmqHXowH/o41nvhiSF+qjzdQ9r8M64k4UY7EVvFN
	 mGCES1b2BhUhYxZMa4oHBfXuL3wVrJNBBOtHAFDX2gFmTEasc0zFOl+KhsyMsFkM8C031
	 taGvP98vknanKF9+kM2N+ks53ntyh5VVgZLOR6j7JbTrxzN0szLouju5PKWKN20gCRRog
	 kqi3RmAXQPWdbZZW7VkoUhDXxb7QyEEIGsclu8s7I4vQZ0M2sc2VrwWir0cFIowtlDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m2gp/s376UCvXnqfH7KtzyEFaG6mybNPwwvGX/B7t1s=;
	b=HHsmyhv07R7DO+fiRa6xC9acMXkEtpk4usJafjr/SqtX39+dY3WclD3pxg0SL9B++uJc
	 t1opoxxPkQFSxSGbRoThDCfUQgQuLUR6g8tck8NJDhxnnKFIB5B6tX2P4n8WdWL+R+T8I
	 dcCXJSPURzYXjutj+ejo9hNaXDA0VIessI1x8+Z+eAape1Lh9EUc3+rx2r9CG+WN2Zm1d
	 xhx2Ia6wyIzNZBtkT8voH0Zy/LwXkdcQPDJCWZm7px4+NCkaC/FA1O/a61xSAQBn1zIsQ
	 Oc4GumicEfcfmAtusMf8cwpWJ8itUgSQgrYIdFZ/jYKAYKJ5r5dHMTUR1Ey+tLt/o8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g4oMdNY5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC27606A325;
	Wed, 18 Nov 2026 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g4oMdNY5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9AA1F000C4;
	Wed, 18 Nov 2026 17:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023118;
	bh=m2gp/s376UCvXnqfH7KtzyEFaG6mybNPwwvGX/B7t1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4oMdNY595ksZk+zD1HVSxaGWT1yBBznlpaCEZL7qpKzgz3zokNFs1sX7N2/js0Kd
	 O3EC7jaKO9q1WVSgJu1Gd1LYxrQUuXNiBOUAdRPu2XHwA1CyUSxAd9gDe09809NPV3
	 VGPWDFqQXWqoOoSQfNGMZf2ujU+myZg88pGHZtG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0256/2151] spi: mtk-nor: fix runtime PM usage count leak in probe error path
Date: Wed, 18 Nov 2026 15:33:11 +0100
Message-ID: <20261118150131.112602228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4cee1ed13e2687f1a9fec7dd50e31eb179506d75 ]

mtk_nor_probe() takes a runtime PM reference with
pm_runtime_get_noresume() before registering the controller, but the
error path never drops it.

Balance the get with pm_runtime_put_noidle() in the error path.

Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260904-mtk-nor-v1-1-cefdca098f83@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-nor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index ba41ff42f0dde..6a1ca66dd7293 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -925,6 +925,7 @@ static int mtk_nor_probe(struct platform_device *pdev)
 	return 0;
 
 err_probe:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.53.0



