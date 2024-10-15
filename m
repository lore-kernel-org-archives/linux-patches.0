Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CD81CACD0;
	Tue, 15 Oct 2024 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994258; cv=none; b=CwgujcJTJxHSw9OcUevsaZvt2aFqL3GACK8MwlMyPIAVJb81wgyZT8lkehHyqJiLD5J5Dk5t7ANC9bLXZbCavD2D/SR5FZu5K0PZnPn4/DfwhcMCl8yj+C8Lp8Zu8Jrey4xVS+DHVwV6YmZbN11zMA+DyspVGf60wifSnidTHH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994258; c=relaxed/simple;
	bh=hZ7BQaVADDQQtGMvCGeRB6IVbDEyXsbkU+USoWXL+Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FELD7N+l3YukRgITb6KPMoQ8kEzKFTjILN8PRL7SYnWAiCe99N4xMIVAeNaVtaconkyMIdhp9UbPr4cWx47BOmfWfERDbBtkkkdbT4kBfkb6XF5pGJXoeVdSnA5W93kH1QIFc7OZ7+rT6qpogck2byW/NgYmVJnBbMFXDqYNm98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rV5j1JkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rV5j1JkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19138C4CEC6;
	Tue, 15 Oct 2024 12:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994258;
	bh=hZ7BQaVADDQQtGMvCGeRB6IVbDEyXsbkU+USoWXL+Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rV5j1JkJlPM8OwRDyX6FzBFv/4PuZYWHqZP/AVUS26IPe+Uuog1VOqTOJXMh5q8Z9
	 8sHjU8Zfvpp9YEdpvBP/1V9/yhwdWrpNhpG42fa8QRXhUyE6WfcNC7fBO4Cnlwtzwz
	 alpHimS12p4+E6qs2cjFR5s16TNZnkF0syXQEGDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 621/691] drm/amd/display: Check null pointer before dereferencing se
Date: Tue, 15 Oct 2024 13:29:29 +0200
Message-ID: <20241015112504.979966476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index db7a758ab778d..d3d638252e2b9 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1464,7 +1464,7 @@ bool dc_validate_seamless_boot_timing(const struct dc *dc,
 		if (crtc_timing->pix_clk_100hz != pix_clk_100hz)
 			return false;
 
-		if (!se->funcs->dp_get_pixel_format)
+		if (!se || !se->funcs->dp_get_pixel_format)
 			return false;
 
 		if (!se->funcs->dp_get_pixel_format(
-- 
2.43.0



