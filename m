Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A561C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1069C433C1;
	Wed, 23 Nov 2022 09:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196620;
	bh=/8xKRB3HCtQPu0W7+1UDEc8tAg1gj6u0YZVdjpKcPNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOgh93dvB+FFoDgM7xIKUws5RMaLMPNhDAcBtYKPLbApPnODLXzZCMhdW9yLmOwyz
	 DWsyLL4eSkNWBamhU81nU36PhbvwS9C/IqJPMUX4+mkh2AXvXZtRJ7zAq4j21Ijrs9
	 uy+SSh8JHdKhLXQw3U63sm4oUycEEI2Y+vMgaDLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 082/314] arm64: dts: qcom: sc8280xp: fix USB PHY PCS registers
Date: Wed, 23 Nov 2022 09:48:47 +0100
Message-Id: <20221123084629.187006050@linuxfoundation.org>
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

[ Upstream commit 8723c3f290c7b798c0cbd89998576e6b365bda3a ]

With the current binding, the PCS register block (0x1400) needs to
include the PCS_USB registers (0x1700).

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220919094454.1574-4-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 2b8eea373163..cf6d1063bb84 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1181,7 +1181,7 @@ usb_0_qmpphy: phy-wrapper@88ec000 {
 			usb_0_ssphy: usb3-phy@88eb400 {
 				reg = <0 0x088eb400 0 0x100>,
 				      <0 0x088eb600 0 0x3ec>,
-				      <0 0x088ec400 0 0x1f0>,
+				      <0 0x088ec400 0 0x364>,
 				      <0 0x088eba00 0 0x100>,
 				      <0 0x088ebc00 0 0x3ec>,
 				      <0 0x088ec200 0 0x18>;
@@ -1243,7 +1243,7 @@ usb_1_qmpphy: phy-wrapper@8904000 {
 			usb_1_ssphy: usb3-phy@8903400 {
 				reg = <0 0x08903400 0 0x100>,
 				      <0 0x08903600 0 0x3ec>,
-				      <0 0x08904400 0 0x1f0>,
+				      <0 0x08904400 0 0x364>,
 				      <0 0x08903a00 0 0x100>,
 				      <0 0x08903c00 0 0x3ec>,
 				      <0 0x08904200 0 0x18>;
-- 
2.35.1



