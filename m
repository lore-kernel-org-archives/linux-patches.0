Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622421;
	b=e4sCrLMFPN68HZABA+8l8pPUz7mKRBOAjv0XmP/ZGiJfnyRmZdLCDsb0mIJ3BcfwG3GE
	 LF/CJTUfAIiBrr9Fj088LJPMXGQOh67xW+1JSliUHeqVJOvBrLuW6zkMxpEqqZgGMCU3z
	 ygKP05I7jXx4/tOk4gWos13oQl3/JyFXYZzTLn3KmF1EKa9TmNtVEKWebLGgztw6yGzGI
	 lZNHkQIwrwxYiuo0SefeDSOmYgsc3ookBif7ZKuxOXf6Tp01WgSd9RQjLsPRA5vEfQikV
	 mgBJd6JerOHRzEArEALHflrLtHwhI+DYMQGueyQclrnWRTS9kno5Ezr44FJaQKANf0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=31z7/kRGJCcHZ428j95221ez+f/FKKWYAsrbEzmPXZo=;
	b=G1lo4AFI1MeOPDaF34RtjslNKp8Go9ab1X5FZOW+rat9rKPA4LXHs5bDgMCIECZRJLE5
	 SiaNa1WA8PO0jNpXWr/yPiHHhqPDms6u7uh65HNvofDvUa9YqcVddzevGiIh8c1XG3buH
	 g20B5VMLMFu+jtpV8uyxAueg+dWUIU9UDVpGcC2Ym9BsQKrWA+3NEGjjE55Ge4cedpQAh
	 izpPXPXvb0n4YXcDPa2dBS7nA3QjfCLuw1fIllC3HXe3AN9azC6E65fpgpk4ZTF3sHvse
	 +2fGkgpmAVrqlzQ6JovMNcRgJiytGT62D5wFJ9uUA+ZnTe1Z+P4U5q/UdzQWRTKlAYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zup+YR9Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F28606A331;
	Wed, 25 Nov 2026 16:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zup+YR9Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22741F000C6;
	Wed, 25 Nov 2026 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622421;
	bh=31z7/kRGJCcHZ428j95221ez+f/FKKWYAsrbEzmPXZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zup+YR9YALNZZI5KCRQh9S6Lm45Gz2GPHwiHPyy7YAST5u1JzI41hY9oGAh6XaDUo
	 EeRk2sbUzmt3wUBFqfyk2RBKLvEUFFiVNFjcY2MDbc3dl9qF38qGbBQv+0EnorkFWC
	 NVZNgIBw1EI9ynpcLbfqTPydZ79TSHisbZzfegwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 531/990] accel/amdxdna: Preallocate hardware context schedulers
Date: Wed, 25 Nov 2026 15:31:38 +0100
Message-ID: <20261125143834.531670386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit f7afecd54296cf7ad6fa36f692d2a7427e32f25d ]

The hardware context scheduler fence is exposed through
drm_syncobj_add_point(). After a hardware context is destroyed,
userspace can still call drm_sched_fence_get_timeline_name() on the
fence through SYNC_IOC_FILE_INFO. This results in a use-after-free
when accessing fence->sched->name.

Preallocate hardware context schedulers and free them during device
teardown instead. A destroyed hardware context no longer frees its
scheduler, ensuring that the scheduler remains valid while its fences
are still accessible.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reported-by: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
Link: https://lore.kernel.org/dri-devel/20260902012712.880520-1-malhyuk97@gmail.com/
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260923200501.281208-1-lizhi.hou@amd.com
[ sashal: Adapted to the older tree by using ndev->xdna, a single firmware-load failure path that unwinds the scheduler init, and dropping the duplicate ndev declaration and assignment in the hwctx functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 117 +++++++++++++++++++++++--------
 drivers/accel/amdxdna/aie2_pci.c |   9 ++-
 drivers/accel/amdxdna/aie2_pci.h |   6 +-
 3 files changed, 99 insertions(+), 33 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index a87b24654c367..fb411887b6470 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -7,6 +7,7 @@
 #include <drm/drm_device.h>
 #include <drm/drm_gem.h>
 #include <drm/drm_gem_shmem_helper.h>
+#include <drm/drm_managed.h>
 #include <drm/drm_print.h>
 #include <drm/drm_syncobj.h>
 #include <linux/hmm.h>
@@ -62,7 +63,7 @@ static void aie2_hwctx_status_restore(struct amdxdna_hwctx *hwctx)
 static void aie2_hwctx_stop(struct amdxdna_dev *xdna, struct amdxdna_hwctx *hwctx,
 			    struct drm_sched_job *bad_job)
 {
-	drm_sched_stop(&hwctx->priv->sched, bad_job);
+	drm_sched_stop(hwctx->priv->sched, bad_job);
 	aie2_destroy_context(xdna->dev_handle, hwctx);
 }
 
@@ -96,7 +97,7 @@ static int aie2_hwctx_restart(struct amdxdna_dev *xdna, struct amdxdna_hwctx *hw
 	}
 
 out:
-	drm_sched_start(&hwctx->priv->sched, 0);
+	drm_sched_start(hwctx->priv->sched, 0);
 	XDNA_DBG(xdna, "%s restarted, ret %d", hwctx->name, ret);
 	return ret;
 }
@@ -528,10 +529,19 @@ static void aie2_ctx_syncobj_destroy(struct amdxdna_hwctx *hwctx)
 	drm_syncobj_put(hwctx->priv->syncobj);
 }
 
-int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
+void aie2_hwctx_sched_fini(struct amdxdna_dev_hdl *ndev)
 {
-	struct amdxdna_client *client = hwctx->client;
-	struct amdxdna_dev *xdna = client->xdna;
+	int i;
+
+	for (i = 0; i < ndev->priv->hwctx_limit; i++)
+		drm_sched_fini(&ndev->hwctx_sched[i]);
+
+	ida_destroy(&ndev->hwctx_sched_ida);
+}
+
+int aie2_hwctx_sched_init(struct amdxdna_dev_hdl *ndev)
+{
+	struct amdxdna_dev *xdna = ndev->xdna;
 	const struct drm_sched_init_args args = {
 		.ops = &sched_ops,
 		.num_rqs = DRM_SCHED_PRIORITY_COUNT,
@@ -540,10 +550,57 @@ int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
 		.name = "amdxdna_js",
 		.dev = xdna->ddev.dev,
 	};
-	struct drm_gpu_scheduler *sched;
+	int i, ret;
+
+	ndev->hwctx_sched = drmm_kcalloc(&xdna->ddev, ndev->priv->hwctx_limit,
+					 sizeof(*ndev->hwctx_sched), GFP_KERNEL);
+	if (!ndev->hwctx_sched)
+		return -ENOMEM;
+
+	for (i = 0; i < ndev->priv->hwctx_limit; i++) {
+		ret = drm_sched_init(&ndev->hwctx_sched[i], &args);
+		if (ret) {
+			XDNA_ERR(xdna, "Failed to init DRM scheduler. ret %d", ret);
+			goto fini_sched;
+		}
+	}
+
+	ida_init(&ndev->hwctx_sched_ida);
+
+	return 0;
+
+fini_sched:
+	while (--i >= 0)
+		drm_sched_fini(&ndev->hwctx_sched[i]);
+
+	return ret;
+}
+
+static struct drm_gpu_scheduler *aie2_hwctx_sched_alloc(struct amdxdna_dev_hdl *ndev)
+{
+	int ret;
+
+	ret = ida_alloc_range(&ndev->hwctx_sched_ida, 0,
+			      ndev->priv->hwctx_limit - 1, GFP_KERNEL);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	return &ndev->hwctx_sched[ret];
+}
+
+static void aie2_hwctx_sched_free(struct amdxdna_dev_hdl *ndev,
+				  struct drm_gpu_scheduler *sched)
+{
+	ida_free(&ndev->hwctx_sched_ida, sched - ndev->hwctx_sched);
+}
+
+int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
+{
+	struct amdxdna_client *client = hwctx->client;
+	struct amdxdna_dev *xdna = client->xdna;
+	struct amdxdna_dev_hdl *ndev = xdna->dev_handle;
 	struct amdxdna_hwctx_priv *priv;
 	struct amdxdna_gem_obj *heap;
-	struct amdxdna_dev_hdl *ndev;
 	int i, ret;
 
 	priv = kzalloc(sizeof(*hwctx->priv), GFP_KERNEL);
@@ -551,13 +608,26 @@ int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
 		return -ENOMEM;
 	hwctx->priv = priv;
 
+	priv->sched = aie2_hwctx_sched_alloc(ndev);
+	if (IS_ERR(priv->sched)) {
+		ret = PTR_ERR(priv->sched);
+		goto free_priv;
+	}
+
+	ret = drm_sched_entity_init(&priv->entity, DRM_SCHED_PRIORITY_NORMAL,
+				    &priv->sched, 1, NULL);
+	if (ret) {
+		XDNA_ERR(xdna, "Failed to initial sched entity. ret %d", ret);
+		goto free_sched;
+	}
+
 	mutex_lock(&client->mm_lock);
 	heap = client->dev_heap;
 	if (!heap) {
 		XDNA_ERR(xdna, "The client dev heap object not exist");
 		mutex_unlock(&client->mm_lock);
 		ret = -ENOENT;
-		goto free_priv;
+		goto free_entity;
 	}
 	drm_gem_object_get(to_gobj(heap));
 	mutex_unlock(&client->mm_lock);
@@ -590,30 +660,16 @@ int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
 		priv->cmd_buf[i] = abo;
 	}
 
-	sched = &priv->sched;
 	mutex_init(&priv->io_lock);
 
 	fs_reclaim_acquire(GFP_KERNEL);
 	might_lock(&priv->io_lock);
 	fs_reclaim_release(GFP_KERNEL);
 
-	ret = drm_sched_init(sched, &args);
-	if (ret) {
-		XDNA_ERR(xdna, "Failed to init DRM scheduler. ret %d", ret);
-		goto free_cmd_bufs;
-	}
-
-	ret = drm_sched_entity_init(&priv->entity, DRM_SCHED_PRIORITY_NORMAL,
-				    &sched, 1, NULL);
-	if (ret) {
-		XDNA_ERR(xdna, "Failed to initial sched entiry. ret %d", ret);
-		goto free_sched;
-	}
-
 	ret = aie2_hwctx_col_list(hwctx);
 	if (ret) {
 		XDNA_ERR(xdna, "Create col list failed, ret %d", ret);
-		goto free_entity;
+		goto free_cmd_bufs;
 	}
 
 	ret = amdxdna_pm_resume_get(xdna);
@@ -641,7 +697,6 @@ int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
 	amdxdna_pm_suspend_put(xdna);
 
 	hwctx->status = HWCTX_STAT_INIT;
-	ndev = xdna->dev_handle;
 	ndev->hwctx_num++;
 	init_waitqueue_head(&priv->job_free_wq);
 
@@ -655,10 +710,6 @@ int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
 	amdxdna_pm_suspend_put(xdna);
 free_col_list:
 	kfree(hwctx->col_list);
-free_entity:
-	drm_sched_entity_destroy(&priv->entity);
-free_sched:
-	drm_sched_fini(&priv->sched);
 free_cmd_bufs:
 	for (i = 0; i < ARRAY_SIZE(priv->cmd_buf); i++) {
 		if (!priv->cmd_buf[i])
@@ -668,6 +719,10 @@ int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
 	amdxdna_gem_unpin(heap);
 put_heap:
 	drm_gem_object_put(to_gobj(heap));
+free_entity:
+	drm_sched_entity_destroy(&priv->entity);
+free_sched:
+	aie2_hwctx_sched_free(ndev, priv->sched);
 free_priv:
 	kfree(priv);
 	return ret;
@@ -687,10 +742,10 @@ void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx)
 	aie2_hwctx_wait_for_idle(hwctx);
 
 	/* Request fw to destroy hwctx and cancel the rest pending requests */
-	drm_sched_stop(&hwctx->priv->sched, NULL);
+	drm_sched_stop(hwctx->priv->sched, NULL);
 	aie2_release_resource(hwctx);
 	hwctx->status = HWCTX_STAT_STOP;
-	drm_sched_start(&hwctx->priv->sched, 0);
+	drm_sched_start(hwctx->priv->sched, 0);
 
 	mutex_unlock(&xdna->dev_lock);
 	drm_sched_entity_destroy(&hwctx->priv->entity);
@@ -701,7 +756,7 @@ void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx)
 		   atomic64_read(&hwctx->job_free_cnt));
 	mutex_lock(&xdna->dev_lock);
 
-	drm_sched_fini(&hwctx->priv->sched);
+	aie2_hwctx_sched_free(ndev, hwctx->priv->sched);
 	aie2_ctx_syncobj_destroy(hwctx);
 
 	for (idx = 0; idx < ARRAY_SIZE(hwctx->priv->cmd_buf); idx++)
diff --git a/drivers/accel/amdxdna/aie2_pci.c b/drivers/accel/amdxdna/aie2_pci.c
index 4a7d1feac6a5e..5a030da5b9d4a 100644
--- a/drivers/accel/amdxdna/aie2_pci.c
+++ b/drivers/accel/amdxdna/aie2_pci.c
@@ -502,11 +502,15 @@ static int aie2_init(struct amdxdna_dev *xdna)
 	ndev->priv = xdna->dev_info->dev_priv;
 	ndev->xdna = xdna;
 
+	ret = aie2_hwctx_sched_init(ndev);
+	if (ret)
+		return ret;
+
 	ret = request_firmware(&fw, ndev->priv->fw_path, &pdev->dev);
 	if (ret) {
 		XDNA_ERR(xdna, "failed to request_firmware %s, ret %d",
 			 ndev->priv->fw_path, ret);
-		return ret;
+		goto free_hwctx_sched;
 	}
 
 	ret = pcim_enable_device(pdev);
@@ -597,6 +601,8 @@ static int aie2_init(struct amdxdna_dev *xdna)
 	aie2_hw_stop(xdna);
 release_fw:
 	release_firmware(fw);
+free_hwctx_sched:
+	aie2_hwctx_sched_fini(ndev);
 
 	return ret;
 }
@@ -605,6 +611,7 @@ static void aie2_fini(struct amdxdna_dev *xdna)
 {
 	amdxdna_pm_fini(xdna);
 	aie2_hw_stop(xdna);
+	aie2_hwctx_sched_fini(xdna->dev_handle);
 }
 
 static int aie2_get_aie_status(struct amdxdna_client *client,
diff --git a/drivers/accel/amdxdna/aie2_pci.h b/drivers/accel/amdxdna/aie2_pci.h
index 7d56f4bca3d63..a3f66e87d0a55 100644
--- a/drivers/accel/amdxdna/aie2_pci.h
+++ b/drivers/accel/amdxdna/aie2_pci.h
@@ -133,7 +133,7 @@ struct amdxdna_hwctx_priv {
 	struct amdxdna_gem_obj		*heap;
 	void				*mbox_chann;
 
-	struct drm_gpu_scheduler	sched;
+	struct drm_gpu_scheduler	*sched;
 	struct drm_sched_entity		entity;
 
 	struct mutex			io_lock; /* protect seq and cmd order */
@@ -173,6 +173,8 @@ struct amdxdna_dev_hdl {
 	u32				total_col;
 	struct aie_version		version;
 	struct aie_metadata		metadata;
+	struct drm_gpu_scheduler	*hwctx_sched;
+	struct ida			hwctx_sched_ida;
 
 	/* power management and clock*/
 	enum amdxdna_power_mode_type	pw_mode;
@@ -293,6 +295,8 @@ int aie2_sync_bo(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job,
 /* aie2_hwctx.c */
 int aie2_hwctx_init(struct amdxdna_hwctx *hwctx);
 void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx);
+int aie2_hwctx_sched_init(struct amdxdna_dev_hdl *ndev);
+void aie2_hwctx_sched_fini(struct amdxdna_dev_hdl *ndev);
 int aie2_hwctx_config(struct amdxdna_hwctx *hwctx, u32 type, u64 value, void *buf, u32 size);
 void aie2_hwctx_suspend(struct amdxdna_client *client);
 int aie2_hwctx_resume(struct amdxdna_client *client);
-- 
2.53.0



