Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F3518C039;
	Wed,  5 Feb 2025 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766872; cv=none; b=aSpBKmyymlCftWASL6nzkOY81NQ4yheKLYwPhDmoiNqb6cT4Gj5d+fsFIDOTTw0Nfg6Dc/H480fBfGUQULnY43bJnM19RUP79PSiwXLHX0vnbYGjOgOCgRm3Z9cKY6wKg7O8YQuAounWIVcE1BrI7aTAVNZaC9zjxtuAwRUTPBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766872; c=relaxed/simple;
	bh=sBboVCvzpXUXeYlByk6qVXbm9CuvP6c7/YebJCadnHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gM8zPIVxbUdDj4HFUIlYrAiui3CMAI2W76TKiAZ9kDp1VKoQkAdVUdclvRqSyxY8fopnNc51qsb/tfNf/V66O7W9BfFrxEg2x3QDrbRfCxBRlMMkA53l+mFqYq9Vb+jYJX4fUdA6Lug198tKnoG3YyuqAUCnQ59SmljJrnTB6NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxGB3SVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxGB3SVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A19C4CED1;
	Wed,  5 Feb 2025 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766872;
	bh=sBboVCvzpXUXeYlByk6qVXbm9CuvP6c7/YebJCadnHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxGB3SVgKuw0AA7Iql8bR7ymVHL1x8Le6XNLZedkdEWSKIO2w+0loyjp2jv6Zue1a
	 FUScQczlVzQkuFVryCFiupZAa86m12xvvWi27mMcyqeJ1V41uXsEUebM7MXxzqiYk2
	 9gMjA25wT+Nv27SeQ5HgLR5MEN7T4nYKbgJJMIIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 374/590] arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply
Date: Wed,  5 Feb 2025 14:42:09 +0100
Message-ID: <20250205134509.579147852@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 00229b1515e60..ff8996b4de4e1 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
@@ -78,6 +78,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&lcd_rst>;
 		avdd-supply = <&ppvar_lcd>;
+		avee-supply = <&ppvar_lcd>;
 		pp1800-supply = <&v1p8_disp>;
 		pp3300-supply = <&pp3300_dx_edp>;
 		backlight = <&backlight>;
-- 
2.39.5



