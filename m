Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62366262BE;
	Mon, 27 May 2024 19:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837871; cv=none; b=Tst0WzfekUqHBUbcbGu2rPtCYd0dq+Mafroplg1i64DeoWhEvkggIILBRyTYcpZJvAoGRZu6nYkLJGbXYpf1xS/Cuzk2WMDIxVpqHwooy3ytZD5AKBQNGpkXcN5AitZ8+cY3fGmpFN/EYSY8koc7uwcDSdXxMIOe82Tl3y1OnoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837871; c=relaxed/simple;
	bh=Sb4hrVPVvzq1hoW4TbVfqh8cqn1XQy7O39pNFEmebK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCG6wptt2qngTRqeRbICpLk3Y1oBn1EVLAbogAaGmUVpxVHLoxciLFKB8rkrtjIeUGf5VCRP0A4NNsFMQsLHv4cgMC22E2GcwyZu4n73mQCCdEb0ivsUTStkF+2RY0MckqJdUEhvXzETT6UXSU8Kp7XF1q8ZsqUvMwPOAWNdv0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAMFKrZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAMFKrZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED813C2BBFC;
	Mon, 27 May 2024 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837871;
	bh=Sb4hrVPVvzq1hoW4TbVfqh8cqn1XQy7O39pNFEmebK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAMFKrZ7F1aqHQOAjXtzGPtk9LQt6KFSn4pKptJQj8sI588SjlkHZqJtp/aEDzdms
	 fn4XCQHX7xH/pJv/g7Tbn8bmszpWM34eRamjRv0LCbtE7ngBOAhO1xC05uSEvqmGhB
	 Bu/CratXWEyiZ5A8FkpKF9XzAoC6BH/Q15hBcgAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Maxime Ripard <mripard@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 126/493] ARM: configs: sunxi: Enable DRM_DW_HDMI
Date: Mon, 27 May 2024 20:52:08 +0200
Message-ID: <20240527185634.617371443@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit deff401b14e2d832b25b55862ad6c73378fe034e ]

Commit 4fc8cb47fcfd ("drm/display: Move HDMI helpers into display-helper
module") turned the DRM_DW_HDMI dependency of DRM_SUN8I_DW_HDMI into a
depends on which ended up disabling the driver in the defconfig. Make
sure it's still enabled.

Fixes: 4fc8cb47fcfd ("drm/display: Move HDMI helpers into display-helper module")
Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20240403-fix-dw-hdmi-kconfig-v1-5-afbc4a835c38@kernel.org
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/sunxi_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/sunxi_defconfig b/arch/arm/configs/sunxi_defconfig
index bddc82f789421..a83d29fed1756 100644
--- a/arch/arm/configs/sunxi_defconfig
+++ b/arch/arm/configs/sunxi_defconfig
@@ -110,6 +110,7 @@ CONFIG_DRM_PANEL_LVDS=y
 CONFIG_DRM_PANEL_SIMPLE=y
 CONFIG_DRM_PANEL_EDP=y
 CONFIG_DRM_SIMPLE_BRIDGE=y
+CONFIG_DRM_DW_HDMI=y
 CONFIG_DRM_LIMA=y
 CONFIG_FB_SIMPLE=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
-- 
2.43.0



