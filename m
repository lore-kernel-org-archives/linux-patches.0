Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5E516C688;
	Wed,  3 Jul 2024 11:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005903; cv=none; b=Th2+u5AOjX6MML0mdq77s96liXFec0HT/2iAthVhzhWJitYcpgIL4SZt86EwkcztF6DSSbZUL9YASajBHsKsgvp3PLllg+iZNGnGFRW5/qlylqvyIYCZh7mB9z7dtk7itQwDg8zPPdo7pQ+1j/zWcTOvKkK9n3a3zgkw+rTjXUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005903; c=relaxed/simple;
	bh=tTl8T/1xfgIQLdYZD9F+HIwC7OWCE/Dx/phbxq1V3pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPpAy+XRXynV1+IIYF6ehZ9WDMlN1aaueQzP8RDd1uYvTxs72tBn1gw0JzOpeqq4WJqACLOFlwhbKtRGRNthoNPvx3ydvyZRQcBv3dfe8PtJScGkMKqEkrl087HGQnwYj0kizc93JuFw4zLKuv+Ex2cYJ02U+OnClnoF894QxIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oeo6/383; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oeo6/383"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614D2C2BD10;
	Wed,  3 Jul 2024 11:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005902;
	bh=tTl8T/1xfgIQLdYZD9F+HIwC7OWCE/Dx/phbxq1V3pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oeo6/383Z7IDf+M+wSdEBpqe0airNW46R8lDE2APkjQv2lX+4UKysKSfFszqCPfFt
	 2QEpQAiH61Lkw/SMGLVX32gwuPbc1xi2bRnUx+33y+kOx3XsxzVBnqDdbCkbHmoiL/
	 j3BEIUi4eGYIj1JRHbF4vbQzXTq6pHQ75/8JMEH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/356] ARM: dts: samsung: smdkv310: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:30 +0200
Message-ID: <20240703102921.968901654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index d5797a67bf48d..4cf6ee4a813fc 100644
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



