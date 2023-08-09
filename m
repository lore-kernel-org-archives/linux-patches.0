Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D21517AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5DCC433C7;
	Wed,  9 Aug 2023 11:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580359;
	bh=cYaSP2DfhiFv8EgyERl99h2EsgBV+APSYi2fASBmTpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHTmMNos8fFsjEcyktNVN8P/c/hrYqD1+LoJhmU2GSNcd0nxRoxIfoeoNGbqZBYXm
	 h+gK2B4VAU+7Cwq74lX8iHnT/hf1NabP8wjQhKFpeTRuFXOufSAkyIIoj1V7ZTUzWM
	 l+5/R9hahEM+XgXAoq/mMp9rdS28Uz7L4jXBke+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 320/323] ARM: dts: imx6sll: fixup of operating points
Date: Wed,  9 Aug 2023 12:42:38 +0200
Message-ID: <20230809103712.722459687@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 1875903019ea6e32e6e544c1631b119e4fd60b20 ]

Make operating point definitions comply with binding
specifications.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: ee70b908f77a ("ARM: dts: nxp/imx6sll: fix wrong property name in usbphy node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sll.dtsi | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index b519ab87c4596..164836fe63cc2 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -51,20 +51,18 @@ cpu0: cpu@0 {
 			device_type = "cpu";
 			reg = <0>;
 			next-level-cache = <&L2>;
-			operating-points = <
+			operating-points =
 				/* kHz    uV */
-				996000  1275000
-				792000  1175000
-				396000  1075000
-				198000	975000
-			>;
-			fsl,soc-operating-points = <
+				<996000  1275000>,
+				<792000  1175000>,
+				<396000  1075000>,
+				<198000	  975000>;
+			fsl,soc-operating-points =
 				/* ARM kHz      SOC-PU uV */
-				996000          1175000
-				792000          1175000
-				396000          1175000
-				198000		1175000
-			>;
+				<996000         1175000>,
+				<792000         1175000>,
+				<396000         1175000>,
+				<198000		1175000>;
 			clock-latency = <61036>; /* two CLK32 periods */
 			clocks = <&clks IMX6SLL_CLK_ARM>,
 				 <&clks IMX6SLL_CLK_PLL2_PFD2>,
-- 
2.40.1



