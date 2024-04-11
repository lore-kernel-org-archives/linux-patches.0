Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFCD14600E;
	Thu, 11 Apr 2024 10:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831459; cv=none; b=jATy/140bDV6mx9lmQaH0LVecWNAI+ZJrKv3E23rbiT5rMWuNFDHGDnn5jWDpQdnmijxwZ42dwW/21aWMmxWfgZxvwKz8svZTW1PBAxtpFcSbvz8bY4KY8gy1LuYhZxerjdoJDrfV+EzioH+VLgT9M4KfM0iXnwWOl7duOzJc3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831459; c=relaxed/simple;
	bh=o2FE66SDBcS2t6rfUeOHC+6efKB//2QV2zNtSXL+QtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBgy6PcsbmnOZK/pBnGkqPAAblt1G6BHAgxXOAe6K+7f9smgtkl8VNB1WI2CC2o4f25KwiAvmmoRpTaxU6kZ5IEMmQaHIpjT0uVodZ4uLAHAMPwPYWd906/higqWZChSfZWSOuCtGo6KYpo2a4gBQ+mG0fYrthdStQkDc5G7Kmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACS8aNS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACS8aNS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA951C433C7;
	Thu, 11 Apr 2024 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831459;
	bh=o2FE66SDBcS2t6rfUeOHC+6efKB//2QV2zNtSXL+QtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACS8aNS0zkYpcIAy0BO0Sb4DWc9rRuc4s0J7pNWzrniYlOHUWscPBlPbvjzJGjyT1
	 fo5v5ZDpqC2svWPk6YIfp+vV/0sW0Li73gT2dt6yoQqb66chtgyIhjrVcxblUKAMkT
	 QX/LtZtlcExO43fRBOJrDZXihiMMfmE+b3PXBEh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zackr@vmware.com>,
	Roland Scheidegger <sroland@vmware.com>,
	Martin Krastev <krastevm@vmware.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/294] drm/vmwgfx: Fix some static checker warnings
Date: Thu, 11 Apr 2024 11:52:59 +0200
Message-ID: <20240411095436.122972106@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit 74231041d14030f1ae6582b9233bfe782ac23e33 ]

Fix some minor issues that Coverity spotted in the code. None
of that are serious but they're all valid concerns so fixing
them makes sense.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210609172307.131929-5-zackr@vmware.com
Stable-dep-of: 517621b70600 ("drm/vmwgfx: Fix possible null pointer derefence with invalid contexts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_memory.c           |  2 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_binding.c    | 20 ++++++++------------
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c     |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c |  4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c    |  2 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c        |  4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c        |  6 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |  8 ++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_so.c         |  3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c |  4 ++--
 10 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index 89d50f38c0f2c..5af52012fc5c6 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -431,8 +431,10 @@ int ttm_mem_global_init(struct ttm_mem_global *glob)
 
 	si_meminfo(&si);
 
+	spin_lock(&glob->lock);
 	/* set it as 0 by default to keep original behavior of OOM */
 	glob->lower_mem_limit = 0;
+	spin_unlock(&glob->lock);
 
 	ret = ttm_mem_init_kernel_zone(glob, &si);
 	if (unlikely(ret != 0))
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c b/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
index f41550797970b..4da4bf3b7f0b3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_binding.c
@@ -713,7 +713,7 @@ static int vmw_binding_scrub_cb(struct vmw_ctx_bindinfo *bi, bool rebind)
  * without checking which bindings actually need to be emitted
  *
  * @cbs: Pointer to the context's struct vmw_ctx_binding_state
- * @bi: Pointer to where the binding info array is stored in @cbs
+ * @biv: Pointer to where the binding info array is stored in @cbs
  * @max_num: Maximum number of entries in the @bi array.
  *
  * Scans the @bi array for bindings and builds a buffer of view id data.
@@ -723,11 +723,9 @@ static int vmw_binding_scrub_cb(struct vmw_ctx_bindinfo *bi, bool rebind)
  * contains the command data.
  */
 static void vmw_collect_view_ids(struct vmw_ctx_binding_state *cbs,
-				 const struct vmw_ctx_bindinfo *bi,
+				 const struct vmw_ctx_bindinfo_view *biv,
 				 u32 max_num)
 {
-	const struct vmw_ctx_bindinfo_view *biv =
-		container_of(bi, struct vmw_ctx_bindinfo_view, bi);
 	unsigned long i;
 
 	cbs->bind_cmd_count = 0;
@@ -835,7 +833,7 @@ static int vmw_emit_set_sr(struct vmw_ctx_binding_state *cbs,
  */
 static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->render_targets[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->render_targets[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetRenderTargets body;
@@ -871,7 +869,7 @@ static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
  * without checking which bindings actually need to be emitted
  *
  * @cbs: Pointer to the context's struct vmw_ctx_binding_state
- * @bi: Pointer to where the binding info array is stored in @cbs
+ * @biso: Pointer to where the binding info array is stored in @cbs
  * @max_num: Maximum number of entries in the @bi array.
  *
  * Scans the @bi array for bindings and builds a buffer of SVGA3dSoTarget data.
@@ -881,11 +879,9 @@ static int vmw_emit_set_rt(struct vmw_ctx_binding_state *cbs)
  * contains the command data.
  */
 static void vmw_collect_so_targets(struct vmw_ctx_binding_state *cbs,
-				   const struct vmw_ctx_bindinfo *bi,
+				   const struct vmw_ctx_bindinfo_so_target *biso,
 				   u32 max_num)
 {
-	const struct vmw_ctx_bindinfo_so_target *biso =
-		container_of(bi, struct vmw_ctx_bindinfo_so_target, bi);
 	unsigned long i;
 	SVGA3dSoTarget *so_buffer = (SVGA3dSoTarget *) cbs->bind_cmd_buffer;
 
@@ -916,7 +912,7 @@ static void vmw_collect_so_targets(struct vmw_ctx_binding_state *cbs,
  */
 static int vmw_emit_set_so_target(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->so_targets[0].bi;
+	const struct vmw_ctx_bindinfo_so_target *loc = &cbs->so_targets[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetSOTargets body;
@@ -1063,7 +1059,7 @@ static int vmw_emit_set_vb(struct vmw_ctx_binding_state *cbs)
 
 static int vmw_emit_set_uav(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->ua_views[0].views[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->ua_views[0].views[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetUAViews body;
@@ -1093,7 +1089,7 @@ static int vmw_emit_set_uav(struct vmw_ctx_binding_state *cbs)
 
 static int vmw_emit_set_cs_uav(struct vmw_ctx_binding_state *cbs)
 {
-	const struct vmw_ctx_bindinfo *loc = &cbs->ua_views[1].views[0].bi;
+	const struct vmw_ctx_bindinfo_view *loc = &cbs->ua_views[1].views[0];
 	struct {
 		SVGA3dCmdHeader header;
 		SVGA3dCmdDXSetCSUAViews body;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
index 9a9fe10d829b8..87a39721e5bc0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
@@ -514,7 +514,7 @@ static void vmw_cmdbuf_work_func(struct work_struct *work)
 	struct vmw_cmdbuf_man *man =
 		container_of(work, struct vmw_cmdbuf_man, work);
 	struct vmw_cmdbuf_header *entry, *next;
-	uint32_t dummy;
+	uint32_t dummy = 0;
 	bool send_fence = false;
 	struct list_head restart_head[SVGA_CB_CONTEXT_MAX];
 	int i;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
index 47b92d0c898a7..f212368c03129 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
@@ -160,6 +160,7 @@ void vmw_cmdbuf_res_commit(struct list_head *list)
 void vmw_cmdbuf_res_revert(struct list_head *list)
 {
 	struct vmw_cmdbuf_res *entry, *next;
+	int ret;
 
 	list_for_each_entry_safe(entry, next, list, head) {
 		switch (entry->state) {
@@ -167,7 +168,8 @@ void vmw_cmdbuf_res_revert(struct list_head *list)
 			vmw_cmdbuf_res_free(entry->man, entry);
 			break;
 		case VMW_CMDBUF_RES_DEL:
-			drm_ht_insert_item(&entry->man->resources, &entry->hash);
+			ret = drm_ht_insert_item(&entry->man->resources, &entry->hash);
+			BUG_ON(ret);
 			list_del(&entry->head);
 			list_add_tail(&entry->head, &entry->man->list);
 			entry->state = VMW_CMDBUF_RES_COMMITTED;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 00082c679170a..831291b5d1a03 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2535,6 +2535,8 @@ static int vmw_cmd_dx_so_define(struct vmw_private *dev_priv,
 
 	so_type = vmw_so_cmd_to_type(header->id);
 	res = vmw_context_cotable(ctx_node->ctx, vmw_so_cotables[so_type]);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
 	cmd = container_of(header, typeof(*cmd), header);
 	ret = vmw_cotable_notify(res, cmd->defined_id);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
index 7f95ed6aa2241..fb0797b380dd2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -494,11 +494,13 @@ static void vmw_mob_pt_setup(struct vmw_mob *mob,
 {
 	unsigned long num_pt_pages = 0;
 	struct ttm_buffer_object *bo = mob->pt_bo;
-	struct vmw_piter save_pt_iter;
+	struct vmw_piter save_pt_iter = {0};
 	struct vmw_piter pt_iter;
 	const struct vmw_sg_table *vsgt;
 	int ret;
 
+	BUG_ON(num_data_pages == 0);
+
 	ret = ttm_bo_reserve(bo, false, true, NULL);
 	BUG_ON(ret != 0);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index 15b5bde693242..751582f5ab0b1 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -154,6 +154,7 @@ static unsigned long vmw_port_hb_out(struct rpc_channel *channel,
 	/* HB port can't access encrypted memory. */
 	if (hb && !mem_encrypt_active()) {
 		unsigned long bp = channel->cookie_high;
+		u32 channel_id = (channel->channel_id << 16);
 
 		si = (uintptr_t) msg;
 		di = channel->cookie_low;
@@ -161,7 +162,7 @@ static unsigned long vmw_port_hb_out(struct rpc_channel *channel,
 		VMW_PORT_HB_OUT(
 			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
 			msg_len, si, di,
-			VMWARE_HYPERVISOR_HB | (channel->channel_id << 16) |
+			VMWARE_HYPERVISOR_HB | channel_id |
 			VMWARE_HYPERVISOR_OUT,
 			VMW_HYPERVISOR_MAGIC, bp,
 			eax, ebx, ecx, edx, si, di);
@@ -209,6 +210,7 @@ static unsigned long vmw_port_hb_in(struct rpc_channel *channel, char *reply,
 	/* HB port can't access encrypted memory */
 	if (hb && !mem_encrypt_active()) {
 		unsigned long bp = channel->cookie_low;
+		u32 channel_id = (channel->channel_id << 16);
 
 		si = channel->cookie_high;
 		di = (uintptr_t) reply;
@@ -216,7 +218,7 @@ static unsigned long vmw_port_hb_in(struct rpc_channel *channel, char *reply,
 		VMW_PORT_HB_IN(
 			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
 			reply_len, si, di,
-			VMWARE_HYPERVISOR_HB | (channel->channel_id << 16),
+			VMWARE_HYPERVISOR_HB | channel_id,
 			VMW_HYPERVISOR_MAGIC, bp,
 			eax, ebx, ecx, edx, si, di);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 5e922d9d5f2cc..26f88d64879f1 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -114,6 +114,7 @@ static void vmw_resource_release(struct kref *kref)
 	    container_of(kref, struct vmw_resource, kref);
 	struct vmw_private *dev_priv = res->dev_priv;
 	int id;
+	int ret;
 	struct idr *idr = &dev_priv->res_idr[res->func->res_type];
 
 	spin_lock(&dev_priv->resource_lock);
@@ -122,7 +123,8 @@ static void vmw_resource_release(struct kref *kref)
 	if (res->backup) {
 		struct ttm_buffer_object *bo = &res->backup->base;
 
-		ttm_bo_reserve(bo, false, false, NULL);
+		ret = ttm_bo_reserve(bo, false, false, NULL);
+		BUG_ON(ret);
 		if (vmw_resource_mob_attached(res) &&
 		    res->func->unbind != NULL) {
 			struct ttm_validate_buffer val_buf;
@@ -1001,7 +1003,9 @@ int vmw_resource_pin(struct vmw_resource *res, bool interruptible)
 		if (res->backup) {
 			vbo = res->backup;
 
-			ttm_bo_reserve(&vbo->base, interruptible, false, NULL);
+			ret = ttm_bo_reserve(&vbo->base, interruptible, false, NULL);
+			if (ret)
+				goto out_no_validate;
 			if (!vbo->base.pin_count) {
 				ret = ttm_bo_validate
 					(&vbo->base,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_so.c b/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
index 3f97b61dd5d83..9330f1a0f1743 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_so.c
@@ -538,7 +538,8 @@ const SVGACOTableType vmw_so_cotables[] = {
 	[vmw_so_ds] = SVGA_COTABLE_DEPTHSTENCIL,
 	[vmw_so_rs] = SVGA_COTABLE_RASTERIZERSTATE,
 	[vmw_so_ss] = SVGA_COTABLE_SAMPLER,
-	[vmw_so_so] = SVGA_COTABLE_STREAMOUTPUT
+	[vmw_so_so] = SVGA_COTABLE_STREAMOUTPUT,
+	[vmw_so_max]= SVGA_COTABLE_MAX
 };
 
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
index f2e2bf6d1421f..cc1cfc827bb9a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -585,13 +585,13 @@ int vmw_validation_bo_validate(struct vmw_validation_context *ctx, bool intr)
 			container_of(entry->base.bo, typeof(*vbo), base);
 
 		if (entry->cpu_blit) {
-			struct ttm_operation_ctx ctx = {
+			struct ttm_operation_ctx ttm_ctx = {
 				.interruptible = intr,
 				.no_wait_gpu = false
 			};
 
 			ret = ttm_bo_validate(entry->base.bo,
-					      &vmw_nonfixed_placement, &ctx);
+					      &vmw_nonfixed_placement, &ttm_ctx);
 		} else {
 			ret = vmw_validation_bo_validate_single
 			(entry->base.bo, intr, entry->as_mob);
-- 
2.43.0



