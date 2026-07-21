Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0157C346A0C;
	Tue, 21 Jul 2026 20:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666310; cv=none; b=K6TtP7a9IaD+9qv+mpluvcxxlTQCsas+v0QBX02BV4GmFAH0ymOm6qNEGUTMcfTwVbzR5A2HyalwglLUJCPM1drHPFT/lMEQuPHddFjSk9Qsl9Vlv+K7JY1kml7NW5Es0CvA+TDl0G7sXjixmpwY8Q5VWENHGWQWovTeTqwVWDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666310; c=relaxed/simple;
	bh=v+qe8FPJ3oqoAu0u3gJ5nZiS7sgvYxoOP4vvW6JU0+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAp+jP1pOiziG5QPeCOrUJxzlHkTJCofcklWNDLpptkRxl1cEAU6sQQk1PXbhNW4iYvG6YWybPg67BGc17rbt4ZXtnHazomDxmjhLcBIYfGVkA0p/hOw1fDK6HdvRzSMypmGJXxSUI7eUkEBBnj4PBr9zvrX5azygEHkJohl9tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnI26/0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnI26/0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFD91F000E9;
	Tue, 21 Jul 2026 20:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666308;
	bh=SPA4wAEFgUyBbmaDPphEhwIQ2FVXoxrzmQP5PMmWjYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnI26/0mtDhmnMKriav+uCo9yDqF7+XFXuhtzBx+e02p0WvPNb89Z3/emmAmZWsd2
	 IeMngiTLT4+YiY+1s2yBujBjlzIhsBp92VN6MgNuoG5mGMhWfHCyRznbmIygPOQA9m
	 38iBEFuxWsp+LGxpm+L08OsuCYH2nCZD0KQBIFFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0633/1266] drm/amd/display: Add missing kdoc for ALLM parameters
Date: Tue, 21 Jul 2026 17:17:50 +0200
Message-ID: <20260721152456.021564548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit d4c6ec729fb7a8bf8a27b19bd70a1b945ad93dac ]

Add descriptions for the missing parameters for ALLMEnabled and
ALLMValue  to keep the function documentation synchronized with the
function prototype mod_build_hf_vsif_infopacket().

Fixes the below with gcc W=1:
../display/modules/info_packet/info_packet.c:507 function parameter 'ALLMEnabled' not described in 'mod_build_hf_vsif_infopacket'
../display/modules/info_packet/info_packet.c:507 function parameter 'ALLMValue' not described in 'mod_build_hf_vsif_infopacket'

Fixes: 3c2381b92cba ("drm/amd/display: add support for VSIP info packet")
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index 84f9b412a4f117..dbb62b911c75c1 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -447,6 +447,8 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
  *
  *  @stream:      contains data we may need to construct VSIF (i.e. timing_3d_format, etc.)
  *  @info_packet: output structure where to store VSIF
+ *  @ALLMEnabled: indicates whether ALLM HF-VSIF should be generated
+ *  @ALLMValue:   ALLM bit value to advertise in HF-VSIF
  */
 void mod_build_hf_vsif_infopacket(const struct dc_stream_state *stream,
 		struct dc_info_packet *info_packet)
-- 
2.53.0



