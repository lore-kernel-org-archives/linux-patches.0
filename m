Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060952;
	b=ZsZCx4ixaWIWs5n+YQ0ZtTSWBOAVBQHbTknq79MgDQI8Rnib/hdwezYcHLofwFetabrh
	 kd3SUzY/IVz6/5gZgLTHM/6UIIpdNUi2cK908BB5AHeAyElSjDsbLBHQl+fq3jAleCA8P
	 y7QfIHKTexpOelShrOLFWOGfvHY1XHJCbhLNwi1VrfKwC05KZMfRw8lrxCjz3NCFesVQb
	 i2Of0TQRUbRBNYE9JdCacb4+wo+oSndCw0oKDkgsr3PVVtGncVNLbD2vkfJCnzvirpLGK
	 /OBKUjeu04uHyrbXuat2VWWxdVck/WrFXq9aM8APUUwZMW8YpBZLr0NvQvsmtzU1Gmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vFIeQYuitF7+gK9QmRX8139jWk2iS8pNG3sUfWPQDVw=;
	b=BD1rpEujjHLtr9Z7xU5qjtCkR/fSKmtvp0hOw68x/6YJbZqH34vQbnoOg/m9ZSJmvlPS
	 /N49B5yWeoaD4UcJFpjnzkqCthF+e8Ik/kSteQN2V29jH0xAcAnkp+MIVVImXdcGVMdOp
	 P2kV43V4kYVDKnNYVSU4+kINeopWOTAx1VDzCwyEltimbYaQu8+2slOvi0lF/AHZlTpSB
	 7pKHXimy+oQ02yLebbWwyjKQ+55k3GwUgKZ1QUXBHOdGFJjxHJBA/TXx8aOZThCEBSg3M
	 P/BdFFtZr+gUgk9/zol4rQKvZA7r2nz3AG8oZMYEwECBUo+8JTnn9x+wNqCY4j9R5WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B2T/Z8YN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D031606A320;
	Thu, 19 Nov 2026 04:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2T/Z8YN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1D31F000C4;
	Thu, 19 Nov 2026 04:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060952;
	bh=vFIeQYuitF7+gK9QmRX8139jWk2iS8pNG3sUfWPQDVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2T/Z8YNRjRbpBm9VRKN4DSl5RXwslwhFTP/F0KxiyReQTWCisYuIGpXiRf9xP7XE
	 5lsVbIb8wZPO0fVMpLgKD8JpkhBz9qraEzuTxHwt3Sacmc4DWgZfnVVtdkDPEbofU8
	 7fLWvoHgt/C2G7P4yl/rNFQ0vwjQv/hSenENVOXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1384/1848] drm/exynos/fimd: fix register offset type in fimd_trigger()
Date: Wed, 18 Nov 2026 15:57:02 +0100
Message-ID: <20261118150017.416371144@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit f901c9b986b6355716822d5c6ad34ae5edd71085 ]

Sparse reports:

    exynos_drm_fimd.c:992:39: warning: incorrect type in initializer (different address spaces)
    exynos_drm_fimd.c:992:39:    expected void *timing_base
    exynos_drm_fimd.c:992:39:    got void [noderef] __iomem *
    exynos_drm_fimd.c:1005:33: warning: incorrect type in argument 1 (different address spaces)
    exynos_drm_fimd.c:1005:33:    expected void const volatile [noderef] __iomem *addr
    exynos_drm_fimd.c:1005:33:    got void *
    exynos_drm_fimd.c:1007:33: warning: incorrect type in argument 2 (different address spaces)
    exynos_drm_fimd.c:1007:33:    expected void volatile [noderef] __iomem *addr
    exynos_drm_fimd.c:1007:33:    got void *

Add "__iomem" to *timing_base to fix its type.

Fixes: 3854fab24e89 ("drm/exynos: fimd: support LCD I80 interface")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 3b89a8774db5a..bc368e2de9104 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -944,7 +944,7 @@ static void fimd_trigger(struct device *dev)
 {
 	struct fimd_context *ctx = dev_get_drvdata(dev);
 	const struct fimd_driver_data *driver_data = ctx->driver_data;
-	void *timing_base = ctx->regs + driver_data->timing_base;
+	void __iomem *timing_base = ctx->regs + driver_data->timing_base;
 	u32 reg;
 
 	 /*
-- 
2.53.0



