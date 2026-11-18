Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015445;
	b=Ldy+zENpA4/+oOAo+6VMMzwGaElxjm/oDEGZHaYHfn5Nc6+lalX8K8SgPICzhUteq+OT
	 5YE0X/JZknwVjubNn9RaXxisKSZ5IWAtjFLstWXNQNDHeMKufepc3Qgp18z0Z3zBQz8XK
	 dbY3TTPrua6W5P0re7EQLqTQIjvAEttdU9HbX9f/dOvXa9QdzDRmWImIalHN2V9/Om3RW
	 FKkgJdS1iSPi9D83CZFFMlvlPgEwnpaRNtWnuLKkNKoMOA9QOycynPXHc6KGQ7TC2Me4f
	 ArnQQ/nw9eZjzc5sH1PbPmmZh+NnY7goQO+Q4vUFHRYyYNTEnrGP6MYMnmgQdwtV+Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yZBMpeo2zJy3tqRJp9RaLN8JQVqIThB4NRzoiZ6/piw=;
	b=k2fegvssQg9Ns1LqeWxA8BcIJmx/jAewPDvO4T55MrmU/RjXgdp8WSV6INX+kB68q+/l
	 n88wz5D2L8F4l7Qp4NZesgww7KfxlLu4dkIdMNhcQJ/ZvgMdFoLZJsY2y5lVROly7WYjC
	 6uqiMwueDpAduj/yr0/LJ3fLWAFwpTGb0bMJQj1pymFD/fhl2CA+ifTA4w6pBWQcg09wP
	 eF82N84s6MdeXtfsUxgm6+fbcawnP5PooJ62DSfCIqQ7pBa4wEcFD7mybUAfpYCAO8CRJ
	 OfqOxCyI1SIIgsQ7NRaqdpppjQ0Jck4XILNeGcw1zBoT4y+yVpcWtf9I6/OoRAeAzWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFSSnlU0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8989606A335;
	Wed, 18 Nov 2026 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFSSnlU0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2407A1F000C4;
	Wed, 18 Nov 2026 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015445;
	bh=yZBMpeo2zJy3tqRJp9RaLN8JQVqIThB4NRzoiZ6/piw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFSSnlU0gV8ypgNxlHJ8A8kr53NID1SraIBchl8r+tjH6FdOtWM6OHLaSaX5hcaTm
	 NHemYQz9YpxKrBDVDVhi0OdOkAvLhyvOE1YptjiJ/phAb9VWKV6TDfOJXdlT41YiX9
	 OIu/FbKu/X9Dc6U4A0PS9M9kko1IhE3N7Pa5UAvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0177/2651] drm/amd/display: use translate_curve_to_degamma_hw_format on DCN30
Date: Wed, 18 Nov 2026 15:23:37 +0100
Message-ID: <20261118150254.217842527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit e377716b9863fb79c59e0f1f7612a1ebf160f8cc ]

DCN3.01 presents the same banding issue as reported in the link below,
but the previous fix doesn't cover this hw. Change the helper used to
translate degamma/blend curves to HW points for DCN30, DCN 301, DCN31
and DCN314 similar to what was done for DCN32+ by commit 3719314af322
("drm/amd/display: use a separate helper to translate degamma curves").

Link: https://lore.kernel.org/amd-gfx/20260623160112.1636801-1-mwen@igalia.com/
Fixes: 222e63bddae5 ("drm/amd/display: use a separate helper to translate degamma curves")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
index bab29ca58c351..a6144da65254c 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
@@ -242,10 +242,9 @@ bool dcn30_set_blend_lut(
 	if (plane_state->cm.blend_func.type == TF_TYPE_HWPWL)
 		blend_lut = &plane_state->cm.blend_func.pwl;
 	else if (plane_state->cm.blend_func.type == TF_TYPE_DISTRIBUTED_POINTS) {
-		result = cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
+		result = cm3_helper_translate_curve_to_degamma_hw_format(
 				&plane_state->cm.blend_func,
-				&dpp->regamma_params,
-				false);
+				&dpp->regamma_params);
 		if (!result)
 			return result;
 
@@ -335,9 +334,8 @@ bool dcn30_set_input_transfer_func(struct set_input_transfer_func_params *params
 	if (plane_state->in_transfer_func.type == TF_TYPE_HWPWL)
 		pwl_params = &plane_state->in_transfer_func.pwl;
 	else if (plane_state->in_transfer_func.type == TF_TYPE_DISTRIBUTED_POINTS &&
-		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
-							&plane_state->in_transfer_func,
-							&dpp->degamma_params, false))
+		cm3_helper_translate_curve_to_degamma_hw_format(&plane_state->in_transfer_func,
+								&dpp->degamma_params))
 		pwl_params = &dpp->degamma_params;
 
 	result = dpp->funcs->dpp_program_gamcor_lut(dpp, pwl_params);
-- 
2.53.0



