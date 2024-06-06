Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC93F199242;
	Thu,  6 Jun 2024 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682988; cv=none; b=B07scwu1Y1evck1oUzDz8jMKVxZ0e+4wTtyIlVQ0eSfVnwobqlk5SAY5k7cAXmZSRjwAaYGhJGYAEWQYlB8RgPxG4DF7fDQIXUUlVSeqN2T/XDw8fhRk7Jm/19AghIx3OFYCLhNlr1NaIRty2utNsNL+VSnZ6TQzhLEJOPkY6lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682988; c=relaxed/simple;
	bh=w5w+YNHbPYAAXcZLL68VMGenVf8z7N6ArYf5Nz+rHkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBYJ8xZ2WPoqA1lY1i4KOhEfq9CFIIGoxyrG8gqqMU+iQv3XvLUZ1070NkOS4iu7lZ3aAZnAvn9L2oYla6fQ+EtMfEK3ITLsIKeqa0d6RqlcsE+XaYY5suanAzsYY5CcVwo/B9I3ANSX7oVHsV1EiqThM2oAPBJIIM8cdy1jQ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stXVwGDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stXVwGDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE499C32782;
	Thu,  6 Jun 2024 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682988;
	bh=w5w+YNHbPYAAXcZLL68VMGenVf8z7N6ArYf5Nz+rHkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stXVwGDX657xPrnLWV6cBCNz/lCtPZCDQ3WWQdOdB9v1Y+OEDX2/YLl93GEhWzU4/
	 oL6VrxRR8PKeSv88Rcxt7lg3/qhzb/KmR+Kprzhhtzjvyt08ClAqLVR24QxTo/GQAN
	 FOWJp5gDZi3cYF8wYpRChbrq+hAICWFH87ZWr+Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Adam Ford <aford173@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 177/374] drm/bridge: imx: Fix unmet depenency for PHY_FSL_SAMSUNG_HDMI_PHY
Date: Thu,  6 Jun 2024 16:02:36 +0200
Message-ID: <20240606131657.809169429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit cbdbd9ca718e6efbc77b97ddf0b19b0cd46ac36c ]

When enabling i.MX8MP DWC HDMI driver, it automatically selects
PHY_FSL_SAMSUNG_HDMI_PHY, since it wont' work without the phy.
This may cause some Kconfig warnings during various build tests.
Fix this by implying the phy instead of selecting the phy.

To prevent this from happening with the DRM_IMX8MP_HDMI_PVI, also
imply it instead of selecting it.

Fixes: 1f36d634670d ("drm/bridge: imx: add bridge wrapper driver for i.MX8MP DWC HDMI")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404190103.lLm8LtuP-lkp@intel.com/
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240422103352.8886-1-aford173@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/imx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/imx/Kconfig b/drivers/gpu/drm/bridge/imx/Kconfig
index 7687ed652df5b..13142a6b85905 100644
--- a/drivers/gpu/drm/bridge/imx/Kconfig
+++ b/drivers/gpu/drm/bridge/imx/Kconfig
@@ -8,8 +8,8 @@ config DRM_IMX8MP_DW_HDMI_BRIDGE
 	depends on COMMON_CLK
 	depends on DRM_DW_HDMI
 	depends on OF
-	select DRM_IMX8MP_HDMI_PVI
-	select PHY_FSL_SAMSUNG_HDMI_PHY
+	imply DRM_IMX8MP_HDMI_PVI
+	imply PHY_FSL_SAMSUNG_HDMI_PHY
 	help
 	  Choose this to enable support for the internal HDMI encoder found
 	  on the i.MX8MP SoC.
-- 
2.43.0



