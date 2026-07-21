Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFBA46A5E8;
	Tue, 21 Jul 2026 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648237; cv=none; b=rHnVWuJpuidlCb6Euz1Z2eRJiG9AeP10lQW9tL93fVUuUls6mRtLWthNVADwMqFmfN5Kdvl/m4/uQi9oYeuZdwbhgqS1cpPQ+b4RPSJlxhA9JD8EZKF+Sg7mIdjfN7dHJz6xNcKI3CFhvY/jnvy0K1h1XKSmrLodQSwQGntG6pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648237; c=relaxed/simple;
	bh=XUnfmSxPCub3W1iWqcRF0rAZdEZZ9T9T0WvH3Z8QJVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbsv84n6EDCAeGEE8Ss7qFJdFJVa2MuLbpzwLlHh0dserBPRcz52g1NX5zhvfBdipeFmFFRKxda2CFndzy9nPVmUIYb6osOoCfsX0TYiCtKaGAxIdf3LlgOm/v9VtLl4Bl29PSjTSwTTkLnrjkmyxtKdRgtEy94SQn7Je5st4L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zD3GxyBi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zD3GxyBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4401F000E9;
	Tue, 21 Jul 2026 15:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648235;
	bh=3YSLHKKKRwqorD8V6AGjWJNm+f8sbQgckZZUswtSKWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zD3GxyBiD/0A3+ZKhIVxBjgEVs9E3QrYztRM3LUlQe96/JwCftX5EPI8NY6oMKLxz
	 Q0b36DJG5CrAGrqhXN/biqf4pSYZGy/pEOkZ23nU2gy4a2Q+SfbWuHa/pATdO1Qxrk
	 IfgmWiWQ01R7eIrxdgwJCUzRZ3gQXxvThNUUeX0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0086/2077] arm64: dts: qcom: ipq5424: Fix USB simple_bus_reg warnings
Date: Tue, 21 Jul 2026 16:55:59 +0200
Message-ID: <20260721152554.721758791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 864fde494aa1dd26c68254661f2ce973e9f03832 ]

Correct the unit address of USB nodes in Qualcomm IPQ5424 SoC DTSI to
fix W=1 DTC warnings:

  ipq5424.dtsi:642.22-693.5: Warning (simple_bus_reg): /soc@0/usb2@1e00000: simple-bus unit address format error, expected "1ef8800"
  ipq5424.dtsi:733.22-786.5: Warning (simple_bus_reg): /soc@0/usb3@8a00000: simple-bus unit address format error, expected "8af8800"

Fixes: 113d52bdc820 ("arm64: dts: qcom: ipq5424: Add USB controller and phy nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260405-dts-qcom-w-1-fixes-v2-3-1f2c7b74a93f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq5424.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq5424.dtsi b/arch/arm64/boot/dts/qcom/ipq5424.dtsi
index f20cda42909497..876bf6a8b8ff0c 100644
--- a/arch/arm64/boot/dts/qcom/ipq5424.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5424.dtsi
@@ -639,7 +639,7 @@ qusb_phy_1: phy@71000 {
 			status = "disabled";
 		};
 
-		usb2: usb2@1e00000 {
+		usb2: usb2@1ef8800 {
 			compatible = "qcom,ipq5424-dwc3", "qcom,dwc3";
 			reg = <0 0x01ef8800 0 0x400>;
 			#address-cells = <2>;
@@ -730,7 +730,7 @@ ssphy_0: phy@7d000 {
 			status = "disabled";
 		};
 
-		usb3: usb3@8a00000 {
+		usb3: usb3@8af8800 {
 			compatible = "qcom,ipq5424-dwc3", "qcom,dwc3";
 			reg = <0 0x08af8800 0 0x400>;
 
-- 
2.53.0



