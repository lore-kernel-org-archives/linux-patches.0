Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D793C3624C4;
	Thu, 15 Jan 2026 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495937; cv=none; b=JBdygbnktrJJF7VhzhXt06eFPdU2VS0GnCUkIXFC05RohnhtDJ7G6UzqSMNX8/l5lV49lmuSALVrqT81MzozgS4OLmNlcS1bZcxFdYXbujMtG8cSnILpSvNeMGgYEaIpCXG8GUS5nb1RLoP5WmGmM+//SkXOOjsScFVcgoAXGK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495937; c=relaxed/simple;
	bh=TfEx6OUyOwqixOEoc/jdoZ6+3W/bVH1t+SR7duNcsqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpYKXbTYlMY5OpRNmsjeIuP9LEMrDaE7/UeohB4VqUWo3sfnwBzC3wKzndn7L9sLYbHdeLRgBb9/0DbhRwL3WVAZ4nwnz/mFGrgGz99hWoQ5stbo2HBPvq8YlXngWVT01f7aiNYoZwCAQwpEM9wOGk/SqpaL0XWIORw8RSDwMno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKfLvcwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKfLvcwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66603C116D0;
	Thu, 15 Jan 2026 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495937;
	bh=TfEx6OUyOwqixOEoc/jdoZ6+3W/bVH1t+SR7duNcsqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKfLvcwCpkIIeTx7L359nsnWsarEmMH9YqLrlyl7MxhVTG+UeRMFDge1h76gkvAdi
	 PVIVifkUk5IrJ7xv2WeU69Yx7zJqgnsOTqxUEGAhZCSRV7xZzh0oJVsX7eEEnifsYR
	 Sgb6fFZsb+R2viKSW4oT4NiO9urMQQBElKVc0YuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Christopher Snowhill <chris@kode54.net>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.18 020/181] nouveau: dont attempt fwsec on sb on newer platforms.
Date: Thu, 15 Jan 2026 17:45:57 +0100
Message-ID: <20260115164203.052533773@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

commit e8b3627bec357698f2d4d6dbf27cdcfa0e9d8715 upstream.

The changes to always loads fwsec sb causes problems on newer GPUs
which don't use this path.

Add hooks and pass through the device specific layers.

Fixes: da67179e5538 ("drm/nouveau/gsp: Allocate fwsec-sb at boot")
Cc: <stable@vger.kernel.org> # v6.16+
Cc: Lyude Paul <lyude@redhat.com>
Cc: Timur Tabi <ttabi@nvidia.com>
Tested-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Tested-by: Christopher Snowhill <chris@kode54.net>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260102041829.2748009-1-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../gpu/drm/nouveau/nvkm/subdev/gsp/ad102.c   |  3 +++
 .../gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c   |  8 +------
 .../gpu/drm/nouveau/nvkm/subdev/gsp/ga100.c   |  3 +++
 .../gpu/drm/nouveau/nvkm/subdev/gsp/ga102.c   |  3 +++
 .../gpu/drm/nouveau/nvkm/subdev/gsp/priv.h    | 23 +++++++++++++++++--
 .../gpu/drm/nouveau/nvkm/subdev/gsp/tu102.c   | 15 ++++++++++++
 .../gpu/drm/nouveau/nvkm/subdev/gsp/tu116.c   |  3 +++
 7 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ad102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ad102.c
index 35d1fcef520b..c456a9626823 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ad102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ad102.c
@@ -30,6 +30,9 @@ ad102_gsp = {
 
 	.booter.ctor = ga102_gsp_booter_ctor,
 
+	.fwsec_sb.ctor = tu102_gsp_fwsec_sb_ctor,
+	.fwsec_sb.dtor = tu102_gsp_fwsec_sb_dtor,
+
 	.dtor = r535_gsp_dtor,
 	.oneinit = tu102_gsp_oneinit,
 	.init = tu102_gsp_init,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c
index 503760246660..851140e80122 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c
@@ -337,18 +337,12 @@ nvkm_gsp_fwsec_sb(struct nvkm_gsp *gsp)
 }
 
 int
-nvkm_gsp_fwsec_sb_ctor(struct nvkm_gsp *gsp)
+nvkm_gsp_fwsec_sb_init(struct nvkm_gsp *gsp)
 {
 	return nvkm_gsp_fwsec_init(gsp, &gsp->fws.falcon.sb, "fwsec-sb",
 				   NVFW_FALCON_APPIF_DMEMMAPPER_CMD_SB);
 }
 
-void
-nvkm_gsp_fwsec_sb_dtor(struct nvkm_gsp *gsp)
-{
-	nvkm_falcon_fw_dtor(&gsp->fws.falcon.sb);
-}
-
 int
 nvkm_gsp_fwsec_frts(struct nvkm_gsp *gsp)
 {
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga100.c
index d201e8697226..27a13aeccd3c 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga100.c
@@ -47,6 +47,9 @@ ga100_gsp = {
 
 	.booter.ctor = tu102_gsp_booter_ctor,
 
+	.fwsec_sb.ctor = tu102_gsp_fwsec_sb_ctor,
+	.fwsec_sb.dtor = tu102_gsp_fwsec_sb_dtor,
+
 	.dtor = r535_gsp_dtor,
 	.oneinit = tu102_gsp_oneinit,
 	.init = tu102_gsp_init,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga102.c
index 917f7e2f6c46..b6b3eb6f4c00 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga102.c
@@ -158,6 +158,9 @@ ga102_gsp_r535 = {
 
 	.booter.ctor = ga102_gsp_booter_ctor,
 
+	.fwsec_sb.ctor = tu102_gsp_fwsec_sb_ctor,
+	.fwsec_sb.dtor = tu102_gsp_fwsec_sb_dtor,
+
 	.dtor = r535_gsp_dtor,
 	.oneinit = tu102_gsp_oneinit,
 	.init = tu102_gsp_init,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/priv.h b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/priv.h
index 86bdd203bc10..9dd66a2e3801 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/priv.h
@@ -7,9 +7,8 @@ enum nvkm_acr_lsf_id;
 
 int nvkm_gsp_fwsec_frts(struct nvkm_gsp *);
 
-int nvkm_gsp_fwsec_sb_ctor(struct nvkm_gsp *);
 int nvkm_gsp_fwsec_sb(struct nvkm_gsp *);
-void nvkm_gsp_fwsec_sb_dtor(struct nvkm_gsp *);
+int nvkm_gsp_fwsec_sb_init(struct nvkm_gsp *gsp);
 
 struct nvkm_gsp_fwif {
 	int version;
@@ -52,6 +51,11 @@ struct nvkm_gsp_func {
 			    struct nvkm_falcon *, struct nvkm_falcon_fw *);
 	} booter;
 
+	struct {
+		int (*ctor)(struct nvkm_gsp *);
+		void (*dtor)(struct nvkm_gsp *);
+	} fwsec_sb;
+
 	void (*dtor)(struct nvkm_gsp *);
 	int (*oneinit)(struct nvkm_gsp *);
 	int (*init)(struct nvkm_gsp *);
@@ -67,6 +71,8 @@ extern const struct nvkm_falcon_func tu102_gsp_flcn;
 extern const struct nvkm_falcon_fw_func tu102_gsp_fwsec;
 int tu102_gsp_booter_ctor(struct nvkm_gsp *, const char *, const struct firmware *,
 			  struct nvkm_falcon *, struct nvkm_falcon_fw *);
+int tu102_gsp_fwsec_sb_ctor(struct nvkm_gsp *);
+void tu102_gsp_fwsec_sb_dtor(struct nvkm_gsp *);
 int tu102_gsp_oneinit(struct nvkm_gsp *);
 int tu102_gsp_init(struct nvkm_gsp *);
 int tu102_gsp_fini(struct nvkm_gsp *, bool suspend);
@@ -91,5 +97,18 @@ int r535_gsp_fini(struct nvkm_gsp *, bool suspend);
 int nvkm_gsp_new_(const struct nvkm_gsp_fwif *, struct nvkm_device *, enum nvkm_subdev_type, int,
 		  struct nvkm_gsp **);
 
+static inline int nvkm_gsp_fwsec_sb_ctor(struct nvkm_gsp *gsp)
+{
+	if (gsp->func->fwsec_sb.ctor)
+		return gsp->func->fwsec_sb.ctor(gsp);
+	return 0;
+}
+
+static inline void nvkm_gsp_fwsec_sb_dtor(struct nvkm_gsp *gsp)
+{
+	if (gsp->func->fwsec_sb.dtor)
+		gsp->func->fwsec_sb.dtor(gsp);
+}
+
 extern const struct nvkm_gsp_func gv100_gsp;
 #endif
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu102.c
index 81e56da0474a..04b642a1f730 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu102.c
@@ -30,6 +30,18 @@
 #include <nvfw/fw.h>
 #include <nvfw/hs.h>
 
+int
+tu102_gsp_fwsec_sb_ctor(struct nvkm_gsp *gsp)
+{
+	return nvkm_gsp_fwsec_sb_init(gsp);
+}
+
+void
+tu102_gsp_fwsec_sb_dtor(struct nvkm_gsp *gsp)
+{
+	nvkm_falcon_fw_dtor(&gsp->fws.falcon.sb);
+}
+
 static int
 tu102_gsp_booter_unload(struct nvkm_gsp *gsp, u32 mbox0, u32 mbox1)
 {
@@ -370,6 +382,9 @@ tu102_gsp = {
 
 	.booter.ctor = tu102_gsp_booter_ctor,
 
+	.fwsec_sb.ctor = tu102_gsp_fwsec_sb_ctor,
+	.fwsec_sb.dtor = tu102_gsp_fwsec_sb_dtor,
+
 	.dtor = r535_gsp_dtor,
 	.oneinit = tu102_gsp_oneinit,
 	.init = tu102_gsp_init,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu116.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu116.c
index 97eb046c25d0..58cf25842421 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu116.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu116.c
@@ -30,6 +30,9 @@ tu116_gsp = {
 
 	.booter.ctor = tu102_gsp_booter_ctor,
 
+	.fwsec_sb.ctor = tu102_gsp_fwsec_sb_ctor,
+	.fwsec_sb.dtor = tu102_gsp_fwsec_sb_dtor,
+
 	.dtor = r535_gsp_dtor,
 	.oneinit = tu102_gsp_oneinit,
 	.init = tu102_gsp_init,
-- 
2.52.0



