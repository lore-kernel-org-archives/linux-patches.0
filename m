Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063801;
	b=N3KPRw/twHOibaBrb9R+0fGjX4T7DReJKTFK5h1hQrygpgFVnxqD3gUn1qICEVvfYe4C
	 n5YxOwG2gr/SpW/HrdxRhXUEsUiXIz/2AXgUFxwlz/ROYqNqeC5i59ENBOdnajmzyjJCq
	 Olri14nFQxsSiobcg5kGVtCYcQUv9VOT6OXQzDjaggMKZHtrCeoI8PyViT6GruTnxZsog
	 ofGJQFEIFYWUShxaSBu1XtT6Hj4e/dv5V5TnnA3NsiIIQTf4VjKfsD1RO7rmV8eRH5vTF
	 AOZlkwZN7TbYq1AZtKU9iYl/QpU50G9UA7orY3QK/kR/UnQ3Xhhy544OV7YClxCOfgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iSGiM2KHr42Wfm/JboEonNA3EfZzDoK/sm7ycVhORhE=;
	b=1WgDwh+vDtfteiO4OwWgnbUgxwl+rmV7zsk06ocGHaiHx77FXIA9Bm7PnRaAHz36eZfc
	 EHLw9gAStXlnffA7nrIUcvgHhe0dtSt6jFVSX/+BUtP6A6G6oTAbJB5b1GWEnvAPEzEfQ
	 AZ/m1pJ0/apQe9kOvedAJxKQ/3DiLNUC2wdc0gxmBSUihERNyw9tIJFi2Or09s1qZBniv
	 b3tt6ZsHh4+F0TSmnFSdCs0RSDQ4GnH5ymlfetHAP2LHXSeDylKOold+ZIOsCZtWrX4/c
	 2SsMzNy6wD2eg/JAH4zLWEsMzAjoGB7NPwOB8ZbO9q4XfP3fxn4gB+XMuJXNErrZVqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vvc6qzZJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C668E606EE81;
	Sat,  7 Nov 2026 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vvc6qzZJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751891F0089F;
	Sat,  7 Nov 2026 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063800;
	bh=iSGiM2KHr42Wfm/JboEonNA3EfZzDoK/sm7ycVhORhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vvc6qzZJQqEz44iir++nZF828pFWyGYoisBAp8xH8YhlyDd6YmzOqeIx1mMajX8Nj
	 auFOol19p8wMPBE8wb5/LKegXfEKgo/FLQnwoq7awFRmekQ/DGRHa0D9EQNsvCCPRq
	 QXPnUgIEOUv9Yp5nUfSjMEONBS6fTkCw8/EAiitU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Robert Mader <robert.mader@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0021/1257] drm/amd/display: Force GAMCOR for subsampled surfaces with PQ/Gamma22/HLG
Date: Sat,  7 Nov 2026 08:38:37 -0500
Message-ID: <20261107134940.000976290@linuxfoundation.org>
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
index 03d88e78165d5..5786ef5787ac6 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1696,7 +1696,8 @@ bool mod_color_calculate_degamma_params(struct dc_color_caps *dc_caps,
 			return true;
 
 		if (dc_caps != NULL &&
-			dc_caps->dpp.dcn_arch == 1) {
+			dc_caps->dpp.dcn_arch == 1 &&
+			!map_user_ramp) {
 
 			if (input_tf->tf == TRANSFER_FUNCTION_PQ &&
 					dc_caps->dpp.dgam_rom_caps.pq == 1)
-- 
2.53.0



