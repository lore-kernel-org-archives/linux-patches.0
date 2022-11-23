Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3631C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADA5C433C1;
	Wed, 23 Nov 2022 09:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196604;
	bh=WiGa33nqOWMdzvVA9pvtn8rx+TxaSrvrJsYk2aP9IEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISGJUR6EXrGwHgWVKiT1jT/Vcwh0tmtqBw+h/SId+lp5FEg9cMrTq9IAdM0HSr5a7
	 2MyG69UEJwvRsdTp4QtC751ZLOVIZL6MWM4HO9af+zDnbeLlwgGTX1Kr168SOjGdY7
	 DaWsXIfIrMYsoel4Otg7MLBBOSC2jk3THwE70zUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Brian Masney <bmasney@redhat.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 078/314] arm64: dts: qcom: sc8280xp: fix ufs_card_phy ref clock
Date: Wed, 23 Nov 2022 09:48:43 +0100
Message-Id: <20221123084629.015503060@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

[ Upstream commit 8d6b458ce6e93286a607e54f787f7a86067f58bd ]

The GCC_UFS_REF_CLKREF_CLK must be enabled or the second UFS controller
fails to enumerate on sa8295p-adp.

Note that the vendor kernel enables both GCC_UFS_REF_CLKREF_CLK and
GCC_UFS_1_CARD_CLKREF_CLK and it is possible that the former should be
modelled as a parent of the latter. The clock driver also has a
GCC_UFS_CARD_CLKREF_CLK clock which the firmware appears to enable on
the ADP.

The usual lack of documentation for Qualcomm SoCs makes this a highly
annoying guessing game, but as the second controller works on the ADP
without either card reference clock enabled, only enable
GCC_UFS_REF_CLKREF_CLK for now.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221005143305.388-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 49ea8b5612fc..92cbe84de0e5 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -959,7 +959,7 @@ ufs_card_phy: phy@1da7000 {
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_1_CARD_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_PHY_AUX_CLK>;
 
 			resets = <&ufs_card_hc 0>;
-- 
2.35.1



