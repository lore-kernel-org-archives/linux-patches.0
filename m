Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B7550266;
	Sat,  3 Feb 2024 04:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933880; cv=none; b=HqzcKlCfHlCfIjtc5R0bxcaBQDT7W2dO+/9NzggpavHkla0uiEk/zZjqkn8hHgzHmxNU0ioLpxSiPTYNbC3Jn/5Q6H75zaRFm1mjFP5me7gOuKZLcHmWxLamUt4sPiSKvkGtqiUSu4kAdkdye4Am55x3qovv1ZuwieBa68TTvC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933880; c=relaxed/simple;
	bh=n9+zPiEtA79kRSoRZuZmnbwO5jrlYSiVx7vJh6s0+YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvVrVeWw/du6W/kNtzKnh51nL0zJAo0nqHgxCwwTO7atiIUv5e97J1ip2Lv7sUl5aCEuZLayFuKMYxjR2Qr2YbQP2Hvw+3N+Yobibg9s9nNRyzbIGottTC+xmVpOM4lbLdIKyul78I5oIc4AAEVISMOu6IAULmdW72QLI5Dag1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoCmZW15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoCmZW15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C44AC433C7;
	Sat,  3 Feb 2024 04:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933880;
	bh=n9+zPiEtA79kRSoRZuZmnbwO5jrlYSiVx7vJh6s0+YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoCmZW15D22vuywuk/6h0PtoB9hZw+i6HG4wKwx+5qoOCY42VMhXoKXJlXaWLc9LD
	 WM5q3ucOqUuJtMleL2mDSG1wr9XGjZCXA71BX8Opbj7VvY1BPndnRjWRPqRDcJI70Z
	 BgE5T7DmPfqkzOkRVc1/MxK1N7ktuHDXNuOSwBWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Allen Pan <allen.pan@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 221/353] drm/amd/display: fix usb-c connector_type
Date: Fri,  2 Feb 2024 20:05:39 -0800
Message-ID: <20240203035410.671683915@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Pan <allen.pan@amd.com>

[ Upstream commit 0d26644bc57d8737c8e2fb3145366f7d0b941935 ]

[why]
BIOS switches to use USB-C connector type 0x18, but VBIOS's
objectInfo table not supported yet. driver needs to patch it
based on enc_cap from system integration info table.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Allen Pan <allen.pan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c    | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c
index f91e08895275..da94e5309fba 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c
@@ -256,6 +256,10 @@ void dcn35_link_encoder_construct(
 		enc10->base.features.flags.bits.IS_UHBR10_CAPABLE = bp_cap_info.DP_UHBR10_EN;
 		enc10->base.features.flags.bits.IS_UHBR13_5_CAPABLE = bp_cap_info.DP_UHBR13_5_EN;
 		enc10->base.features.flags.bits.IS_UHBR20_CAPABLE = bp_cap_info.DP_UHBR20_EN;
+		if (bp_cap_info.DP_IS_USB_C) {
+			/*BIOS not switch to use CONNECTOR_ID_USBC = 24 yet*/
+			enc10->base.features.flags.bits.DP_IS_USB_C = 1;
+		}
 
 	} else {
 		DC_LOG_WARNING("%s: Failed to get encoder_cap_info from VBIOS with error code %d!\n",
@@ -264,4 +268,5 @@ void dcn35_link_encoder_construct(
 	}
 	if (enc10->base.ctx->dc->debug.hdmi20_disable)
 		enc10->base.features.flags.bits.HDMI_6GB_EN = 0;
+
 }
-- 
2.43.0



