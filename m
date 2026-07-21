Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01B1399013;
	Tue, 21 Jul 2026 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657082; cv=none; b=fctBFmpiY18814Djf8iT1W3lf+WZDrLBVYSlUf0PSqQAocnZO3z25GyJ4nyycciQpZqt4SgYBGuh22D/adZWTVsFiZ3ROjuWkNtnDyZZwynkqy/5Cgd1DZqcwgz3PiK1kw1jVxdnmCl+t2GD3sblxolY8xyU/oyYZftykHnxp94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657082; c=relaxed/simple;
	bh=62/6/V/TMD8cfAoGrrdJMDVTE7Nuj+/1pFCiLA7T/Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BS/j55zcTTdhdX8LZV6FGdq15I74vwrrb/crEuHlnaqgoMWL9z7lvBDbvgLYdNbkiMLWnt9fY38/XsvK5y3y1WY36JMlc1M2JihOxDKHzTL9Mbxd2F7Ei+dw1qmp4LYwKijwtyQqnKO73MgWK0DHDqwdDzT55l98jwW7dW0/XqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cRCC9xd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cRCC9xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2439F1F000E9;
	Tue, 21 Jul 2026 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657081;
	bh=kEqJRvtwcbXc9ejsZwHwpwz86ikygfW+E5Y+9IhC9KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2cRCC9xdaWLSTgcNInrTQp+WpqMDyJe0ajEtS3g1idalc94gd1WI7KuIQt53dluXv
	 o4W5j2R4mj63bQ3ZdjG9JXp7Fh5WAO0rhCTEIss1xlU4Ak4ZhSNEXVzWXH3pVVF+31
	 gC94ZuURipXeDtbQPCpJMQll0SJEG3w4CkA4V6Og=
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
Subject: [PATCH 6.18 0630/1611] drm/amd/display: Add missing kdoc for ALLM parameters
Date: Tue, 21 Jul 2026 17:12:26 +0200
Message-ID: <20260721152529.558557071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



