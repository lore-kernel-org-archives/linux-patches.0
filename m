Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C8B196C98;
	Thu,  6 Jun 2024 14:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683204; cv=none; b=AGiwDMG2+XevlVvUzzcQwVmedPiWjuucpAiP1VyWW50XIqxWbuHQJiX9RfmT/C0iIWWbU56SP50TdExuLtoA1q7sGWwhRUnD+zKyaZ3gqYoesL4oPIZ5EDHjDIyAxI4a7XnrezRKP4ZC57bMtcXAg2J6pX+Xk3/+iZV41G2ReHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683204; c=relaxed/simple;
	bh=KILxAP2TfLCY2uDdrPcehXqnDe/2em/uOoZzQ3gLpsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozrA7/JfWLcn9P27RdQap4QEZGH0ucLEm6EeZGOrnp/4pvSiazdEou11Y2zcDSHJvrqbu/AdAJYyBV/Y87lel4pE7d6ZW71NwWdSk+bQOCaKXYUFLNwfzYB41Hplf6JrH3D1ekJnJBp9N3/EqsQMmMQq8WnCsKfNMGOTv6pZvGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bax+/Q4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bax+/Q4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E29C2BD10;
	Thu,  6 Jun 2024 14:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683204;
	bh=KILxAP2TfLCY2uDdrPcehXqnDe/2em/uOoZzQ3gLpsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bax+/Q4spHVhdQu5qapzKF8mQ+dHkaigVuUSPHXS6bQ0aLNEiGP07Wn0Qi9MOxN5x
	 mPPN2ClKWklXiZG7XPPNBlV7UMgFZV3mBhdGZzmmzL/rm7JTEDTgglS9K/qn5iIHmY
	 a++9m/7BoY8JtpvK3HzurNGeZPdCONs2bEv1fncg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Maxime Ripard <mripard@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/473] ARM: configs: sunxi: Enable DRM_DW_HDMI
Date: Thu,  6 Jun 2024 16:00:11 +0200
Message-ID: <20240606131702.621483290@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



