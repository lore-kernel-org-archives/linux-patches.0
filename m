Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE5414A09C;
	Tue, 23 Jan 2024 00:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969200; cv=none; b=tSkd/r1iEBr+W3iMQUgiMURVUIYBGxIIwunth93tpfI9s4npKk9NT32AWQ3fxTlufwoVyXMflkHQqKEeqfDqr0zvyX+2SNQicSidSAC5sMWhW0JTFyanAgp9gBoSq/ahh9WiXrKaBA1GxJod3Nxoql5zWQoGdDPrR8TONTN/mn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969200; c=relaxed/simple;
	bh=jmdQGdeqraQ5Wekpx5vz92EVIoFk3lCIodWTDS6nkFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFZsYcUotw/gdRAG/R3S4M//aBN64Ewe+FTE1u1BAAhuMAWO9bsMUJIg9YrogSIjwdlm0hdrnJgSnd0n8WrsRHWblYQlAGs+I7SBXluhZbBIv9RUWounf5eYepqx51NTA3IQPVmt4y0hdU1lXpU8/t26Yq88HMe2zheDwopAvVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laYL/qCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laYL/qCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49988C433C7;
	Tue, 23 Jan 2024 00:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969200;
	bh=jmdQGdeqraQ5Wekpx5vz92EVIoFk3lCIodWTDS6nkFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laYL/qCu60F2S7C1bbZl1GFFx2FqEhUj+0FvUzMDAOkJDQbADv+P5hB+zb2mxNpJf
	 bwNAqR1O180HTRocPat+OpuFA1wVKoCdG4Rly6k+x9LnBdH+c8npeJnOeyvp8fcamO
	 KSbuoWr/noW79u1AEsgf4Mqhcs0SRqwshSGnEwuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 094/641] arm64: dts: qcom: sc8280xp-x13s: add missing camera LED pin config
Date: Mon, 22 Jan 2024 15:49:58 -0800
Message-ID: <20240122235820.978801428@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit a3457cc5bc30ad053c90ae9f14e9b7723d204a98 ]

Add the missing pin configuration for the recently added camera
indicator LED.

Fixes: 1c63dd1c5fda ("arm64: dts: qcom: sc8280xp-x13s: Add camera activity LED")
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231003093647.3840-1-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 6a4c6cc19c09..f2055899ae7a 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -82,6 +82,9 @@ switch-lid {
 	leds {
 		compatible = "gpio-leds";
 
+		pinctrl-names = "default";
+		pinctrl-0 = <&cam_indicator_en>;
+
 		led-camera-indicator {
 			label = "white:camera-indicator";
 			function = LED_FUNCTION_INDICATOR;
@@ -1278,6 +1281,13 @@ hstp-sw-ctrl-pins {
 		};
 	};
 
+	cam_indicator_en: cam-indicator-en-state {
+		pins = "gpio28";
+		function = "gpio";
+		drive-strength = <2>;
+		bias-disable;
+	};
+
 	edp_reg_en: edp-reg-en-state {
 		pins = "gpio25";
 		function = "gpio";
-- 
2.43.0



