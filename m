Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048711;
	b=FTWtcrv6fifsEEObqwhUvvaPMZ94hNuFAbvH5zxWqkf683uY7CUKKcj5oYMJcfNZ8zYC
	 ujbU5ZMc5sQlh6AoBYp1UkEmeRP+8OCZ+LvNngrDSCcareeln72X+c2nx1eDgkdyGFQBM
	 lYIgM8AZrNWcdfCPrq9nJMPe8kOOL1Q+TjxR4z1hgcRDJF7FezwYQKNHm+lw3VncuSy6k
	 etvLtIZNdSFUkkb0i3MDBBxdUoEP4dZeJ6Ba3pwPrgHYUV5aMQi+hsrjrwlzsC48cx4Ra
	 ulGRRMlmA/0Yn/nUs2VIdznGCy3eCbauWdY0qcepg/RwZUHNjSPhkGB/hysH9zH6D0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xkUNj2vmM5WXNdYDpQOPnl7uIjNjaI2ftM90gKQ0xoQ=;
	b=MG68OrrDSOppM+Jlx8CDEGa7jqiSlBcggu43d4zWVskQdDcWRHViZED98v/ePF/xw5YT
	 yUMoCM1fUP14IZtd7mo0Yah8CDO06n2aIFiIVTmmftJYSR32aYC/uPLU8dGKTHOcVBWDG
	 4KIjScltu3UmDRIGZIRWpiZwzzHPSb/2qShUdQAbDH3/wl6jmho8isv0ZO65bO9lF6cpX
	 Tjfs04dqPfS1h7hdlwht3l7BnQcyNQYeus2d/S/8H1T8XR8Jd8gas3PV/HXG6jLXkIGGD
	 TU/h7BFFXoy6SWQU/nl6FDfcvPz81623e2NA/Wo7H6IxPo1IERo+wmseu2Nh8nyVlOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iP3fsK3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13454606A325;
	Thu, 19 Nov 2026 00:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iP3fsK3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EE11F000C5;
	Thu, 19 Nov 2026 00:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048710;
	bh=xkUNj2vmM5WXNdYDpQOPnl7uIjNjaI2ftM90gKQ0xoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iP3fsK3YJ0Mqosz+lkYZkuIm8PT7jJ8JnQU2N2AkSfCBcrq9Bs6mjQws8lAtPWdbX
	 BUiIq7DDxy0rcnfa09dYiYswbbZgD1yGm8exYqcirpP9D7qEIdc1SqEHNNr8p7VTn0
	 RQo6nKYDpsudyBY2ZjcXIFAQb5RhMiEd1xKxb9zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2093/2857] drm/exynos/fimd: fix register offset type in fimd_trigger()
Date: Wed, 18 Nov 2026 15:52:07 +0100
Message-ID: <20261118150316.765973863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0816714b1e581..8e867dec56a92 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -989,7 +989,7 @@ static void fimd_trigger(struct device *dev)
 {
 	struct fimd_context *ctx = dev_get_drvdata(dev);
 	const struct fimd_driver_data *driver_data = ctx->driver_data;
-	void *timing_base = ctx->regs + driver_data->timing_base;
+	void __iomem *timing_base = ctx->regs + driver_data->timing_base;
 	u32 reg;
 
 	 /*
-- 
2.53.0



