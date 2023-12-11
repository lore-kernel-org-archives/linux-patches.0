Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B27B41740;
	Mon, 11 Dec 2023 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgRHVGAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBB9C433C8;
	Mon, 11 Dec 2023 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319420;
	bh=QgGDbkc3twquDtVXjG7JFw6d64MENH3ZHQ9StQBclvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgRHVGAoQ+gR+Lv4GP30lNkDrWDeyur8LMCtiU0uRenvI5BgNfmbCmy9JFlrj43kH
	 tHMqviyrKg067Bod/3KssEy66FDOayCaeAYQik4NnlZKZUlJ/LJPWbfeybL81OAG8t
	 xSSwZGSjhHfj3il8RIWebL5KJgKERLODhp5uHU3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/244] ARM: dts: bcm2711-rpi-400: Fix delete-node of led_act
Date: Mon, 11 Dec 2023 19:19:51 +0100
Message-ID: <20231211182050.164948606@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit dc761f11af2e39119d3a7942e3d10615f3d900e7 ]

The LED ACT which is included from bcm2711-rpi-4-b doesn't exists
on the Raspberry Pi 400. So the bcm2711-rpi-400.dts tries to
use the delete-node directive in order to remove the complete
node. Unfortunately the usage get broken in commit 1156e3a78bcc
("ARM: dts: bcm283x: Move ACT LED into separate dtsi")
and now ACT and PWR LED using the same GPIO and this prevent
probing of led-gpios on Raspberry Pi 400:

    leds-gpio: probe of leds failed with error -16

So fix the delete-node directive.

Fixes: 1156e3a78bcc ("ARM: dts: bcm283x: Move ACT LED into separate dtsi")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20231118124252.14838-3-wahrenst@gmx.net
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm2711-rpi-400.dts | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm2711-rpi-400.dts b/arch/arm/boot/dts/broadcom/bcm2711-rpi-400.dts
index 1ab8184302db4..5a2869a18bd55 100644
--- a/arch/arm/boot/dts/broadcom/bcm2711-rpi-400.dts
+++ b/arch/arm/boot/dts/broadcom/bcm2711-rpi-400.dts
@@ -36,9 +36,7 @@
 	gpios = <&gpio 42 GPIO_ACTIVE_HIGH>;
 };
 
-&leds {
-	/delete-node/ led_act;
-};
+/delete-node/ &led_act;
 
 &pm {
 	/delete-property/ system-power-controller;
-- 
2.42.0



