Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56F91386DF;
	Thu, 13 Jun 2024 11:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279697; cv=none; b=jKeCTFNk0e+xUFwXudBNJoAOCd3t6qt8+kigwX7BGo2b3Gg9S2Odog+OfB8YHZDknhBzy/schix7S0RmPVb2OU7IO7yFRsfbtXpSGX3GlxlvIgXs+hFex6Hma0PiiGkoulCF0LZWw8w5zJYIXqeJz+0UaUGYZ9xQBpM8NtTrrkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279697; c=relaxed/simple;
	bh=Sbj3MdrXO6SN6TYcm9pjoB5i/yR03U+3H1xjZRz8ZLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bauGaBfzMTliAaQVnS8z68Z4GdsLwlwXGedeLujynRttwslINg/dHmMrnKDm+klPXb/wdKzMVDZmU1xpP3txtED5NeZ1DV9DJtCMsbak3pL1FJ81QvRPnSheO7ZzKQcLZzv+Vw7qtcJxWYhnl/JbGxNTylSY7GfG8ZQfw3dSVZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbevANBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbevANBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CABFC2BBFC;
	Thu, 13 Jun 2024 11:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279696;
	bh=Sbj3MdrXO6SN6TYcm9pjoB5i/yR03U+3H1xjZRz8ZLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbevANBPKRyyY3v8LpEBCu0RKFt9fG/F3TDO8+kPxvNS/ybR4YGlo14cpecxJcMoB
	 36c0KuOWA1wtU9IERu3o2mvm3NOlqAXeNdLEoQmG6Xs/Pjkt9xJgC61ypPDFenat3M
	 9rcvDrWLvbYKQDYLiPT8fXR/BPzUafT9kxfSp2Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.9 122/157] ARM: dts: samsung: smdkv310: fix keypad no-autorepeat
Date: Thu, 13 Jun 2024 13:34:07 +0200
Message-ID: <20240613113232.131884210@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 87d8e522d6f5a004f0aa06c0def302df65aff296 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/samsung/exynos4210-smdkv310.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/samsung/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/samsung/exynos4210-smdkv310.dts
@@ -88,7 +88,7 @@
 &keypad {
 	samsung,keypad-num-rows = <2>;
 	samsung,keypad-num-columns = <8>;
-	linux,keypad-no-autorepeat;
+	linux,input-no-autorepeat;
 	wakeup-source;
 	pinctrl-names = "default";
 	pinctrl-0 = <&keypad_rows &keypad_cols>;


