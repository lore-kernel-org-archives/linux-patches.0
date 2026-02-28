Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B2333447
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301215; cv=none; b=ZSRLkvbAeAWm5hArveMFUMjshqumHDWpKIChn5+W8xOj0HXMd3mId2uLJKcNenH13nrJtwu/+/df/I/Vfx/BzJHnVb4yhlXrfyg+Tv9y6zXSsuT1h4tmnJIQVJrxs8uCS6cebXz0gh/4RCm0PUJDGkESomnNbq9z/LQWpYgia6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301215; c=relaxed/simple;
	bh=XbMFJorPElyGQ/hSArPLI1I62rQipWOFxlM56R1D4PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+c8BxTGbNmF4Ke3LcBMF/wpqVgI5TTkHTrs6JsjygVtIKgAgz1Ng4+XHEUaBNWes2u6P+0oWcsPwIMyLlNc1FAzgfC20UXuwN6L79nf6w8eO/GScGrZ+pMkHQU/h5DzZ01UJTXGebAsP1TDUGQqcxn+E3BrafceETqINebpqqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=suiITwGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="suiITwGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C407EC19424;
	Sat, 28 Feb 2026 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301215;
	bh=XbMFJorPElyGQ/hSArPLI1I62rQipWOFxlM56R1D4PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suiITwGxSUEIMeC6nep+9gELJL4loNfw3dnG4vymILvp82Wg9Wod+x+x6ak+EypnK
	 66t6UeZAZTCXz9Dp5LaYLXHm25JQKsfdct+zdh7uGZDVQ8OWbrUsk5+sA56W04jNwc
	 h5BdgTm8gocYO/TqKWWc/AZQ/r+j4VIUA+SmzCaMhls9ysnyhITUcfYVAabvt71/X8
	 w3HWi3v8mVPuD776iTEgyKSYuAzIupH+ivEfjg4OiCapSuIFcqG3azRP5JVmFvTR4r
	 GIaU0ejONP9gWETdjcvjC3vfo8efiOEQm7cjodmI6qZuJAqy6YNhcg8gtq7F35zE8M
	 SN0aMFT38gBLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/752] drm/amd/display: Remove conditional for shaper 3DLUT power-on
Date: Sat, 28 Feb 2026 12:41:42 -0500
Message-ID: <20260228174750.1542406-391-sashal@kernel.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 1b38a87b8f8020e8ef4563e7752a64182b5a39b9 ]

[Why]
Shaper programming has high chance to fail on first time after
power-on or reboot. This can be verified by running IGT's kms_colorop.

[How]
Always power on the shaper and 3DLUT before programming by
removing the debug flag of low power mode.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c b/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
index 6f0e017a8ae29..a9d2aa0b5390f 100644
--- a/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
@@ -724,8 +724,7 @@ bool mpc32_program_shaper(
 		return false;
 	}
 
-	if (mpc->ctx->dc->debug.enable_mem_low_power.bits.mpc)
-		mpc32_power_on_shaper_3dlut(mpc, mpcc_id, true);
+	mpc32_power_on_shaper_3dlut(mpc, mpcc_id, true);
 
 	current_mode = mpc32_get_shaper_current(mpc, mpcc_id);
 
-- 
2.51.0

