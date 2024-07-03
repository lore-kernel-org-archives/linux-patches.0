Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B060F7CF1F;
	Wed,  3 Jul 2024 10:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003541; cv=none; b=ZbNdvxF87Bc5/CPbLk1Eq1r17f6t9wsvKKjTXUdbOLNEsK4woMel7lv9exyxiCRSo0hadeBJDpeJXx5wQrIK2jipCZmipxk+qMjNzSBqjKhVxLz6vpnfVkwtgsomVsGlpxxwCEwmWiNz0ukTuVuiGm4lNTMMx23tDXwm88ClNBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003541; c=relaxed/simple;
	bh=wyCQkaIy7TlwLufgt83Zvg7sseH0EmjKy6qH3SP2ruc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTkhrop+CIhRkurHJ10op3UtrEdNty+lNi6FjsR91UGdkZNM6h17qyMOTcngNKuhODmAQ7JNt3Os3gZ80ohox/65jqTz8an8XgpgGGhAx6IHtYHIaF9QgUsqLJGRBOM7/6sCqBif/0YvFOZOiobntJsD+tFgjeLcC7QqR1+mvPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PD7E/MZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PD7E/MZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE15C2BD10;
	Wed,  3 Jul 2024 10:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003541;
	bh=wyCQkaIy7TlwLufgt83Zvg7sseH0EmjKy6qH3SP2ruc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PD7E/MZKajY+qKy0apsEBEKQgGAAyL2aUG6vL7jJYqoAD4GIlmSL0obM8dozPEojZ
	 m2vfUWYrNGDZOxT/QyMSgH7zgPOP+xtcm3Q3w4p3dKdyHzeEDii1VjH2Cr3A5qAiwy
	 A9yV4K36PX3VhR52SYcw23LPM1AA/zSIz7qA2UDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/139] ARM: dts: samsung: smdkv310: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:39 +0200
Message-ID: <20240703102833.539085446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7a3e621ededec..b79d860abf90a 100644
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



