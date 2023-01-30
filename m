Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBA528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D81C433EF;
	Mon, 30 Jan 2023 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086916;
	bh=3ba9il19a7JA91ZLcQKFLSWjcAp+9FW/xRFkQVBV0aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=er5Xbs8BToS7hARwONDbBSDoqr59OgsdHMyyKgiVfSsy+lbhYPaXTxXDL2Sa/Himc
	 LryaLoud+Oj3bXgUrdOXT/rmowYRA2z6frXBCC93JSVoa4hQStacfuWDrV3psSNruR
	 uHh5+x5BySRYDvMmc6crT+HiGS+fQBSvg1ZlMR5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/313] ARM: dts: imx6ul-pico-dwarf: Use clock-frequency
Date: Mon, 30 Jan 2023 14:47:24 +0100
Message-Id: <20230130134337.094222233@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 94e2cf1e0db5b06c7a6ae0878c5cbec925819a8a ]

'clock_frequency' is not a valid property.

Use the correct 'clock-frequency' instead.

Fixes: 47246fafef84 ("ARM: dts: imx6ul-pico: Add support for the dwarf baseboard")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-pico-dwarf.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul-pico-dwarf.dts b/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
index 162dc259edc8..5a74c7f68eb6 100644
--- a/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
+++ b/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
@@ -32,7 +32,7 @@ sys_mclk: clock-sys-mclk {
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
-- 
2.39.0



