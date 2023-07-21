Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCAE1FB40
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C405C433C7;
	Fri, 21 Jul 2023 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956056;
	bh=oytDSgUuT7xYCf3cXJP0kRhgXITYLduCI35TG+iGW8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p42NZ8d1XsX1QBd5J1uI+j2MEzPJN03H9e2CN/hqkTbV6+NgRgxg+dTcf3+yfLRLx
	 IadGZEjJCI/024RUTUNV+Um2JS6WbeWaOYhcHxGlAro/SKU2M7VmonfVWyiKUkS1D0
	 YzvGYL1Cn5PiZNdIVY0CdLgUwJyORiQHLmNiJqRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Herbst <kherbst@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 100/292] drm/nouveau/acr: Abort loading ACR if no firmware was found
Date: Fri, 21 Jul 2023 18:03:29 +0200
Message-ID: <20230721160533.091378955@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Herbst <kherbst@redhat.com>

[ Upstream commit 938a06c8b7913455073506c33ae3bff029c3c4ef ]

This fixes a NULL pointer access inside nvkm_acr_oneinit in case necessary
firmware files couldn't be loaded.

Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/212
Fixes: 4b569ded09fd ("drm/nouveau/acr/ga102: initial support")
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230522201838.1496622-1-kherbst@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c
index 795f3a649b122..9b8ca4e898f90 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c
@@ -224,7 +224,7 @@ nvkm_acr_oneinit(struct nvkm_subdev *subdev)
 	u64 falcons;
 	int ret, i;
 
-	if (list_empty(&acr->hsfw)) {
+	if (list_empty(&acr->hsfw) || !acr->func || !acr->func->wpr_layout) {
 		nvkm_debug(subdev, "No HSFW(s)\n");
 		nvkm_acr_cleanup(acr);
 		return 0;
-- 
2.39.2



