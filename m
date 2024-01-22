Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68F36025E;
	Tue, 23 Jan 2024 01:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974692; cv=none; b=hjid0NiFB69yOYq/ZZvy1Hh10TBVXlYF2mjC8g6qkzadQ0iKrVOmEFkkL63wLTydNhIWXFUaNAoGP73+39mzhptBzuKy/MjP3eG8XzhqAEHrfhvW5/nvFkp/JGyhbjllZmz10VHQXNSSfRlqODkmrxJT/aKOuFsttqx1OJspH/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974692; c=relaxed/simple;
	bh=mnigtyfK4oRTMwJGtR6k0dUe12oXFybOg2Y8WdFVWP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjah+31HUbbazF8KRKlNO3buHGnAuKKDMnxpGy1CY5gQ5LpBec+et27fvJEahnZjqHfXAL27Ltz98sq4zA/rSXJB8YdR3Aucj4THxxSV9nPKDrX/5MrPbtQChcfWekmiFaBbFbuxPoi7Lm+P9WTAIoHEKQyzNMCWrNzpf4yttAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QULYkYv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QULYkYv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4EFC43394;
	Tue, 23 Jan 2024 01:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974692;
	bh=mnigtyfK4oRTMwJGtR6k0dUe12oXFybOg2Y8WdFVWP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QULYkYv5Rubg7/ZXOY0+E0bg9fGU6g1A3TWDOQ6N5Vz0pBo73S5tPBFYBmEgJsEOP
	 noJwL3//wuH7hV3EpZI/AV0+rKN33ZWUaah+UwkIfiBpYg2qf3RGyw3S5r5xlnkwJT
	 hJW1OBNG6COj6GQk04WIYKADyzm0gv2Mr6R21o6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/583] arm64: dts: qcom: qrb5165-rb5: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:52:57 -0800
Message-ID: <20240122235815.993496353@linuxfoundation.org>
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
index dfa8ee5c75af..e95a004c3391 100644
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



