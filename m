Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B753841E6BD;
	Thu, 30 Jul 2026 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425621; cv=none; b=lJgdSQNJehhA3znpoX0pqLH7xIL4PRvlvKhSHEmzv712vN589+oB3BIV1OnTlDZhkV1/8aJVJPUKuFAC6IXaf6ZYVzYesPBoeJk2unXR226L91qJRO+L+0lV89HEk0191VPKHdFCaEF7OMLXuT6Yk/4RnFkLkSng96htQeZW3kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425621; c=relaxed/simple;
	bh=ODn74ShNkKRoQvyVbpFCj5ij5MAwy9bc0FvQi6FxXq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrJV7XseOiBNKn7lKx9sntlnANtTlO1iNlbUOqWG01ijFKBDD6QnzSlkHWrk2d0knPfuhSim8yDA4nRzq/GZqpk/enf2bgfnq03lCEZyaVEnkipV7CXtx7yk0fr9Sudxa4ly9Ay0SJ0z+QwxEl5ukulvc1l7M7U7hU4cStMwWyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4jziKVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4jziKVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1061F000E9;
	Thu, 30 Jul 2026 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425620;
	bh=NV1uKRsJNHn7SzaNT3ndAcgy7Mi23qAzwAc/xtApVKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4jziKVJIkSc8wKd/dV/wTfcnSKLGhrrpvtgI82c9GgJewEfPNRQe66qgggeQVC3p
	 wYG5zEZBlCqB1aZ4/Sy78oU38BTZaZ6mCqkHCEA3rYSPr7wEoZ0SUJk/l5TTqVwlaE
	 OpbLyD0xRmxMxrtlM0IeRZ5Szne+5stqFtOHhGTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/602] Revert "drm/amd/display: Add missing kdoc for ALLM parameters"
Date: Thu, 30 Jul 2026 16:08:43 +0200
Message-ID: <20260730141438.737612959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

This reverts commit 8fa292bd7ea0c19a6f87db967db823f48542e170.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index ae858a43c35f4a..b3d55cac35694b 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -447,8 +447,6 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
  *
  *  @stream:      contains data we may need to construct VSIF (i.e. timing_3d_format, etc.)
  *  @info_packet: output structure where to store VSIF
- *  @ALLMEnabled: indicates whether ALLM HF-VSIF should be generated
- *  @ALLMValue:   ALLM bit value to advertise in HF-VSIF
  */
 void mod_build_hf_vsif_infopacket(const struct dc_stream_state *stream,
 		struct dc_info_packet *info_packet)
-- 
2.53.0



