Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA841C07C4;
	Tue, 15 Oct 2024 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997288; cv=none; b=ivij5pK88GG5JyORSazvJdELAFFJiz5YgURQQZxuiEhwA75dVXtqMfSTkQFL5vl+6s5C5J3M5dtm5arBkReJen2pjSd98nq5rZRrvCNHYqb23hUOaYMO7VzdrnMtjZ5cbla4XHgpwFPiCboSEZJ33qN4CodMOuoBHuIrmW7+Hc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997288; c=relaxed/simple;
	bh=ytcTdLySsoafz2xDLbtLGozskl9g5pSeek4yDymO6sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A73R9k+mRNrbRxZUA6sU6YCVfHUBSvN9QGoVzunxk3QUFlFXdJeb0B22/VcMxSPFQcVwa/3h2ZUBthNwYlgxPnrCJavHaJvu8jC6wi8C0dtG7yzX0+tvv5oIKlT5i+VE6PlxlH1zE6SYm5LK+BUIuOWnPcZOZCp6H4GHAm/ui3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhYFGUXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhYFGUXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19275C4CEC6;
	Tue, 15 Oct 2024 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997287;
	bh=ytcTdLySsoafz2xDLbtLGozskl9g5pSeek4yDymO6sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhYFGUXaQwkA482/IC8EYAAOTTbPElC76Zfs01QdRdoLMBUmmpcI6uM/+tSB7emAz
	 RHSEW1/JiR1Z7/3EadxW/+PG3NjNhilzIIc5PYxxmoI80pBDlsgkLiD2ozK1RSoBKt
	 BG4IUBjXcjMCimV0dHOczy498EDGyzc10Il4WXs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuesong Li <liyuesong@vivo.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/518] drivers:drm:exynos_drm_gsc:Fix wrong assignment in gsc_bind()
Date: Tue, 15 Oct 2024 14:40:36 +0200
Message-ID: <20241015123922.091662250@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



