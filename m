Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A611D1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25295C433C9;
	Mon, 21 Aug 2023 20:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648573;
	bh=TIFmacErtkdGo8Q6ZjqysLcFmM67zi5bmtSzjFEbY4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z48PNKLE9T0yM9hExfhdVMiRYlunrRqYciiUfriwzhbPi//hOVWWVisBkcEcA8LEN
	 aJmNmNxTsmIgEGZNBB0Bl6qj/kBvICwQ5lVAcVBlIPZWNxgYfYyz0GmWnGkQcY0g2k
	 oep6+RjyVKI2I2/40Y4TAH8aFKDZ+DDxfiIAVTS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrej Picej <andrej.picej@norik.com>,
	=?UTF-8?q?Stefan=20Riedm=C3=BCller?= <s.riedmueller@phytec.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 184/234] ARM: dts: imx6: phytec: fix RTC interrupt level
Date: Mon, 21 Aug 2023 21:42:27 +0200
Message-ID: <20230821194136.979902200@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrej Picej <andrej.picej@norik.com>

[ Upstream commit 762b700982a1e0f562184363f19860c3b9bdd0bf ]

RTC interrupt level should be set to "LOW". This was revealed by the
introduction of commit:

  f181987ef477 ("rtc: m41t80: use IRQ flags obtained from fwnode")

which changed the way IRQ type is obtained.

Signed-off-by: Andrej Picej <andrej.picej@norik.com>
Reviewed-by: Stefan Riedmüller <s.riedmueller@phytec.de>
Fixes: 800d595151bb ("ARM: dts: imx6: Add initial support for phyBOARD-Mira")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-phytec-mira.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-phytec-mira.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-mira.dtsi
index 1a599c294ab86..1ca4d219609f6 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-mira.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-mira.dtsi
@@ -182,7 +182,7 @@
 		pinctrl-0 = <&pinctrl_rtc_int>;
 		reg = <0x68>;
 		interrupt-parent = <&gpio7>;
-		interrupts = <8 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
 		status = "disabled";
 	};
 };
-- 
2.40.1



