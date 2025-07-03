Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18D22E7BD6;
	Thu,  3 Jul 2025 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554458; cv=none; b=syCtJXYXJuAsg2xpaN7r0mTi7tXPywLN5emeB2IUPmQhoHkVlcQf18l3Bpp6epjlvEBbRtrmJM9Vyf2CiMjCvdZe8xYPbsgCYX3t01RY7TN9BtgrDFxnx5el6yvlfeYCOcvofbT6Io3QAeGIuIjnRVZvrd5COuf0wXLivAtOPfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554458; c=relaxed/simple;
	bh=YHKbfGJzI/02sMPU/Dfr67hqrR2Fio1ApPxOhM5mb5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVJUwWuDk4bsgsoRZB3sTCsncHJgZm03mVWTvLKRjG4Hm3o3xtYLz8m5k+wVfAPt+4kaik09DsoQJv8dFqghZBOnbO4y9gOYwIgJ47MgTa7U3LIdMjSPC5+1LNwSC41cIJPI30iEQ4fq91RLF5M6X2iRu1t21E5EI+UE+HtCvxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ufia+7/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ufia+7/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD20C4CEE3;
	Thu,  3 Jul 2025 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554455;
	bh=YHKbfGJzI/02sMPU/Dfr67hqrR2Fio1ApPxOhM5mb5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ufia+7/6sPoHTpOB3kZUdw7/Ghh3ywOQpo21JTgKsUNZk6lCnfeZSNB9goKD9YFtw
	 4wb+2HjHk4GNKsp/tn2pUr8PzOlUectRTAtcT8tp0rz5G4aZXNchRwUbSnlKgPGbDS
	 N+yK2dhgo4ZbY8c3kBEMsmbYbOe/VACp1VNTLWCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Zhongwei Zhang <Zhongwei.Zhang@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 163/218] drm/amd/display: Correct non-OLED pre_T11_delay.
Date: Thu,  3 Jul 2025 16:41:51 +0200
Message-ID: <20250703144002.674951939@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongwei Zhang <Zhongwei.Zhang@amd.com>

commit 893f07452bca56ff146a6be02b3294a9ea23d18a upstream.

[Why]
Only OLED panels require non-zero pre_T11_delay defaultly.
Others should be controlled by power sequence.

[How]
For non OLED, pre_T11_delay delay in code should be zero.
Also post_T7_delay.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Zhongwei Zhang <Zhongwei.Zhang@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -951,8 +951,8 @@ void dce110_edp_backlight_control(
 	struct dc_context *ctx = link->ctx;
 	struct bp_transmitter_control cntl = { 0 };
 	uint8_t pwrseq_instance = 0;
-	unsigned int pre_T11_delay = OLED_PRE_T11_DELAY;
-	unsigned int post_T7_delay = OLED_POST_T7_DELAY;
+	unsigned int pre_T11_delay = (link->dpcd_sink_ext_caps.bits.oled ? OLED_PRE_T11_DELAY : 0);
+	unsigned int post_T7_delay = (link->dpcd_sink_ext_caps.bits.oled ? OLED_POST_T7_DELAY : 0);
 
 	if (dal_graphics_object_id_get_connector_id(link->link_enc->connector)
 		!= CONNECTOR_ID_EDP) {
@@ -1067,7 +1067,8 @@ void dce110_edp_backlight_control(
 	if (!enable) {
 		/*follow oem panel config's requirement*/
 		pre_T11_delay += link->panel_config.pps.extra_pre_t11_ms;
-		msleep(pre_T11_delay);
+		if (pre_T11_delay)
+			msleep(pre_T11_delay);
 	}
 }
 


