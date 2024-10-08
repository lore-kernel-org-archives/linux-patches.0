Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E6C1DFD1;
	Tue,  8 Oct 2024 13:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392613; cv=none; b=owRTwVjSaWMvb3LINhPMkNPJEu5Em+VI8FC/4AuSoC8bPpIAGjl4aAteqZYHeS7Ny9viEUvhkGprlRAS9JllO/lUSnMqfv7olDtkOa2eG2P2aBpDZQiPLQC5Mn7JSpXktpECeGlM44qhOD4mimDefUE7dGUtdG3n/qFofznalXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392613; c=relaxed/simple;
	bh=0wNA051C0auUwQR7NvSiT0r3gd0DmYMBa2sbkJKN5Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8+u3wRkKfiLpUeVz3BGhmxKrbrkEO9Nx1cqql+WhpW22r/pHvBN/joUFhvTPo9kHHQ4kl1R19Ajf1s6JygbZ2W+nbV1/YrsTOf0Jxed5jQ/47QfxobUu9LEbN2RDanl1Mrozn5jWDaolELjnCSm23TDJxsvuYnbaryIw4B+XVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XUBK2R0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XUBK2R0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC77C4CEC7;
	Tue,  8 Oct 2024 13:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392613;
	bh=0wNA051C0auUwQR7NvSiT0r3gd0DmYMBa2sbkJKN5Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XUBK2R0GTXqg0Z4KPqwEnpsZA1bBVJE2s2u/rmrIUl100k9e+E1hg7lhDPvzNLQG
	 lbVkgeo71Qv65rBCwP6laYQQ3XQOJITwtQoZkw1CProCxEJJ1zR9ldYapkr1K4AO9F
	 uu3ov7nUOhlQ8GwQW3/7RCXsGbn9m4iIVK1Bu6lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 467/558] drm/amd/display: avoid set dispclk to 0
Date: Tue,  8 Oct 2024 14:08:17 +0200
Message-ID: <20241008115720.626917209@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <Charlene.Liu@amd.com>

commit c36df0f5f5e5acec5d78f23c4725cc500df28843 upstream.

[why]
set dispclk to 0 cause stability issue.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1c6b16ebf5eb2bc5740be9e37b3a69f1dfe1dded)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -766,6 +766,7 @@ static const struct dc_debug_options deb
 	.disable_dmub_reallow_idle = false,
 	.static_screen_wait_frames = 2,
 	.notify_dpia_hr_bw = true,
+	.min_disp_clk_khz = 50000,
 };
 
 static const struct dc_panel_config panel_config_defaults = {


