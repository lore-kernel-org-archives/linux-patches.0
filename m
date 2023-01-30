Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B9328EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AAAC433D2;
	Mon, 30 Jan 2023 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086931;
	bh=K3yiNmnkXwN4HW6GU7KXho3/PS4j7sWEwJp7DDr2oF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0MxCQFJf2DbZOZ74HxaRtV62LxfKkwcivTUirAYGZgJihdXH3BY7cE/5X/9W4LoK
	 KrWDtpxOGBaysaOlHH53WW6n3TEL9FInB7ORrFfcvEm8xL0e+7zz+XMCe1HgLtHxhe
	 kTUcFG/H3pn/hi1QFrHdlNt0PiHAEkumBpYBF0cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/313] arm64: dts: qcom: sc8280xp: fix primary USB-DP PHY reset
Date: Mon, 30 Jan 2023 14:47:19 +0100
Message-Id: <20230130134336.749273867@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit ee4e530bdde29a69c58656a919545251a782674e ]

The vendor kernel is using the GCC_USB4_DP_PHY_PRIM_BCR and
GCC_USB4_1_DP_PHY_PRIM_BCR resets for the USB4-USB3-DP QMP PHYs.

Update the primary USB-DP PHY node to match.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221121085058.31213-15-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 9f2a136d5cbc..146a4285c395 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1173,7 +1173,7 @@ usb_0_qmpphy: phy-wrapper@88ec000 {
 			clock-names = "aux", "ref_clk_src", "ref", "com_aux";
 
 			resets = <&gcc GCC_USB3_PHY_PRIM_BCR>,
-				 <&gcc GCC_USB3_DP_PHY_PRIM_BCR>;
+				 <&gcc GCC_USB4_DP_PHY_PRIM_BCR>;
 			reset-names = "phy", "common";
 
 			power-domains = <&gcc USB30_PRIM_GDSC>;
-- 
2.39.0



