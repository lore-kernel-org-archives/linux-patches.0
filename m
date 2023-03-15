Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1DB4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F58C433EF;
	Wed, 15 Mar 2023 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883253;
	bh=CLQCi32XALQCeFoT350WOxU4qJ4EXUKnaul/jbpzpkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zP9P2qkkdinTSthzNoXEbbwB8y5nAyuJIZ2j77s+Tr00L3RUgXSebT4062Sfa37ft
	 I3yJ5N1AArnBQQVMISGMREhcE6n9hCxxbVwBDEFNUMGN9MSE9IxyOzHGKw2JOsopNp
	 2u3qVtwNbaTh10dvVIGnznZ4yhoXbsQ4qYHo2jNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/145] drm/nouveau/kms/nv50-: remove unused functions
Date: Wed, 15 Mar 2023 13:11:49 +0100
Message-Id: <20230315115740.504896721@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 89ed996b888faaf11c69bb4cbc19f21475c9050e ]

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Stable-dep-of: 3638a820c5c3 ("drm/nouveau/kms/nv50: fix nv50_wndw_new_ prototype")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 16 ----------------
 drivers/gpu/drm/nouveau/dispnv50/wndw.c | 12 ------------
 drivers/gpu/drm/nouveau/dispnv50/wndw.h |  2 --
 3 files changed, 30 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index d7b9f7f8c9e31..0722b907bfcf4 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2622,14 +2622,6 @@ nv50_display_fini(struct drm_device *dev, bool runtime, bool suspend)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct drm_encoder *encoder;
-	struct drm_plane *plane;
-
-	drm_for_each_plane(plane, dev) {
-		struct nv50_wndw *wndw = nv50_wndw(plane);
-		if (plane->funcs != &nv50_wndw)
-			continue;
-		nv50_wndw_fini(wndw);
-	}
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
 		if (encoder->encoder_type != DRM_MODE_ENCODER_DPMST)
@@ -2645,7 +2637,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
 {
 	struct nv50_core *core = nv50_disp(dev)->core;
 	struct drm_encoder *encoder;
-	struct drm_plane *plane;
 
 	if (resume || runtime)
 		core->func->init(core);
@@ -2658,13 +2649,6 @@ nv50_display_init(struct drm_device *dev, bool resume, bool runtime)
 		}
 	}
 
-	drm_for_each_plane(plane, dev) {
-		struct nv50_wndw *wndw = nv50_wndw(plane);
-		if (plane->funcs != &nv50_wndw)
-			continue;
-		nv50_wndw_init(wndw);
-	}
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
index 8d048bacd6f02..e1e62674e82d3 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -694,18 +694,6 @@ nv50_wndw_notify(struct nvif_notify *notify)
 	return NVIF_NOTIFY_KEEP;
 }
 
-void
-nv50_wndw_fini(struct nv50_wndw *wndw)
-{
-	nvif_notify_put(&wndw->notify);
-}
-
-void
-nv50_wndw_init(struct nv50_wndw *wndw)
-{
-	nvif_notify_get(&wndw->notify);
-}
-
 static const u64 nv50_cursor_format_modifiers[] = {
 	DRM_FORMAT_MOD_LINEAR,
 	DRM_FORMAT_MOD_INVALID,
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.h b/drivers/gpu/drm/nouveau/dispnv50/wndw.h
index f4e0c50800344..980f8ea96d54a 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.h
@@ -40,8 +40,6 @@ int nv50_wndw_new_(const struct nv50_wndw_func *, struct drm_device *,
 		   enum drm_plane_type, const char *name, int index,
 		   const u32 *format, enum nv50_disp_interlock_type,
 		   u32 interlock_data, u32 heads, struct nv50_wndw **);
-void nv50_wndw_init(struct nv50_wndw *);
-void nv50_wndw_fini(struct nv50_wndw *);
 void nv50_wndw_flush_set(struct nv50_wndw *, u32 *interlock,
 			 struct nv50_wndw_atom *);
 void nv50_wndw_flush_clr(struct nv50_wndw *, u32 *interlock, bool flush,
-- 
2.39.2



