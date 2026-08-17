Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FF12D0C8F;
	Mon, 17 Aug 2026 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979045; cv=none; b=nQkgv8xVh5ZEResGuigYERXsJjliLVL4DudhWJH9FF2yjP7Dz2XkOyrEWhGTXOfdI+lrPyxJo5OT89ByNFRh9M5x6XzJhCgP3HBj7UJjXLuFHgt/0GWBe4MZ84/0FM7t56ngDwyNni4D974bGgRHGJUX8NiDZJvC9KAVOkh/+Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979045; c=relaxed/simple;
	bh=N8teXfDNzxWoGLIKAJEjaIlTGZdFEcY8ZPsG9nCxYEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRPeTNxAgyli8WlpI6kAiwPeCIK14UUzmbdhU62LpPblAwk8t/wxKKDOCmDxDumDaDf6eKr+v6xNRbBTyAJwBVr86C2/dR8Ztm8xn7l6dvraMTNiuIWuEYttbAVpB/fsWqZyXtHvDyjtIgA78GvgJYVJ/UffG2U9u6651O2THQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrH3Qgp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrH3Qgp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6AA1F000E9;
	Mon, 17 Aug 2026 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979044;
	bh=j4VVVfxS7l/LVaKAE+zN1XM41hd+uzo8KvL3c9hWqz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrH3Qgp+/zNPtOta3wsZEPow+TmGFB467yaghllqHtDQqvp5PBL4uz9VgvBOa4Aki
	 nD5dYQnLiXPiwL5S1UJc1WqO2NJb9cMEBraqbOHhJuYkk4TaI1jneBSRBtTD1yW1f/
	 9cvBcgS12yFPsiCVN9wRyu9xJaS6RH1sgSovY98Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/609] Revert "drm/amd/display: Add missing kdoc for ALLM parameters"
Date: Mon, 17 Aug 2026 15:26:25 +0200
Message-ID: <20260817132546.596939993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 7cb4e8ba78f96980a23be4414c8f22f417c814fa.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index 6602ac882d6bce..69691058ab8981 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -445,8 +445,6 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
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



