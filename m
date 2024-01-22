Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E272351C44;
	Tue, 23 Jan 2024 01:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974043; cv=none; b=PEaMxQbT4h80O4ETF5pfqybKpUtYQ1ePTAaLNrXcQS8CD4bwRnTEfVav8fzxdVYF9Wybjgu+1/L8QdoIqkIpsblBo9XQqR5GV+xarfTqtN/IT4Gy2iR8+1ToDWG499bArsfMfZv0amnIBBVcmDQgdNO3creBG5tZChNwLqFxcIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974043; c=relaxed/simple;
	bh=+iFnuB3Z1acTQWdjwVuB4kkVwBVxbx4VPpyYBHoyBNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHitbUHQHEHwotJoaOViD84/7LJxv69M53n2ZT1qknU8piyjLfISRx7/hfO1gQLpuEkor6F3U+exgf782135DOUbaqmA45HK7rigRDVN8WpxgWiEQN9fD0jsZ9YJhxgNmXJi74SzgUmsCXG8q0TBlaoWAPtXMi1Cu4EChpYspGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flGCzJoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flGCzJoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8C3C43390;
	Tue, 23 Jan 2024 01:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974042;
	bh=+iFnuB3Z1acTQWdjwVuB4kkVwBVxbx4VPpyYBHoyBNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flGCzJoQNl73yMSiqdJCrIetiZ/UhkiKm+GM29+pR1Do58Lorud9HZbuCvwcHsR1+
	 SPx28b0QDBsWMhErNICs2lpxrMehtft09uHLY4PYbvCfejWKsxrsU7PU504hiwiloz
	 nnJocIqY4xD88grVIdy+FxX53KmOWacJ8Z70U+bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/374] arm64: dts: qcom: sdm845-db845c: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:56:34 -0800
Message-ID: <20240122235749.438867631@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 0c90c75e663246203a2b7f6dd9e08a110f4c3c43 ]

There is no "panic-indicator" default trigger but a property with that
name:

  sdm845-db845c.dtb: leds: led-0: Unevaluated properties are not allowed ('linux,default-trigger' was unexpected)

Fixes: 3f72e2d3e682 ("arm64: dts: qcom: Add Dragonboard 845c")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231111095617.16496-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 5ce270f0b2ec..62877311e5c2 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -55,8 +55,8 @@ leds {
 		user4 {
 			label = "green:user4";
 			gpios = <&pm8998_gpio 13 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		wlan {
-- 
2.43.0



