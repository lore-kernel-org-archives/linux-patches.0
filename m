Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390E51C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACCAC433D6;
	Wed, 23 Nov 2022 09:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196506;
	bh=gISBxv/LWiXRjrU9C/SlDLpioy9jyy9o+asTMKurs3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqeRA4HKkfoP6C2pD+Ceei21HCFVsrxGGUPUU0uqHRBMh+WEdvl/oagCLjj5eeDnX
	 g9wjjOQVX5WcC2u32B1HBHbaHJlkbPjFhuWAE2kkkHJrg3EE/5YPoUkM2hmgaLFSea
	 SPDbOKjGRlRecpqZn+vFQx8bJDAR4InAHwRJntiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 051/314] drm/amdgpu: set fb_modifiers_not_supported in vkms
Date: Wed, 23 Nov 2022 09:48:16 +0100
Message-Id: <20221123084627.817029244@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 89b3554782e6b65894f0551e9e0a82ad02dac94d ]

This patch to fix the gdm3 start failure with virual display:

/usr/libexec/gdm-x-session[1711]: (II) AMDGPU(0): Setting screen physical size to 270 x 203
/usr/libexec/gdm-x-session[1711]: (EE) AMDGPU(0): Failed to make import prime FD as pixmap: 22
/usr/libexec/gdm-x-session[1711]: (EE) AMDGPU(0): failed to set mode: Invalid argument
/usr/libexec/gdm-x-session[1711]: (WW) AMDGPU(0): Failed to set mode on CRTC 0
/usr/libexec/gdm-x-session[1711]: (EE) AMDGPU(0): Failed to enable any CRTC
gnome-shell[1840]: Running GNOME Shell (using mutter 42.2) as a X11 window and compositing manager
/usr/libexec/gdm-x-session[1711]: (EE) AMDGPU(0): failed to set mode: Invalid argument

vkms doesn't have modifiers support, set fb_modifiers_not_supported to bring the gdm back.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
index 576849e95296..f69827aefb57 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -500,6 +500,8 @@ static int amdgpu_vkms_sw_init(void *handle)
 
 	adev_to_drm(adev)->mode_config.fb_base = adev->gmc.aper_base;
 
+	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
+
 	r = amdgpu_display_modeset_create_props(adev);
 	if (r)
 		return r;
-- 
2.35.1



