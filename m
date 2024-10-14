Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D831AAE27;
	Mon, 14 Oct 2024 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917774; cv=none; b=qJ2wG7wv9LKcy43lE4bb9huDo8o0T0AnrIoCeh9c1RS9qpCWD1XZst/lPZL5B+srqo2+c1wknUnrkXpdvTrk1MfenJ5VZqEkzWk3zDNSBENe9xtS17/P0yDlAb9wKtNXYPYetwOsoIO0RZOufj4TlrxhaX5PPdju1yKTkJtDbWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917774; c=relaxed/simple;
	bh=qU6M8/Va0NCFhQE7R2wOtiWXIAAJV+HyDkH2Tapl2C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4taJUTcAhd3KePw3mrumDv2ZbqOVTHi7CZt+XZENWOA3mRcTWtu50dzHVxMof0u713FEv45/tIv2zSnRASJSfCcPseQcfaMcCyjZC5ZScC3Us7gOaNGtB0zttjixd7IQWlFqZmQ5JS0oa7qAZuVH5t0pRRHqJvyi6R7APIsVjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOOuyyWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOOuyyWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081D6C4CEC3;
	Mon, 14 Oct 2024 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917774;
	bh=qU6M8/Va0NCFhQE7R2wOtiWXIAAJV+HyDkH2Tapl2C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOOuyyWsushH6KgFajzWT55o89UoGgSrsg1Snte90hLhtheETUvWFzQvMKHOrPPXE
	 71r8uUHKaRuhjCf1tM5zwHgfuDiKNjVYVHYK9m4bSWT3msyQ75FokAh6sA7noGfGkt
	 L+6JUk5jPFApJQTxn9uDXOUxfAqZlETLNuofhXwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuesong Li <liyuesong@vivo.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/798] drivers:drm:exynos_drm_gsc:Fix wrong assignment in gsc_bind()
Date: Mon, 14 Oct 2024 16:11:25 +0200
Message-ID: <20241014141223.068809324@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 68ea92742b06b..f8b45fc5b15ad 100644
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



