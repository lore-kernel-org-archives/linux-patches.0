Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CD8101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B2FC4339B;
	Mon, 15 May 2023 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173256;
	bh=pSBL3QwO9Sn5pDMZIlNNy+3GdhBU4CYtzLQ9WcD+dk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaXtapxyIvLxBEUPFggeoAmXHhMFMOjEo20ykbxtJW+UnjC8eIliLkAigpGNp6JNf
	 8dhTtQyxVJaDYLG7gsh054tIsVg+58HJMh4cB+tPbZE6YZJh8O3+RSZIOysXC0oqJ7
	 +RKME12GeVYwtFbJNHz76R1iGHXDDkVm5A3OuHSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/282] drm/rockchip: Drop unbalanced obj unref
Date: Mon, 15 May 2023 18:26:53 +0200
Message-Id: <20230515161723.325318104@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 8ee3b0e85f6ccd9e6c527bc50eaba774c3bb18d0 ]

In the error path, rockchip_drm_gem_object_mmap() is dropping an obj
reference that it doesn't own.

Fixes: 41315b793e13 ("drm/rockchip: use drm_gem_mmap helpers")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230119231734.2884543-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
index 291e89b4045f3..96cc794147b5f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -249,9 +249,6 @@ static int rockchip_drm_gem_object_mmap(struct drm_gem_object *obj,
 	else
 		ret = rockchip_drm_gem_object_mmap_dma(obj, vma);
 
-	if (ret)
-		drm_gem_vm_close(vma);
-
 	return ret;
 }
 
-- 
2.39.2



