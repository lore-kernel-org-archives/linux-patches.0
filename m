Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7F5C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DF1C433C8;
	Mon, 26 Jun 2023 18:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804663;
	bh=CNtcYf3C913L4qZW+Z+LQTGDw8tBa30R8IlCjpUSR1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTNFgF4c3VOdULFiNsxZiqDYfW8m8/ybg/cErs5gOt+LLd5A39bWdUGLqewCGJVE+
	 leHSGzj8gheU9Z2Rnq3nsfuaF78qNagjYYJrZfOa/1in/weXRexWucSJc0fmvEsLQl
	 GWd1Qbf5B/nRPki8gJaPAsRDnhr2bV/LxnmYWK40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inki Dae <inki.dae@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 53/60] drm/exynos: vidi: fix a wrong error return
Date: Mon, 26 Jun 2023 20:12:32 +0200
Message-ID: <20230626180741.737918207@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
References: <20230626180739.558575012@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Inki Dae <inki.dae@samsung.com>

[ Upstream commit 4a059559809fd1ddbf16f847c4d2237309c08edf ]

Fix a wrong error return by dropping an error return.

When vidi driver is remvoed, if ctx->raw_edid isn't same as fake_edid_info
then only what we have to is to free ctx->raw_edid so that driver removing
can work correctly - it's not an error case.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
index 65b891cb9c50b..d882a22dfd6e6 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -483,8 +483,6 @@ static int vidi_remove(struct platform_device *pdev)
 	if (ctx->raw_edid != (struct edid *)fake_edid_info) {
 		kfree(ctx->raw_edid);
 		ctx->raw_edid = NULL;
-
-		return -EINVAL;
 	}
 
 	component_del(&pdev->dev, &vidi_component_ops);
-- 
2.39.2



