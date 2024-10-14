Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2512C1AB52F;
	Mon, 14 Oct 2024 14:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916927; cv=none; b=AQII0h5dkqWS4jqGAyKFEmgP+5gpwhtUmh+dYjJuTRB2uh4L6NQDFnY7n85FCuAAOqkORbd0vq/JTg/qRX44DZHogr1sirv4TC4ChkaElO/cdvTFw81fVpywxumXjHTtY1f0HZXYuLOEMJbm06zTVc+Dnt9gWrA3+c6ZImR5x7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916927; c=relaxed/simple;
	bh=2aMmNJ7M+HP5EG+jVGtRHec7ROiHfwZVxPY5hLmJi14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZtrB6+jEBJM8fn53Ym9TQVa99BF31LsGwx8Q3JgVH7sK3dVO+vMjAOJIbCPS186ppXPoYHfbB3cV9odF5jAB+2g+29HpuK2ue5RfC+uoL9NvLDEkH0CWCVvJBPBk2ubdbUZt+D5s7kApkmDf3Yeg/bOmPLexVBwZPIYgNukanY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNXOK02o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNXOK02o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978A4C4CEC3;
	Mon, 14 Oct 2024 14:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916927;
	bh=2aMmNJ7M+HP5EG+jVGtRHec7ROiHfwZVxPY5hLmJi14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNXOK02oFu7+plg4aNDPfkh31hAkI1wJTsRMVsPxITuShWOZNnybz2RtkQesvKDDB
	 mu8FPvCpo5PvzXVQ6kgaAel0pW2NOAecnDVUmW2mcCIuL+ptz3Si7PNH9GNoQOO8Yq
	 G8w5U9GIJndbURWeoDRhMZNWSDlDl+KeV/ioio5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/213] drm/amd/display: Check null pointer before dereferencing se
Date: Mon, 14 Oct 2024 16:20:09 +0200
Message-ID: <20241014141046.990156775@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit ff599ef6970ee000fa5bc38d02fa5ff5f3fc7575 ]

[WHAT & HOW]
se is null checked previously in the same function, indicating
it might be null; therefore, it must be checked when used again.

This fixes 1 FORWARD_NULL issue reported by Coverity.

Acked-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index a7a6f6c5c7655..c2efe18ceacd0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1691,7 +1691,7 @@ bool dc_validate_boot_timing(const struct dc *dc,
 		if (crtc_timing->pix_clk_100hz != pix_clk_100hz)
 			return false;
 
-		if (!se->funcs->dp_get_pixel_format)
+		if (!se || !se->funcs->dp_get_pixel_format)
 			return false;
 
 		if (!se->funcs->dp_get_pixel_format(
-- 
2.43.0



