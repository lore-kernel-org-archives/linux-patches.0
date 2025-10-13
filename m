Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF66274669;
	Mon, 13 Oct 2025 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369055; cv=none; b=UUR8ObDSiU9FmhL90j9GfeyFhnQw7cRoS9kPuJZTOlH0FTUGMH8EtU7UpM/b9LrT02zzTf3HcAZNVPJHNS78GxJLdW0y4D+OxJHCEMIF2otE/nnNTcYA/ugRfqlW2LepBBYiJiSGHjcuPWh0KHRe25G/KAvKc8pkQWmFeR/SOP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369055; c=relaxed/simple;
	bh=kmqBNyz4A93wTLrcbXC5DaCpgWxXRlDa2sthNMsBGyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKF67xYv5Re7DKwQmTrUHkcpSQ9qkRPDTy6gY0+hovtQC4Fy+cqe1+fak/RYMli/h58lUW3ulDbSLKAF++OTtrycS0eVNbRWnGS0hcT7E9ZEBWd1uytiXDjZg6F6JYTfhA9kUDSCUZuWQUCCOLsHUF3jMdECYc8CzDJVPO6b3aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fObBx4lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fObBx4lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF6BC4CEE7;
	Mon, 13 Oct 2025 15:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369055;
	bh=kmqBNyz4A93wTLrcbXC5DaCpgWxXRlDa2sthNMsBGyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fObBx4ltGNG7duiwhNZV2v3lFnnfiCtiuZTL6vy9kKHP5rF0BflzBsqc0lo8qJ+FL
	 IAG4fuC3ePXjhB4hVhZu8A2Wng7b+dZRJANZ1TMjf5JYZFDpysY7qzb0XIsnzCIQqh
	 avBAU+ESE82kyMN7LEKJB3Bw0DzF7Dw7IXAKKGrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 112/563] arm64: dts: mediatek: mt8183: Fix out of range pull values
Date: Mon, 13 Oct 2025 16:39:33 +0200
Message-ID: <20251013144415.354411237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 0aeb7ed4bcb244862a35f880053cd64d28c6fb04 ]

A value of 10 is not valid for "mediatek,pull-down-adv" and
"mediatek,pull-up-adv" properties which have defined values of 0-3. It
appears the "10" was written as a binary value. The driver only looks at
the lowest 2 bits, so the value "10" decimal works out the same as if
"2" was used.

Fixes: cd894e274b74 ("arm64: dts: mt8183: Add krane-sku176 board")
Fixes: 19b6403f1e2a ("arm64: dts: mt8183: add mt8183 pumpkin board")
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250722171152.58923-2-robh@kernel.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi  | 14 +++++++-------
 arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts | 14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index 400c61d110356..fff93e26eb760 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -580,7 +580,7 @@ pins-cmd-dat {
 		pins-clk {
 			pinmux = <PINMUX_GPIO124__FUNC_MSDC0_CLK>;
 			drive-strength = <MTK_DRIVE_14mA>;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 		};
 
 		pins-rst {
@@ -609,13 +609,13 @@ pins-cmd-dat {
 		pins-clk {
 			pinmux = <PINMUX_GPIO124__FUNC_MSDC0_CLK>;
 			drive-strength = <MTK_DRIVE_14mA>;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 		};
 
 		pins-ds {
 			pinmux = <PINMUX_GPIO131__FUNC_MSDC0_DSL>;
 			drive-strength = <MTK_DRIVE_14mA>;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 		};
 
 		pins-rst {
@@ -633,13 +633,13 @@ pins-cmd-dat {
 				 <PINMUX_GPIO33__FUNC_MSDC1_DAT2>,
 				 <PINMUX_GPIO30__FUNC_MSDC1_DAT3>;
 			input-enable;
-			mediatek,pull-up-adv = <10>;
+			mediatek,pull-up-adv = <2>;
 		};
 
 		pins-clk {
 			pinmux = <PINMUX_GPIO29__FUNC_MSDC1_CLK>;
 			input-enable;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 		};
 	};
 
@@ -652,13 +652,13 @@ pins-cmd-dat {
 				 <PINMUX_GPIO30__FUNC_MSDC1_DAT3>;
 			drive-strength = <6>;
 			input-enable;
-			mediatek,pull-up-adv = <10>;
+			mediatek,pull-up-adv = <2>;
 		};
 
 		pins-clk {
 			pinmux = <PINMUX_GPIO29__FUNC_MSDC1_CLK>;
 			drive-strength = <8>;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 			input-enable;
 		};
 	};
diff --git a/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts b/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts
index dbdee604edab4..7c3010889ae73 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts
@@ -324,7 +324,7 @@ pins_cmd_dat {
 		pins_clk {
 			pinmux = <PINMUX_GPIO124__FUNC_MSDC0_CLK>;
 			drive-strength = <MTK_DRIVE_14mA>;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 		};
 
 		pins_rst {
@@ -353,13 +353,13 @@ pins_cmd_dat {
 		pins_clk {
 			pinmux = <PINMUX_GPIO124__FUNC_MSDC0_CLK>;
 			drive-strength = <MTK_DRIVE_14mA>;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 		};
 
 		pins_ds {
 			pinmux = <PINMUX_GPIO131__FUNC_MSDC0_DSL>;
 			drive-strength = <MTK_DRIVE_14mA>;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 		};
 
 		pins_rst {
@@ -377,13 +377,13 @@ pins_cmd_dat {
 				 <PINMUX_GPIO33__FUNC_MSDC1_DAT2>,
 				 <PINMUX_GPIO30__FUNC_MSDC1_DAT3>;
 			input-enable;
-			mediatek,pull-up-adv = <10>;
+			mediatek,pull-up-adv = <2>;
 		};
 
 		pins_clk {
 			pinmux = <PINMUX_GPIO29__FUNC_MSDC1_CLK>;
 			input-enable;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 		};
 
 		pins_pmu {
@@ -401,13 +401,13 @@ pins_cmd_dat {
 				 <PINMUX_GPIO30__FUNC_MSDC1_DAT3>;
 			drive-strength = <6>;
 			input-enable;
-			mediatek,pull-up-adv = <10>;
+			mediatek,pull-up-adv = <2>;
 		};
 
 		pins_clk {
 			pinmux = <PINMUX_GPIO29__FUNC_MSDC1_CLK>;
 			drive-strength = <8>;
-			mediatek,pull-down-adv = <10>;
+			mediatek,pull-down-adv = <2>;
 			input-enable;
 		};
 	};
-- 
2.51.0



