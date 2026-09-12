Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD6E47986A;
	Sat, 12 Sep 2026 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232287; cv=none; b=WByF1rlaXPxai4sHsyQqR10iTa4UDK4R1ReoWdYQ7ApiJetyTsrGorMN4YKATh91NT+W9rUZYGKErOnO1lWrdNMFsW7WjKeGkDzBsmcsqfhZhvFYoO8oL4x7bhF70i6SXIJebCJhqiZhcKj882OU9BcyoyBcO+ZiMqkzT7pRa40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232287; c=relaxed/simple;
	bh=LeF12eYRM/fzYIbI9Z5RcMHxJAinhs5KZn/d88nEBqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=le0j14EH+2gjQ7JHrH3oOHkd+CtCQF1zOIzQ+DzvRxzWAca4sjmUAbOhFvOTYpkoq2FRYNU+V8Ciq8WOUTziHgW9P/3IX1iY/EPnaC+K9sYeTvoebm0pja9wS2nF12aHnkvIFCNZcGNNqCDa7Ta8kdWTHIrn/261K9lZuwIqM2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUOQ0XLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUOQ0XLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DE31F00893;
	Sat, 12 Sep 2026 16:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232283;
	bh=tXSJZ1WfcfMYGvJJ2yCzYOLCW1Azi4Ij9RSRHJWQrrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUOQ0XLNLSiBeuWVxHcy3WvqfyevO8uuql9JshLfIOVHyUJioCtmT0S3pPaRaRW/H
	 o5z7SrTs2USovCXv9FObawyy80/G2CxNzLuVKorpAijiFxsVhcNPa6cePiSXV7P1tB
	 0OVeY0jDBpT8KvQMABLbyOFattWSsRYwyCjpbAJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1171/1191] arm64: dts: qcom: sm8550: correct pinctrl unit address
Date: Sat, 12 Sep 2026 09:04:59 +0200
Message-ID: <20260912065614.440898395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 950a4fe6ec8498799d1c7bd31a489a718f94a87e ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/pinctrl@f000000: simple-bus unit address format error, expected "f100000"

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-17-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 7bc87711dfc3e..cb4927e0a24ad 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1849,7 +1849,7 @@ spmi_bus: spmi@c400000 {
 			#interrupt-cells = <4>;
 		};
 
-		tlmm: pinctrl@f000000 {
+		tlmm: pinctrl@f100000 {
 			compatible = "qcom,sm8550-tlmm";
 			reg = <0 0x0f100000 0 0x300000>;
 			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.53.0



