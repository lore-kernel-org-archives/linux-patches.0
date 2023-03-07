Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9119BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C62DC433EF;
	Tue,  7 Mar 2023 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211936;
	bh=KR4Wtts8RX/4NVEphfV16f6oHlzquRdtvp/Kt+reE5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2I01+EUe8jo0bmpvdWMSDpQB7wi6njOm9KYXLVyPRfZiWlSxXjzpwkiXsS+JrvX2J
	 UwW26sO+wfVCm/3Uw1fACBr1xuKCkSoTm8b6e9jfgUWG9X52GVe3gn1quLnjIJSCP4
	 c2vhgaKbk5rDeZouo/NWNhmzs0YCzC7gP+yeyvzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/885] arm64: dts: qcom: sc8280xp: Vote for CX in USB controllers
Date: Tue,  7 Mar 2023 17:49:18 +0100
Message-Id: <20230307170002.698841193@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit fe07640280cd29ac2997a617a1fb5487feef9387 ]

Running GCC_USB30_*_MASTER_CLK at 200MHz requires CX at nominal level,
not doing so results in occasional lockups. This was previously hidden
by the fact that the display stack incorrectly voted for CX (instead of
MMCX).

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230112135117.3836655-1-quic_bjorande@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1287,6 +1287,7 @@
 					  "ss_phy_irq";
 
 			power-domains = <&gcc USB30_PRIM_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_USB30_PRIM_BCR>;
 
@@ -1341,6 +1342,7 @@
 					  "ss_phy_irq";
 
 			power-domains = <&gcc USB30_SEC_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_USB30_SEC_BCR>;
 


