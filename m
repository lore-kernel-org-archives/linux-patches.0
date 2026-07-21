Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7914842FCC9;
	Tue, 21 Jul 2026 19:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662468; cv=none; b=owJlZnEmEmFb3xTKFfyaP5naKe84RikPGQznodO2jVPaLUQlxcy2l0+qwQKG5oo5bc/v4UXzsv55vPlwcxyWBaL+64fl5W2DJcrP552b7egzg7FbtyAJ481fnNU3KhV1kstDoPggTqhu32c6mwT2X2Xx3iKMK1HWluhKvwYodLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662468; c=relaxed/simple;
	bh=eev5MW9iG/HdA+ugIEed3tNDbstyKrWD9Jr0AhmPFDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0uq9dYA8fLD75qwK+iYZ2EVYhUtj4ImlgQYzYWsGHh0ZxHoq6wY/TbQ8X+JDfARbfW3pk62drSXQTNyP9auJWWLf8uR71luQTu71qdxtpdpf1tdN/bfbO3i+LpqwBzHXZiVZrVt53h4MTEEFsV7xO2y5KNQli/tj+ItHI+Xh/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLThrop7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLThrop7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E547B1F000E9;
	Tue, 21 Jul 2026 19:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662467;
	bh=76vXLisBxvXpvOWS01S6FeLuPpTznO3fv+QskvKv5PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLThrop7zmLNcjOOHewjwUzASGmGDzs79hZdNJ924vP9Kt7PWozHpayCDWD/MZ8tO
	 SexDu3hMriIicTmCG7wCYOwQzvFht+mKETIjKxpKYCgH2OE2i5V3wQ3cpG+3zff1oQ
	 uy0knxDoZzzB8XoDts+041VvJo+jxe6qvlTjD/k0=
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
Subject: [PATCH 6.12 0454/1276] drm/amd/display: Add missing kdoc for ALLM parameters
Date: Tue, 21 Jul 2026 17:14:57 +0200
Message-ID: <20260721152456.263240536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b3d55cac35694b..ae858a43c35f4a 100644
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



