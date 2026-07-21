Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7094429CDF;
	Tue, 21 Jul 2026 19:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661450; cv=none; b=CirSAzJBc+7hNNxIedSz6utf7cm24zj6U5SGwm6am9llbH8ak819PD9rwaBGVtmPGGBUEbQn6JyUQuFVPhLedY6L/V9ItZTWK8g58LwDBWwPTJSspD7A1nakGawMXl0cV28WegkjdC8+uFE4AYZLHwwjLryASEWR6QHseU0jU+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661450; c=relaxed/simple;
	bh=J0X8gtaGhXLQvfAfAzzXjheDAD8+EohexC/2MNGE38g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQkrZ2Yk/zMfi1TS9/SdIbd6gI+V5/SgkqDPpCLJAMHamu6O+GvBa+ycdRfqWSqg1mmMCki+aUcKPeYLmIQzkI4aez+yNstxQEkvdGnXETL+TYVPha1vs85Bp9ZY2pjNdlQMirco5AaxZx2zyZCKCJdxqN5MhllU4LRkheOYUxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaFjkZ8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaFjkZ8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2356B1F000E9;
	Tue, 21 Jul 2026 19:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661449;
	bh=uqXo4Z5tkKunz6i3eKQxKm/N/Rh92xrjY/1wKIyYKyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaFjkZ8CtwOkK6UPhGOdCH+T4owsl6AwQQpoFQDzc2UYvN3hNuzvG2P3AmP220l9d
	 7l1A+52ep5mN5ydVhgWvwwpBR/dnAXuGklqr7v0Bina4UsDy0GVEk3jBkb+OSBqp4s
	 MdyEGaMhNrzlgaAaM6T3bPze/UeMK0bDVT7ng9h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0071/1276] arm64: dts: qcom: sc8180x: Fix phy simple_bus_reg warning
Date: Tue, 21 Jul 2026 17:08:34 +0200
Message-ID: <20260721152447.681296589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit f319a5fc998e29699d325af0e461721b3768eeec ]

Correct the unit address of phy node in Qualcomm SC8180x SoC DTSI to fix
W=1 DTC warning:

  sc8180x.dtsi:2650.31-2695.5: Warning (simple_bus_reg): /soc@0/phy@88ee000: simple-bus unit address format error, expected "88ed000"

Fixes: 35e3a9c1afce ("arm64: dts: qcom: sc8180x: switch USB+DP QMP PHYs to new bindings")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260405-dts-qcom-w-1-fixes-v2-4-1f2c7b74a93f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 60f71b49026153..6ca9fba74c08ba 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2637,7 +2637,7 @@ usb_mp_qmpphy1: phy@88ec000 {
 			status = "disabled";
 		};
 
-		usb_sec_qmpphy: phy@88ee000 {
+		usb_sec_qmpphy: phy@88ed000 {
 			compatible = "qcom,sc8180x-qmp-usb3-dp-phy";
 			reg = <0 0x088ed000 0 0x3000>;
 
-- 
2.53.0



