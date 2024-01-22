Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1854BAA4;
	Tue, 23 Jan 2024 00:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970730; cv=none; b=uZrZfv6CdIRV3RQs4Ws4fPOYfbJEveAGitdxAPdOprXggxsng95WRm+r0xmsZjVovbOgRJqDZRfIs8PRsVD5xTOumpDl3/WIgDbpCconRe+nrBI77IGHH1CB3yKxmwe49F9CQtEyS8inM/iEXCVds2KB7CfQgfPeWUW39aJq2oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970730; c=relaxed/simple;
	bh=NGY/iVymPTlzntdJUrEZRja6Zn6abpX19LwcVxV8Nmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFMJry0uflcI49acAJJz3otjDyVmbR+woABA4P20Nc+VH0T/8fxOPToofXR+Mo1o3hbnESH0PkcBXhin+Hz956eFWUeZin06aVERrFHyxPRmNLoHh/QeZ78JMW8mfn6S+MAzYUVuOEIQvKkZikvm10rIGf5cuBpXDHDNJscTTjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMeCcKC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMeCcKC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E67C433C7;
	Tue, 23 Jan 2024 00:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970730;
	bh=NGY/iVymPTlzntdJUrEZRja6Zn6abpX19LwcVxV8Nmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMeCcKC9ohh3HsQnqxusHueQfrMFM328w1SUxJFoYCBSbMg0dJOyxm3iegzK3C5Tx
	 oAW6SJxKwI2CjUYuqOzHY06kr/wtHeqlYOCyEi7aVPPFEQFqCenijZwaE9LmMijTID
	 fkVhv+ydIjH9TMJbg/kDFABrxvJjJOyNGPoQKFKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/417] arm64: dts: qcom: qrb5165-rb5: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:54:28 -0800
Message-ID: <20240122235755.165566250@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit dc6b5562acbac0285ab3b2dad23930b6434bdfc6 ]

There is no "panic-indicator" default trigger but a property with that
name:

  qrb5165-rb5.dtb: leds: led-user4: Unevaluated properties are not allowed ('linux,default-trigger' was unexpected)

Fixes: b5cbd84e499a ("arm64: dts: qcom: qrb5165-rb5: Add onboard LED support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231111094623.12476-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index 9731a7c63d53..1defbe0404e2 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -63,8 +63,8 @@ led-user4 {
 			function = LED_FUNCTION_INDICATOR;
 			color = <LED_COLOR_ID_GREEN>;
 			gpios = <&pm8150_gpios 10 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		led-wlan {
-- 
2.43.0



