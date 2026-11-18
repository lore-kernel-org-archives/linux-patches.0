Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030245;
	b=od55/U1DT/2u2v842dSh/A4SAiTgf1ywsr278zqW5dl1/YZW67pui23Cy/+J4+fpthtk
	 4ervLXJrwHRyxxwDdpoqfmAM99oB/OTi8FMsAVqX97h3pzj3NNNxYd+igmZCYFRk2raEV
	 QOsS6hWWhUuVbyf1rXxuZ1lbnW7sPJZGJ/B5pwfAuVwVKwoNGj//E3WTZLdFHTKHjd3/E
	 rJ3xHOZ4j1bKTpKold6TmoYR8yi/5NSE8EXLTE4ZWaLjeBw3hPp5vpN5HUA1MxDn0AMIx
	 7hdeIEVbzhDRTltD1Yn//vou399g19f/ioFZVCiUXRg1ceWZHBHHNbLqlVhKevkd/YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r4SXJkiuRMm0YgB7DZpd7A6iac/NLAPScdLT80ok06U=;
	b=vUKRkmrOOaLCt0L06cUgXeJQY5RVEFjqI+l3/q2RYSHoyQXIdtNfWtj7NPIe0Vp9DRdX
	 hIIVCVH1j/yKCF0M6LAQDCmMPdRmv8Q5+gspl0L6uYy3YaIRh+uIsMvLySwfiA6tFF8Bh
	 BeiY+5KKb4BVhp4qum5MQLjQVPxqK+c9GByr580BFjd4OY7YmSVw938KWyFTIlAYaKScr
	 zwviUKNjJOQuK6QzePtMKr1erVROeneMaPTceVeoQuVihhDdwZibT6uJfy0j+z/JT3brh
	 2Ox3mXeTQNKpD/blQuws9R0pICUm2rDQqXw3nWoZSE1YJZwoMAi3z5ATY8RtD9W0hnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lau3VOOl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E178D606F60F;
	Wed, 18 Nov 2026 19:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lau3VOOl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B191F000CA;
	Wed, 18 Nov 2026 19:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030244;
	bh=r4SXJkiuRMm0YgB7DZpd7A6iac/NLAPScdLT80ok06U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lau3VOOlVBzglfW5c+YLHP5msNakAslU16qRaDY6LQcBiS8rZutWya6enFXfMNkjK
	 O3Pb1HgMirSUTke0pmKTicwyMGGp+l7r/d1i1mWihc7eQ0CIOa3PCnKnBKY+S2WcOg
	 aY0K7d4tL99www9at922SMlzvj/y6kaHXepZjvCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0635/1756] drm/exynos/fimd: fix register offset type in fimd_trigger()
Date: Wed, 18 Nov 2026 15:46:02 +0100
Message-ID: <20261118150034.144817487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 05e4a5a63f5d8..e7f96b3568808 100644
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



