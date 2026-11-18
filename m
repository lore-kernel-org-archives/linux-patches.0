Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024671;
	b=KmlV38P1o98I/MACT1UBGuE7yoVpNEDymonDPNGjr2ImmZIAlapBk6nc9LzbyIynzIig
	 ZLR0J5z4LRLR4KhpPcTz+dXUJNBhGekju4RZXVzqypNSqqXB7xOcffYssOlPZCCdGxPhr
	 AoqG0OpaK2zlJFeStfAe+RZ5VUZrrVn1YO+DOLcZJUC6kjzzLlw11VEI2tFxWOPD0eK2V
	 Ue8932tnPQcfUclZj8T8KkoXHLnkix3/f+9JV7EoXjUei07y9jdsvBhqVU7q+jkfXu/La
	 rc9NNDhrol3DP5sqnKGtn+FMmG6KBn947ZRA7yG4fuG5cdwvd9bUMJti4Z//rV7fxjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KkcKoX3RknZ7by16swb5jEgyAvd+I+Co54w0gHxpjw0=;
	b=Vna6+llzdEJd4/V14mqFCQQvRrDJSPa2bU+iL/n21ltJANQDAfwxFZph/peeJQSLWdBS
	 phj00MtpRNrYKLhDQc5aU/rapyGYSoo5jdo1Ug5qxDkZ7teqgrInFY3A8uckoPR6XiGCO
	 ebPzd3s3LgmN/9ytiIv6yB8eMV8D/Pd+l0rx1eQAw79V129Yt6NwR2fZYdfQmzKGXJmJv
	 /9vYl+RjLouJ/ef9uqVfVBwUdi0mB4u2Kq7cBG8aufvuZ9MSQsPi0GHAbpY1zHlGqbA8s
	 6uXkCddg8uaQAzy1vzG3yxk/fxJm+Pe8Td0tFdwSn1GC3kXZ7lRIFE+8p0E5vkLfThw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPUeMgXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242DA606A330;
	Wed, 18 Nov 2026 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPUeMgXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E2F1F000C5;
	Wed, 18 Nov 2026 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024671;
	bh=KkcKoX3RknZ7by16swb5jEgyAvd+I+Co54w0gHxpjw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPUeMgXgyoYFoxrowWAd21EcN6DWqroQCsqtMbWYcMVE0XS/92ggTspwVaJ3T6OkN
	 jI4MJjuE/MsLN3rvLexwad4Tcnq2dJ3nJeEBZZ0wMM5RJmiEEGdY2ttzSe3/ZXZTyD
	 WcvlArC8YA+sZ2DBiwK4w5pwoDYhk/IODRwtDuVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0807/2151] drm/exynos/fimd: fix register offset type in fimd_trigger()
Date: Wed, 18 Nov 2026 15:42:22 +0100
Message-ID: <20261118150151.448893874@linuxfoundation.org>
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
index 205c238cc73a6..ba3ff13d7d02a 100644
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



