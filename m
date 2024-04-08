Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAED67867D;
	Mon,  8 Apr 2024 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582046; cv=none; b=WTFdCVsnVZ6UBnGPtZYyK1ViB7pWqZ0Qoo2mD8STaaXCT1FrMdsnbRGwXMEdKH/rW1eFKjCDQQ/U4cDOYp0wZYhS5XtHOtbrExs2ZkOj5xNdpKDFhEAcIWnMr+J2OngeO+8QZIDn/VVo/wOglvDuEFocJHqNR/jDfQrW9dgqs5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582046; c=relaxed/simple;
	bh=frOEcItHtFOURjvSZppRp7YA9aXPb2YPPWFvQvHbE20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sl6yNNauk0y5uavZ7yruE7jPefUicGlVl0PYTIlxFKa280oLBd8c5uLIwvUqYX1mgXGPgXuJr9k/MyzIc3Q9LVTCu8ig4YoGviSSNz0iMNZe5eEZD1eGpwU58lIiloMWfZBUHfKZFREXoZSiBo6wGYX2dfa1Dvo305e08Q8rPBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yey2WBMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yey2WBMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71657C433C7;
	Mon,  8 Apr 2024 13:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582045;
	bh=frOEcItHtFOURjvSZppRp7YA9aXPb2YPPWFvQvHbE20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yey2WBMjE9iH0oNc5UAqGj/FFYEoGXfheZlOMxT2SKmQrYjYflV+L4qb93j9xaK3x
	 eSP4V8qIAYjbXhZCSsctJdDSRfmk3C8NdtMF1cJl8aMf5E4/vKTMTcGHTVrjoQaDnr
	 laXjTmC3F6GYDY2PH+m/kFO8a+E8WgxaR1S/GFy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Taimur Hassan <syed.hassan@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 042/273] drm/amd/display: Send DTBCLK disable message on first commit
Date: Mon,  8 Apr 2024 14:55:17 +0200
Message-ID: <20240408125310.596769248@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Taimur Hassan <syed.hassan@amd.com>

[ Upstream commit f341055b10bd8be55c3c995dff5f770b236b8ca9 ]

[Why]
Previous patch to allow DTBCLK disable didn't address boot case. Driver
thinks DTBCLK is disabled by default, so we don't send disable message to
PMFW. DTBCLK is then enabled at idle desktop on boot, burning power.

[How]
Set dtbclk_en to true on boot so that disable message is sent during first
commit.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Taimur Hassan <syed.hassan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index 9cbab880c6233..f07629694ec5e 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -415,6 +415,7 @@ void dcn35_init_clocks(struct clk_mgr *clk_mgr)
 	memset(&(clk_mgr->clks), 0, sizeof(struct dc_clocks));
 
 	// Assumption is that boot state always supports pstate
+	clk_mgr->clks.dtbclk_en = true;
 	clk_mgr->clks.ref_dtbclk_khz = ref_dtbclk;	// restore ref_dtbclk
 	clk_mgr->clks.p_state_change_support = true;
 	clk_mgr->clks.prev_p_state_change_support = true;
-- 
2.43.0



