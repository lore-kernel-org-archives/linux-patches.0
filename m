Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ABA3C0A03;
	Sat, 17 Oct 2026 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255511; cv=none; b=rEEBVaHPYQOl23yvvIVkO4vd/O51DYpa1MDbZQ8Dkcav/lyhjAPYFSXDtVh4VK5fMaHsmtPhZBuUUKqXsSZW/IO4AJoB2kg00TxtchsMFml1/GjBEZNXTuVjrAfYlBZTDd5qDQcPo9y1aLWyrO5zuWfKVLhq1UX2JMGxcSLrFSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255511; c=relaxed/simple;
	bh=T6K89MyOGtb97v2C0XRBXKbaYcWujxPh/OEHqIufYkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gu2gtl56AzImQWY2tI2qvNifFaXAouNwkN391+aMxMwfIyVeKB9db3D6crbn+98QNPKpYZeIDemJzwJRsGVhDxv0NnP2ScNuQ4LNKwZZf5p/CeZVzX6AUuTI5Ny7n2au4+banuISv00rIT9YXvz3yYk6ECkbqDboAYWoOpF1XFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWQWE78Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWQWE78Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7391F000C4;
	Sat, 17 Oct 2026 16:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255509;
	bh=ILgceJ77CjpOYOknQTPn10EeHM9BbKUDWq6AGwdXD90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWQWE78ZqfoPOZr4p5umqNAEay/Vsj4YBmnQEW1KwRMbS1zYJNPb9IulDO1sYfZSZ
	 fKXrb9pR9ctHXbI669DZFUcONpJdfPIAkc7WmsCDsTk0+CdVA7as88QUGfkHjZlf2A
	 QVpJTf3iM14D3AaR3rfLoJCCmcezDuHBk4CQpVcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongwon Kim <dongwon.kim@intel.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Rob Clark <robdclark@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 801/869] drm/virtio: Use drm_gem_plane_helper_prepare_fb()
Date: Sat, 17 Oct 2026 18:00:42 +0200
Message-ID: <20261017160057.439071302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dongwon Kim <dongwon.kim@intel.com>

[ Upstream commit 30f86b8f86ada845fbd0d853b3a3d238567ac2c2 ]

Use drm_gem_plane_helper_prepare_fb() helper for explicit framebuffer
synchronization. We need to wait for explicit fences in a case of
Venus and native contexts when guest user space uses explicit fencing.

Signed-off-by: Dongwon Kim <dongwon.kim@intel.com>
[dmitry.osipenko@collabora.com: edit commit message]
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241020230803.247419-1-dmitry.osipenko@collabora.com
Stable-dep-of: 6a736d2f9d0c ("drm/virtio: use the DMA API for resource backing on Xen")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_plane.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_plane.c b/drivers/gpu/drm/virtio/virtgpu_plane.c
index 7a091beddaef9..d59f11b781866 100644
--- a/drivers/gpu/drm/virtio/virtgpu_plane.c
+++ b/drivers/gpu/drm/virtio/virtgpu_plane.c
@@ -26,6 +26,7 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_damage_helper.h>
 #include <drm/drm_fourcc.h>
+#include <drm/drm_gem_atomic_helper.h>
 
 #include "virtgpu_drv.h"
 
@@ -276,6 +277,9 @@ static int virtio_gpu_plane_prepare_fb(struct drm_plane *plane,
 	vgfb = to_virtio_gpu_framebuffer(new_state->fb);
 	vgplane_st = to_virtio_gpu_plane_state(new_state);
 	bo = gem_to_virtio_gpu_obj(vgfb->base.obj[0]);
+
+	drm_gem_plane_helper_prepare_fb(plane, new_state);
+
 	if (!bo || (plane->type == DRM_PLANE_TYPE_PRIMARY && !bo->guest_blob))
 		return 0;
 
-- 
2.53.0



