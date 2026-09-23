Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57413334C3B;
	Wed, 23 Sep 2026 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173465; cv=none; b=s+8RleZEuFXYJGA6DozJpjPcf2UkZiPMs3W0LnWCe6XaANdcF8PXSSyjsLEOvKBL5gurLLpxqPKqTCg/GkeeGYGxHmHhfMEBptAn1mPrrrNbOus44rEyn9lIBFA9cXUp9xyEOTxsaJSsI0V7XqfwFHcnUeLmC7OublpnPSxHKWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173465; c=relaxed/simple;
	bh=D/6swvvkXGAE0WlWOZ7jdOuumLcT+Z4a8wTXKYPtplk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkGFI1kv6skXQ9KxGb3Ri7gDF8ygSUtQRRMBojTrVhgNmdyqaG2sBuPc2/duZGwCbKf1Wvu9p15AtSv4i0ijPx7VwkMrXgW3vdOD7IPNcqUSR6EPED54GotqzrnG3MgurZQYWKYL8EU3cBTd6Vz5DKWMGmAC8Cgzg1c/1G2n0Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQoiLXSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQoiLXSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDBF1F000FF;
	Wed, 23 Sep 2026 14:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173464;
	bh=fiBkGaa5jtYbkNihUOtXPn16esMHgeGTxepzgFTxbE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQoiLXSruwwBBJHavGocHrmbEa1cXnYI7VEGT076rbmtC0b+RNci1AAX0gTOALwG3
	 2NEnqu1b5sJ5+C+zWsyuKHEicviTzloB+1mBpkxQNtB0p6dS3BhLBsXJ57rDzOtcxH
	 LJ+qtGx07bfuzrJQVAtelZ2wZa8abImQKj+w1seU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 7.2 253/438] Revert "nouveau/gsp: fix suspend/resume regression on r570 firmware"
Date: Wed, 23 Sep 2026 16:04:34 +0200
Message-ID: <20260923140651.328008938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1749,7 +1749,7 @@ r535_gsp_fini(struct nvkm_gsp *gsp, enum
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
 


