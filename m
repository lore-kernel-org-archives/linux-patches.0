Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A87B17D8BB;
	Tue, 30 Jul 2024 16:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358717; cv=none; b=cbJ4Vra4+GW2fvnIyVyesrAF53Musn5DVhWw9z3BXvxtz4D3SoDgGt1lvqNmZjmh/fSRPC7XBQXzixR76zVr35avs0INkDGVmAOZ5xlsG2h+pwRixAvCimmA2DZ1sm9lTtpfzipa521AtbXaTNdl2pf6dDzejJ5BdC3aXhrHHFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358717; c=relaxed/simple;
	bh=Fu4ZYTGsO1gsgCkevfo1irf1SDsShIjFP7TaiRAooHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5KJJeUYJIX4pF1jDgxxYn58GbelCPuTHpBqFpJiKQcNCP03VJADxiXJ8RqE4izB/k9i80iUNJ2zBCnBHRXafSU5bsK/w6rVuAQ/Fy5iuP0HQHpLlZ8Y2W7ZqkmtgQOUrBfAA9AguLxeQ+9O2eKwORjs8H+xf4aeXIHrYHLLNNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGhgKgOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGhgKgOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA074C32782;
	Tue, 30 Jul 2024 16:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358717;
	bh=Fu4ZYTGsO1gsgCkevfo1irf1SDsShIjFP7TaiRAooHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGhgKgOOwJtTpoe81Y8/3xdlw8zqeOm0SLi1YzUvqsnFUzUB2lx/QPA+G74F4bMkU
	 8PcWiaEz6962sqPEudxjqbg0mMzMTD4ANiJtSnK4McBs+gCQejyku75zNmuMszNYdu
	 vtscNwUH9wWLpFNWmtCL/Xm3Z3VcCZ2/G/MvTY3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Xi (Alex) Liu" <xi.liu@amd.com>,
	Sung Joon Kim <sungjoon.kim@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 6.6 388/568] drm/amd/display: Check for NULL pointer
Date: Tue, 30 Jul 2024 17:48:15 +0200
Message-ID: <20240730151655.029809380@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Joon Kim <sungjoon.kim@amd.com>

commit 4ab68e168ae1695f7c04fae98930740aaf7c50fa upstream.

[why & how]
Need to make sure plane_state is initialized
before accessing its members.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Xi (Alex) Liu <xi.liu@amd.com>
Signed-off-by: Sung Joon Kim <sungjoon.kim@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 295d91cbc700651782a60572f83c24861607b648)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
@@ -154,7 +154,8 @@ const struct dc_plane_status *dc_plane_g
 		if (pipe_ctx->plane_state != plane_state)
 			continue;
 
-		pipe_ctx->plane_state->status.is_flip_pending = false;
+		if (pipe_ctx->plane_state)
+			pipe_ctx->plane_state->status.is_flip_pending = false;
 
 		break;
 	}


