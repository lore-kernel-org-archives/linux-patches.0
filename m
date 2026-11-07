Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065503;
	b=JwPl0OZt9l+7MwpCgOfnN3t81+8ra7DFz3/AR4J5l01LLbN3eFQp4jZ7aeEctM9G5udC
	 YMHcfUCpTGb4N0m3nz3DG1H4cI95Qvm/7eP+lj+qV0MG7rC1RNJBkMFwhGSgdp/aHh/K6
	 OTgaeyW/reiKdXtVvMqM9XvfSUy33zejjXzMXkk7aBzYobvL38W6eTqA+gMdzk78DEfR8
	 K4Fn7jwQadtVsu2cP6i2Gps0Oz7aMzApruGk0YEAOF8q5CbmmShBqeoye+xDFb9WbJNO2
	 4RwYk6K8fgFBNzWjAHwjj4li7W/pGRsqoR0kvuLtfnjiI0PQVnHgfuUJ69GV7PCoTcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OMYDJ8nnfYGyCD8jha9STV8fQ4K9zpav1SLPL7FRx5A=;
	b=sWrWMZaNyhVhc32WCh24J6gvgKcEriARaIxYAsaK84BYDPyj/ViPoWzFu7s0PVCfGxH2
	 DOcWQOwtjhA+I1wYfBtX9+ptZegcoLKYKEiayJOUOWkmoWjnpSKKFm+Jt0PqSmOLSHHxf
	 LvPduIHetluK6u49rmNa2mX3pYS+8dNd2EfvkwP3dM07lp4Erby7vK8axMxBpqJ20ka8D
	 o38gHUBC33FkSn3xYnMplKOfAsy6YqsQ6pP91aABn+mDtIf7d2+7+deb2aRFKQ7IVwRDM
	 NkYtRDosIKHF65Vkta6AdN73fAaJbvuDFu11bLQoChTq48l2FjURW/4ihADS/1AsAeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQ3f0xgA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA1F606D808;
	Sat,  7 Nov 2026 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQ3f0xgA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E451F0089F;
	Sat,  7 Nov 2026 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065503;
	bh=OMYDJ8nnfYGyCD8jha9STV8fQ4K9zpav1SLPL7FRx5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQ3f0xgAXRo9cgNL6oREqFwlJm1Dh8IzeYiW8xPXpMz65GBzyK0DW+D+IpIDOD9oF
	 EhS9XMvZ8F5Gn2SPtKdV4nASL6fMdyBGXisa9ov60cMHiT3OGq3z6I8ViSN+xKFwU9
	 zNAn7EOXkG4PpJSkij/2+jBRhcy12TCf8u64cxbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Karthikeyan B <karthikeyan.b@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1190/1257] drm/amd/display: Poll passive DVI sinks for EDID readiness
Date: Sat,  7 Nov 2026 08:58:06 -0500
Message-ID: <20261107135012.035961571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <jerry.zuo@amd.com>

[ Upstream commit e9ddfb93fafa50f92165d2b48c7728720999b117 ]

A passive DP-DVI adapter is identified when the adapter DDC probe does not
respond, but the downstream monitor's EDID EEPROM may still need time to
become available after resume. Poll the downstream DDC address for passive
DP-DVI links before reading and parsing the EDID.

Keep the eDP detection optimization without adding a generic EDID retry
delay or a deferred connector reprobe.

Revert commit 3001d2073d65 ("drm/amd/display: Exit IPS before connector
detection on resume") and rely on targeted passive DP-DVI EDID readiness
polling instead of the generic pre-detection IPS exit.

Fixes: d1d51519bc3b ("drm/amd/display: Skip eDP detection when no sink")
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Karthikeyan B <karthikeyan.b@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8297e1c724733fc59027b717df73680eaf03dd56)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  4 ----
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 22 +++++++++++++++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0c92f9c5d5825..f3551bd0b0a4f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1979,10 +1979,6 @@ static int dm_resume(struct amdgpu_ip_block *ip_block)
 	/* On resume we need to rewrite the MSTM control bits to enable MST*/
 	s3_handle_mst(ddev, false);
 
-	/* Exit IPS before the detection loop's first AUX/DDC access. */
-	scoped_guard(mutex, &dm->dc_lock)
-		dc_exit_ips_for_hw_access(dm->dc);
-
 	/* Do detection*/
 	drm_connector_list_iter_begin(ddev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index bf6f013fdfc58..673b3cede7ddf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -1218,6 +1218,26 @@ void populate_hdmi_info_from_connector(bool enable_frl, struct drm_hdmi_info *hd
 }
 EXPORT_IF_KUNIT(populate_hdmi_info_from_connector);
 
+static void dm_helpers_wait_for_edid_ready(struct dc_link *link,
+					   struct i2c_adapter *ddc)
+{
+	const unsigned int retry_count = 50;
+	const unsigned int retry_interval_ms = 20;
+	unsigned int retry;
+
+	if (!ddc || link->dpcd_caps.dongle_type !=
+			DISPLAY_DONGLE_DP_DVI_DONGLE)
+		return;
+
+	for (retry = 0; retry < retry_count; retry++) {
+		if (drm_probe_ddc(ddc))
+			return;
+
+		if (retry + 1 < retry_count)
+			msleep(retry_interval_ms);
+	}
+}
+
 enum dc_edid_status dm_helpers_read_local_edid(
 		struct dc_context *ctx,
 		struct dc_link *link,
@@ -1242,6 +1262,8 @@ enum dc_edid_status dm_helpers_read_local_edid(
 	if (link->dc->hwss.prepare_ddc)
 		link->dc->hwss.prepare_ddc(link);
 
+	dm_helpers_wait_for_edid_ready(link, ddc);
+
 	/* some dongles read edid incorrectly the first time,
 	 * do check sum and retry to make sure read correct edid.
 	 */
-- 
2.53.0



