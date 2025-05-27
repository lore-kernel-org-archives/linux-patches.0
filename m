Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A242110E;
	Tue, 27 May 2025 17:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365495; cv=none; b=u8WXsK0L/diiMp/su1M8YJyHhuFyjraSvoBqxB5KRUMLtAcJfHkFCXG8G9FaYM+pNQyYQ2Z4b4yij5CjrNE5FrbTxTCK+CkKwjXtrb90DIwY2q2SEqVtLxPgnvAMa4Q4gBEfgDceRAtqKmhBuGnsuxJPeWMcRPvOwlIG2fQYeLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365495; c=relaxed/simple;
	bh=7IUgqDO5eJy1e2J9fqYdsxr5lWPJsj3DaF4/7GS5v40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rn4lPpeqHNc+myWtS5AJDlAjqWCVsts6el7+wxSlZD7SeDdShvwjSAcPWsRjaCvanACR2iil4yQYnJFxQC3/frNp/319OAFVlktSuThcSsS/mR72cNIf9pKRzo+neSATrDWJXaI+7mWdSpNDN2iom4wcHCzMibS6KPT5oyPbpIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiFH9BrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiFH9BrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BDCC4CEE9;
	Tue, 27 May 2025 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365495;
	bh=7IUgqDO5eJy1e2J9fqYdsxr5lWPJsj3DaF4/7GS5v40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiFH9BrZhsjmug5rCifla1j8O2pdN3LbGWd7HHVDNZEXCiAjQ9Ju5OsRUvZeP+caB
	 PMJkwNZX5ciXuYAaC77BIaTDJEBw3AyC2DAI55HeNmwI/HrE/rOZ3fhFbNz0JOKQTe
	 FsSSyaEqm5iogIHftvbhOXD7znHZrh5+Gk3C1/tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Brandon Syu <Brandon.Syu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 395/626] Revert "drm/amd/display: Exit idle optimizations before attempt to access PHY"
Date: Tue, 27 May 2025 18:24:48 +0200
Message-ID: <20250527162501.073310609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Brandon Syu <Brandon.Syu@amd.com>

[ Upstream commit be704e5ef4bd66dee9bb3f876964327e3a247d31 ]

This reverts commit de612738e9771bd66aeb20044486c457c512f684.

Reason to revert: screen flashes or gray screen appeared half of the
screen after resume from S4/S5.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Brandon Syu <Brandon.Syu@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 59457ca24e1dc..ccdc9d4101863 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1888,7 +1888,6 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 	bool can_apply_edp_fast_boot = false;
 	bool can_apply_seamless_boot = false;
 	bool keep_edp_vdd_on = false;
-	struct dc_bios *dcb = dc->ctx->dc_bios;
 	DC_LOGGER_INIT();
 
 
@@ -1965,8 +1964,6 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 			hws->funcs.edp_backlight_control(edp_link_with_sink, false);
 		}
 		/*resume from S3, no vbios posting, no need to power down again*/
-		if (dcb && dcb->funcs && !dcb->funcs->is_accelerated_mode(dcb))
-			clk_mgr_exit_optimized_pwr_state(dc, dc->clk_mgr);
 
 		power_down_all_hw_blocks(dc);
 
@@ -1979,8 +1976,6 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 		disable_vga_and_power_gate_all_controllers(dc);
 		if (edp_link_with_sink && !keep_edp_vdd_on)
 			dc->hwss.edp_power_control(edp_link_with_sink, false);
-		if (dcb && dcb->funcs && !dcb->funcs->is_accelerated_mode(dcb))
-			clk_mgr_optimize_pwr_state(dc, dc->clk_mgr);
 	}
 	bios_set_scratch_acc_mode_change(dc->ctx->dc_bios, 1);
 }
-- 
2.39.5



