Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF627F4CB;
	Tue, 27 May 2025 16:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365004; cv=none; b=Hkfw70WyrUqCvo0fu4/X825iPbV9fcGZTwF8VcknGLkdtgqZKj4xgBQ/+axcHHA0xTPALvTFcI5LAhgGmdb66mL5suVgAZgVSPWjgl3V+SHq1LJOFiUYXRDgrd08XyEZg7PGIM0ZcBZ1WGwyoTTvSNZITkzpK5IzoBfJsOrz3hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365004; c=relaxed/simple;
	bh=oRiMdiZ9mGEWj5K/Pant1s6cEg9bI6+al1nRe22DoiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdr+9exRTbvodpDKRHDwVSHfSDUbbH9szzwjXLBUY9zqQlHz5JtIeX8NhyHlNlOpZLJXnWgqHGT72lPZIKs66J28v/18ZvLLwM2C/8xd4VIyF/WTQFzViAUWlXMoHOsuv9Qlly6s9B1cuUSuwjcnoQAbpadNgV9PdZGtMC8b4NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjRaZftu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjRaZftu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E44C4CEE9;
	Tue, 27 May 2025 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365003;
	bh=oRiMdiZ9mGEWj5K/Pant1s6cEg9bI6+al1nRe22DoiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjRaZftukjdZtysIku7jq+v4XYBi8vVK5pifTEk/2ksVAb0dbFJuw4BBv/TFxqbC2
	 Ooif9V7n9vzRgEWvfRlIo6vU4+UkY8SaZ2hyBGlQlQM8Gnumlejuj3e2D5e3kC4reM
	 LvPiJAMk7rdpnHOYHJ7H6CeffyO/L/eCCn8Cn7fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/626] drm/amd/display: Fix p-state type when p-state is unsupported
Date: Tue, 27 May 2025 18:22:09 +0200
Message-ID: <20250527162454.605009033@linuxfoundation.org>
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

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit a025f424af0407b7561bd5e6217295dde3abbc2e ]

[WHY&HOW]
P-state type would remain on previously used when unsupported which
causes confusion in logging and visual confirm, so set back to zero
when unsupported.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index fdcba960e1e6f..d2342a91e7e71 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -508,6 +508,7 @@ void set_p_state_switch_method(
 	if (!dc->ctx || !dc->ctx->dmub_srv || !pipe_ctx || !vba)
 		return;
 
+	pipe_ctx->p_state_type = P_STATE_UNKNOWN;
 	if (vba->DRAMClockChangeSupport[vba->VoltageLevel][vba->maxMpcComb] !=
 			dm_dram_clock_change_unsupported) {
 		/* MCLK switching is supported */
-- 
2.39.5



