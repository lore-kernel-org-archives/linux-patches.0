Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673B560252;
	Tue, 23 Jan 2024 00:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970874; cv=none; b=eSJBckdzgkGTLEael2+h/VjShbIdAboXbkhGwo464HktKVYccF/YGufbkNr9qeEbYBPY7uyY8l45sTfLya1pPOF5Lir2YUFuqq11u0TdPXX8ZMOOufTzdjplqB5xwn1lo/SsefKVu4pKrDJ2bNMNZlj1a/RLiblR+rmnrKYzP0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970874; c=relaxed/simple;
	bh=/e9pw0zPZ/YU6V4koy/j2NKkuw+1C9txEzY3PhfApTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPaqxHqVkxX7fcUKqG8z+TElPFZ/Wy+8QW1qhJxG5VJsImo1zjnyrH8hncev+JYWIGQd+quHcY0pk/0ZHz0cx+FN7T2TT3fUoBiHVp6AiSKrx5uGCYEwNYt225tQ9GfDJ6NhkVoJgg72pmQXD6R32pLDeKo+ntH8eRouwVjq4cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzMq6ey/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzMq6ey/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AD6C433C7;
	Tue, 23 Jan 2024 00:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970873;
	bh=/e9pw0zPZ/YU6V4koy/j2NKkuw+1C9txEzY3PhfApTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzMq6ey/qY1KWg+oQiYUHAQ2EGQPyxbb6ZTf1RG/vl+YF0lJS/+o2RVQmTzRtisd4
	 DbHz+n/mLAyWENXGq5W4QHRVxhwdoIl9Ut/fWxEkVX4u+F8bfntCJb/LvZAQRwuZHB
	 iyFW63cs888/mQMcjA5fJZq68Cm3uPp3tbJ0KRIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/417] arm64: dts: qcom: ipq6018: Use lowercase hex
Date: Mon, 22 Jan 2024 15:54:58 -0800
Message-ID: <20240122235756.318243514@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 0431dba3733bf52dacf7382e7b0c1b4c0b59e88d ]

Use lowercase hex, as that's the preferred and overwhermingly present
style.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221212111037.98160-2-konrad.dybcio@linaro.org
Stable-dep-of: 5c0dbe8b0584 ("arm64: dts: qcom: ipq6018: fix clock rates for GCC_USB0_MOCK_UTMI_CLK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index f3743ef7354f..55f685f51c71 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -685,7 +685,7 @@ dwc_1: usb@7000000 {
 
 		ssphy_0: ssphy@78000 {
 			compatible = "qcom,ipq6018-qmp-usb3-phy";
-			reg = <0x0 0x78000 0x0 0x1C4>;
+			reg = <0x0 0x78000 0x0 0x1c4>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
@@ -702,7 +702,7 @@ ssphy_0: ssphy@78000 {
 			usb0_ssphy: phy@78200 {
 				reg = <0x0 0x00078200 0x0 0x130>, /* Tx */
 				      <0x0 0x00078400 0x0 0x200>, /* Rx */
-				      <0x0 0x00078800 0x0 0x1F8>, /* PCS */
+				      <0x0 0x00078800 0x0 0x1f8>, /* PCS */
 				      <0x0 0x00078600 0x0 0x044>; /* PCS misc */
 				#phy-cells = <0>;
 				#clock-cells = <0>;
@@ -727,7 +727,7 @@ qusb_phy_0: qusb@79000 {
 
 		usb3: usb@8af8800 {
 			compatible = "qcom,ipq6018-dwc3", "qcom,dwc3";
-			reg = <0x0 0x8AF8800 0x0 0x400>;
+			reg = <0x0 0x8af8800 0x0 0x400>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
@@ -753,7 +753,7 @@ usb3: usb@8af8800 {
 
 			dwc_0: usb@8a00000 {
 				compatible = "snps,dwc3";
-				reg = <0x0 0x8A00000 0x0 0xcd00>;
+				reg = <0x0 0x8a00000 0x0 0xcd00>;
 				interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&qusb_phy_0>, <&usb0_ssphy>;
 				phy-names = "usb2-phy", "usb3-phy";
-- 
2.43.0



