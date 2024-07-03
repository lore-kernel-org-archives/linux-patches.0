Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCF716F8FA;
	Wed,  3 Jul 2024 11:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004825; cv=none; b=jJrXSEhYDiJLtcEsojXBJDKuv7VV6gjpTGG2N1i2u9T2vPxE4S5A1CMwUKIqCMXHVO/EGG5RYqu93HpqqfCV+wEPhYDu0Y/WIEc8KFa83t8obTUFVbO0MH3N1y197rSdPVpDdkIac7vmRuT+jfEGbrHAaIkaYhyQqgSW3JpjL/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004825; c=relaxed/simple;
	bh=oAZ72CO5raHlgf/2x+TUkarTBzdntZK83cT5zsg32Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBiry+lV1fY+Z0ZE80FC4mCdvmGEdAejo577C1kv9p1ysW79XJGmXRyGNfJe/tNKJ3uHsFHCy5C2xlbTeRJk7CFrgFGFJc/iJh75ZJo2aZzsyfMYkaZcWFRrau1NjE/Uca+5jaZ+Mdsty1iAfe+t/Xw4KKx2xeBmMH6nOCJXoS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdUmCtBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdUmCtBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD20C2BD10;
	Wed,  3 Jul 2024 11:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004824;
	bh=oAZ72CO5raHlgf/2x+TUkarTBzdntZK83cT5zsg32Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdUmCtBpAPSn9/SCT/z/IuErBt3k6Ju3jd54Pr02pexZVfF4l971yon8GeixkDUjA
	 O/4ucmsqBRaHtOTTfV00fsEsuc5sNAz3Jl4+asZaZljlYSPWwEaHpQexLLAj9zolto
	 C1Xi/W6xOxjTcA/SERUsMbj0WPUMV2SXLxcS44VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/290] ARM: dts: samsung: exynos4412-origen: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:13 +0200
Message-ID: <20240703102910.671975544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 88208d3cd79821117fd3fb80d9bcab618467d37b ]

Although the Samsung SoC keypad binding defined
linux,keypad-no-autorepeat property, Linux driver never implemented it
and always used linux,input-no-autorepeat.  Correct the DTS to use
property actually implemented.

This also fixes dtbs_check errors like:

  exynos4412-origen.dtb: keypad@100a0000: 'linux,keypad-no-autorepeat' does not match any of the regexes: '^key-[0-9a-z]+$', 'pinctrl-[0-9]+'

Cc: <stable@vger.kernel.org>
Fixes: bd08f6277e44 ("ARM: dts: Add keypad entries to Exynos4412 based Origen")
Link: https://lore.kernel.org/r/20240312183105.715735-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-origen.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index e2d76ea4404e8..7138bf291437e 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -447,7 +447,7 @@ buck9_reg: BUCK9 {
 &keypad {
 	samsung,keypad-num-rows = <3>;
 	samsung,keypad-num-columns = <2>;
-	linux,keypad-no-autorepeat;
+	linux,input-no-autorepeat;
 	wakeup-source;
 	pinctrl-0 = <&keypad_rows &keypad_cols>;
 	pinctrl-names = "default";
-- 
2.43.0



