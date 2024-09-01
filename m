Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9368D28387;
	Sun,  1 Sep 2024 16:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208144; cv=none; b=QYrcMJQ9IHO4koTwLSdoCvFh/LWTJN5QpegJrL7o5ZMDpB1Kt/iqKVerdnt5l+WOmr0EeRvE2b/9nFkSDu3fxBLcOOTxIDIO/HhFGM8zNqqfZbTYHRxiJYCNTeqBcbuK+tCCRILI6+hIZ3+ud9D5Sr4yjrSL7WsiXrCFj2fslQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208144; c=relaxed/simple;
	bh=zt/uuSzGQ/7o84j2dxSqDFEXkCs06L2mZEmf2xAcQz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTQVOVtskTVfHA6UbTZm1FdEtKrSHiKTepg9BLQtQLS8BxHrasQFOsBY59PoySBqmqcIPOZkrpDwjv6b9t6y4D9yZ//7k1npOmYBW1cZRCnUkkxMTy1ETENa9FRGo2j+9KpoMLAyl4BTBYxhZbSXzyrpUp1eTjVC8BWZyEvlqbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fA/aMN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fA/aMN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63CEC4CEC3;
	Sun,  1 Sep 2024 16:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208144;
	bh=zt/uuSzGQ/7o84j2dxSqDFEXkCs06L2mZEmf2xAcQz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fA/aMN4gNWrZ4LlDlpe/mALz0QsZkdPTZ8iBJVtFf2qpz+/2KGoHE37HS2gfDZZH
	 W6fQX5WhrRFsJGOReUP3pE36mQOAtpA4VHKvGFWJzdQ+lB6QUSxj0kKIajRtv+zKo4
	 t5LCF5X5CVd6Ls5PeElvQkyO5DTiebdULJmqiCEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 86/93] arm64: dts: imx8mp-beacon-kit: Fix Stereo Audio on WM8962
Date: Sun,  1 Sep 2024 18:17:13 +0200
Message-ID: <20240901160810.972078530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index acd265d8b58ed..e094f409028dd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts
@@ -163,13 +163,12 @@
 
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
@@ -381,10 +380,9 @@
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



