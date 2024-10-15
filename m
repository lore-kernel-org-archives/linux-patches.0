Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BD61C7274;
	Tue, 15 Oct 2024 11:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992678; cv=none; b=QKpedjoGhWwU7U3zRD5XHRsYkF4uU2dru5WHfWkKbKiGkIqeMuCDCYISIWFXKAb0YhCVLJna5e/3kGeGzj5b2jn8jhf83+AqAICqmiHA5b3ZOr0/G4S8nTMDIF4C2pZbWS/oQ/rZTdSZgQM+itdXlvyyubRyitbK+naCyixouDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992678; c=relaxed/simple;
	bh=qZngwuzmvZifCA78IbPy5Zm/WxCpYuLELkWWDVelE0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1sSBIVC9SegM9fKRoMp9PQnUImFMjUwkM2shd45ZCz1O0DSwkv9kDsV5Q0eClJjm/9j7b6NtFfSHHIzTs8B4+OSeHhgcYx4ADx3y/uvDL6x70eT4Daz8POgyOVaTj4GzmqabXfmFmCQY8kC9Q/P00pipyESeGSVlPtZHbfnDf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1iCWoyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1iCWoyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED49C4CEC6;
	Tue, 15 Oct 2024 11:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992678;
	bh=qZngwuzmvZifCA78IbPy5Zm/WxCpYuLELkWWDVelE0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1iCWoyffU+t6e07k+Zth4ea8Si2au8ZOdDJKb4nNqcQaizoU2rJFGW9ruqBQR0sc
	 cMozGcDoLU5ytO95l9TKsIeoapZRcNZheBhH1oTfrye+Of34AVKkjmPofBLoQ5o1jw
	 pe6xFvRjqPWtmA3648L2iBFhGGQ7y3bkcsSWEGqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuesong Li <liyuesong@vivo.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/691] drivers:drm:exynos_drm_gsc:Fix wrong assignment in gsc_bind()
Date: Tue, 15 Oct 2024 13:22:15 +0200
Message-ID: <20241015112447.781947755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8c090354fd8a5..d7e0d19c0c025 100644
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



