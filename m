Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80CC31A802;
	Wed, 17 Sep 2025 12:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113212; cv=none; b=u8h+jXCXdqHkRAfp7GO0VoVdLIfx5T14/mOui49T+xrtTLK6GgNB8S9UuJFVJi2ZAgQvC21eLWFqiG1tc1NKFym6DOEHfuWUBzAxDwD1WEEwBo0snecWZjIHYSZrRWS30CEX/V8tddu7HU4cUd+1pQtTsiUkyeVA4PchOedE8kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113212; c=relaxed/simple;
	bh=HB2YCYPtKMRMCvP4YeOgWE0TjCPlvadPJEy2h/ABODo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFmF8syuL1Img4pv6RTf6duiX7ZAE8xdDSZRcrAwl4Tz/LjltYuSJTLR7kGlCn1aFzqjXPY4oDH7G4JWFitldxs2seOxpQxjgUWn1SvQVWDfi6gD5WSyMw0SK/InHtb94cwRH76nMjJ+bVZ63jSlnKDxvJSNUhb5qtqJxesQc5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIH5NlpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIH5NlpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B88DC4CEF0;
	Wed, 17 Sep 2025 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113211;
	bh=HB2YCYPtKMRMCvP4YeOgWE0TjCPlvadPJEy2h/ABODo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIH5NlpV8dAhpIH62tSP1UC1HKDSfNunsD2aGoEVaeiYm83k0BsMzDpwNzSmU7InX
	 MIduP9tAIY/VhrWcBlJRiewXFLXW1D11P68cX3gV+iJl81b5YbPqef2ZyS5niK+B7X
	 D7bll7J10EG0WQd+DFJoCe29dO653gBvc6G0AE0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/140] Revert "drm/amd/display: Optimize cursor position updates"
Date: Wed, 17 Sep 2025 14:33:09 +0200
Message-ID: <20250917123344.732913558@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit a5d258a00b41143d9c64880eed35799d093c4782 ]

This reverts commit 88c7c56d07c108ed4de319c8dba44aa4b8a38dd1.

SW and HW state are not always matching in some cases causing cursor to
be disabled.

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c   |  7 +++----
 .../gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c  |  6 ++----
 drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c |  8 +++-----
 .../gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c   | 10 ++++------
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c
index 01480a04f85ef..9a3be1dd352b6 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c
@@ -483,11 +483,10 @@ void dpp1_set_cursor_position(
 	if (src_y_offset + cursor_height <= 0)
 		cur_en = 0;  /* not visible beyond top edge*/
 
-	if (dpp_base->pos.cur0_ctl.bits.cur0_enable != cur_en) {
-		REG_UPDATE(CURSOR0_CONTROL, CUR0_ENABLE, cur_en);
+	REG_UPDATE(CURSOR0_CONTROL,
+			CUR0_ENABLE, cur_en);
 
-		dpp_base->pos.cur0_ctl.bits.cur0_enable = cur_en;
-	}
+	dpp_base->pos.cur0_ctl.bits.cur0_enable = cur_en;
 }
 
 void dpp1_cnv_set_optional_cursor_attributes(
diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c
index 712aff7e17f7a..92b34fe47f740 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c
@@ -155,11 +155,9 @@ void dpp401_set_cursor_position(
 	struct dcn401_dpp *dpp = TO_DCN401_DPP(dpp_base);
 	uint32_t cur_en = pos->enable ? 1 : 0;
 
-	if (dpp_base->pos.cur0_ctl.bits.cur0_enable != cur_en) {
-		REG_UPDATE(CURSOR0_CONTROL, CUR0_ENABLE, cur_en);
+	REG_UPDATE(CURSOR0_CONTROL, CUR0_ENABLE, cur_en);
 
-		dpp_base->pos.cur0_ctl.bits.cur0_enable = cur_en;
-	}
+	dpp_base->pos.cur0_ctl.bits.cur0_enable = cur_en;
 }
 
 void dpp401_set_optional_cursor_attributes(
diff --git a/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c b/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c
index c74ee2d50a699..b405fa22f87a9 100644
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c
@@ -1044,13 +1044,11 @@ void hubp2_cursor_set_position(
 	if (src_y_offset + cursor_height <= 0)
 		cur_en = 0;  /* not visible beyond top edge*/
 
-	if (hubp->pos.cur_ctl.bits.cur_enable != cur_en) {
-		if (cur_en && REG_READ(CURSOR_SURFACE_ADDRESS) == 0)
-			hubp->funcs->set_cursor_attributes(hubp, &hubp->curs_attr);
+	if (cur_en && REG_READ(CURSOR_SURFACE_ADDRESS) == 0)
+		hubp->funcs->set_cursor_attributes(hubp, &hubp->curs_attr);
 
-		REG_UPDATE(CURSOR_CONTROL,
+	REG_UPDATE(CURSOR_CONTROL,
 			CURSOR_ENABLE, cur_en);
-	}
 
 	REG_SET_2(CURSOR_POSITION, 0,
 			CURSOR_X_POSITION, pos->x,
diff --git a/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c b/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c
index 7013c124efcff..2d52100510f05 100644
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c
@@ -718,13 +718,11 @@ void hubp401_cursor_set_position(
 			dc_fixpt_from_int(dst_x_offset),
 			param->h_scale_ratio));
 
-	if (hubp->pos.cur_ctl.bits.cur_enable != cur_en) {
-		if (cur_en && REG_READ(CURSOR_SURFACE_ADDRESS) == 0)
-			hubp->funcs->set_cursor_attributes(hubp, &hubp->curs_attr);
+	if (cur_en && REG_READ(CURSOR_SURFACE_ADDRESS) == 0)
+		hubp->funcs->set_cursor_attributes(hubp, &hubp->curs_attr);
 
-		REG_UPDATE(CURSOR_CONTROL,
-			CURSOR_ENABLE, cur_en);
-	}
+	REG_UPDATE(CURSOR_CONTROL,
+		CURSOR_ENABLE, cur_en);
 
 	REG_SET_2(CURSOR_POSITION, 0,
 		CURSOR_X_POSITION, x_pos,
-- 
2.51.0



