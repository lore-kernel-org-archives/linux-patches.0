Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740E5DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8991C433EF;
	Mon, 15 May 2023 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168791;
	bh=cemAPspP2FcMIaRC4ma3azE2eb0PWCfk2r8bo9exoNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpgLioFjnmLvPCH9py2m5bziWiZBSuENvdPpCZXidPEM7yWDEtJOCh7ldV8EBtW34
	 mllkNGhozPE3PFdNJFM3XcY+7FnRUHc7UnGA/80pFjUKLgCoB1DdB5jUR80Yt7Jxw7
	 rkusbvXbD+0DmmVgtabW0+QuZx2f2bQf0fbthJ7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/191] drm/rockchip: Drop unbalanced obj unref
Date: Mon, 15 May 2023 18:24:22 +0200
Message-Id: <20230515161708.095054779@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
index a8db758d523e9..94242fa9e25d1 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -270,9 +270,6 @@ static int rockchip_drm_gem_object_mmap(struct drm_gem_object *obj,
 	else
 		ret = rockchip_drm_gem_object_mmap_dma(obj, vma);
 
-	if (ret)
-		drm_gem_vm_close(vma);
-
 	return ret;
 }
 
-- 
2.39.2



