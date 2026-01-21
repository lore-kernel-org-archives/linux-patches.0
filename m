Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554D13A9D92;
	Wed, 21 Jan 2026 18:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020407; cv=none; b=bhQRADziagTxjjRjJuhhBohuqpgxalqVqTJgZaeP0MxTW68zO1zDqLR8IrklL/d0qRWHvCoMXR16ImC+iRUwbodzxkHbhx+RQ+3D0HbUBa4Q+KdSE+mSB+xU25uSGqprR1r0ID6LeVHxDuIEHY5akbJtwDaxevPEcyLqNTLsn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020407; c=relaxed/simple;
	bh=yE5Y6x539HNA7rxUBQ1NK8UG4QJfp6FlfF2S8PV7X60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UROOOZQMkgw0MoGgtDjfRz0PwqD7YPt6GOnmq310DBuwnmlcqkMJIsLeqLiQF9SpGiAC76Z3Eo/RPYUGVpMwR8q8K8aMi7c5B/JwJrpL8bP6m+v/BlWH4GN0fyARFGgSWjkN1FqjCUAh7/k3OOnfT4q7rB8X3rguxyUSYVcOzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaTQLAOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaTQLAOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BCAC4CEF1;
	Wed, 21 Jan 2026 18:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020406;
	bh=yE5Y6x539HNA7rxUBQ1NK8UG4QJfp6FlfF2S8PV7X60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaTQLAOP2Fhisd9e3z/0tOHrqDcEt2w8f+1t/IyOFZ4T1n5v28scSTEMglfDwO6KR
	 hoQM9rkbTsCBhm9AzQj0MqA4B7nLG8PckAaHV8KmwxsN7HY2VPtJ4O6Px/3Zcfiwut
	 GUbxfGThAXxuWX+vCmEss2Rw6LvBbpvJfz3JxXAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dianne Skoll <dianne@skoll.ca>,
	Chris Park <chris.park@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 149/198] drm/amd/display: Bump the HDMI clock to 340MHz
Date: Wed, 21 Jan 2026 19:16:17 +0100
Message-ID: <20260121181423.920257992@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit fee50077656d8a58011f13bca48f743d1b6d6015 upstream.

[Why]
DP-HDMI dongles can execeed bandwidth requirements on high resolution
monitors. This can lead to pruning the high resolution modes.

HDMI 1.3 bumped the clock to 340MHz, but display code never matched it.

[How]
Set default to (DVI) 165MHz.  Once HDMI display is identified update
to 340MHz.

Reported-by: Dianne Skoll <dianne@skoll.ca>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4780
Reviewed-by: Chris Park <chris.park@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ac1e65d8ade46c09fb184579b81acadf36dcb91e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc_hdmi_types.h       |    2 +-
 drivers/gpu/drm/amd/display/dc/link/link_detection.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dc_hdmi_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hdmi_types.h
@@ -41,7 +41,7 @@
 /* kHZ*/
 #define DP_ADAPTOR_DVI_MAX_TMDS_CLK 165000
 /* kHZ*/
-#define DP_ADAPTOR_HDMI_SAFE_MAX_TMDS_CLK 165000
+#define DP_ADAPTOR_HDMI_SAFE_MAX_TMDS_CLK 340000
 
 struct dp_hdmi_dongle_signature_data {
 	int8_t id[15];/* "DP-HDMI ADAPTOR"*/
--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -332,7 +332,7 @@ static void query_dp_dual_mode_adaptor(
 
 	/* Assume we have no valid DP passive dongle connected */
 	*dongle = DISPLAY_DONGLE_NONE;
-	sink_cap->max_hdmi_pixel_clock = DP_ADAPTOR_HDMI_SAFE_MAX_TMDS_CLK;
+	sink_cap->max_hdmi_pixel_clock = DP_ADAPTOR_DVI_MAX_TMDS_CLK;
 
 	/* Read DP-HDMI dongle I2c (no response interpreted as DP-DVI dongle)*/
 	if (!i2c_read(
@@ -388,6 +388,8 @@ static void query_dp_dual_mode_adaptor(
 
 		}
 	}
+	if (is_valid_hdmi_signature)
+		sink_cap->max_hdmi_pixel_clock = DP_ADAPTOR_HDMI_SAFE_MAX_TMDS_CLK;
 
 	if (is_type2_dongle) {
 		uint32_t max_tmds_clk =


