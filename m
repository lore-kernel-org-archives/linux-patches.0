Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A071991CE;
	Thu,  6 Jun 2024 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683164; cv=none; b=Q3mhOI92sRZyh/MyDsT0O8gJDaoCU/Ay+YZ18st9toT2+5iKsbLhJCjWLyyHU/Y+xjKKROLjZbWZMjozh6uAZGYk+mWdpyk6md/MHUkJfMEFBj6MUksMKLV0yzPo3tQCKlqf587kJcpgP6EhkV9J+RmbB3UWViWVTec+byFUiPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683164; c=relaxed/simple;
	bh=QexsfiIlW/iLfEskw6pcTAG0B9yFctLFdP4SwfqbGmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upV8YszH2FelPbr7V6gbr1eOZK8kKDtcfqUW3KjHPesBUXuYgoKarF/t/z4d1t49RNMlb2UNoR2gfMQHs6h9Ypu+XEjmX+vpgw0uBAS7L9nCqFot/v69l/me5HEP2TnID6XZggAZ/L8P1WsaT/spXuMLlW7xVPoZApCZhCPf630=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gdo7SKJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gdo7SKJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327C0C32781;
	Thu,  6 Jun 2024 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683164;
	bh=QexsfiIlW/iLfEskw6pcTAG0B9yFctLFdP4SwfqbGmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gdo7SKJJCX4akXWv/T4DhEJ2Q+mwLVkfjIbZb97bdZ1jey/tQWwY3lCBdQIy5pclr
	 +FOJuYbRj1Eq66zW/CEDjy9g3xM73jScUzljIdjtOvKOUNOoR6iadPD4FJh8Mb+sKM
	 ZacS7fUPANQyVGCo1JWX6V0uJrTdTucK7EHfHy4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Maxime Ripard <mripard@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/744] ARM: configs: sunxi: Enable DRM_DW_HDMI
Date: Thu,  6 Jun 2024 15:56:20 +0200
Message-ID: <20240606131735.864190373@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



