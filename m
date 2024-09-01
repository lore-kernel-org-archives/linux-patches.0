Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F3B1C68C;
	Sun,  1 Sep 2024 16:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208633; cv=none; b=IB2KMczkz2z8zTQuBAzPZe4kQOFz9QYwctH4kDANiijnt3dVa8R/yXQ+E+Yj16/v2A46zcWdbFmHyq8HPHbsZb/16g/mdoXp0/me3DNDgXHVPKSiuRkSFwZiSe0CTMX/rDIaiSSr3M3ZJ/F0PTpUsXn49DbJARfFHlX2spbDy4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208633; c=relaxed/simple;
	bh=XHsMSZr3KlPLIfSKh78Ci4cc8WrTor00O74lvL/5J9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKF0numKVVnmuQ2W6eVn4J4hBDgD4HdsfMMh3d/efyQ3qoqzivlgaUGOo3kc+t1YThF9CQvDuj6AcNVl7p1Ez1qiA5hahZLB1I56L0JzjJKnk7PxJ8mtaLYfrkV1DzMadYLph3EZWlwUNCDiyMvjt+aB3M0A/Q0IGXExdX+iqsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdJqO5+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdJqO5+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0985EC4CEC3;
	Sun,  1 Sep 2024 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208633;
	bh=XHsMSZr3KlPLIfSKh78Ci4cc8WrTor00O74lvL/5J9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdJqO5+rOlbBXwbORwjVWWQMjV1oVtrEhOynkzRTvCeHgMmpVGt6qrdDFJgZ/URXx
	 /qgdgVyD3tgQAXP7zVpTG6goMXp4JSpbQRhMIgOPCTF+bkeEox/QXGkddzTygpxxCn
	 k/DzsgmZTbmtZq9sZgLKd/kcQcKB2pcgNixAvGoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 142/149] arm64: dts: imx8mp-beacon-kit: Fix Stereo Audio on WM8962
Date: Sun,  1 Sep 2024 18:17:33 +0200
Message-ID: <20240901160822.787153794@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 4e69cd835a2d5c3915838491f59a68ee697a87d0 ]

The L/R clock needs to be controlled by the SAI3 instead of the
CODEC to properly achieve stereo sound. Doing this allows removes
the need for unnecessary clock manipulation to try to get the
CODEC's clock in sync with the SAI3 clock, since the CODEC can cope
with a wide variety of clock inputs.

Fixes: 161af16c18f3 ("arm64: dts: imx8mp-beacon-kit: Fix audio_pll2 clock")
Fixes: 69e2f37a6ddc ("arm64: dts: imx8mp-beacon-kit: Enable WM8962 Audio CODEC")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts b/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts
index e5d3901f29136..e1f59bdcae497 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts
@@ -211,13 +211,12 @@
 
 		simple-audio-card,cpu {
 			sound-dai = <&sai3>;
+			frame-master;
+			bitclock-master;
 		};
 
 		simple-audio-card,codec {
 			sound-dai = <&wm8962>;
-			clocks = <&clk IMX8MP_CLK_IPP_DO_CLKO1>;
-			frame-master;
-			bitclock-master;
 		};
 	};
 };
@@ -499,10 +498,9 @@
 &sai3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_sai3>;
-	assigned-clocks = <&clk IMX8MP_CLK_SAI3>,
-			  <&clk IMX8MP_AUDIO_PLL2> ;
-	assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL2_OUT>;
-	assigned-clock-rates = <12288000>, <361267200>;
+	assigned-clocks = <&clk IMX8MP_CLK_SAI3>;
+	assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL1_OUT>;
+	assigned-clock-rates = <12288000>;
 	fsl,sai-mclk-direction-output;
 	status = "okay";
 };
-- 
2.43.0



