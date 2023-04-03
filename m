Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F93C6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA797C433EF;
	Mon,  3 Apr 2023 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531829;
	bh=Q4MYWkyT1lKDhtdpe7b6Cjgie62j0doR8iBY5OJBEHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fO1kUvJKr0hHdp0s7kEkMQhgYul/3TsPO2f2CgwOX7qnN6tICWgIMJ2SuV8Ei6740
	 4t51/z0jNV0JkAoZY3b8vGrvxcVw714xMp3MCUf36LoJ0P8kP1BC8XpDd2NQJ3/G9z
	 +pQI247gBKE0VuOMmtXJxxBLV+E0Q4KPh2kA9o3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/173] ARM: dts: imx6sl: tolino-shine2hd: fix usbotg1 pinctrl
Date: Mon,  3 Apr 2023 16:07:18 +0200
Message-Id: <20230403140415.088095150@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 1cd489e1ada1cffa56bd06fd4609f5a60a985d43 ]

usb@2184000: 'pinctrl-0' is a dependency of 'pinctrl-names'

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: 9c7016f1ca6d ("ARM: dts: imx: add devicetree for Tolino Shine 2 HD")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
index caa2796088036..0fd126db4e5db 100644
--- a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
+++ b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
@@ -580,6 +580,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
-- 
2.39.2



