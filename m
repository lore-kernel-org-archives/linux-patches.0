Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055474;
	b=bWSQUWlrlmJpv4ioLW1fErdMwZmYcKYXGH4YrKiKCyqR27Ethk0rV2spb6Opg+cn/wjW
	 XkD3mZalGEtizAXOrBLsRyswbY9JaELNFpWkZog5LddrDNdGq+wL4He2vjDofT5yDoFWA
	 yHcGZfoeLrAatlzOxZ+nGXfXuhFS2f50cKQiRVF1TyE+HXi4VYilJIJwleYcCNqZmdPXb
	 F7rNVeQblDi7m/OLDpTulknyB7z3p90XKlVHd+LIYH9JY2CW67/nKc7aYoZeLVAUDcNOK
	 dkWANgvmjba5PEA8MRCTM7KmPFtGKdXWC1FBILalzonmqzKxSI3c2xxkkNTW6CLyOXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zuABfasr920Xcig7KYAyc8phQmSZPmklHoUPTplpOf0=;
	b=vvsUu40cwO6hfYCVynokdWMCm+CrNMFf6GiZITPqkWIzDyO+y/eIZuWnL3eG8Zk9Hs72
	 i4E1Vr/QWz4A1L5DkI3URq5e7szoKEkkC4oEdMk76RdCfR1g8FjWeU/GaBxGurUhOmHXK
	 dp2yi3g0gKmMsI1QA4dhQLCsu3tiJzSZquJVHCGr9UZHcI+aqwaUhE+Ju31Mliud1Ukcs
	 6aQ7Wd2hwZqwZifpdOYrfs+T7Dipv82doUui4IxrfK4+OFHFDUwFQISIQU4eb4p8m4M1D
	 mZIg88U0x4hEYZFG03lIX/w4UqFf0BYO8bmN9S7pFluCqsa9dWWEMGsEJPbaJkCqL/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnETpJ+A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024FF606A31C;
	Thu, 19 Nov 2026 02:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnETpJ+A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BFE1F000C4;
	Thu, 19 Nov 2026 02:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055473;
	bh=zuABfasr920Xcig7KYAyc8phQmSZPmklHoUPTplpOf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnETpJ+A5bs48RxbY9ThJBySJ3+zOX+TpQ5Ifr7MZqxR7DFltGUz69C52XmHVtPAU
	 HUFCZ6TJa+8yfFVQPFrpcr8owwMPkQGETtawPmQZBI/rSzb5iL1Y0d2JLAiU21yHEa
	 +2PSu6+Sq9cCpfeUBH1WmrzOcRP5zmhcT6bZyhO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1637/2214] drm/exynos/fimd: fix register offset type in fimd_trigger()
Date: Wed, 18 Nov 2026 15:55:13 +0100
Message-ID: <20261118150117.421667196@linuxfoundation.org>
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
index 2a3152f97c843..44385c2c06c3a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -955,7 +955,7 @@ static void fimd_trigger(struct device *dev)
 {
 	struct fimd_context *ctx = dev_get_drvdata(dev);
 	const struct fimd_driver_data *driver_data = ctx->driver_data;
-	void *timing_base = ctx->regs + driver_data->timing_base;
+	void __iomem *timing_base = ctx->regs + driver_data->timing_base;
 	u32 reg;
 
 	 /*
-- 
2.53.0



