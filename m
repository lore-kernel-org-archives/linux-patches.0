Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6661863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503AAC433D2;
	Wed, 28 Dec 2022 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238895;
	bh=ya4vl80IGu2zQ0aIZ+GlVYXMzZylTjNH7QKwBEX4I4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXLwy75TgquRpzQW2ixHjij1hkX/i5aAJo3eysgxFGZmzNCePPe8/ReFIJQu9Ov4H
	 DqQYkGMWGBYNFv7hE7/VcIQYJbQ6deEcxEyF8dusLUT4D4jaVCxGyR5kBREzLiDUCd
	 zw/KnmuXFSGVR9EUYo/pxG7r9uRJBUv4pCsOvPMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/731] arm64: dts: qcom: sm8250: drop bogus DP PHY clock
Date: Wed, 28 Dec 2022 15:32:10 +0100
Message-Id: <20221228144257.216405938@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index e4ba998d0c6e..2051eb8ff18e 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2312,9 +2312,6 @@ dp_phy: dp-phy@88ea200 {
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



