Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF3F53A390;
	Wed, 23 Sep 2026 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174852; cv=none; b=knFYntFlyHW9MDUMgVgeL4f2x/zeXiSZZzm51/TSylQ51glQHgkA7ZkmP+soMHb8Dodqbmzk8MterqAHVTMZ/TmVMyQDwozotEeATeDTolixsPdyREG8e6KUG+YpoSe/kC41/Da9pDmX5E4x6BhsmqwX4turXJVsx/zuZZpPpVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174852; c=relaxed/simple;
	bh=2ALl8WWb0W2bt9d4akfqHkdPhpWTMaY8mnGgPalXTy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UegaPcFiYBR07z87+EQDbetckYGU90dVZlGDGzfz15Ca7FXMoZ1jEbkFrALxXdOM/f/KaN9xDdLzVjOnTAHPr7COcyScZeqnREBnRTarEu1bxZ6uYhrmGhyzItpU8Pkke7PDQ70cVteIbevZEcgWeTNAHPd4G0qwfCbP0dm35vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4WmxDDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4WmxDDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C741F000FF;
	Wed, 23 Sep 2026 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174851;
	bh=wdeq1nHzB/sr7e3JE2t5Kh9Y/ik3z0gKXxLi/qQgewo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4WmxDDdXT7yBK+P75PK1AWLQEq4kRdGAH+kqChDLoqxKUXrcHP4TmAMflRlge+UY
	 qsZeKP3lC8U9iRUXqadbIllVKBRUjqo5tdZynlbkQyEUEVU22VsGBkA1Hzyywajyh0
	 MPO+KrEYgHrg4RBjctcqCNCRelLjPEKNo+fD+khs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.18 211/398] Revert "nouveau/gsp: fix suspend/resume regression on r570 firmware"
Date: Wed, 23 Sep 2026 16:04:45 +0200
Message-ID: <20260923140648.889901910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyude Paul <lyude@redhat.com>

commit a5c41fa7f925fda2db394329fa0b26243fa63a81 upstream.

This reverts commit 8302d0afeaec0bc57d951dd085e0cffe997d4d18.

It turns out this looked like the right fix on some systems, but it's not -
as this causes runtime PM to actually fail on many a laptop.

Fixes: 8302d0afeaec ("nouveau/gsp: fix suspend/resume regression on r570 firmware")
Cc: <stable@vger.kernel.org> # v6.19+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260814194542.781955-2-lyude@redhat.com
(cherry picked from commit 94097122bfd701976bc1a62ccd434c13f3f67cde)
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/fbsr.c |    2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |    2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c |    8 ++++----
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/rm.h        |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/fbsr.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/fbsr.c
@@ -208,7 +208,7 @@ r535_fbsr_resume(struct nvkm_gsp *gsp)
 }
 
 static int
-r535_fbsr_suspend(struct nvkm_gsp *gsp, bool runtime)
+r535_fbsr_suspend(struct nvkm_gsp *gsp)
 {
 	struct nvkm_subdev *subdev = &gsp->subdev;
 	struct nvkm_device *device = subdev->device;
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
@@ -1748,7 +1748,7 @@ r535_gsp_fini(struct nvkm_gsp *gsp, enum
 		sr->sysmemAddrOfSuspendResumeData = gsp->sr.radix3.lvl0.addr;
 		sr->sizeOfSuspendResumeData = len;
 
-		ret = rm->api->fbsr->suspend(gsp, suspend == NVKM_RUNTIME_SUSPEND);
+		ret = rm->api->fbsr->suspend(gsp);
 		if (ret) {
 			nvkm_gsp_mem_dtor(&gsp->sr.meta);
 			nvkm_gsp_radix3_dtor(gsp, &gsp->sr.radix3);
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c
@@ -62,7 +62,7 @@ r570_fbsr_resume(struct nvkm_gsp *gsp)
 }
 
 static int
-r570_fbsr_init(struct nvkm_gsp *gsp, struct sg_table *sgt, u64 size, bool runtime)
+r570_fbsr_init(struct nvkm_gsp *gsp, struct sg_table *sgt, u64 size)
 {
 	NV2080_CTRL_INTERNAL_FBSR_INIT_PARAMS *ctrl;
 	struct nvkm_gsp_object memlist;
@@ -81,7 +81,7 @@ r570_fbsr_init(struct nvkm_gsp *gsp, str
 	ctrl->hClient = gsp->internal.client.object.handle;
 	ctrl->hSysMem = memlist.handle;
 	ctrl->sysmemAddrOfSuspendResumeData = gsp->sr.meta.addr;
-	ctrl->bEnteringGcoffState = runtime ? 1 : 0;
+	ctrl->bEnteringGcoffState = 1;
 
 	ret = nvkm_gsp_rm_ctrl_wr(&gsp->internal.device.subdevice, ctrl);
 	if (ret)
@@ -92,7 +92,7 @@ r570_fbsr_init(struct nvkm_gsp *gsp, str
 }
 
 static int
-r570_fbsr_suspend(struct nvkm_gsp *gsp, bool runtime)
+r570_fbsr_suspend(struct nvkm_gsp *gsp)
 {
 	struct nvkm_subdev *subdev = &gsp->subdev;
 	struct nvkm_device *device = subdev->device;
@@ -133,7 +133,7 @@ r570_fbsr_suspend(struct nvkm_gsp *gsp,
 		return ret;
 
 	/* Initialise FBSR on RM. */
-	ret = r570_fbsr_init(gsp, &gsp->sr.fbsr, size, runtime);
+	ret = r570_fbsr_init(gsp, &gsp->sr.fbsr, size);
 	if (ret) {
 		nvkm_gsp_sg_free(device, &gsp->sr.fbsr);
 		return ret;
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/rm.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/rm.h
@@ -79,7 +79,7 @@ struct nvkm_rm_api {
 	} *device;
 
 	const struct nvkm_rm_api_fbsr {
-		int (*suspend)(struct nvkm_gsp *, bool runtime);
+		int (*suspend)(struct nvkm_gsp *);
 		void (*resume)(struct nvkm_gsp *);
 	} *fbsr;
 


