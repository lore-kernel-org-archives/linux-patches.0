Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668076FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F13FC433C8;
	Sun, 17 Sep 2023 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978414;
	bh=7xFIj5EJfDh5QGMGqLIgmlVtIQvrkS+6UhH9ti5qQ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+uIwpEQZPfPiVPBNo4ZEg1vTTwpdZIJcmE0NfYWCy/zDerSDePq2k6U7fiqkE9KZ
	 8qfL5HOtq+P4gjAjlslH1ATBuXJPPDehRa+3Tez2dYd//pUqG8UoQxl0hnWt9wWJsV
	 1VwNKIEZUBFMOzSTBcOK8CoSPR4XiTkKV26gFeCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/406] ARM: dts: imx: Set default tuning step for imx7d usdhc
Date: Sun, 17 Sep 2023 21:08:01 +0200
Message-ID: <20230917191101.873285541@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit be18293e47cbca7c6acee9231fc851601d69563a ]

If the tuning step is not set, the tuning step is set to 1.
For some sd cards, the following Tuning timeout will occur.

Tuning failed, falling back to fixed sampling clock
mmc0: Tuning failed, falling back to fixed sampling clock

So set the default tuning step. This refers to the NXP vendor's
commit below:

https://github.com/nxp-imx/linux-imx/blob/lf-6.1.y/
arch/arm/boot/dts/imx7s.dtsi#L1216-L1217

Fixes: 1e336aa0c025 ("mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 2b664d457b461..854c380cccea4 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1137,6 +1137,8 @@
 					<&clks IMX7D_USDHC1_ROOT_CLK>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-step = <2>;
+				fsl,tuning-start-tap = <20>;
 				status = "disabled";
 			};
 
@@ -1149,6 +1151,8 @@
 					<&clks IMX7D_USDHC2_ROOT_CLK>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-step = <2>;
+				fsl,tuning-start-tap = <20>;
 				status = "disabled";
 			};
 
@@ -1161,6 +1165,8 @@
 					<&clks IMX7D_USDHC3_ROOT_CLK>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-step = <2>;
+				fsl,tuning-start-tap = <20>;
 				status = "disabled";
 			};
 
-- 
2.40.1



