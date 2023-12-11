Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FCD321B8;
	Mon, 11 Dec 2023 18:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfKVJPAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D136C433C8;
	Mon, 11 Dec 2023 18:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321067;
	bh=BYdlKJIyTW66eYRiiBTe2LxbqBB9+Ai5XGAIGPZGJBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfKVJPAsmbxsD6RUoa9mgfzmgw9C+1KKOH2lLoV5/KSn6VKvdraqiFO1Ky65MAD3t
	 lvuq8FVQI+4zwX+EayY0lJQB+dffqzpUO0zXvu5ABNw628JKPZQp+ctS14cM9cy1PO
	 gKbrG3WI3aLQvltATh4y1URO9UVDeGtN/d5I7DxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/141] ARM: dts: imx6ul-pico: Describe the Ethernet PHY clock
Date: Mon, 11 Dec 2023 19:22:06 +0100
Message-ID: <20231211182029.460430466@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit d951f8f5f23a9417b7952f22b33784c73caa1ebb ]

Since commit c7e73b5051d6 ("ARM: imx: mach-imx6ul: remove 14x14 EVK
specific PHY fixup")thet Ethernet PHY is no longer configured via code
in board file.

This caused Ethernet to stop working.

Fix this problem by describing the clocks and clock-names to the
Ethernet PHY node so that the KSZ8081 chip can be clocked correctly.

Fixes: c7e73b5051d6 ("ARM: imx: mach-imx6ul: remove 14x14 EVK specific PHY fixup")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-pico.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6ul-pico.dtsi b/arch/arm/boot/dts/imx6ul-pico.dtsi
index 357ffb2f5ad61..dd6790852b0d6 100644
--- a/arch/arm/boot/dts/imx6ul-pico.dtsi
+++ b/arch/arm/boot/dts/imx6ul-pico.dtsi
@@ -121,6 +121,8 @@
 			max-speed = <100>;
 			interrupt-parent = <&gpio5>;
 			interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&clks IMX6UL_CLK_ENET_REF>;
+			clock-names = "rmii-ref";
 		};
 	};
 };
-- 
2.42.0



