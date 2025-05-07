Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A9D1DDC23;
	Wed,  7 May 2025 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643751; cv=none; b=JkWQhowO4/hylV0v/R9AYfqmcDf/1/4NSnrtkMAd6tI0rDodGaPLmMGRPXoEjYRMQaRY6M0UjgvQossqxz7HUszZOqR+AnU81qiKv79i0OCj8+K2JLL2IelGwkpxdUtCB2dlVIdNbghdh/Cr2j+LHMFbGQs9ipIhhJBNzp8AK6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643751; c=relaxed/simple;
	bh=72lQOFaB8bifiu4goCDpcPx3zu/XrbmdWjKajfy+FL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNL7hfD3wKx5Xeh/NYeerKf5rA8nV/Lj9WFy0v792Zbf7aUO83pJsDZ830z/cEZhwFWpcZDdEaxNBDkBiPVKOT8gPn2HrTDWuWtWykbUSMeF6dhs5kIbSbGc4JJIyKxf0TuZaPumVoygqZMr7n3iLedJTPO9QP2mp9dnlF/NOH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0RMqYd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0RMqYd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDF4C4CEE2;
	Wed,  7 May 2025 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643751;
	bh=72lQOFaB8bifiu4goCDpcPx3zu/XrbmdWjKajfy+FL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0RMqYd/jO8F0NZJOSYc+G/rdUg6L7HCQcwCDafky9OmpSeZnq6TbTsPT4oL3yle2
	 cFeaVkQq7XgAdGHH4LGW1ZlQal9mPA1AbClPqL8oAD3x5e28TC6ad3Q7+NCfhoO4Dz
	 K3u67WnZBXYMarcZjQhXdvurBjs8R50ujv+CtXCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 92/97] drm/amd/display: Clean up style problems in amdgpu_dm_hdcp.c
Date: Wed,  7 May 2025 20:40:07 +0200
Message-ID: <20250507183810.675159773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit a19de9dbb4d293c064b02cec8ef134cb9812d639 ]

Conform to Linux kernel coding style.

And promote sysfs entry for set/get srm to kdoc.

Suggested-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: be593d9d91c5 ("drm/amd/display: Fix slab-use-after-free in hdcp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_hdcp.c    | 185 +++++++++---------
 1 file changed, 89 insertions(+), 96 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 7fc26ca30dcd6..15537f554ca86 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -39,10 +39,10 @@
 static bool
 lp_write_i2c(void *handle, uint32_t address, const uint8_t *data, uint32_t size)
 {
-
 	struct dc_link *link = handle;
 	struct i2c_payload i2c_payloads[] = {{true, address, size, (void *)data} };
-	struct i2c_command cmd = {i2c_payloads, 1, I2C_COMMAND_ENGINE_HW, link->dc->caps.i2c_speed_in_khz};
+	struct i2c_command cmd = {i2c_payloads, 1, I2C_COMMAND_ENGINE_HW,
+				  link->dc->caps.i2c_speed_in_khz};
 
 	return dm_helpers_submit_i2c(link->ctx, link, &cmd);
 }
@@ -52,8 +52,10 @@ lp_read_i2c(void *handle, uint32_t address, uint8_t offset, uint8_t *data, uint3
 {
 	struct dc_link *link = handle;
 
-	struct i2c_payload i2c_payloads[] = {{true, address, 1, &offset}, {false, address, size, data} };
-	struct i2c_command cmd = {i2c_payloads, 2, I2C_COMMAND_ENGINE_HW, link->dc->caps.i2c_speed_in_khz};
+	struct i2c_payload i2c_payloads[] = {{true, address, 1, &offset},
+					     {false, address, size, data} };
+	struct i2c_command cmd = {i2c_payloads, 2, I2C_COMMAND_ENGINE_HW,
+				  link->dc->caps.i2c_speed_in_khz};
 
 	return dm_helpers_submit_i2c(link->ctx, link, &cmd);
 }
@@ -76,7 +78,6 @@ lp_read_dpcd(void *handle, uint32_t address, uint8_t *data, uint32_t size)
 
 static uint8_t *psp_get_srm(struct psp_context *psp, uint32_t *srm_version, uint32_t *srm_size)
 {
-
 	struct ta_hdcp_shared_memory *hdcp_cmd;
 
 	if (!psp->hdcp_context.context.initialized) {
@@ -96,13 +97,12 @@ static uint8_t *psp_get_srm(struct psp_context *psp, uint32_t *srm_version, uint
 	*srm_version = hdcp_cmd->out_msg.hdcp_get_srm.srm_version;
 	*srm_size = hdcp_cmd->out_msg.hdcp_get_srm.srm_buf_size;
 
-
 	return hdcp_cmd->out_msg.hdcp_get_srm.srm_buf;
 }
 
-static int psp_set_srm(struct psp_context *psp, uint8_t *srm, uint32_t srm_size, uint32_t *srm_version)
+static int psp_set_srm(struct psp_context *psp,
+		       u8 *srm, uint32_t srm_size, uint32_t *srm_version)
 {
-
 	struct ta_hdcp_shared_memory *hdcp_cmd;
 
 	if (!psp->hdcp_context.context.initialized) {
@@ -119,7 +119,8 @@ static int psp_set_srm(struct psp_context *psp, uint8_t *srm, uint32_t srm_size,
 
 	psp_hdcp_invoke(psp, hdcp_cmd->cmd_id);
 
-	if (hdcp_cmd->hdcp_status != TA_HDCP_STATUS__SUCCESS || hdcp_cmd->out_msg.hdcp_set_srm.valid_signature != 1 ||
+	if (hdcp_cmd->hdcp_status != TA_HDCP_STATUS__SUCCESS ||
+	    hdcp_cmd->out_msg.hdcp_set_srm.valid_signature != 1 ||
 	    hdcp_cmd->out_msg.hdcp_set_srm.srm_version == PSP_SRM_VERSION_MAX)
 		return -EINVAL;
 
@@ -150,7 +151,6 @@ static void process_output(struct hdcp_workqueue *hdcp_work)
 
 static void link_lock(struct hdcp_workqueue *work, bool lock)
 {
-
 	int i = 0;
 
 	for (i = 0; i < work->max_link; i++) {
@@ -160,10 +160,11 @@ static void link_lock(struct hdcp_workqueue *work, bool lock)
 			mutex_unlock(&work[i].mutex);
 	}
 }
+
 void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 			 unsigned int link_index,
 			 struct amdgpu_dm_connector *aconnector,
-			 uint8_t content_type,
+			 u8 content_type,
 			 bool enable_encryption)
 {
 	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
@@ -178,18 +179,19 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 	query.display = NULL;
 	mod_hdcp_query_display(&hdcp_w->hdcp, aconnector->base.index, &query);
 
-	if (query.display != NULL) {
+	if (query.display) {
 		memcpy(display, query.display, sizeof(struct mod_hdcp_display));
 		mod_hdcp_remove_display(&hdcp_w->hdcp, aconnector->base.index, &hdcp_w->output);
 
 		hdcp_w->link.adjust.hdcp2.force_type = MOD_HDCP_FORCE_TYPE_0;
 
 		if (enable_encryption) {
-			/* Explicitly set the saved SRM as sysfs call will be after we already enabled hdcp
-			 * (s3 resume case)
+			/* Explicitly set the saved SRM as sysfs call will be after
+			 * we already enabled hdcp (s3 resume case)
 			 */
 			if (hdcp_work->srm_size > 0)
-				psp_set_srm(hdcp_work->hdcp.config.psp.handle, hdcp_work->srm, hdcp_work->srm_size,
+				psp_set_srm(hdcp_work->hdcp.config.psp.handle, hdcp_work->srm,
+					    hdcp_work->srm_size,
 					    &hdcp_work->srm_version);
 
 			display->adjust.disable = MOD_HDCP_DISPLAY_NOT_DISABLE;
@@ -219,7 +221,7 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 }
 
 static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
-			 unsigned int link_index,
+				unsigned int link_index,
 			 struct amdgpu_dm_connector *aconnector)
 {
 	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
@@ -238,7 +240,8 @@ static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
 		conn_state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
 
 		DRM_DEBUG_DRIVER("[HDCP_DM] display %d, CP 2 -> 1, type %u, DPMS %u\n",
-			 aconnector->base.index, conn_state->hdcp_content_type, aconnector->base.dpms);
+				 aconnector->base.index, conn_state->hdcp_content_type,
+				 aconnector->base.dpms);
 	}
 
 	mod_hdcp_remove_display(&hdcp_w->hdcp, aconnector->base.index, &hdcp_w->output);
@@ -246,6 +249,7 @@ static void hdcp_remove_display(struct hdcp_workqueue *hdcp_work,
 	process_output(hdcp_w);
 	mutex_unlock(&hdcp_w->mutex);
 }
+
 void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_index)
 {
 	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
@@ -274,15 +278,12 @@ void hdcp_handle_cpirq(struct hdcp_workqueue *hdcp_work, unsigned int link_index
 	schedule_work(&hdcp_w->cpirq_work);
 }
 
-
-
-
 static void event_callback(struct work_struct *work)
 {
 	struct hdcp_workqueue *hdcp_work;
 
 	hdcp_work = container_of(to_delayed_work(work), struct hdcp_workqueue,
-				      callback_dwork);
+				 callback_dwork);
 
 	mutex_lock(&hdcp_work->mutex);
 
@@ -294,13 +295,12 @@ static void event_callback(struct work_struct *work)
 	process_output(hdcp_work);
 
 	mutex_unlock(&hdcp_work->mutex);
-
-
 }
 
 static void event_property_update(struct work_struct *work)
 {
-	struct hdcp_workqueue *hdcp_work = container_of(work, struct hdcp_workqueue, property_update_work);
+	struct hdcp_workqueue *hdcp_work = container_of(work, struct hdcp_workqueue,
+							property_update_work);
 	struct amdgpu_dm_connector *aconnector = NULL;
 	struct drm_device *dev;
 	long ret;
@@ -337,11 +337,10 @@ static void event_property_update(struct work_struct *work)
 		mutex_lock(&hdcp_work->mutex);
 
 		if (conn_state->commit) {
-			ret = wait_for_completion_interruptible_timeout(
-				&conn_state->commit->hw_done, 10 * HZ);
+			ret = wait_for_completion_interruptible_timeout(&conn_state->commit->hw_done,
+									10 * HZ);
 			if (ret == 0) {
-				DRM_ERROR(
-					"HDCP state unknown! Setting it to DESIRED");
+				DRM_ERROR("HDCP state unknown! Setting it to DESIRED\n");
 				hdcp_work->encryption_status[conn_index] =
 					MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
 			}
@@ -352,24 +351,20 @@ static void event_property_update(struct work_struct *work)
 				DRM_MODE_HDCP_CONTENT_TYPE0 &&
 				hdcp_work->encryption_status[conn_index] <=
 				MOD_HDCP_ENCRYPTION_STATUS_HDCP2_TYPE0_ON) {
-
 				DRM_DEBUG_DRIVER("[HDCP_DM] DRM_MODE_CONTENT_PROTECTION_ENABLED\n");
-				drm_hdcp_update_content_protection(
-					connector,
-					DRM_MODE_CONTENT_PROTECTION_ENABLED);
+				drm_hdcp_update_content_protection(connector,
+								   DRM_MODE_CONTENT_PROTECTION_ENABLED);
 			} else if (conn_state->hdcp_content_type ==
 					DRM_MODE_HDCP_CONTENT_TYPE1 &&
 					hdcp_work->encryption_status[conn_index] ==
 					MOD_HDCP_ENCRYPTION_STATUS_HDCP2_TYPE1_ON) {
-				drm_hdcp_update_content_protection(
-					connector,
-					DRM_MODE_CONTENT_PROTECTION_ENABLED);
+				drm_hdcp_update_content_protection(connector,
+								   DRM_MODE_CONTENT_PROTECTION_ENABLED);
 			}
 		} else {
 			DRM_DEBUG_DRIVER("[HDCP_DM] DRM_MODE_CONTENT_PROTECTION_DESIRED\n");
-			drm_hdcp_update_content_protection(
-				connector, DRM_MODE_CONTENT_PROTECTION_DESIRED);
-
+			drm_hdcp_update_content_protection(connector,
+							   DRM_MODE_CONTENT_PROTECTION_DESIRED);
 		}
 		mutex_unlock(&hdcp_work->mutex);
 		drm_modeset_unlock(&dev->mode_config.connection_mutex);
@@ -409,7 +404,7 @@ static void event_property_validate(struct work_struct *work)
 				       &query);
 
 		DRM_DEBUG_DRIVER("[HDCP_DM] disp %d, connector->CP %u, (query, work): (%d, %d)\n",
-			aconnector->base.index,
+				 aconnector->base.index,
 			aconnector->base.state->content_protection,
 			query.encryption_status,
 			hdcp_work->encryption_status[conn_index]);
@@ -417,7 +412,8 @@ static void event_property_validate(struct work_struct *work)
 		if (query.encryption_status !=
 		    hdcp_work->encryption_status[conn_index]) {
 			DRM_DEBUG_DRIVER("[HDCP_DM] encryption_status change from %x to %x\n",
-				hdcp_work->encryption_status[conn_index], query.encryption_status);
+					 hdcp_work->encryption_status[conn_index],
+					 query.encryption_status);
 
 			hdcp_work->encryption_status[conn_index] =
 				query.encryption_status;
@@ -436,7 +432,7 @@ static void event_watchdog_timer(struct work_struct *work)
 	struct hdcp_workqueue *hdcp_work;
 
 	hdcp_work = container_of(to_delayed_work(work),
-				      struct hdcp_workqueue,
+				 struct hdcp_workqueue,
 				      watchdog_timer_dwork);
 
 	mutex_lock(&hdcp_work->mutex);
@@ -450,7 +446,6 @@ static void event_watchdog_timer(struct work_struct *work)
 	process_output(hdcp_work);
 
 	mutex_unlock(&hdcp_work->mutex);
-
 }
 
 static void event_cpirq(struct work_struct *work)
@@ -466,10 +461,8 @@ static void event_cpirq(struct work_struct *work)
 	process_output(hdcp_work);
 
 	mutex_unlock(&hdcp_work->mutex);
-
 }
 
-
 void hdcp_destroy(struct kobject *kobj, struct hdcp_workqueue *hdcp_work)
 {
 	int i = 0;
@@ -486,10 +479,8 @@ void hdcp_destroy(struct kobject *kobj, struct hdcp_workqueue *hdcp_work)
 	kfree(hdcp_work);
 }
 
-
 static bool enable_assr(void *handle, struct dc_link *link)
 {
-
 	struct hdcp_workqueue *hdcp_work = handle;
 	struct mod_hdcp hdcp = hdcp_work->hdcp;
 	struct psp_context *psp = hdcp.config.psp.handle;
@@ -507,7 +498,8 @@ static bool enable_assr(void *handle, struct dc_link *link)
 	memset(dtm_cmd, 0, sizeof(struct ta_dtm_shared_memory));
 
 	dtm_cmd->cmd_id = TA_DTM_COMMAND__TOPOLOGY_ASSR_ENABLE;
-	dtm_cmd->dtm_in_message.topology_assr_enable.display_topology_dig_be_index = link->link_enc_hw_inst;
+	dtm_cmd->dtm_in_message.topology_assr_enable.display_topology_dig_be_index =
+		link->link_enc_hw_inst;
 	dtm_cmd->dtm_status = TA_DTM_STATUS__GENERIC_FAILURE;
 
 	psp_dtm_invoke(psp, dtm_cmd->cmd_id);
@@ -549,7 +541,7 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	else if (aconnector->dc_em_sink)
 		sink = aconnector->dc_em_sink;
 
-	if (sink != NULL)
+	if (sink)
 		link->mode = mod_hdcp_signal_type_to_operation_mode(sink->sink_signal);
 
 	display->controller = CONTROLLER_ID_D0 + config->otg_inst;
@@ -574,16 +566,20 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	conn_state = aconnector->base.state;
 
 	DRM_DEBUG_DRIVER("[HDCP_DM] display %d, CP %d, type %d\n", aconnector->base.index,
-			(!!aconnector->base.state) ? aconnector->base.state->content_protection : -1,
-			(!!aconnector->base.state) ? aconnector->base.state->hdcp_content_type : -1);
+			 (!!aconnector->base.state) ?
+			 aconnector->base.state->content_protection : -1,
+			 (!!aconnector->base.state) ?
+			 aconnector->base.state->hdcp_content_type : -1);
 
 	if (conn_state)
 		hdcp_update_display(hdcp_work, link_index, aconnector,
-			conn_state->hdcp_content_type, false);
+				    conn_state->hdcp_content_type, false);
 }
 
-
-/* NOTE: From the usermodes prospective you only need to call write *ONCE*, the kernel
+/**
+ * DOC: Add sysfs interface for set/get srm
+ *
+ * NOTE: From the usermodes prospective you only need to call write *ONCE*, the kernel
  *      will automatically call once or twice depending on the size
  *
  * call: "cat file > /sys/class/drm/card0/device/hdcp_srm" from usermode no matter what the size is
@@ -594,23 +590,23 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
  * sysfs interface doesn't tell us the size we will get so we are sending partial SRMs to psp and on
  * the last call we will send the full SRM. PSP will fail on every call before the last.
  *
- * This means we don't know if the SRM is good until the last call. And because of this limitation we
- * cannot throw errors early as it will stop the kernel from writing to sysfs
+ * This means we don't know if the SRM is good until the last call. And because of this
+ * limitation we cannot throw errors early as it will stop the kernel from writing to sysfs
  *
  * Example 1:
- * 	Good SRM size = 5096
- * 	first call to write 4096 -> PSP fails
- * 	Second call to write 1000 -> PSP Pass -> SRM is set
+ *	Good SRM size = 5096
+ *	first call to write 4096 -> PSP fails
+ *	Second call to write 1000 -> PSP Pass -> SRM is set
  *
  * Example 2:
- * 	Bad SRM size = 4096
- * 	first call to write 4096 -> PSP fails (This is the same as above, but we don't know if this
- * 	is the last call)
+ *	Bad SRM size = 4096
+ *	first call to write 4096 -> PSP fails (This is the same as above, but we don't know if this
+ *	is the last call)
  *
  * Solution?:
- * 	1: Parse the SRM? -> It is signed so we don't know the EOF
- * 	2: We can have another sysfs that passes the size before calling set. -> simpler solution
- * 	below
+ *	1: Parse the SRM? -> It is signed so we don't know the EOF
+ *	2: We can have another sysfs that passes the size before calling set. -> simpler solution
+ *	below
  *
  * Easy Solution:
  * Always call get after Set to verify if set was successful.
@@ -619,20 +615,21 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
  * +----------------------+
  * PSP will only update its srm if its older than the one we are trying to load.
  * Always do set first than get.
- * 	-if we try to "1. SET" a older version PSP will reject it and we can "2. GET" the newer
- * 	version and save it
+ *	-if we try to "1. SET" a older version PSP will reject it and we can "2. GET" the newer
+ *	version and save it
  *
- * 	-if we try to "1. SET" a newer version PSP will accept it and we can "2. GET" the
- * 	same(newer) version back and save it
+ *	-if we try to "1. SET" a newer version PSP will accept it and we can "2. GET" the
+ *	same(newer) version back and save it
  *
- * 	-if we try to "1. SET" a newer version and PSP rejects it. That means the format is
- * 	incorrect/corrupted and we should correct our SRM by getting it from PSP
+ *	-if we try to "1. SET" a newer version and PSP rejects it. That means the format is
+ *	incorrect/corrupted and we should correct our SRM by getting it from PSP
  */
-static ssize_t srm_data_write(struct file *filp, struct kobject *kobj, struct bin_attribute *bin_attr, char *buffer,
+static ssize_t srm_data_write(struct file *filp, struct kobject *kobj,
+			      struct bin_attribute *bin_attr, char *buffer,
 			      loff_t pos, size_t count)
 {
 	struct hdcp_workqueue *work;
-	uint32_t srm_version = 0;
+	u32 srm_version = 0;
 
 	work = container_of(bin_attr, struct hdcp_workqueue, attr);
 	link_lock(work, true);
@@ -646,19 +643,19 @@ static ssize_t srm_data_write(struct file *filp, struct kobject *kobj, struct bi
 		work->srm_version = srm_version;
 	}
 
-
 	link_lock(work, false);
 
 	return count;
 }
 
-static ssize_t srm_data_read(struct file *filp, struct kobject *kobj, struct bin_attribute *bin_attr, char *buffer,
+static ssize_t srm_data_read(struct file *filp, struct kobject *kobj,
+			     struct bin_attribute *bin_attr, char *buffer,
 			     loff_t pos, size_t count)
 {
 	struct hdcp_workqueue *work;
-	uint8_t *srm = NULL;
-	uint32_t srm_version;
-	uint32_t srm_size;
+	u8 *srm = NULL;
+	u32 srm_version;
+	u32 srm_size;
 	size_t ret = count;
 
 	work = container_of(bin_attr, struct hdcp_workqueue, attr);
@@ -691,12 +688,12 @@ static ssize_t srm_data_read(struct file *filp, struct kobject *kobj, struct bin
 /* From the hdcp spec (5.Renewability) SRM needs to be stored in a non-volatile memory.
  *
  * For example,
- * 	if Application "A" sets the SRM (ver 2) and we reboot/suspend and later when Application "B"
- * 	needs to use HDCP, the version in PSP should be SRM(ver 2). So SRM should be persistent
- * 	across boot/reboots/suspend/resume/shutdown
+ *	if Application "A" sets the SRM (ver 2) and we reboot/suspend and later when Application "B"
+ *	needs to use HDCP, the version in PSP should be SRM(ver 2). So SRM should be persistent
+ *	across boot/reboots/suspend/resume/shutdown
  *
- * Currently when the system goes down (suspend/shutdown) the SRM is cleared from PSP. For HDCP we need
- * to make the SRM persistent.
+ * Currently when the system goes down (suspend/shutdown) the SRM is cleared from PSP. For HDCP
+ * we need to make the SRM persistent.
  *
  * -PSP owns the checking of SRM but doesn't have the ability to store it in a non-volatile memory.
  * -The kernel cannot write to the file systems.
@@ -706,8 +703,8 @@ static ssize_t srm_data_read(struct file *filp, struct kobject *kobj, struct bin
  *
  * Usermode can read/write to/from PSP using the sysfs interface
  * For example:
- * 	to save SRM from PSP to storage : cat /sys/class/drm/card0/device/hdcp_srm > srmfile
- * 	to load from storage to PSP: cat srmfile > /sys/class/drm/card0/device/hdcp_srm
+ *	to save SRM from PSP to storage : cat /sys/class/drm/card0/device/hdcp_srm > srmfile
+ *	to load from storage to PSP: cat srmfile > /sys/class/drm/card0/device/hdcp_srm
  */
 static const struct bin_attribute data_attr = {
 	.attr = {.name = "hdcp_srm", .mode = 0664},
@@ -716,10 +713,9 @@ static const struct bin_attribute data_attr = {
 	.read = srm_data_read,
 };
 
-
-struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev, struct cp_psp *cp_psp, struct dc *dc)
+struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev,
+					     struct cp_psp *cp_psp, struct dc *dc)
 {
-
 	int max_caps = dc->caps.max_links;
 	struct hdcp_workqueue *hdcp_work;
 	int i = 0;
@@ -728,14 +724,16 @@ struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev, struct
 	if (ZERO_OR_NULL_PTR(hdcp_work))
 		return NULL;
 
-	hdcp_work->srm = kcalloc(PSP_HDCP_SRM_FIRST_GEN_MAX_SIZE, sizeof(*hdcp_work->srm), GFP_KERNEL);
+	hdcp_work->srm = kcalloc(PSP_HDCP_SRM_FIRST_GEN_MAX_SIZE,
+				 sizeof(*hdcp_work->srm), GFP_KERNEL);
 
-	if (hdcp_work->srm == NULL)
+	if (!hdcp_work->srm)
 		goto fail_alloc_context;
 
-	hdcp_work->srm_temp = kcalloc(PSP_HDCP_SRM_FIRST_GEN_MAX_SIZE, sizeof(*hdcp_work->srm_temp), GFP_KERNEL);
+	hdcp_work->srm_temp = kcalloc(PSP_HDCP_SRM_FIRST_GEN_MAX_SIZE,
+				      sizeof(*hdcp_work->srm_temp), GFP_KERNEL);
 
-	if (hdcp_work->srm_temp == NULL)
+	if (!hdcp_work->srm_temp)
 		goto fail_alloc_context;
 
 	hdcp_work->max_link = max_caps;
@@ -788,10 +786,5 @@ struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev, struct
 	kfree(hdcp_work);
 
 	return NULL;
-
-
-
 }
 
-
-
-- 
2.39.5



