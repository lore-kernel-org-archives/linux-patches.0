Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB48BA47;
	Mon, 28 Oct 2024 06:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097960; cv=none; b=qRUGnjiTUWcMZZlOB7DEbF4f9OAxXVncyJ7dQjKCoBLpg+JZ/adsehJXQIfY8YZMiRnofme3AI6ejkK90XvxXI1mZYf2YdHO7zQ381NlW997CeyCxyjt89mAGHut3gO33xxSMMsYWiMkJImuAx/Gm5Utd3/YNPe9Fqa407BoZeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097960; c=relaxed/simple;
	bh=3NXZAmOy1J3+nhYFBV1pNHu00WMFYlXhluiIA1dQbxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IavMjMWS9Lz+5qSQNj13fxP9OgBnucQ7ra5vjWwmCZt/evXkDr1L1Gh4ZQcf1LgBdto9/SwSvnuEaZpnUWcXB/SxJEarTbDDJxo2Sm7uf2DSRQFFxB8JXD5c5FKviJXzw6gxLOKgFnpT0GxHK0mgq7/CQOZTxrBYu+lBRMCaIuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aw+QPyP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aw+QPyP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B42C4CEC3;
	Mon, 28 Oct 2024 06:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097960;
	bh=3NXZAmOy1J3+nhYFBV1pNHu00WMFYlXhluiIA1dQbxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aw+QPyP8tL59mhK1qK7oNO9JfMNPHSfXSc5tfBiwKryruaju2Q3PX7isYFoiRisNb
	 ej1UrHwDIk6hf54OtwI9bqABMbWmALxn8naeLEJxj0NftN5aK+NlNExr/8WNFqkXnh
	 303NoTMoaR2sHuXsHzfWfvGr5qL7BmB8mZA6rDEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Klink <flokli@flokli.de>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 016/261] ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin
Date: Mon, 28 Oct 2024 07:22:38 +0100
Message-ID: <20241028062312.419412679@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Klink <flokli@flokli.de>

[ Upstream commit dc7785e4723510616d776862ddb4c08857a1bdb2 ]

HDMI_HPD_N_1V8 is connected to GPIO pin 0, not 1.

This fixes HDMI hotplug/output detection.

See https://datasheets.raspberrypi.com/cm/cm3-schematics.pdf

Signed-off-by: Florian Klink <flokli@flokli.de>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20240715230311.685641-1-flokli@flokli.de
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Fixes: a54fe8a6cf66 ("ARM: dts: add Raspberry Pi Compute Module 3 and IO board")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts b/arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
index 72d26d130efaa..85f54fa595aa8 100644
--- a/arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
+++ b/arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts
@@ -77,7 +77,7 @@
 };
 
 &hdmi {
-	hpd-gpios = <&expgpio 1 GPIO_ACTIVE_LOW>;
+	hpd-gpios = <&expgpio 0 GPIO_ACTIVE_LOW>;
 	power-domains = <&power RPI_POWER_DOMAIN_HDMI>;
 	status = "okay";
 };
-- 
2.43.0



