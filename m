Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4950512C819;
	Tue, 30 Apr 2024 10:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474317; cv=none; b=Nu7fOJVdvtegljn6UeLPaVKxjpmBHV1aU6mT9sdv+Kx3T8po3fxdLOkXcrazMlv8lLs7w8OM104g3wQTvFYWXOWWUTJcgn/G+N8TWuB7EAyU6BwSygOI7yE1eNTtQeswkj3AcjRavf+flxZdVVlsQmMSwurbfMI1UNh6e4eCiHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474317; c=relaxed/simple;
	bh=gvcuYK+I1eqn+uJphWXRk6ea4XRDTBC9JFXB8a18W8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqCWoPkvwyn5Npy/JAPYdyhzBVgVYdHuywBXXp/SXj0nVHqGYkdLQs+ug9oTOTIlbAsc8FWzEz69WyzM6Cl/LRLjK0Erjz7+beRkLifw3kefx6nwTyDH1ZlKUN6v98FvYjmIIaUZ186PjQKi2fTcLk+iQrW/c6ZER+pdyUEpgj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kUFrS35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kUFrS35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C560C4AF19;
	Tue, 30 Apr 2024 10:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474316;
	bh=gvcuYK+I1eqn+uJphWXRk6ea4XRDTBC9JFXB8a18W8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kUFrS35SI8+KjeHCEpi3gbZd9N1ODN1gONv4YU15E7PyEKwaIzqBJDUMnAOgbw2Y
	 MG+2Un5wmCB5pWKlFttNSuWJrE8ZpsBOk9QUvkE4zuqg0VVVoK9vn331i3jqG6g8Dn
	 hWCeL4efjpnI2JAs/R9zlSHhrhTA5yg3jRBnFWrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Muhammad Ahmed <ahmed.ahmed@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 121/228] Revert "drm/amd/display: fix USB-C flag update after enc10 feature init"
Date: Tue, 30 Apr 2024 12:38:19 +0200
Message-ID: <20240430103107.299104640@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 91f10a3d21f2313485178d49efef8a3ba02bd8c7 ]

This reverts commit b5abd7f983e14054593dc91d6df2aa5f8cc67652.

This change breaks DSC on 4k monitors at 144Hz over USB-C.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3254
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Muhammad Ahmed <ahmed.ahmed@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Charlene Liu <charlene.liu@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c | 8 +++-----
 .../gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c | 4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c
index e224a028d68ac..8a0460e863097 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c
@@ -248,14 +248,12 @@ void dcn32_link_encoder_construct(
 	enc10->base.hpd_source = init_data->hpd_source;
 	enc10->base.connector = init_data->connector;
 
-	enc10->base.preferred_engine = ENGINE_ID_UNKNOWN;
-
-	enc10->base.features = *enc_features;
 	if (enc10->base.connector.id == CONNECTOR_ID_USBC)
 		enc10->base.features.flags.bits.DP_IS_USB_C = 1;
 
-	if (enc10->base.connector.id == CONNECTOR_ID_USBC)
-		enc10->base.features.flags.bits.DP_IS_USB_C = 1;
+	enc10->base.preferred_engine = ENGINE_ID_UNKNOWN;
+
+	enc10->base.features = *enc_features;
 
 	enc10->base.transmitter = init_data->transmitter;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c
index 81e349d5835bb..da94e5309fbaf 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dio_link_encoder.c
@@ -184,6 +184,8 @@ void dcn35_link_encoder_construct(
 	enc10->base.hpd_source = init_data->hpd_source;
 	enc10->base.connector = init_data->connector;
 
+	if (enc10->base.connector.id == CONNECTOR_ID_USBC)
+		enc10->base.features.flags.bits.DP_IS_USB_C = 1;
 
 	enc10->base.preferred_engine = ENGINE_ID_UNKNOWN;
 
@@ -238,8 +240,6 @@ void dcn35_link_encoder_construct(
 	}
 
 	enc10->base.features.flags.bits.HDMI_6GB_EN = 1;
-	if (enc10->base.connector.id == CONNECTOR_ID_USBC)
-		enc10->base.features.flags.bits.DP_IS_USB_C = 1;
 
 	if (bp_funcs->get_connector_speed_cap_info)
 		result = bp_funcs->get_connector_speed_cap_info(enc10->base.ctx->dc_bios,
-- 
2.43.0



