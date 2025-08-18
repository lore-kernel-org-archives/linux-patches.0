Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4953831CA55;
	Mon, 18 Aug 2025 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522301; cv=none; b=qgLKfEQRuwttTLDvVakLaju0CJi1KPAaCMXCr/r+UyMZh+tfh/Safvy3dJYkoSQ3GEEY4/FPx1eD4lRMcI85vcs6ZsWT6fexj9+eWM4wKgmayH1pQwUgyIuQ1mNiQjNA+Lf84BLac5Rl/BFXxw5kRiK1NU/cXxkYKMW7S2aocuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522301; c=relaxed/simple;
	bh=uBJw7FC1EW8VolAbxdjCj/bhJ/Oy8c0WQv8XtqTcAWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz3LI5y9giXl744yK0/Q3dWseB+2ufgYSAi+OmNiiL0e4W94Gus2MZAgQ6trf04oSBcvjplYfS1OvXQHL8d9tlhjc5ZHWHbqEby7FWE/xXJOyA8BeThHs7FAmX3lP3ZC/lWmSr/JWrPLNKPq+nVLiaNyTc/Ej3vMttcy80Zjk+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4Oj3yYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4Oj3yYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8902EC4CEEB;
	Mon, 18 Aug 2025 13:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522301;
	bh=uBJw7FC1EW8VolAbxdjCj/bhJ/Oy8c0WQv8XtqTcAWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4Oj3yYObpRg8MImTJiHvULqKLq+u1RPn/QnFVtoCL+qmeFj+QKDQBgiKAvoB7mvI
	 WTEDKcm3R1nN+4U1cCmqS6HYzD6D0o5CNB9P56ZkfWLy6S2r+9xfGFJ3sGphzDLpeS
	 DIt0YDaPzaeyZa7gJJATZMK8LAGeRrz9/vPqQYHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/444] drm/amd/display: Disable dsc_power_gate for dcn314 by default
Date: Mon, 18 Aug 2025 14:45:01 +0200
Message-ID: <20250818124459.283668916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 02f3ec53177243d32ee8b6f8ba99136d7887ee3a ]

[Why]
"REG_WAIT timeout 1us * 1000 tries - dcn314_dsc_pg_control line"
warnings seen after resuming from s2idle.
DCN314 has issues with DSC power gating that cause REG_WAIT timeouts
when attempting to power down DSC blocks.

[How]
Disable dsc_power_gate for dcn314 by default.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
index 01d95108ce66..585c3e8a2194 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
@@ -927,6 +927,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.seamless_boot_odm_combine = true,
 	.enable_legacy_fast_update = true,
 	.using_dml2 = false,
+	.disable_dsc_power_gate = true,
 };
 
 static const struct dc_panel_config panel_config_defaults = {
-- 
2.39.5



