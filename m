Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A751CA6F;
	Sat, 12 Sep 2026 14:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223573; cv=none; b=JAPcpBU5iBxZcKA9y6oFey8zjYbTciD6X0nf9N7Uq1ZcS9z6Fbz/M/DKsGPKFZZaN/3dcXozJbp19tnsKaLeuGEmQNi/KyUKKMlMD8bd4JBV+ORw7zPib1tbSelsin31TMEu2Y4nxwPBqKzCAoI5ZhjrJIR1W2YDL7OMhTnQwUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223573; c=relaxed/simple;
	bh=dTWprmdt2MBZ6yZAXY6twhFFPgN04uJGQYPNEUl4vn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUdoP+LoKE4O+0/MIlxWJWOC2fUxF+Uff3E6B/iHrkPduQbSlRva2VAh+MgpO1UUdsezxQkyuFe2l3wJSUqwrDTYTLWK5g9LzaF1FcSGGgusb/lwa802VvUidWbNZ44UrGroEaENqviu8Gm1cgt6yOe/hmwmS/LrHcJpy+fzd3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6E+c07U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6E+c07U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ACE1F000FF;
	Sat, 12 Sep 2026 14:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223572;
	bh=ZZmPFng+Gykn4F42ZEsav01bNkWsEYU3S2jmi5GFl9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6E+c07Ux7aGRHuwQmvSV4AuBp8ETmB63dnQVKiTh1oaOye5v8zImocehGWKmeMyo
	 Mw8vu0exx/Z0lPhtE6XZojQGHmeowY00hUc74wjJgqo9ESt2WTduvvqBzU/VnW6eXR
	 lItCM8uhg+3+EoC3C/Pq06BLiZeWUSiA7WgnTA40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0774/1424] arm64: dts: qcom: msm8996-xiaomi-gemini: Fix up ti,drv2604 enable GPIO
Date: Sat, 12 Sep 2026 08:53:26 +0200
Message-ID: <20260912065624.633463337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 569413a98a1761782a0770aa85d20a2c78893279 ]

Update the 'enable-gpio' property name to 'enable-gpios' to conform to
the bindings for the TI DRV2604 haptics module. While at it, use the
GPIO_ACTIVE_HIGH define instead of the raw literal.

Fixes: 4ac46b3682c5 ("arm64: dts: qcom: msm8996: xiaomi-gemini: Add support for Xiaomi Mi 5")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260625-topic-ti_drv2604_dtwarn-v1-1-76e91fcafbe8@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
index dbad8f57f2fa3..f145e8ee5f80b 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
@@ -39,7 +39,7 @@ &blsp2_i2c3 {
 	haptics: drv2604@5a {
 		compatible = "ti,drv2604";
 		reg = <0x5a>;
-		enable-gpio = <&tlmm 93 0x00>;
+		enable-gpios = <&tlmm 93 GPIO_ACTIVE_HIGH>;
 		mode = <DRV260X_LRA_MODE>;
 		library-sel = <DRV260X_LIB_LRA>;
 		pinctrl-names = "default","sleep";
-- 
2.53.0



