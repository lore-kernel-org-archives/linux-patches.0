Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB19979C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D231C433D7;
	Wed, 30 Nov 2022 18:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833387;
	bh=g2WIqdFXdE5EjQDyff6iGvwtakaJ+ICMwIn4XY8FVrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYKFlvBVxaKhREXdeONcNfMkANQ30HascNWFG9ywvJVmweKMHOblj2nkwx8B2+Hmi
	 uZj/UBEa8n3M0MJ8ZQdszomjXa1hFp60LZ5pxYlJ3fi663YczEUQuOLrKv6f/yxNwg
	 zOVCqUAlWSQf4YLJy+1CtlYaiZWxUazdYj9avgQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/206] ARM: dts: imx6q-prti6q: Fix ref/tcxo-clock-frequency properties
Date: Wed, 30 Nov 2022 19:22:20 +0100
Message-Id: <20221130180535.249555745@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit e68be7b39f21d8a9291a5a3019787cd3ca999dd7 ]

make dtbs_check gives the following errors:

ref-clock-frequency: size (9) error for type uint32
tcxo-clock-frequency: size (9) error for type uint32

Fix it by passing the frequencies inside < > as documented in
Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml.

Signed-off-by: Fabio Estevam <festevam@denx.de>
Fixes: 0d446a505592 ("ARM: dts: add Protonic PRTI6Q board")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-prti6q.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-prti6q.dts b/arch/arm/boot/dts/imx6q-prti6q.dts
index b4605edfd2ab..d8fa83effd63 100644
--- a/arch/arm/boot/dts/imx6q-prti6q.dts
+++ b/arch/arm/boot/dts/imx6q-prti6q.dts
@@ -364,8 +364,8 @@ wifi {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_wifi>;
 		interrupts-extended = <&gpio1 30 IRQ_TYPE_LEVEL_HIGH>;
-		ref-clock-frequency = "38400000";
-		tcxo-clock-frequency = "19200000";
+		ref-clock-frequency = <38400000>;
+		tcxo-clock-frequency = <19200000>;
 	};
 };
 
-- 
2.35.1



