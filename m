Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4617BAFD;
	Mon,  8 Apr 2024 13:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583593; cv=none; b=EV9WCyAknkKTZLO61D5SepGBKrAAPk3Q7Gl0czNq0B9THOvcKE4gLSkGEA6c5tFa7qsvrDhmpOcHkQ7tykXPxWX1h+1iADBGca+bUDFw7pxkadT//5qN0niuS4xs5Y+HhtBWDuz1WR4dlBHVDPBFOmHhIFIJgh+9PCfZx8Y7JFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583593; c=relaxed/simple;
	bh=ej7jXpAler8y8CylVWuZRtTYpjnMTVm5XfV+0WWbCNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5xi0yYythgkF1NcrHqdeQzED6vey2eFuCui14dTOimO/PiHCPDmdnoRZziEqH4B3ENUOA+/XkqSTvjfb6E7l36oK22rZAsgq0cjZPfa35cM7cNJfeY4H/WY30vxXU5j8q5a/+GDmM5O7ULM78lv5HBk4Y5NY56QggsIlBtYT0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTT7EuZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTT7EuZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51050C433C7;
	Mon,  8 Apr 2024 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583593;
	bh=ej7jXpAler8y8CylVWuZRtTYpjnMTVm5XfV+0WWbCNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTT7EuZ7GJ2/KX7iMDhXvJ/dWem1LA/b17Uei+b77RK02oTi0JIadZrFu9PmL6Hpg
	 Aj+mkpORjAq30WDgs/yXBGqcMAXsTu+I3kQB8HQ2EpU2LHEd3IMnXqRfQbKf4cs5di
	 ynj1j73qLUHD1iUnfJhqKFZvLgLBLU668gdRtaoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Gabe Teeger <gabe.teeger@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.8 195/273] Revert "drm/amd/display: Send DTBCLK disable message on first commit"
Date: Mon,  8 Apr 2024 14:57:50 +0200
Message-ID: <20240408125315.381550485@linuxfoundation.org>
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

From: Gabe Teeger <gabe.teeger@amd.com>

commit 3a6a32b31a111f6e66526fb2d3cb13a876465076 upstream.

This reverts commit f341055b10bd8be55c3c995dff5f770b236b8ca9.

System hang observed, this commit is thought to be the
regression point.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Gabe Teeger <gabe.teeger@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -415,7 +415,6 @@ void dcn35_init_clocks(struct clk_mgr *c
 	memset(&(clk_mgr->clks), 0, sizeof(struct dc_clocks));
 
 	// Assumption is that boot state always supports pstate
-	clk_mgr->clks.dtbclk_en = true;
 	clk_mgr->clks.ref_dtbclk_khz = ref_dtbclk;	// restore ref_dtbclk
 	clk_mgr->clks.p_state_change_support = true;
 	clk_mgr->clks.prev_p_state_change_support = true;


