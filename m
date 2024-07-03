Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7DF16C688;
	Wed,  3 Jul 2024 11:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005906; cv=none; b=tibv4ZUnJKVdxFSMHdV2Re6pIfJFB+aawskJggwgSTj+fO8RvNoLenURtGAnHIEWGnvcNZZ/pxEyUK1UkdgI+LW9/4DSdjlq4wZm6YC0TVsb2eowVt9Zld7z4diI91Q9SQ7kd1EUreKJekxXrI3oQKZqn3fdBgcVzvkiUED8ljY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005906; c=relaxed/simple;
	bh=N0fqH0e3mG5sptZpHhBS+3K3wn9t7WggAgCdl3/QvOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srphsdooFe783CrJwEQUYIozPVznlF1OYcOPo1K/74BzBkexpcg3yYEjjzQYWZDlIwXsFZfHYzd+JEYEuYXokzf3mOc0NE6UT/uKlPRR+BXQfgyi1uBCZIYvcoIXCP6eLqZUZu5YoxHJ+45WdBU5tT2Dj22lSSwP70zx+TAhf24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFYu/kRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFYu/kRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F19C2BD10;
	Wed,  3 Jul 2024 11:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005905;
	bh=N0fqH0e3mG5sptZpHhBS+3K3wn9t7WggAgCdl3/QvOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFYu/kRkZupcuXD8M93a7UN4B95DsF+za0I3wCRCeqDPx348rOCkfBBTRA4cfuvkk
	 iJxpxRSFuVQHW/w2foNvEn9DKIYEasGiKUIAhmFDDakJEAwc9vZl1kDWhUtbYfbJu3
	 X4Gk+krQLSKl4EXmlPvJKUMTKFLOu7twRaNtvaew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/356] ARM: dts: samsung: exynos4412-origen: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:31 +0200
Message-ID: <20240703102922.005963749@linuxfoundation.org>
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
index 0acb05f0a2b7c..68ed31821a282 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -448,7 +448,7 @@
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



