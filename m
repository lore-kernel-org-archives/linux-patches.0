Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035700;
	b=ghOcbSqFs/0935Rmn+4ozOeV1BDj8lyZWGPRkAc6UmAHSJnmlhHD++JA4EWzvy6tLsjP
	 eV+PIm3TazrwcczC96T/MqBMOleGD1FCzGVakwL645pXJXgbztX/u6V8LA4QV6qzwwjcL
	 xft2RteQp5RdyTAcx0EO0XX68oWLBR6fXwAbTzZirTkYt1anyypaUiVxpSToCQVwaa8OR
	 yrzY6VkyBfJgqaLA38ATp/aIE9+3u3C0T0VtzM1Vog8hq6wlv2SdlgeY0BkEG8/1E92d2
	 4DQCumCbXI9eNj15KMEK1Rw4nc0d23qAsWhFVCo4WpVptnGBN3ShZba3KekSwvt28uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zxcfcLYrEd9+MqARcSoM5LilqUYSih/o/JmWDdvBICY=;
	b=hAh7sHtLo6ANyM+9NQCOlU3F79V3gwHhB6I1v91gS6MgRFu72PX8Ozk/Cb+k85wDR4Lh
	 1lFT2xNr2z78+irmwo9kHhwyznU/nfp+486xcwVBQXISLRq/yqNZ4CiddlxMC9u7wRwcX
	 hP6cWQw7u8LPYLjSfBnwKkY3NRjhm1kKj9cv6Gwea3s6JxpMMv+O2TdzaQebHdkM4N6mh
	 GRGeAVWoo4/ZJR0Ud2PffJUJjMbxQls+zORZT9/khiG3eeME6zFpjs7aBcukVPtK4O8L4
	 rQepXygMiTxhzGFubsp7eHORGtxxsah7zM/ffwDFjNtLghty8gK79hYLmGeyQ8bi3wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLNCdDqZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C486606A325;
	Wed, 18 Nov 2026 21:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lLNCdDqZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F121F000C4;
	Wed, 18 Nov 2026 21:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035699;
	bh=zxcfcLYrEd9+MqARcSoM5LilqUYSih/o/JmWDdvBICY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLNCdDqZmt/047y0iH1G6ejk8X+FociOJU4Np4s33Ga+/0Olnjm8VjdVz9jvFICBO
	 6g/qVyI1b8gaPMIfu8B2bG0PldS3/XXEs80Kf75M7GRYG/+hw3qDl6o3PhIRDOgc4H
	 8emLZELhGT+kJVoVNOn9zXJIfH7xR9U9lvY/JRC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Robert Mader <robert.mader@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0797/3318] drm/amd/display: Force GAMCOR for subsampled surfaces with PQ/Gamma22/HLG
Date: Wed, 18 Nov 2026 15:23:39 +0100
Message-ID: <20261118150342.818169263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 2ffaa7c4050605cb27756f5336f778d1b21268b9 ]

The ROM early-return checks for PQ, Gamma 2.2, and HLG in
mod_color_calculate_degamma_params() do not consider the map_user_ramp
parameter. When map_user_ramp is true (indicating a subsampled surface
that requires post-scaler degamma via GAMCOR), the function still takes
the ROM path, programming PRE_DEGAM instead.

For subsampled formats the chroma channels must be upsampled by the
scaler before degamma is applied. PRE_DEGAM sits before the scaler in
the pipeline (CNVC domain), while GAMCOR sits after it (CM domain).
Using the ROM for subsampled surfaces means degamma is applied to
subsampled chroma before upsampling, producing incorrect results.

Fix by gating the dcn_arch ROM capability checks on !map_user_ramp,
forcing PQ/Gamma22/HLG through the GAMCOR LUT path when the surface
is subsampled.

Fixes: a8bf71649088 ("drm/amd/display: Internal refactoring to abstract color caps")
Cc: stable@vger.kernel.org
Assisted-by: Copilot:claude-opus-4.6
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Robert Mader <robert.mader@collabora.com>
Link: https://patch.msgid.link/20260814211816.1219597-11-harry.wentland@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index ff8e5708735d1..20a699300e409 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1899,7 +1899,8 @@ bool mod_color_calculate_degamma_params(struct dc_color_caps *dc_caps,
 			return true;
 
 		if (dc_caps != NULL &&
-			dc_caps->dpp.dcn_arch == 1) {
+			dc_caps->dpp.dcn_arch == 1 &&
+			!map_user_ramp) {
 
 			if (input_tf->tf == TRANSFER_FUNCTION_PQ &&
 					dc_caps->dpp.dgam_rom_caps.pq == 1)
-- 
2.53.0



