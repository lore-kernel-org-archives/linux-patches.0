Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7AE416124;
	Sat, 12 Sep 2026 08:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202237; cv=none; b=t1iS2xEcQOrSAlMCstSUA3dzEpGWGbeYxvNtaWZ5qid0MnUYwi4ShS/j565C8Tm9NPhrhD2bqAlS9vZ5cgew8NgiceapfNvZCinU+7DBMnNFrQ6cjtcZor8wBXLbmw66rpOo4E8Y0PYIS2ZZygTJRDPty3hRXcTec4FPxJMFGIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202237; c=relaxed/simple;
	bh=LdiYeNO+dSsJpr27YUIea+xeyXRdf4tZAUAB1PPg+VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMVr0nlWVPdxhsu8Xee5aH3ZCJ3i7UeVBUx2zQczh/lHfStBOjKbCXIhSBuMo7lVvcgoNvw+EzFVdn4SQ4Zh/ow8rTsPOcB4yZeDIUslJTLsMKdu7kUo98g5y5KNVOvpwBa6keUBm88ftu1O86Ci4wo0C64S+eDu9LdT7eUzPVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMzN+cMw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMzN+cMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDEB1F0089A;
	Sat, 12 Sep 2026 08:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202236;
	bh=68ktg/4Y7iyOz1pCT38k2RXoAKXCowlhnuvy/BzQC2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMzN+cMw6/eQJHiYxocXT2EFrQYbW5tLU0/qv0HAKHenq2pcLIxcV2vdIsrY/5SDb
	 q7flDLSqoxITemxA5qduZrmO93re37BfJY5GbBDcBFK+NMfJVnd980/sPoD8+yJrrt
	 W5UFMSioXn+ChtoJszTHJJh2iqmX5wN4Tw9g6Y0I=
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
Subject: [PATCH 7.2 1161/1815] drm/amd/display: Resize MST HDCP per-connector arrays to 32
Date: Sat, 12 Sep 2026 08:48:31 +0200
Message-ID: <20260912065716.271814806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 10 +++++-----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 8304e8897a3ed..acb38051c96e4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -294,7 +294,7 @@ void hdcp_reset_display(struct hdcp_workqueue *hdcp_work, unsigned int link_inde
 
 	cancel_delayed_work(&hdcp_w->property_validate_dwork);
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT; conn_index++) {
 		hdcp_w->encryption_status[conn_index] =
 			MOD_HDCP_ENCRYPTION_STATUS_HDCP_OFF;
 		if (hdcp_w->aconnector[conn_index]) {
@@ -341,7 +341,7 @@ static void event_property_update(struct work_struct *work)
 	struct drm_connector *connector;
 	struct drm_connector_state *conn_state;
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX; conn_index++) {
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT; conn_index++) {
 		aconnector = hdcp_work->aconnector[conn_index];
 
 		if (!aconnector)
@@ -410,7 +410,7 @@ static void event_property_validate(struct work_struct *work)
 
 	guard(mutex)(&hdcp_work->mutex);
 
-	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_INDEX;
+	for (conn_index = 0; conn_index < AMDGPU_DM_MAX_DISPLAY_COUNT;
 	     conn_index++) {
 		aconnector = hdcp_work->aconnector[conn_index];
 
@@ -817,10 +817,10 @@ struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev,
 
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
index 90b18c450ca61..1c6436eebb063 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
@@ -36,7 +36,7 @@
  * Minimal declarations needed by this header.
  * Full amdgpu/DM definitions come from amdgpu_dm.h included by each .c file.
  */
-#define AMDGPU_DM_MAX_DISPLAY_INDEX 31
+#define AMDGPU_DM_MAX_DISPLAY_COUNT 32
 struct amdgpu_dm_connector;
 
 struct mod_hdcp;
@@ -51,7 +51,7 @@ struct hdcp_workqueue {
 	struct delayed_work callback_dwork;
 	struct delayed_work watchdog_timer_dwork;
 	struct delayed_work property_validate_dwork;
-	struct amdgpu_dm_connector *aconnector[AMDGPU_DM_MAX_DISPLAY_INDEX];
+	struct amdgpu_dm_connector *aconnector[AMDGPU_DM_MAX_DISPLAY_COUNT];
 	struct mutex mutex;
 
 	struct mod_hdcp hdcp;
@@ -59,7 +59,7 @@ struct hdcp_workqueue {
 	struct mod_hdcp_display display;
 	struct mod_hdcp_link link;
 
-	enum mod_hdcp_encryption_status encryption_status[AMDGPU_DM_MAX_DISPLAY_INDEX];
+	enum mod_hdcp_encryption_status encryption_status[AMDGPU_DM_MAX_DISPLAY_COUNT];
 	/* when display is unplugged from mst hub, connctor will be
 	 * destroyed within dm_dp_mst_connector_destroy. connector
 	 * hdcp perperties, like type, undesired, desired, enabled,
@@ -69,9 +69,9 @@ struct hdcp_workqueue {
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



