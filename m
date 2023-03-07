Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7820FBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CB0C433D2;
	Tue,  7 Mar 2023 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214736;
	bh=accuZ4zkPpOQhHJpujBjASp+zGSb9c4nunhrHy0Kh7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZbaQojeOF5WxPO/YYSg6SEhvJUmHTX6/ALBLEo9uLO35V3XPerrapuaKXHEz+WnR
	 LIUegoF6WsyAKw7JKQRQBb96eaUvjdZTPgsC7f8BgjkVK8e1h3b0mf1xPGneX2Mg58
	 fJ/ElueE7fvRdY8+r0QP7yVV/Y1mNwM19urdTJlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/567] ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato
Date: Tue,  7 Mar 2023 17:56:09 +0100
Message-Id: <20230307165907.359165389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit d15d2a617499882971ddb773a583015bf36fa492 ]

The property is wr-active:

  exynos3250-rinato.dtb: fimd@11c00000: i80-if-timings: 'wr-act' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: b59b3afb94d4 ("ARM: dts: add fimd device support for exynos3250-rinato")
Link: https://lore.kernel.org/r/20230120155404.323386-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index f6ba5e4260404..7562497c45dd8 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -249,7 +249,7 @@ &fimd {
 	i80-if-timings {
 		cs-setup = <0>;
 		wr-setup = <0>;
-		wr-act = <1>;
+		wr-active = <1>;
 		wr-hold = <0>;
 	};
 };
-- 
2.39.2



