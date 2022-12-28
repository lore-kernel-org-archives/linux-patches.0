Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4E31863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94345C433D2;
	Wed, 28 Dec 2022 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239798;
	bh=OepPGvD5L0rJXQdAq7Umh3WccAxWFMYdTvuPPkA0cIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXKRktD0nagdXRHujF0rbWzDfhwYvtLb9udK2zyVvVvMRc/sYQhz+uN1MFrQTJRKy
	 hsCr/ikQEfhvCH73DTbCVtE+aQmzu4NH1P+SDFnmypmLemyKqdMfsN33sxmvNawlnP
	 m5By1Bgyq7+tZdhz55P6HzRtBOW2xwFV83wdv4NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0035/1146] arm64: dts: qcom: sm8250: drop bogus DP PHY clock
Date: Wed, 28 Dec 2022 15:26:14 +0100
Message-Id: <20221228144331.120673421@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit bb9f23e46ddcebe1bc68a43a0f7acfc1865a6472 ]

The QMP pipe clock is used by the USB part of the PHY so drop the
corresponding properties from the DP child node.

Fixes: 5aa0d1becd5b ("arm64: dts: qcom: sm8250: switch usb1 qmp phy to USB3+DP mode")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221026152511.9661-2-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 1452213efb00..29b34adb09e2 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2898,9 +2898,6 @@ dp_phy: dp-phy@88ea200 {
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



