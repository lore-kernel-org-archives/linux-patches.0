Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEF01F7069;
	Wed,  6 Nov 2024 12:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897979; cv=none; b=gi9wt4vJIEaPAvMHx2AlVr1M+k1y2p6PfYZXFlzb06ndcWzAvD3kt1ZaWKugyowAywZmzusxEUwTe4v4a4l13O90AM8GyET/MveMaTOA33YuwZ9lPSLBiOoRMR5UBfEh/Ya49l2ke0TNw2WkOWArqZiW/DnyNaa4+Iry7aRXrHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897979; c=relaxed/simple;
	bh=B82LKUZqoSG+mMRJBZzWNsOUuIJ0pfJMc1/iKbay3/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQL5QHvPNzQEASkoBnbRSykKaAxi/QINOUn6L1cUWanQsjmKKW+pJpUditLsaFjhLrtZC+CYU7TznuNWC1t9+FSV243ulIqqM5socFYqvHAYN+mqRKt8qYj3ScHtA6CZ+S1yaW1MmdITBVejEVQ8++NCI5vNhYC4RphOOJIcpkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uyw9Rbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uyw9Rbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF62C4CED3;
	Wed,  6 Nov 2024 12:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897979;
	bh=B82LKUZqoSG+mMRJBZzWNsOUuIJ0pfJMc1/iKbay3/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uyw9Rbrti6/6cpLKnVzKi0Z25toJ19Urez5st3Cw/b/BV3+0EQYhTK5+UjfrBQQV
	 GQOaq3hQct0D3PDB+wfaHNiASpC9i0rqiTBHl5qgxq+6+/LHPbp/fdxOIzn/tPrRaw
	 dYFgQeKZ4BvF1FX9aeaCznZaogcVgY2Pv5m8sPnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuesong Li <liyuesong@vivo.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/462] drivers:drm:exynos_drm_gsc:Fix wrong assignment in gsc_bind()
Date: Wed,  6 Nov 2024 12:59:37 +0100
Message-ID: <20241106120333.581850592@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuesong Li <liyuesong@vivo.com>

[ Upstream commit 94ebc3d3235c5c516f67315059ce657e5090e94b ]

cocci reported a double assignment problem. Upon reviewing previous
commits, it appears this may actually be an incorrect assignment.

Fixes: 8b9550344d39 ("drm/ipp: clean up debug messages")
Signed-off-by: Yuesong Li <liyuesong@vivo.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index bcf830c5b8ea9..1bc2afcf9f088 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1169,7 +1169,7 @@ static int gsc_bind(struct device *dev, struct device *master, void *data)
 	struct exynos_drm_ipp *ipp = &ctx->ipp;
 
 	ctx->drm_dev = drm_dev;
-	ctx->drm_dev = drm_dev;
+	ipp->drm_dev = drm_dev;
 	exynos_drm_register_dma(drm_dev, dev, &ctx->dma_priv);
 
 	exynos_drm_ipp_register(dev, ipp, &ipp_funcs,
-- 
2.43.0



