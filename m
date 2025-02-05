Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B158D1519AA;
	Wed,  5 Feb 2025 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763756; cv=none; b=g4sidvuONfk/73QeFnTiaw4WuzlqjCpsgm+mNhFLQyyk2Q6K49bhBXo5npNHQu4iQsl3Rafcg/pSj/EaPMJ8er9r/LXI2LxqAJhYdONgSc5UvBKzwQzPb9koPQEFw/JHGX+seKExocDrYe/to4EKwoy4HBwzr1jwLYIQSq2X3yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763756; c=relaxed/simple;
	bh=dlTy+ktMGSYROdNZXlZNeCGqyhH/nbVr2J5tzbpdhl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSlayGgARdztL+ViO13eZLrg6S9naAuJK2CxoVyf8wHT4qBNZ2pKr+28FKuvBHIOVtR84PfNg9QxEvZH4zRU8Wnl9W29IsP7UOOtR2vM0S6twswBTexzqf8NkUDJPw6iW5w9T3Qf4oY+nVXs6LjUZgScvMbP9Yo6GtBgeay6vH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPlffucy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPlffucy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382E2C4CED1;
	Wed,  5 Feb 2025 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763756;
	bh=dlTy+ktMGSYROdNZXlZNeCGqyhH/nbVr2J5tzbpdhl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPlffucyXU5s3hTqnFxyKUkyUPSc8Fuo0tsLu8UVNxuY+onMnFwYO+VUHUDERxV0G
	 xyZupeLETvNUPhfYlJbcKdjjc9Evug5zHNN8A3DvvtxFn80zfnzhVVzOCVBbmKGTzl
	 eYA1SXl6K3Nh194SP61ypym8ieW5TStDqdK2Bb/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Michael Riesch <michael.riesch@wolfvision.net>
Subject: [PATCH 6.12 054/590] drm/rockchip: vop2: include rockchip_drm_drv.h
Date: Wed,  5 Feb 2025 14:36:49 +0100
Message-ID: <20250205134457.324142000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit 77b1ccb2a27c7b3b118a03bf1730def92070d31b ]

Move rockchip_drm_drv.h in rockchip_drm_vop2.h to fix the follow
sparse warning:

ARCH=arm64 LLVM=1 make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
mrproper defconfig all  -j12

drivers/gpu/drm/rockchip/rockchip_vop2_reg.c:502:24: sparse:
warning: symbol 'vop2_platform_driver' was not declared. Should it
be static?

It is also beneficial for the upcoming support for rk3576.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Min-Hua Chen <minhuadotchen@gmail.com>
Tested-by: Detlev Casanova <detlev.casanova@collabora.com>
Tested-by: Michael Riesch <michael.riesch@wolfvision.net> # on RK3568
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241214081719.3330518-8-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 1 -
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 6082b1c179aeb..5880d87fe6b3a 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -33,7 +33,6 @@
 #include <uapi/linux/videodev2.h>
 #include <dt-bindings/soc/rockchip,vop2.h>
 
-#include "rockchip_drm_drv.h"
 #include "rockchip_drm_gem.h"
 #include "rockchip_drm_vop2.h"
 #include "rockchip_rgb.h"
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
index 1c4204324f9f5..130aaa40316d1 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
@@ -9,6 +9,7 @@
 
 #include <linux/regmap.h>
 #include <drm/drm_modes.h>
+#include "rockchip_drm_drv.h"
 #include "rockchip_drm_vop.h"
 
 #define VOP2_VP_FEATURE_OUTPUT_10BIT        BIT(0)
-- 
2.39.5



