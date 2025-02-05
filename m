Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD6C14A088;
	Wed,  5 Feb 2025 14:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765404; cv=none; b=hQ6N3O6TCsAfcvm7G9m3t44zyA78awJTvucdlFIjlgwt7RbazrgJuJL/JhzuCJVUsc9G4S9gg/qVssZDKxpz2KkvWfXvEkQ/UDb67/oww4OA/aEn+azjh/9P0tMz/GterLx5zcciKGXtO8/tE/V85x+ekYQ3WiH11IRQLutrDOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765404; c=relaxed/simple;
	bh=LLndXl54dXVcAVHwmwRcGcuJ0DdNHLKzHddnqIaCamw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=If0iswxiWVTaVeoMl9Rmzl5CmGSs3VUlFXrQ8pePSkbtrL2w+0Tj29G0Pd/QAWWWAXPzj+CSKaZ7s4SIPGrADem5rSoDowIwjPz+qT/q5RELNpEdhFVv9I0uhCtWAY1UBhNMenN9DMSuN21kcLxX6C+mim3KBawZ8psssuX2TJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMb7+1Qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMb7+1Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C0BC4CED1;
	Wed,  5 Feb 2025 14:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765404;
	bh=LLndXl54dXVcAVHwmwRcGcuJ0DdNHLKzHddnqIaCamw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMb7+1QiphhpUw/D6ebE/z7Igtv01HJkmuUqt+/O6T2b3IkUh5lR7uXV8WIM6tHcz
	 uVD/+WVYaphrMIoRWKza0kUMkOs5rnFYa6Q+ndkzFirx2qsqrxLx49IiYpu/rcrFG7
	 TpAmBoNX/T+zRGmtgy1HqQ4AGUymqf+hVW++7Iw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/393] arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply
Date: Wed,  5 Feb 2025 14:42:57 +0100
Message-ID: <20250205134430.181242925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 62ab6427dd65d..e1e31e0fc0e14 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
@@ -84,6 +84,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&lcd_rst>;
 		avdd-supply = <&ppvar_lcd>;
+		avee-supply = <&ppvar_lcd>;
 		pp1800-supply = <&v1p8_disp>;
 		pp3300-supply = <&pp3300_dx_edp>;
 		backlight = <&backlight>;
-- 
2.39.5



