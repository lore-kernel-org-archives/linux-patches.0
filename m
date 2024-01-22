Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219135025B;
	Tue, 23 Jan 2024 01:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974697; cv=none; b=D6EX7m2ODHzIwuqbM9f7xmO03jwc9Rhn5Jj8M0/u+X+1vSftgl4tWzeVwvmCNpulp9oGdnVC8XsDcZ2wOD7GVkUkLcrLPoN+/MfF5ILXYaRVMc+ENoM3nYiavcZd+4wSgutdHqZikowKffFKQrtvz9/kezCCpw1Buocowbn8508=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974697; c=relaxed/simple;
	bh=5mcWKA0I6Nc9lGCQZowv0XmJhWz6UytnvFJ45FB6nxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkluRXklBds5M7CZdjtbH8X5/D6jAG1B4zqDflf8L24Vym2dV3HkQiBlyV/61R7uoyt1Wz1gUUtqOJtDm7ocydEVz1ur4tmSyihwNxGxeZPiUyGs1axZdOTmsI8R6F0Fh4aGkbo3iZLSZ3Buo+CCTw3MLWc7TnaybGXz/Mu7c3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K59x4Oiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K59x4Oiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEDEC433C7;
	Tue, 23 Jan 2024 01:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974697;
	bh=5mcWKA0I6Nc9lGCQZowv0XmJhWz6UytnvFJ45FB6nxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K59x4OiyPwDU1Uh+8yhu1dSE4pp6ms60GASfTBq9hoY9ozHP+s1ODW70Zfc/hYU1+
	 v2eCwBjpR9HT7uRqzeRf8GoB+lcoqxupauCs13+C/UMD6eO3j3IQXzFSWzVaPZF8o6
	 Hyxnljder2ADYGmhU43PmkDJxMe6pAtNjSVh8UtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/583] arm64: dts: qcom: sm6125: add interrupts to DWC3 USB controller
Date: Mon, 22 Jan 2024 15:52:59 -0800
Message-ID: <20240122235816.054279329@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 67e4656f4487b95a39e45884c99235f62ebfaa47 ]

Add interrupts to SM6125 DWC3 USB controller, based on downstream/vendor
code of Trinket DTSI from Xiaomi Laurel device, to fix dtbs_check
warnings:

  sm6125-xiaomi-laurel-sprout.dtb: usb@4ef8800: 'interrupt-names' is a required property
  sm6125-xiaomi-laurel-sprout.dtb: usb@4ef8800: 'oneOf' conditional failed, one must be fixed:
    'interrupts' is a required property
    'interrupts-extended' is a required property

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20231111164229.63803-5-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index 197f8fed19a2..07081088ba14 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -1165,6 +1165,10 @@ usb3: usb@4ef8800 {
 					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <66666667>;
 
+			interrupts = <GIC_SPI 260 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "hs_phy_irq", "ss_phy_irq";
+
 			power-domains = <&gcc USB30_PRIM_GDSC>;
 			qcom,select-utmi-as-pipe-clk;
 			status = "disabled";
-- 
2.43.0



