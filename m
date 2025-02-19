Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989381E1C02;
	Wed, 19 Feb 2025 09:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956420; cv=none; b=SPUQ2rT1yQvsnx3b1pO49Eo8qq8uQWzl4qj/dzNt0VWcWteUfZAu1kQfFp1iyFlOkRpTQRubRjob+qzDAdPVJPK6y2XoXEuQthQ9NkeHbqWAg6M8TcWSJsfBkRDqM/z2akoPfOpt/8NHzSNpQmEoiH8APTjl2oosKAUMJSwN2MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956420; c=relaxed/simple;
	bh=q4CHvOVLA/0IydRK4aYVL6yJnXH/GBmEnMmErxE5Feg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaxKCfJHKYNZzdsTOimpSOFghOISI1YB6LYEYXIr3b3Iij4WNNNgtoVRWW23pPYPcg4O0Vw1NsSx2YbDoZRxpLOwyTAiimmIb0jTWCB8gPXzXe244ii8a/Z4M0d85+rEqWM0d9IqqFT+fJ6kK8lch9Q8UGJD+sCi/oL2KpwzS8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yO/C7f1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yO/C7f1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3C6C4CED1;
	Wed, 19 Feb 2025 09:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956420;
	bh=q4CHvOVLA/0IydRK4aYVL6yJnXH/GBmEnMmErxE5Feg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yO/C7f1E/7c7+b6aGSDSgcQhxmFD8a4ANtLjYjkfHHCogCT+WAWI5vYjWNc2+iOL/
	 4xKL8QUQ7X9NbCTn507YrmADYZkZSbprI4gk5pnTWsCzv1Kv8G6+9oAM1ldwpaVUet
	 GwsYhIj+5kgF8rqDzUNojz8GhcG5Vga2nIQKulDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/578] arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply
Date: Wed, 19 Feb 2025 09:22:56 +0100
Message-ID: <20250219082659.735348987@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit aa09de104d421e7ff8d8cde9af98568ce62a002c ]

The bindings requires the avee-supply, use the same regulator as
the avdd (positive voltage) which would also provide the negative
voltage by definition.

The fixes:
sc7180-trogdor-quackingstick-r0.dts: panel@0: 'avee-supply' is a required property
	from schema $id: http://devicetree.org/schemas/display/panel/boe,tv101wum-nl6.yaml#

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241230-topic-misc-dt-fixes-v4-3-1e6880e9dda3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
index 4ec3e578a1120..a2906126242cb 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
@@ -60,6 +60,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&lcd_rst>;
 		avdd-supply = <&ppvar_lcd>;
+		avee-supply = <&ppvar_lcd>;
 		pp1800-supply = <&v1p8_disp>;
 		pp3300-supply = <&pp3300_dx_edp>;
 		backlight = <&backlight>;
-- 
2.39.5



