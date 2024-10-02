Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB74C1D0797;
	Wed,  2 Oct 2024 14:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877840; cv=none; b=h8m1gBQ3pfoF8M49HGsxOkPeIVuBfgCFRp8ks4RjX4+3t3/uxK+MWaa29joAV3sKzZDBjPnYU1XRzVJmE30b/BcSsPYrau+M8bpqyYzfRMZXcWjJvAZzT6paqb7DOdl/gVqAbCpJUw1c7W82vmGkAIOR0mM53nW36zgR97eY+k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877840; c=relaxed/simple;
	bh=e8de2aF3uEATmR4ZgdBSrEIEJeA/WszKmC/I/iWyEVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5AHqBNGW5WJViKwXkfkKYVCKzWSYzCBMNpmVTFcWq38nD5ugaFmYrcvc7wfr6jZ1UtZLPw8+vEHGQ7cVqovGaaM8oKyI7Z/5Ir/s8P2LnKFRHEKtUGhd6pr7zNorlFHe5Ft0bUFf/trJ1icFRVM9pojLY7X9HZ/jkyO/tmxsis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5rbvolH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5rbvolH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B5DC4CEC2;
	Wed,  2 Oct 2024 14:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877840;
	bh=e8de2aF3uEATmR4ZgdBSrEIEJeA/WszKmC/I/iWyEVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5rbvolHspZ0o/MoLsO3ZBncuYldo+di2vBrjZEb1FL2z6UbAwXwEAkpRtaTQTbTp
	 gKmnMA8XuhpimSROxTq8qGjA2R1/KzpVY19ncxDDsnjcwkmrqaF2u4MxYX4Wd/OWRe
	 LE38huCt/oIiLK8GAjJsquE+P87Ir8r8pA3kJwIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuesong Li <liyuesong@vivo.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 213/634] drivers:drm:exynos_drm_gsc:Fix wrong assignment in gsc_bind()
Date: Wed,  2 Oct 2024 14:55:13 +0200
Message-ID: <20241002125819.511199389@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1b111e2c33472..752339d33f39a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1174,7 +1174,7 @@ static int gsc_bind(struct device *dev, struct device *master, void *data)
 	struct exynos_drm_ipp *ipp = &ctx->ipp;
 
 	ctx->drm_dev = drm_dev;
-	ctx->drm_dev = drm_dev;
+	ipp->drm_dev = drm_dev;
 	exynos_drm_register_dma(drm_dev, dev, &ctx->dma_priv);
 
 	exynos_drm_ipp_register(dev, ipp, &ipp_funcs,
-- 
2.43.0



