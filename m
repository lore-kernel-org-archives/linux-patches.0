Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4209013C90B;
	Tue, 25 Jun 2024 10:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309742; cv=none; b=XuoVxwmtWBPrQEFsYjvXepeO4V8cEMf9l45+bBoMPYplasBi9h/mUy2DcMNR392usPM5dT446zZG3fWevGsBVnkgLYCis33Dh8LsyHuUY2Aw6qq6tozxtg08UyaTypYdLPRHBwc1XXhffiD9FGBmX7YftGy5Stu6kBcsE8BdNeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309742; c=relaxed/simple;
	bh=u7m5fpWc5lW2OG7lJp2NYqw2wpKVgA70oFJnJIvWGto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IadBDN9MrG+5bMDk81lzquYh/2KjthRh6mfAq2oebA/Fxt2k35twmFACghLLYjvltLk+AehRBZCDWjrZWrrQfZO1LtYL8f3K6BIz9QLI0s3nU5idWGo8COVmSsFL3HfdxBIE+GO3M/Q5z/Z/ynHm3IsW4IZ7O98Vx6Mo5ikrLsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CE0tqub+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CE0tqub+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9325C32781;
	Tue, 25 Jun 2024 10:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309742;
	bh=u7m5fpWc5lW2OG7lJp2NYqw2wpKVgA70oFJnJIvWGto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CE0tqub+pmn2o4VrMmYCUHPFRZZpT/RZlJ7xUXumYqyAY8/lisQWNDtgQc2sfv+gY
	 3GZZWu68AtofqYV3pbly3Y4ZMvL5wsZKZhikq7Vk2jk9jYa+Rew18m9FOJ/kbWPyNE
	 2gAbJ0ct0Jn0QQeaTvXF69ylHw7pYYaqTvpAup24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/131] ARM: dts: samsung: smdkv310: fix keypad no-autorepeat
Date: Tue, 25 Jun 2024 11:34:34 +0200
Message-ID: <20240625085530.457579796@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
index a5dfd7fd49b39..9de3cb3f3290d 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -84,7 +84,7 @@
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



