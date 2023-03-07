Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B22BBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1E9C433EF;
	Tue,  7 Mar 2023 17:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209051;
	bh=/C6a0BzfZh2MygVqbjkfPJMEXr/y35qjQX6rGP28Zvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbbMMb5lI5kSc6KgweznAZlNHjVjQUyirnHJif8akYRLne6VxIIzvbAwgI4V6bV6V
	 8RgiNYkod0VyjGMrqCULL1BFc4FMBWXDkN10q6yM8N4jdttjlvJWwzpd2zjrt7JSHe
	 oKYYB1jlX5H5i4NTD6vGUIcSIaxPyakdPOxlUS0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0055/1001] arm64: dts: qcom: ipq8074: correct USB3 QMP PHY-s clock output names
Date: Tue,  7 Mar 2023 17:47:07 +0100
Message-Id: <20230307170024.511911084@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 4e51d8e3df043..9dcb48ebc4661 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -137,7 +137,7 @@ usb1_ssphy: phy@58200 {
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_USB1_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "gcc_usb1_pipe_clk_src";
+				clock-output-names = "usb3phy_1_cc_pipe_clk";
 			};
 		};
 
@@ -180,7 +180,7 @@ usb0_ssphy: phy@78200 {
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_USB0_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "gcc_usb0_pipe_clk_src";
+				clock-output-names = "usb3phy_0_cc_pipe_clk";
 			};
 		};
 
-- 
2.39.2



