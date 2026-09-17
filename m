Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080784E73A9;
	Thu, 17 Sep 2026 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660845; cv=none; b=pkNrVIqQS4h3yMb8BHbBFUG6qLxf9Wh+0vc8SpFDn/WzaLrlwoR8BYXfuu80wo8w5pUrIuoAErNCZKTwjen8DDls4WYsx+ympBr5nFN2lb5g62tEPcCSTJAWgil3lnWyROvi3D43DtF7LtkCO5L6+R46CJJokNDDql4DmouLv1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660845; c=relaxed/simple;
	bh=6mQPBoDds7F4HLZQrDe4/ndTy4w3AI11xQ9G6B4giQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNkpZo3wat05nQnkBT/cy/ofCswxgocnQ61VGBC8aSewNDkBrmEkHhohzoJKDiV5VOue+hl/AtwlNp+dWJtzEAv07BtNZ0hNV4+Us56A8eKtBguAbIiqSEvsPmPHINJB812BBxgPk5WqQ2qmgN80ZKMAfnsaZponIhHU8PGlVrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceVy/lL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceVy/lL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3A51F000FF;
	Thu, 17 Sep 2026 16:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660843;
	bh=uAu2lV30iBo2jU0YsqI44Vn54D39P6AGn0WLkvefEKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceVy/lL8fgCSii+NMKw6zhkHYC/Zyi0xc59Mf2kW/Udd9cjcybtNghjCPJmoOM1uG
	 a5Lw+nJY5g81WDjq9r7B6KBk6APrxqIaOu5CpFdulTZ4zRZitNmmvkuY/utKwPBi//
	 TRjofQR0t9p7QyjAoXd2VaZ4e4sPVk6KDd0VYy8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 727/733] drm/amd/display: Honor Broadcast RGB for BT.2020 RGB output
Date: Thu, 17 Sep 2026 16:17:15 +0100
Message-ID: <20260917151411.093474318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyajit Roy <sroy14@alum.utk.edu>

[ Upstream commit 7fca7acd60a228b62b4e9efa5f184738041e9564 ]

amdgpu_dm_get_output_color_space() applies the Broadcast RGB connector
property to default RGB output, but always selects full-range output for
BT.2020 RGB. Consequently, explicitly selecting Limited has no effect on
the output CSC or AVI InfoFrame when HDR uses BT.2020 RGB.

Select COLOR_SPACE_2020_RGB_LIMITEDRANGE when the output encoding is RGB
and Broadcast RGB is Limited. Keep Automatic and Full at full range, and
leave YCbCr output unchanged.

Add KUnit coverage for limited-range RGB output through both BT.2020
connector colorspace values.

Fixes: 6eb4c13a3845 ("drm/amd/display: Support "Broadcast RGB" drm property")
Signed-off-by: Satyajit Roy <sroy14@alum.utk.edu>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 022236eaa63bbf65761aa8aec43f661451a94654)
Cc: stable@vger.kernel.org
[ adapted the hunk to the older get_output_color_space() function in amdgpu_dm.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6895,10 +6895,14 @@ get_output_color_space(const struct dc_c
 		break;
 	case DRM_MODE_COLORIMETRY_BT2020_RGB:
 	case DRM_MODE_COLORIMETRY_BT2020_YCC:
-		if (dc_crtc_timing->pixel_encoding == PIXEL_ENCODING_RGB)
-			color_space = COLOR_SPACE_2020_RGB_FULLRANGE;
-		else
+		if (dc_crtc_timing->pixel_encoding == PIXEL_ENCODING_RGB) {
+			if (connector_state->hdmi.broadcast_rgb == DRM_HDMI_BROADCAST_RGB_LIMITED)
+				color_space = COLOR_SPACE_2020_RGB_LIMITEDRANGE;
+			else
+				color_space = COLOR_SPACE_2020_RGB_FULLRANGE;
+		} else {
 			color_space = COLOR_SPACE_2020_YCBCR_LIMITED;
+		}
 		break;
 	case DRM_MODE_COLORIMETRY_DEFAULT: // ITU601
 	default:


