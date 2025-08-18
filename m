Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2659B21507C;
	Mon, 18 Aug 2025 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525756; cv=none; b=AVikyU+YfJDwSvGsSEke4xOhKugpmPt38dJnfFy8xX24uuhUmqTeQSJj4yrRsruJoNNGhVchEnh2B3JIlg3Mmu795ozgRZhZONWvl0kYOH8oTIzN987vE64Ob8+Eh5VVjlX/UU0I7Ul+it5gSHOeQbK1RCsEryCZxV4c6HeOArQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525756; c=relaxed/simple;
	bh=K3ozS63WcWLtk8a4A5/B+L5Z8pNCn2h49rFWiyMS4PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o86yml7GBypPmvbqovSgmnsfiCCiK5Puds9ADsjlegA8SZBARq3CmNwUYw0UxbPD3cEDjUAnUuSejkhkzbaJEMXQQxol0/Z1a/adGjxGjsynWwQI1Z0xyzv8ZaCqB7eXU1zGaeG0QGuSI0R11RuCjFj0llKsvpktkrPQ9V+GMYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DljcBkb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DljcBkb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B268C4CEEB;
	Mon, 18 Aug 2025 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525755;
	bh=K3ozS63WcWLtk8a4A5/B+L5Z8pNCn2h49rFWiyMS4PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DljcBkb2xHW9h/0gPMrp1FMNjRU46xET27zViri1FLhsDuBnqbjWqDVZZSALExNmv
	 WtyNDDAfvfyoRT3oIcCjrR60l9eQPCZU9u9+2F+obZF6WW9GAN1qnJGVAQangUgsIm
	 kymrpq4aulm09ZkP5vIFCEbLKdLIvltF5JS9Pbwc=
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
Subject: [PATCH 6.16 358/570] drm/amd/display: Disable dsc_power_gate for dcn314 by default
Date: Mon, 18 Aug 2025 14:45:45 +0200
Message-ID: <20250818124519.646514199@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 8383e2e59be5..eed64b05bc60 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
@@ -926,6 +926,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.seamless_boot_odm_combine = true,
 	.enable_legacy_fast_update = true,
 	.using_dml2 = false,
+	.disable_dsc_power_gate = true,
 };
 
 static const struct dc_panel_config panel_config_defaults = {
-- 
2.39.5



