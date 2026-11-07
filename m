Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062705;
	b=LPntqpm3HC9XQ4Tt5yVnPX6v0Ks7WjlOM5vUVvg3IXx52X9//g3Z1XqrecrO3tqbzmpb
	 n1GnXhkzNlvA5Uy29Md0hJSvVld0ohrGFWw1PloI+m5FoxSy7iQapOQZHtaGhJw3vHGP7
	 ChyopV1HmvPuOyoalFb+i1+oBba+VO4x93g3guUbIi/PHASSr9gnlFeZzoZcsZJ3AQLc/
	 5fFapTITcr1ft3FXBp/4lsusz1xQr9mzReNNLKYlR9wK1ra3l5sg6MFXcHYcpyAWuHEjo
	 ERuVHtf3AlbVoVs2aKFkqS3G/kMQHoEmMi1zl861AznC6rajSCgXL5ldwTnvjNN4Zpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U3Fe+BxfCyHeUxqH7GPCjlqGwQ9Sqk77LAFSW+kaiJY=;
	b=pCab758BMvyHrMu0B0ftNUO/wzhpnLzIZEtrQ5ki4iWMj6Vjhg2vQI6S7IOYXnuWyTuR
	 JaHhx9Pq7AXSAr/mz3JUePyM87wMYGTwX0c8rt3PZ1PIVSAH9MKYUNZnWDwknLRyHaPlN
	 53Ss+XYf0Cvn1UsLLaEqQ59amym8cIv4tEpbT+9QtTDfAO7qjBI0U0pVzryDrkFw9oKqL
	 usQHN/1cX5b12VFlRNJjA/5Cz40E2L8kF9+Ma3zVolyctYXLyYq0AauID6x66GShNduoU
	 SeUn4mWAkAP7FHaCl3k30Jm6IP9ToJETrknHEM2tcm8EDv5wu9soRgqgXmE6Xkmjt1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9X+v1kI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295F1606A333;
	Sat,  7 Nov 2026 14:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9X+v1kI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8721F0089F;
	Sat,  7 Nov 2026 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062704;
	bh=U3Fe+BxfCyHeUxqH7GPCjlqGwQ9Sqk77LAFSW+kaiJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9X+v1kImkjGKdv7sr4qrhk7xawWncm32lMkV8aT4R3r5VJzgPf8OFjuaPCZ3zX4S
	 bMigOxDNglPHBw1TuM2yELSsNGjseeAH8liB3IFrWcjC+URTbIBcl/g9Jix/F/fFcA
	 xOf5tftrCD6t41drsleZfoohE/iwqsTT0iTL1PqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Robert Mader <robert.mader@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/869] drm/amd/display: Force GAMCOR for subsampled surfaces with PQ/Gamma22/HLG
Date: Sat,  7 Nov 2026 08:45:10 -0500
Message-ID: <20261107134853.058248421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a71df052cf252..7103d8cfb4799 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1694,7 +1694,8 @@ bool mod_color_calculate_degamma_params(struct dc_color_caps *dc_caps,
 			return true;
 
 		if (dc_caps != NULL &&
-			dc_caps->dpp.dcn_arch == 1) {
+			dc_caps->dpp.dcn_arch == 1 &&
+			!map_user_ramp) {
 
 			if (input_tf->tf == TRANSFER_FUNCTION_PQ &&
 					dc_caps->dpp.dgam_rom_caps.pq == 1)
-- 
2.53.0



