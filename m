Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C191F542D;
	Tue, 21 Jan 2025 18:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482568; cv=none; b=ZaV5h21gUR1DJMFGNkPbvJnBekhSTBr4o6JVqBa8vZCaK1iZvLvRmqBhGU0XqqOvVTPbuLVaaYwXJFYoLxLAx5vaBUYto2LJyL1Ta80zMDzpL/TugyOivlHdD0HD7F4GgkCLXPXqHLzoMnI/d/Yo8GPCo5se9hHdjc7RfTi7Dak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482568; c=relaxed/simple;
	bh=5Dk/YAaRbnPPDLq41w//j5gVBUW0Rnk+weIlCbWsLok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coNSck7K4vTP5wQReTDwLUahTogCT3IIS9MG+Hg6P1RPfCwOZ6hBOSveXa3Gk1HOOqOOLuN+52yAmab8btW1ByFCZsCmkUVkv+BTI5xofi0K4r7JvzRDcpTe9l6XVyhb9sINnZnVPwlSy9dM4UpqmcPUcXiaNuLFIjAvRSLi12I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh/RjwDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh/RjwDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD532C4CEE0;
	Tue, 21 Jan 2025 18:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482568;
	bh=5Dk/YAaRbnPPDLq41w//j5gVBUW0Rnk+weIlCbWsLok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh/RjwDhnAZKGBpFYa5FbLvWApgQhuTnUS0D50uSeAxT5FGcFz+W9IfXbEud6Tgvs
	 DXzxTv/N4X79cRUQjAmNz1vDx7vzgyGQiIRhMTxw+mGOCSWx/tJlE2D4SVQtCZZEmg
	 RZAAjCXjm4557gPjZQXUV46FxHESZnl3SG+8b8Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 121/122] drm/amd/display: Validate mdoe under MST LCT=1 case as well
Date: Tue, 21 Jan 2025 18:52:49 +0100
Message-ID: <20250121174537.725091763@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit b5cd418f016fb801be413fd52fe4711d2d13018c upstream.

[Why & How]
Currently in dm_dp_mst_is_port_support_mode(), when valdidating mode
under dsc decoding at the last DP link config, we only validate the
case when there is an UFP. However, if the MSTB LCT=1, there is no
UFP.

Under this case, use root_link_bw_in_kbps as the available bw to
compare.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3720
Fixes: fa57924c76d9 ("drm/amd/display: Refactor function dm_dp_mst_is_port_support_mode()")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a04d9534a8a75b2806c5321c387be450c364b55e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   14 +++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1831,11 +1831,15 @@ enum dc_status dm_dp_mst_is_port_support
 			if (immediate_upstream_port) {
 				virtual_channel_bw_in_kbps = kbps_from_pbn(immediate_upstream_port->full_pbn);
 				virtual_channel_bw_in_kbps = min(root_link_bw_in_kbps, virtual_channel_bw_in_kbps);
-				if (bw_range.min_kbps > virtual_channel_bw_in_kbps) {
-					DRM_DEBUG_DRIVER("MST_DSC dsc decode at last link."
-							 "Max dsc compression can't fit into MST available bw\n");
-					return DC_FAIL_BANDWIDTH_VALIDATE;
-				}
+			} else {
+				/* For topology LCT 1 case - only one mstb*/
+				virtual_channel_bw_in_kbps = root_link_bw_in_kbps;
+			}
+
+			if (bw_range.min_kbps > virtual_channel_bw_in_kbps) {
+				DRM_DEBUG_DRIVER("MST_DSC dsc decode at last link."
+						 "Max dsc compression can't fit into MST available bw\n");
+				return DC_FAIL_BANDWIDTH_VALIDATE;
 			}
 		}
 


