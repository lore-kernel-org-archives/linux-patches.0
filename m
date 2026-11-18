Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040419;
	b=v5N/jChRFlmVBFBA90JxvZVRivhOoe24VKpy2LPwHTAWDuZ9O0hB1GyQRfxE/qvcNpvT
	 +O25UI/LUJ8xtce3Og6cnhfHnifhZUulBgmEGNozTC9yCrGE5BpKCga+spS+6/wLAF1TJ
	 N3N0jwS901OgWKotObXKwtzjZajG60jQwyMN6pEAtwjaAzGqFYkIsHhqDJd1GNud9zsuT
	 Xm0iKXA3mXK0jn7kmlLpdd+35Tm02JPgCU/RzV0vyZ6O/F7uaEVLN/SUxb255u6SItcsT
	 B56qzVv7dIOZ7KDSoc7VYnQRz3FtX4x+A+pDX7n+PtwFC+TOPFhtBptgTernk0rRPKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tfnhC/zF7B+v3xaGUoIaXR+4pFEMMF/cCQF0o++tWMA=;
	b=HMGv2cpht/yTgAF1iB2yeWP98w0RK3dVUCM8edN7fQhWNS/9sd2uYBo6XZn1K9yeoEbR
	 hmZeLLTrDBTLjagq0F7QmEdXOvvJfO5QVhQ9ohqoK0zkauOIkRUMphyttV6lZIfUMQvTb
	 71ftaYnw8w2x6JM2mjXJwQi1qIVfZkBtZGMz5/Q1ffleCuOEJ2tTB4i7gWaS6oxg83T2x
	 tGfyG29+eXiz8LwtfeIZaKlrEXBxCV6n9lkXg9WECnkf5/qjEuEp9DCyNsUIhGWTfPyY1
	 Ofw0BfoJWoVQy6OCJ5OKErCGI9aEWocOTK5bB5FXN3ynGGY53G1qWiZu/UzmcQmbjNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b2M/KlSO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98369606A325;
	Wed, 18 Nov 2026 22:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2M/KlSO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16E21F000C4;
	Wed, 18 Nov 2026 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040419;
	bh=tfnhC/zF7B+v3xaGUoIaXR+4pFEMMF/cCQF0o++tWMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2M/KlSOakLIa+kb/vM7vWPpRWusY8tXEBjjr6NiXduwhh2B+Kj6DciV62VhkqzZ1
	 z0qrmnoK9/e0hPy+N3f0wwhp7W5DT9xLzjDttEoYWyok/5pJ51EOhfdrC5+wTknRNX
	 MvuCQU1tsAChIZ3Tg9ToVO+J6HD1WSnCLuKHAEPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2409/3318] drm/exynos/fimd: fix register offset type in fimd_trigger()
Date: Wed, 18 Nov 2026 15:50:31 +0100
Message-ID: <20261118150433.764931764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 341e95269836e..955768e83e627 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -988,7 +988,7 @@ static void fimd_trigger(struct device *dev)
 {
 	struct fimd_context *ctx = dev_get_drvdata(dev);
 	const struct fimd_driver_data *driver_data = ctx->driver_data;
-	void *timing_base = ctx->regs + driver_data->timing_base;
+	void __iomem *timing_base = ctx->regs + driver_data->timing_base;
 	u32 reg;
 
 	 /*
-- 
2.53.0



