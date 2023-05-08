Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6534811CA1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68E8C433D2;
	Mon,  8 May 2023 11:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543794;
	bh=B/ReKX88RM0PtQZM1w8RndsuF/jF2Qt+kHQrX7M+pEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hESpOMmErYuvEK+HPmELdbM71vKynjy547VoRfNJ4P+VnuZyeGwmMfRSKCPiT7+ex
	 Z2RRnCyMSGTUFl7OijfjWUFKpMOB+wczF5+RhA5kGkBel1KxNQZXllMmedaLeygpcJ
	 dnTBJqvl+TrqulKdqRJtvCp8uZG7hWKxJmCCL+m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 203/694] arm64: dts: qcom: sc8280xp: fix external display power domain
Date: Mon,  8 May 2023 11:40:38 +0200
Message-Id: <20230508094438.977528680@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit cf386126aef92256245adc8be686f2df4b837013 ]

Fix the external display controller nodes which erroneously described
the controllers as belonging to CX rather than MMCX.

Fixes: 19d3bb90754f ("arm64: dts: qcom: sc8280xp: Add USB-C-related DP blocks")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230316141252.2436-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 60433c810f23f..80401834bb063 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -3253,7 +3253,7 @@
 				#sound-dai-cells = <0>;
 
 				operating-points-v2 = <&mdss0_dp0_opp_table>;
-				power-domains = <&rpmhpd SC8280XP_CX>;
+				power-domains = <&rpmhpd SC8280XP_MMCX>;
 
 				status = "disabled";
 
@@ -3331,7 +3331,7 @@
 				#sound-dai-cells = <0>;
 
 				operating-points-v2 = <&mdss0_dp1_opp_table>;
-				power-domains = <&rpmhpd SC8280XP_CX>;
+				power-domains = <&rpmhpd SC8280XP_MMCX>;
 
 				status = "disabled";
 
-- 
2.39.2



