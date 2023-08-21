Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFEF11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA7BC433C7;
	Mon, 21 Aug 2023 19:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647796;
	bh=9GFseNURY6Jlq6FDHxAejCEZE1twpkrLSlYzNVziqv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAEqxKOKkOYv0Joytyo5Hf0/gPdaqtmgMRWtfOFsHbkFGhdhfK/ZFjRIyIs/PPxPY
	 8mP1wOiHc0vtjK6CPaY3ZLrwzg6dXGGt74/noI7WWaEZqdGZwikxaQz4E9k0O88gY+
	 WElvj8H1s0vMegpY2xdvT0kXCi9Yl7UGwOxU/T9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/194] ARM: dts: imx: Set default tuning step for imx6sx usdhc
Date: Mon, 21 Aug 2023 21:42:01 +0200
Message-ID: <20230821194128.937308566@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 0a2b96e42a0284c4fc03022236f656a085ca714a ]

If the tuning step is not set, the tuning step is set to 1.
For some sd cards, the following Tuning timeout will occur.

Tuning failed, falling back to fixed sampling clock

So set the default tuning step. This refers to the NXP vendor's
commit below:

https://github.com/nxp-imx/linux-imx/blob/lf-6.1.y/
arch/arm/boot/dts/imx6sx.dtsi#L1108-L1109

Fixes: 1e336aa0c025 ("mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index abc3572d699e6..1f1053a898fbf 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -981,6 +981,8 @@
 					 <&clks IMX6SX_CLK_USDHC1>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-start-tap = <20>;
+				fsl,tuning-step= <2>;
 				status = "disabled";
 			};
 
@@ -993,6 +995,8 @@
 					 <&clks IMX6SX_CLK_USDHC2>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-start-tap = <20>;
+				fsl,tuning-step= <2>;
 				status = "disabled";
 			};
 
@@ -1005,6 +1009,8 @@
 					 <&clks IMX6SX_CLK_USDHC3>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-start-tap = <20>;
+				fsl,tuning-step= <2>;
 				status = "disabled";
 			};
 
-- 
2.40.1



