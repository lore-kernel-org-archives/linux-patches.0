Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D481863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B9CC433D2;
	Wed, 28 Dec 2022 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239493;
	bh=PJWZcfOsEMmvedelveXm8G+SS9VZuYnXoioqc5fHs5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+43/EBTf10C4A7Swkq/A0nM2h8/K0aQmAeJ5gnu5MiM+cozmT94iyWi9fzRVN9Ea
	 ewjoYujkyCCbVgy19TeLA/8zSRwjqDBCYUdghlkBogxr2Bdct5y+kQVXVSkwaqkmZh
	 WqtY7TylybUz/LBTu7af10rmeAyu7ifJ3GSWFZfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0039/1073] arm64: dts: qcom: sm6350: drop bogus DP PHY clock
Date: Wed, 28 Dec 2022 15:27:07 +0100
Message-Id: <20221228144329.191164054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 95fade4016cbd57ee050ab226c8f0483af1753c4 ]

The QMP pipe clock is used by the USB part of the PHY so drop the
corresponding properties from the DP child node.

Fixes: 23737b9557fe ("arm64: dts: qcom: sm6350: Add USB1 nodes")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221026152511.9661-3-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index d06aefdf3d9e..ec64b6a12e20 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1011,9 +1011,6 @@ dp_phy: dp-phy@88ea200 {
 				      <0 0x088eaa00 0 0x100>;
 				#phy-cells = <0>;
 				#clock-cells = <1>;
-				clocks = <&gcc GCC_USB3_PRIM_PHY_PIPE_CLK>;
-				clock-names = "pipe0";
-				clock-output-names = "usb3_phy_pipe_clk_src";
 			};
 		};
 
-- 
2.35.1



