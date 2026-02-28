Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2ED355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300987; cv=none; b=Rwu8Os99Wi86hXUYUs+Y0ejjkYe2kVscBHqzc24kcgCZSTR5OXtExO2NrIePH7nvaIq/pgAw4vVb+NFNsDd4dUBhUtPXtG9T8+j15V86YJ3138LVVf8JOlPETPJlZ7w06z+H9rrgBkxH8gm9PSZ/v35p+EsC5nGCpERiSCUYiL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300987; c=relaxed/simple;
	bh=j/xh8wlR+zRY/O6MvZfDqz+VTu2m/elruzPfLGA0we4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkdZga9VbChLe8JITFmk9VEJO7G/ynx+kr2GyTXZMFJVh8HgaGIZmKfCgRMTFcl2EE2zNLpdWgMHk3AQnh9zNXKk6953eBRVe4msvdaMeWff7DL3r9G4skza4k+1dmYqudOG1hrgYqPboELPsPvk1G5FswMzMvujDR6uKruzYtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcCVYgEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcCVYgEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8773C116D0;
	Sat, 28 Feb 2026 17:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300987;
	bh=j/xh8wlR+zRY/O6MvZfDqz+VTu2m/elruzPfLGA0we4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcCVYgEkxMSxrgLasgW9vnwaijJv6dZZpkAzrJrYOBbYnIWnaZV2v2yAkV4dn0HfJ
	 c9v9oh9PnJgOPnQ7xZsaqYMDh/NAvcIph5boci0aFe9B1b/l+Hw1/ukGgrllwm9rbQ
	 10kRZERcerZ3yF3HOhgUNvzI4m4fOsfED1ldaDiF1hhLkToSO8J0s16Y8xbT32YEh9
	 +nJ/6LPwSX2wwSD1SMfW869TaKHOP5RNp4kmtB6pza+9IjS4/M2hNp5IyqKxsEYE82
	 hVxZtbEn5yuxqfL5U/SUjGfq7isqdpTzSgrjwO5LjmSGsnSK3TesOxeBUkPrD4eGSl
	 UO2fVuMl2bYrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dillon Varone <Dillon.Varone@amd.com>,
	Sridevi Arvindekar <sridevi.arvindekar@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/752] drm/amd/display: Guard FAMS2 configuration updates
Date: Sat, 28 Feb 2026 12:37:08 -0500
Message-ID: <20260228174750.1542406-117-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 7dedb906cdfec100061daf41f8e54266e975987d ]

[WHY&HOW]
If DMCUB is not initialized or FAMS2 is not supported, the
interface should not be called.

Reviewed-by: Sridevi Arvindekar <sridevi.arvindekar@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 77cdd02a41bdd..bbfefc9edd1f1 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -1628,7 +1628,8 @@ void dcn401_unblank_stream(struct pipe_ctx *pipe_ctx,
 void dcn401_hardware_release(struct dc *dc)
 {
 	if (!dc->debug.disable_force_pstate_allow_on_hw_release) {
-		dc_dmub_srv_fams2_update_config(dc, dc->current_state, false);
+		if (dc->ctx->dmub_srv && dc->debug.fams2_config.bits.enable)
+			dc_dmub_srv_fams2_update_config(dc, dc->current_state, false);
 
 		/* If pstate unsupported, or still supported
 		* by firmware, force it supported by dcn
@@ -1648,7 +1649,9 @@ void dcn401_hardware_release(struct dc *dc)
 			dc->clk_mgr->clks.p_state_change_support = false;
 			dc->clk_mgr->funcs->update_clocks(dc->clk_mgr, dc->current_state, true);
 		}
-		dc_dmub_srv_fams2_update_config(dc, dc->current_state, false);
+
+		if (dc->ctx->dmub_srv && dc->debug.fams2_config.bits.enable)
+			dc_dmub_srv_fams2_update_config(dc, dc->current_state, false);
 	}
 }
 
-- 
2.51.0

