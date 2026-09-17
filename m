Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE194E4C55;
	Thu, 17 Sep 2026 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661043; cv=none; b=lFWSPkPdduZYXpMTxLHI/jpxSUY9AmlxEMfPO6TboxEwM5BdfflfjIha13gW14j8B/ByifxO8p9qeQYDlCFkQpEYvSRXF0RvicqchyFKPJ3vwO4YewhHydVACClUB2xj9IxF21X3kCNgZt3mBWbr98a/v+GNk8lFl2L5kBviMNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661043; c=relaxed/simple;
	bh=66EYd8RPO3UeD2bzMA/a5NZFqzjK0UfzZV+xHuNurds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlwlw8iqsHyamWEVVSgJyMneliATJg0hTG9pUZpLLevK/eO+dFEWG/50jKs7zOK/1K/cBp5zrS2gVQRxKIRe6eU4d7q8GThxTdfMBQJc1ldL7M0zk+B193vdgmG3fKpoK7J37HgqR9nERllipRYm/CiOUrmJjp53pfmGvX6lpps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANnbkhnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANnbkhnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2B11F00898;
	Thu, 17 Sep 2026 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661042;
	bh=ZRrqifS7GYEmGJuvVXRob85aAWzEmVfmQ3vsGkfEApE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANnbkhnfa61j3hvW7r3lxuVB/72dHMIcITgcdcKx5P0C5qvmUtWTQ6tNr1seo9RdB
	 cRnIe5/H8CCuexcyCuJiyYzh/YgLlmQ19TAD66GBeDJAX02rvjOr0SkwzTVCKK2WCL
	 Nl9rmQgZtyw82dFfRUKzgfpVs6LM/3NmxBctCqv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	James Lin <pinglei.lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0062/1250] drm/amd/display: Find link encoder for flexible DIG mapping cases
Date: Thu, 17 Sep 2026 15:57:37 +0100
Message-ID: <20260917151553.623539985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

[ Upstream commit 74ef54e656e7006cfc215e960b0cf2720a7a3d48 ]

[why & how]
link->link_enc can only be used to identify the link's link encoder
when the link is not permitted to use flexible link encoder
assignments.

Use the correct function for identifying link encoder and add
function pointer guards before calling them.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: James Lin <pinglei.lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c    | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index fe02dc4e97e4a..8eec1feafc4ad 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1753,20 +1753,22 @@ static void power_down_encoders(struct dc *dc)
 
 	for (i = 0; i < dc->link_count; i++) {
 		struct dc_link *link = dc->links[i];
-		struct link_encoder *link_enc = link->link_enc;
+		struct link_encoder *link_enc = link_enc_cfg_get_link_enc(link);
 		enum signal_type signal = link->connector_signal;
 
 		dc->link_srv->blank_dp_stream(link, false);
 		if (signal != SIGNAL_TYPE_EDP)
 			signal = SIGNAL_TYPE_NONE;
 
-		if (link->ep_type == DISPLAY_ENDPOINT_PHY)
+		if (link->ep_type == DISPLAY_ENDPOINT_PHY && link_enc)
 			link_enc->funcs->disable_output(link_enc, signal);
 
 		if (link->fec_state == dc_link_fec_enabled) {
-			link_enc->funcs->fec_set_enable(link_enc, false);
-			link_enc->funcs->fec_set_ready(link_enc, false);
-			link->fec_state = dc_link_fec_not_ready;
+			if (link_enc && link_enc->funcs->fec_set_enable && link_enc->funcs->fec_set_ready) {
+				link_enc->funcs->fec_set_enable(link_enc, false);
+				link_enc->funcs->fec_set_ready(link_enc, false);
+				link->fec_state = dc_link_fec_not_ready;
+			}
 		}
 
 		link->link_status.link_active = false;
-- 
2.53.0



