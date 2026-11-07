Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061879;
	b=JaccCEGRi5P7tkoXorFqkuKpwy+RiT1dnoVkNc2Z4hnzAghAioeorou4q6Knj7EuWwH1
	 Bh9bXYeQaUZxoG/Wav/3JcNCc6SXqZRE3qyfnBPyTxAhj/PvufI1gbTvLwzmOeGCDDWXs
	 C1olZJ8AOcFy4vSzwJQ3JAG5rnoI6OTHYhzRNpuRdhUEwaGrdcek0s+ybgFKn0BzzOztt
	 xJOVEPTM7mVz8vWje9hL7LOw/SA3luC1quURT4Zkgq1Q7/DtKt3K6CMRuXjGy7BBiFX2p
	 bVlHPPbO4d0TFbanO49yuwBm5qnF9DrUQa8ePoPmyPR/pYaqL0TzFSIEDG1mFsXTf2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0La8O7IyckLHFvqKOssn/7aR8wHUjjDWi0W27pUd994=;
	b=XUv6xvXQqofX5tO9rRiHTF4OtGDclfQixLqnAu8OD95qV21FcW0iMJmIDdNFGriJpBRi
	 /+fOKLCnNp5bt9JY8c+qtQXKN1yGKossa+YKc8hB7zGjwqXpIb1A6AInLSomXZGRpnhBk
	 Tj8oqUVlO/J4+NUcMVGdqcy2m362c2aAh/IkeiiBMhpx+IiKOT8xBe0w99XTi8fYVLe94
	 TCIPn/Jvwc2n3Mehvkby98xpvWVTmaIc99uvKPC3bEm7WDr7fvOrVdJ9ZL4ovMU1CywSd
	 qNP2h2TOjvn1F2BwXp5E74lKg2trAGshUwEccwmBQrbralgLJb6a8C7s0a37NWMvvIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI6VtJc5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0417606A326;
	Sat,  7 Nov 2026 14:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI6VtJc5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5F91F0089F;
	Sat,  7 Nov 2026 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061878;
	bh=0La8O7IyckLHFvqKOssn/7aR8wHUjjDWi0W27pUd994=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI6VtJc5NbqSyeR6+YkN+eWM5ZSjJQ5Pcwx88Fg3do74Qsxb5YxKXnKnTWhZr3jBh
	 IGdVHBQtxgKNykycYLjPLPeTsBimdkeE/0+dvsGtemxtNC3rS/fP8FmsGr7yPx648b
	 bmo0ANUMaFn3Ry32HlOKFDhzHP+SIGXz08GMZVNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Robert Mader <robert.mader@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0892/1536] drm/amd/display: Force GAMCOR for subsampled surfaces with PQ/Gamma22/HLG
Date: Sat,  7 Nov 2026 08:48:28 -0500
Message-ID: <20261107135022.679359175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3699e633801d2..d6fc669fd45c2 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -2001,7 +2001,8 @@ bool mod_color_calculate_degamma_params(struct dc_color_caps *dc_caps,
 			return true;
 
 		if (dc_caps != NULL &&
-			dc_caps->dpp.dcn_arch == 1) {
+			dc_caps->dpp.dcn_arch == 1 &&
+			!map_user_ramp) {
 
 			if (input_tf->tf == TRANSFER_FUNCTION_PQ &&
 					dc_caps->dpp.dgam_rom_caps.pq == 1)
-- 
2.53.0



