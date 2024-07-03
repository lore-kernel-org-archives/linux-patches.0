Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B73119CD02;
	Wed,  3 Jul 2024 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004098; cv=none; b=Ew32iLXycyyTjL/Pmi+Jzrq9kDhhlfsDqMjtXflL6PM++/4LlEkMAdFZCASQmvhRwHg9UyaRryWPxxPnmT7UwcXb1UVUq+P5h2PERKSBUAeKZGWRJyRe8Q/aRzt/NFBJrZ5I3dnSqf9ALo6mnXa12vQ+357Zk1FKDFkHufISW4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004098; c=relaxed/simple;
	bh=V+L7c00RCEu5spi8DBrqsysi0tpeVb98xFDQrZ3zUSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4FjiqH46zjVZ4GdaZNzm5+SM8FDzhClTy4NFougzmOkzpKPNZS6WX2NZyWGBfKb1/sHGPc+2UYRX70kmS4UZxNCsd30U1guNCHJDblZkq43lP04/kY4gYcr/ci1sQeK1MYkKm6+89NrQJ28kLC9qf6o+wpVhfcg3YhBwceKmt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHZw4u8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHZw4u8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15F2C2BD10;
	Wed,  3 Jul 2024 10:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004098;
	bh=V+L7c00RCEu5spi8DBrqsysi0tpeVb98xFDQrZ3zUSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHZw4u8J2oa32rVNZ0h6Z3UEycKwRN205FxhQW7CDbXJzSzcSkrMWXR6Z4CxeVNfG
	 rHGXo65X0QgmTEX/PWxjtOFhWitYSfevoMgNP6DI0M4+XnW6QGWBFR2Ti6gcN/AFC3
	 KWyQGVQM5rVyWBWeDO9BcbAUejPYtnSwMMeAJqRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/189] ARM: dts: samsung: smdkv310: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:41 +0200
Message-ID: <20240703102846.025705653@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 87d8e522d6f5a004f0aa06c0def302df65aff296 ]

Although the Samsung SoC keypad binding defined
linux,keypad-no-autorepeat property, Linux driver never implemented it
and always used linux,input-no-autorepeat.  Correct the DTS to use
property actually implemented.

This also fixes dtbs_check errors like:

  exynos4210-smdkv310.dtb: keypad@100a0000: 'linux,keypad-no-autorepeat' does not match any of the regexes: '^key-[0-9a-z]+$', 'pinctrl-[0-9]+'

Cc: <stable@vger.kernel.org>
Fixes: 0561ceabd0f1 ("ARM: dts: Add intial dts file for EXYNOS4210 SoC, SMDKV310 and ORIGEN")
Link: https://lore.kernel.org/r/20240312183105.715735-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210-smdkv310.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210-smdkv310.dts b/arch/arm/boot/dts/exynos4210-smdkv310.dts
index 77fc11e593ad3..9297788c0c43f 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -64,7 +64,7 @@ eeprom@52 {
 &keypad {
 	samsung,keypad-num-rows = <2>;
 	samsung,keypad-num-columns = <8>;
-	linux,keypad-no-autorepeat;
+	linux,input-no-autorepeat;
 	wakeup-source;
 	pinctrl-names = "default";
 	pinctrl-0 = <&keypad_rows &keypad_cols>;
-- 
2.43.0



