Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FBC4D7D30;
	Tue, 13 Oct 2026 12:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894123; cv=none; b=FdveckLu341byJc8sExQR7Tjtiax5bJyx3baGtTUqmypOk8JNwie5FH/O7tra6wwlY6ogV1BDIno0WhEaGAtbFb5wJ9qtQ6l0kAIYm8VrQrOAEpa0KS5RJp5IvQ2NwtoZnwFltJNioj4OiY8GCRYjj9Q80x+Qymo6SuQTLuSfns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894123; c=relaxed/simple;
	bh=h/BrrMHm3mh5YnRsz6GmeGTXYc20zhsvuC/J60y6V4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsEnU4YCnd/4jF+O35d4H5cdXTed4KiRRf6G81QJNmXvOlNqSS5OJZJU5Z7W8Q4+GL74vRbV6XfhbI43uCGNB4hLQiaaVSE1y/lczhEX1c4DyCxaShxw22EE2C1OZ3td5ikub1d/amu5iywwX/4engMM2n+GYhBVnGQuXbEqqUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTWq/JsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTWq/JsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DC91F00893;
	Tue, 13 Oct 2026 12:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894121;
	bh=wTdY0yA1qMnoSMew6viutLwp/dwZyKzqhvgtYMA/9+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTWq/JsVFpbfWT/t0T8cewa+l7bkRsmUBlOWVRokd7bgsdPHUEDlVrHbLyORRtCHt
	 lhextQtr9i85Dz5UZ8Fsta+AbR51P+as7iWbPtlbu7Ak5ziQOc6B1HGtwGKOJ+FrXO
	 MXotd8tDV1UWW4kfk+tQlfoj3T1shySg7rR+pUH0=
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
Subject: [PATCH 6.18 437/621] drm/amd/display: Resize MST HDCP per-connector arrays to 32
Date: Tue, 13 Oct 2026 13:37:12 +0200
Message-ID: <20261013112931.203279755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 284cfcd238a29..ff334d05fd880 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -45,7 +45,7 @@
  * in amdgpu_dm_kms.h file
  */
 
-#define AMDGPU_DM_MAX_DISPLAY_INDEX 31
+#define AMDGPU_DM_MAX_DISPLAY_COUNT 32
 
 #define AMDGPU_DM_MAX_CRTC 6
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 19038f3361553..1b0a242513c31 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -287,7 +287,7 @@ void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_inde
 
 	cancel_delayed_work(&hdcp_w->property_validate_dwork);
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT; conn_index++) {
 		hdcp_w->encryption_status[conn_index] =
 			MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
 		if (hdcp_w->aconnector[conn_index]) {
@@ -334,7 +334,7 @@ static void event_property_update(struct work_struct *work)
 	struct drm_connector *connector;
 	struct drm_connector_state *conn_state;
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT; conn_index++) {
 		aconnector = hdcp_work->aconnector[conn_index];
 
 		if (!aconnector)
@@ -403,7 +403,7 @@ static void event_property_validate(struct work_struct *work)
 
 	guard(mutex)(&hdcp_work->mutex);
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX;
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT;
 	     conn_index++) {
 		aconnector = hdcp_work->aconnector[conn_index];
 
@@ -798,10 +798,10 @@ struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev,
 
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
index 4faa344f196e7..1e31fc92ac719 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
@@ -44,7 +44,7 @@ struct hdcp_workqueue {
 	struct delayed_work callback_dwork;
 	struct delayed_work watchdog_timer_dwork;
 	struct delayed_work property_validate_dwork;
-	struct amdgpu_dm_connector *aconnector[AMDGPU_DM_MAX_DISPLAY_INDEX];
+	struct amdgpu_dm_connector *aconnector[AMDGPU_DM_MAX_DISPLAY_COUNT];
 	struct mutex mutex;
 
 	struct mod_hdcp hdcp;
@@ -52,7 +52,7 @@ struct hdcp_workqueue {
 	struct mod_hdcp_display display;
 	struct mod_hdcp_link link;
 
-	enum mod_hdcp_encryption_status encryption_status[AMDGPU_DM_MAX_DISPLAY_INDEX];
+	enum mod_hdcp_encryption_status encryption_status[AMDGPU_DM_MAX_DISPLAY_COUNT];
 	/* when display is unplugged from mst hub, connctor will be
 	 * destroyed within dm_dp_mst_connector_destroy. connector
 	 * hdcp perperties, like type, undesired, desired, enabled,
@@ -62,9 +62,9 @@ struct hdcp_workqueue {
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



