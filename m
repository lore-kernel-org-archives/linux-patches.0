Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216487;
	b=FgdmjEJJNEqepxGblyv04i2XRuqWFUhZGu7ti4qQ3z+qUwgu3VRknNgpq/vmHVSqnDTO
	 4is6svGQ8R7xgbEKfJSP3hu/p9FLnfP0OdVtZTkfPTXWUDKF5DEqfZiiSbpt9KU8RAhnT
	 no3puTe8XlQVNY89arwO/JRg2JPFOthaF/N/OdfVEOnPxs/YPGwaIES1FcRcPrst607Ik
	 RHVXogPgHQ0wToXafxBhl1jE9kG9+hHjt5fl74YgNF71eZtLw1d8lIOnOBKnh54I6mZrG
	 frBA9Cam7WWA2eT34IUsun1pQ+tOcZOOwh2UlwgvLlxBs0FHNdiPYVETbExuhE+8VOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lNO4RREIdNTvlOz7xEb4gWgcqMqnlSsz3a/xSduQywQ=;
	b=gxYMx1zOlbe+4rlI96TbUMDs8t+8fyEu7GgUGK91dVh6bv/PtCaHlUDta7deLGsRVOjP
	 MAU9/U8dkQxUob5swMq/OA1HltvXB7ldt+PIsBiAEZc5GwHl0bj+xLY7Z+OJqstUhmppA
	 TJzanxrhlTEeWarGKqSVU06aoy40GirlMCA/rFRdWDs3xJ1TiQktXBvygakJ4E7J2Ej8S
	 AawCjOCVgVf1WGDp1RQORETb2+8b1dFHvkQCLsNMAsVekNit0+JlbAxV2pfwBWNmTSDGt
	 iWNc2vF1yA8rz2L84O3fMrWinFYieC9p7F3+apedVVm6MJPTTeuRXxa7jUlfk3YVTRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gm+vxKjs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E5D606A31C;
	Wed, 28 Oct 2026 19:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gm+vxKjs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59891F01825;
	Wed, 28 Oct 2026 19:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216486;
	bh=lNO4RREIdNTvlOz7xEb4gWgcqMqnlSsz3a/xSduQywQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gm+vxKjsDhHaqLEgBSepVkUGz/990mkuJjiBfhmP6H238Z/zoSvjPbjMZf/PyOgEm
	 7am3L780aNG0FPXWCAGpMQGlMtuXkGDxtKpTaCUvbvc6TF8ohwcqd06bm5ZQkdUuLP
	 RQOrp2400b/f/v3rGP7saLY6LNG55YVGzurs7h10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1573/1887] drm/amd/display: Resize MST HDCP per-connector arrays to 32
Date: Wed, 28 Oct 2026 18:01:09 +0100
Message-ID: <20261028170535.262715676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 261e0fe4e2c99f687114b64b10b98db964b475f4 ]

AMDGPU_DM_MAX_DISPLAY_INDEX is 31. It suggest a maximum number of
32 connectors. But the way it's used is like MAX_DISPLAY_COUNT.
Hence we're off by one with DRM core, which supports a max of 32
connectors.

Rename AMDGPU_DM_MAX_DISPLAY_INDEX to AMDGPU_DM_MAX_DISPLAY_COUNT
to match its actual use, and increase the size to 32 to match the
originally intended size.

Fixes: 82986fd631fa ("drm/amd/display: save restore hdcp state when display is unplugged from mst hub")
Assisted-by: Copilot:claude-opus-4.8
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h      |  2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 10 +++++-----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h |  8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 12385b6f8443b..6036b138245ba 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -43,7 +43,7 @@
  * in amdgpu_dm_kms.h file
  */
 
-#define AMDGPU_DM_MAX_DISPLAY_INDEX 31
+#define AMDGPU_DM_MAX_DISPLAY_COUNT 32
 
 #define AMDGPU_DM_MAX_CRTC 6
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 6110d88efdbba..678ee48075e99 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -256,7 +256,7 @@ void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_inde
 
 	cancel_delayed_work(&hdcp_w->property_validate_dwork);
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT; conn_index++) {
 		hdcp_w->encryption_status[conn_index] =
 			MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
 		if (hdcp_w->aconnector[conn_index]) {
@@ -303,7 +303,7 @@ static void event_property_update(struct work_struct *work)
 	struct drm_connector *connector;
 	struct drm_connector_state *conn_state;
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT; conn_index++) {
 		aconnector = hdcp_work->aconnector[conn_index];
 
 		if (!aconnector)
@@ -375,7 +375,7 @@ static void event_property_validate(struct work_struct *work)
 
 	guard(mutex)(&hdcp_work->mutex);
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX;
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT;
 	     conn_index++) {
 		aconnector = hdcp_work->aconnector[conn_index];
 
@@ -753,10 +753,10 @@ struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev,
 
 		memset(hdcp_work[i].aconnector, 0,
 		       sizeof(struct amdgpu_dm_connector *) *
-			       AMDGPU_DM_MAX_DISPLAY_INDEX);
+			       AMDGPU_DM_MAX_DISPLAY_COUNT);
 		memset(hdcp_work[i].encryption_status, 0,
 		       sizeof(enum mod_hdcp_encryption_status) *
-			       AMDGPU_DM_MAX_DISPLAY_INDEX);
+			       AMDGPU_DM_MAX_DISPLAY_COUNT);
 	}
 
 	cp_psp->funcs.update_stream_config = update_config;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
index 69b445b011c8c..d18c4cc7d69f3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
@@ -43,7 +43,7 @@ struct hdcp_workqueue {
 	struct delayed_work callback_dwork;
 	struct delayed_work watchdog_timer_dwork;
 	struct delayed_work property_validate_dwork;
-	struct amdgpu_dm_connector *aconnector[AMDGPU_DM_MAX_DISPLAY_INDEX];
+	struct amdgpu_dm_connector *aconnector[AMDGPU_DM_MAX_DISPLAY_COUNT];
 	struct mutex mutex;
 
 	struct mod_hdcp hdcp;
@@ -51,7 +51,7 @@ struct hdcp_workqueue {
 	struct mod_hdcp_display display;
 	struct mod_hdcp_link link;
 
-	enum mod_hdcp_encryption_status encryption_status[AMDGPU_DM_MAX_DISPLAY_INDEX];
+	enum mod_hdcp_encryption_status encryption_status[AMDGPU_DM_MAX_DISPLAY_COUNT];
 	/* when display is unplugged from mst hub, connctor will be
 	 * destroyed within dm_dp_mst_connector_destroy. connector
 	 * hdcp perperties, like type, undesired, desired, enabled,
@@ -61,9 +61,9 @@ struct hdcp_workqueue {
 	 * will be retrieved from hdcp_work within dm_dp_mst_get_modes
 	 */
 	/* un-desired, desired, enabled */
-	unsigned int content_protection[AMDGPU_DM_MAX_DISPLAY_INDEX];
+	unsigned int content_protection[AMDGPU_DM_MAX_DISPLAY_COUNT];
 	/* hdcp1.x, hdcp2.x */
-	unsigned int hdcp_content_type[AMDGPU_DM_MAX_DISPLAY_INDEX];
+	unsigned int hdcp_content_type[AMDGPU_DM_MAX_DISPLAY_COUNT];
 
 	uint8_t max_link;
 
-- 
2.53.0



