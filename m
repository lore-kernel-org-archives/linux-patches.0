Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D85126C18;
	Wed,  5 Feb 2025 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763436; cv=none; b=dHKLoedYCWVlBi2NB/9EvT7TAFy+N5qEBi6FlmDGwPfcUnqArE3J9L+GynAbijVH1K4fYMagg38Rs5xIeZQ+/sAxqWldb/v/M0dhGkdmSh+k045m1NQ97KQCSsN028IstlstCIEVJlMYF3574Ci2mt/wh2QPmZb60L8AZN1oQ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763436; c=relaxed/simple;
	bh=QnqDKIaup4EZ3U1iCFQPzPhy9X/yOG+QX3MhH8VmhZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsN3T8CPN+R2BXvG/Jj+HGLfaDdIH/io16Y82X3zDdu25LfEoylU4a4mMj9TwcOSZtpYGB50uAVKPukWKi4Ue5zEK+IgTTuDnOiNWPijaZ+QWXuozTaXrijktVfu3Oh1atC+/1+13HPcs5fXKKf5VlVU+EODdUuITDmIVs5C0X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vsyxdfge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vsyxdfge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60A8C4CED1;
	Wed,  5 Feb 2025 13:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763436;
	bh=QnqDKIaup4EZ3U1iCFQPzPhy9X/yOG+QX3MhH8VmhZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsyxdfgewOhfmD7mtogTuizOGOZLwqQgTcUEp4s3ppz4v5x/xffYcjnnh8xDyYVXd
	 UzcnP9sXhLslIdJMQMKdD/dj2i6UW60s0Zt4USprnAJ8J7R/3cj5Ofsr5BReBbNaFc
	 vt6xzWUtNsftl6edsC/RH4wvpymvSUHNnJMZ30h0=
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
Subject: [PATCH 6.6 034/393] drm/rockchip: vop2: include rockchip_drm_drv.h
Date: Wed,  5 Feb 2025 14:39:13 +0100
Message-ID: <20250205134421.608656117@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index abd88d2d7cabb..d8f8c37c326c4 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -33,7 +33,6 @@
 #include <uapi/linux/videodev2.h>
 #include <dt-bindings/soc/rockchip,vop2.h>
 
-#include "rockchip_drm_drv.h"
 #include "rockchip_drm_gem.h"
 #include "rockchip_drm_fb.h"
 #include "rockchip_drm_vop2.h"
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
index 5672df5de90be..eec06ab1d7371 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.h
@@ -9,6 +9,7 @@
 
 #include <linux/regmap.h>
 #include <drm/drm_modes.h>
+#include "rockchip_drm_drv.h"
 #include "rockchip_drm_vop.h"
 
 #define VOP_FEATURE_OUTPUT_10BIT        BIT(0)
-- 
2.39.5



