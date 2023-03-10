Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F16881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326F2C433D2;
	Fri, 10 Mar 2023 14:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459467;
	bh=beqFEl9hVH8gGQavvi2kOfHWgX/YI7Tlxf2gko4Con0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sk9oJ00hKniG3Ec0buOeIBgN1D3fBP3KickdfOIK9WRSuY9ZjHUGF42xLyG4Kd06r
	 a24Q2xBJ1HfOMdBm8iSjZ4ukXxs0gvB2PT+FqpePBetBH+0twnntU3tW/Xe5xc0QzO
	 lsitM83RMN4yQu99OZXoA5FclO0UtZ4sMkNnr0HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/529] arm64: dts: qcom: ipq8074: correct USB3 QMP PHY-s clock output names
Date: Fri, 10 Mar 2023 14:32:37 +0100
Message-Id: <20230310133805.669874952@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 877cff3568c0f54511d77918ae16b2d6e9a0dfce ]

It seems that clock-output-names for the USB3 QMP PHY-s where set without
actually checking what is the GCC clock driver expecting, so clock core
could never actually find the parents for usb0_pipe_clk_src and
usb1_pipe_clk_src clocks in the GCC driver.

So, correct the names to be what the driver expects so that parenting
works.

Before:
gcc_usb0_pipe_clk_src                0        0        0   125000000          0     0  50000         Y
gcc_usb1_pipe_clk_src                0        0        0   125000000          0     0  50000         Y

After:
 usb3phy_0_cc_pipe_clk                1        1        0   125000000          0     0  50000         Y
    usb0_pipe_clk_src                 1        1        0   125000000          0     0  50000         Y
       gcc_usb0_pipe_clk              1        1        0   125000000          0     0  50000         Y
 usb3phy_1_cc_pipe_clk                1        1        0   125000000          0     0  50000         Y
    usb1_pipe_clk_src                 1        1        0   125000000          0     0  50000         Y
       gcc_usb1_pipe_clk              1        1        0   125000000          0     0  50000         Y

Fixes: 5e09bc51d07b ("arm64: dts: ipq8074: enable USB support")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230108130440.670181-2-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 99e2488b92dc3..9114402c044b3 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -108,7 +108,7 @@ usb1_ssphy: lane@58200 {
 				#phy-cells = <0>;
 				clocks = <&gcc GCC_USB1_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "gcc_usb1_pipe_clk_src";
+				clock-output-names = "usb3phy_1_cc_pipe_clk";
 			};
 		};
 
@@ -151,7 +151,7 @@ usb0_ssphy: lane@78200 {
 				#phy-cells = <0>;
 				clocks = <&gcc GCC_USB0_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "gcc_usb0_pipe_clk_src";
+				clock-output-names = "usb3phy_0_cc_pipe_clk";
 			};
 		};
 
-- 
2.39.2



