Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820F51D04A8;
	Wed,  2 Oct 2024 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879667; cv=none; b=ryy9crKlQUmqrv8hpl4/Sd4phB0o/tjcSvti+ntNBgc7FpmPV8wYUzZTkR5uUmazLE8E11PyNkjQGpvb3zGgBupUpurNDy3q41hd6KZtx7GFCyP65ofyqNT+dDIJYxoT0YNqYsvp117rLvD4oKkyKa5DvU/4228q6/Z6KTw/zfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879667; c=relaxed/simple;
	bh=3FOL0vZOpUI6Cru6EkBXcgYa1uhXDJOi8P3SZlchaLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2XMuRP2PUdRcd3/pkHZq3DVHQznPOL6zxTtB3bQuzmiRTxEWi4ZyAlZPnT1YiC7Heeq1v+BG08y//IdJ3sa+MTU6cUlad1pBebx0WEE4CPOVppZFGu2o44TXBK4QMm4TtPMD/v/xgxl1N2UsWstQecvbssRy17AlkV/eJFfxNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2oQdlK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2oQdlK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAA7C4CEC2;
	Wed,  2 Oct 2024 14:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879667;
	bh=3FOL0vZOpUI6Cru6EkBXcgYa1uhXDJOi8P3SZlchaLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2oQdlK0jUZER/jHZJP6/8vsE//WH/FteWVLlIZdEwlHmRQswcFnXjId/+V4b8aza
	 9uScSRbJTCrQOlX8ID/94RBkNYGOLJsu6kgNlWNuRlFyFkiYKvgzreLNCU87vqmvlM
	 9bFaBXfz+xXQ7zylj3ZJl6R+WvhU4L2r6BTndX3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuesong Li <liyuesong@vivo.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/538] drivers:drm:exynos_drm_gsc:Fix wrong assignment in gsc_bind()
Date: Wed,  2 Oct 2024 14:56:45 +0200
Message-ID: <20241002125758.806241974@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5302bebbe38c9..1456abd5b9dde 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1173,7 +1173,7 @@ static int gsc_bind(struct device *dev, struct device *master, void *data)
 	struct exynos_drm_ipp *ipp = &ctx->ipp;
 
 	ctx->drm_dev = drm_dev;
-	ctx->drm_dev = drm_dev;
+	ipp->drm_dev = drm_dev;
 	exynos_drm_register_dma(drm_dev, dev, &ctx->dma_priv);
 
 	exynos_drm_ipp_register(dev, ipp, &ipp_funcs,
-- 
2.43.0



