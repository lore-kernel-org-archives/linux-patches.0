Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B655C1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146C5C433B5;
	Wed, 23 Nov 2022 09:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196611;
	bh=3BVQFlI9Xv6+9PtX5E+AxRdo9ciUdmLL3GX+MxRYr4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSy/1RsTXw3odDXsG6sU1h1FgZgLxWww52xBgZmipicw4BOW4j2S1BfzlmGapcJrT
	 /J8pwU8d5ia0KlGN2H+KWR3hHg133a9mvdvFZnZbbONLo8VFv0GrrJ4RjupmtSzI49
	 Pp9MSS/WlQN4O6iCp5FsClUi+7qeZwG4QKgkb8Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 080/314] arm64: dts: qcom: sc8280xp: fix USB0 PHY PCS_MISC registers
Date: Wed, 23 Nov 2022 09:48:45 +0100
Message-Id: <20221123084629.096775697@linuxfoundation.org>
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

[ Upstream commit 31b3b3059791be536e2ec0c6830767b596af340f ]

The USB0 SS PHY node had the PCS_MISC register block (0x1200) replaced
with PCS_USB (0x1700).

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220919094454.1574-2-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index cdc395d53c5a..e3e192877a88 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1184,7 +1184,7 @@ usb_0_ssphy: usb3-phy@88eb400 {
 				      <0 0x088ec400 0 0x1f0>,
 				      <0 0x088eba00 0 0x100>,
 				      <0 0x088ebc00 0 0x3ec>,
-				      <0 0x088ec700 0 0x64>;
+				      <0 0x088ec200 0 0x18>;
 				#phy-cells = <0>;
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_USB3_PRIM_PHY_PIPE_CLK>;
-- 
2.35.1



