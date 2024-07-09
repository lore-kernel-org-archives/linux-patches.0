Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0590E1581E3;
	Tue,  9 Jul 2024 11:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523529; cv=none; b=VcEDp9z/ebWfZ3xCUKZoOeU8TdsIoKC2/rysPfjrIy/ddVS4KrYKyM17QOfQzCVCeKj7jWvQlu5ISpN8Tj2u5rhpHzEScy3M9XoqL2Hlg3KDEIOCnriMzCY1VkCPgdpHwtO0KeFgo0MYrx4DsJ1V6+DX/pNfnRx8q3s7IA7bkeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523529; c=relaxed/simple;
	bh=k9JsNFlNRQ2NnrH81ju6c80gtE3CT7FWHx7/gSZHBsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOtlL4j1AlK6eLfmE89+ClbkRxU9szkIETLjD/AbapGANbukqZTTSBDNjJGdkDf6CoCPWeLZ4FhWWnPmXbMJPFaaCiQPjywVZx1l2JjIUhyR1tJ3xSEmE/JYCOVrgtI8mh5pYhC1c2MR9LEdAHGZvoLqZWgrMdnr8y2zxxrySRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Euz6YFJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Euz6YFJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729F9C32786;
	Tue,  9 Jul 2024 11:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523528;
	bh=k9JsNFlNRQ2NnrH81ju6c80gtE3CT7FWHx7/gSZHBsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Euz6YFJHjBBEmx1Q1LyIXUgJm74ldOInEt6JrIBPiZ48b2VHkOuXzBJKZKhoy3Eac
	 9bFffktMCybiQ4rShW35eZ8GaQMiEfGPEWmjTeG5GfMomdUzRCY1YYmfT1XrPotrSr
	 Woiy9TwXegoLKc6M2F5hyae6OOEVabWH//RyBr0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hersen Wu <hersenxs.wu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/139] drm/amd/display: Fix uninitialized variables in DM
Date: Tue,  9 Jul 2024 13:08:43 +0200
Message-ID: <20240709110659.059646150@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit f95bcb041f213a5da3da5fcaf73269bd13dba945 ]

This fixes 11 UNINIT issues reported by Coverity.

Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c         | 8 ++++----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7ed6bb61fe0ad..c1a0fd47802a0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -264,7 +264,7 @@ static u32 dm_vblank_get_counter(struct amdgpu_device *adev, int crtc)
 static int dm_crtc_get_scanoutpos(struct amdgpu_device *adev, int crtc,
 				  u32 *vbl, u32 *position)
 {
-	u32 v_blank_start, v_blank_end, h_position, v_position;
+	u32 v_blank_start = 0, v_blank_end = 0, h_position = 0, v_position = 0;
 	struct amdgpu_crtc *acrtc = NULL;
 
 	if ((crtc < 0) || (crtc >= adev->mode_info.num_crtc))
@@ -801,7 +801,7 @@ static void dm_handle_hpd_work(struct work_struct *work)
  */
 static void dm_dmub_outbox1_low_irq(void *interrupt_params)
 {
-	struct dmub_notification notify;
+	struct dmub_notification notify = {0};
 	struct common_irq_params *irq_params = interrupt_params;
 	struct amdgpu_device *adev = irq_params->adev;
 	struct amdgpu_display_manager *dm = &adev->dm;
@@ -6895,7 +6895,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 	struct amdgpu_dm_connector *aconnector;
 	struct dm_connector_state *dm_conn_state;
 	int i, j, ret;
-	int vcpi, pbn_div, pbn, slot_num = 0;
+	int vcpi, pbn_div, pbn = 0, slot_num = 0;
 
 	for_each_new_connector_in_state(state, connector, new_con_state, i) {
 
@@ -10064,7 +10064,7 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	struct dm_crtc_state *dm_old_crtc_state, *dm_new_crtc_state;
 	struct drm_dp_mst_topology_mgr *mgr;
 	struct drm_dp_mst_topology_state *mst_state;
-	struct dsc_mst_fairness_vars vars[MAX_PIPES];
+	struct dsc_mst_fairness_vars vars[MAX_PIPES] = {0};
 
 	trace_amdgpu_dm_atomic_check_begin(state);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 2bc37c5a27605..c8609595f324b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1219,7 +1219,7 @@ static ssize_t dp_sdp_message_debugfs_write(struct file *f, const char __user *b
 				 size_t size, loff_t *pos)
 {
 	int r;
-	uint8_t data[36];
+	uint8_t data[36] = {0};
 	struct amdgpu_dm_connector *connector = file_inode(f)->i_private;
 	struct dm_crtc_state *acrtc_state;
 	uint32_t write_size = 36;
@@ -2929,7 +2929,7 @@ static int psr_read_residency(void *data, u64 *val)
 {
 	struct amdgpu_dm_connector *connector = data;
 	struct dc_link *link = connector->dc_link;
-	u32 residency;
+	u32 residency = 0;
 
 	link->dc->link_srv->edp_get_psr_residency(link, &residency);
 
-- 
2.43.0



