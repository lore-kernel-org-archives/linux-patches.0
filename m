Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E1D2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAB7C433D2;
	Sun, 22 Jan 2023 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401280;
	bh=ReBOtPZ5fpUjOsWwyJ/QczdIT5b+B2+bozn5z18Wc0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNam/46ttol6ii+3KzG/RRXDhayrZs7gwxPhz0u0DOgkTYjcJQST0/05uv4E8bCQI
	 akb2uST6dI8bsZ39VktltR4MzIvb2yOXjFT6ChMfq9jvm5rp3vdX1WJfw3MyzW5Oz0
	 QmBCpsIevIdmjHUFwMb+jnBzoe6IS7/VBRDHlUfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 178/193] drm/amdgpu: enable GFX Power Gating for GC IP v11.0.4
Date: Sun, 22 Jan 2023 16:05:07 +0100
Message-Id: <20230122150254.565994981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

commit a89e2965da6e644729a8ee9c318b7fa9a2990353 upstream.

Enable GFX Power Gating control for GC IP v11.0.4.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5030,6 +5030,7 @@ static void gfx_v11_cntl_power_gating(st
 	if (enable && (adev->pg_flags & AMD_PG_SUPPORT_GFX_PG)) {
 		switch (adev->ip_versions[GC_HWIP][0]) {
 		case IP_VERSION(11, 0, 1):
+		case IP_VERSION(11, 0, 4):
 			WREG32_SOC15(GC, 0, regRLC_PG_DELAY_3, RLC_PG_DELAY_3_DEFAULT_GC_11_0_1);
 			break;
 		default:
@@ -5063,6 +5064,7 @@ static int gfx_v11_0_set_powergating_sta
 		amdgpu_gfx_off_ctrl(adev, enable);
 		break;
 	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
 		gfx_v11_cntl_pg(adev, enable);
 		amdgpu_gfx_off_ctrl(adev, enable);
 		break;


