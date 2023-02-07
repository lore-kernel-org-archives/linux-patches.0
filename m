Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9826E28E7
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F034C433D2;
	Tue,  7 Feb 2023 12:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774744;
	bh=dCoBYjpxtCIQuvMBOX58QUxAXYRwvFahDHUMUiem8tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv8CmS4jE4f1R2a/s0VWzlbklObjJNobtE9+AWFp/XnCqbmrVzYD5eISlRO/6roed
	 Fpdcqndg6DifM+U3pkQKMlIeYmkYvxNKm9XV8dDheego+xC8EG07OtOwOTX49eyX3D
	 A545mexj7tDul1suwU2JVzoKGeIHytYEtvm2AyoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/208] arm64: dts: freescale: imx8dxl: fix sc_pwrkeys property name linux,keycode
Date: Tue,  7 Feb 2023 13:54:18 +0100
Message-Id: <20230207125634.524261181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit cfb47bf5a470bdd80e8ac2f7b2f3a34563ecd4ea ]

linux,keycode should be "linux,keycodes" according binding-doc
Documentation/devicetree/bindings/input/fsl,scu-key.yaml

Fixes: f537ee7f1e76 ("arm64: dts: freescale: add i.MX8DXL SoC support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
index 5ddbda0b4def..f2c4d13b2f3c 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8dxl.dtsi
@@ -157,7 +157,7 @@
 
 		sc_pwrkey: keys {
 			compatible = "fsl,imx8qxp-sc-key", "fsl,imx-sc-key";
-			linux,keycode = <KEY_POWER>;
+			linux,keycodes = <KEY_POWER>;
 			wakeup-source;
 		};
 
-- 
2.39.0



