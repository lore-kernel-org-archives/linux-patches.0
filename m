Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007A01741D1;
	Wed,  3 Jul 2024 11:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004829; cv=none; b=Yh/6qKBGfc2EWVtWSoLxq85MJoXqRbdeYJ1sOmSQhVhyQuvl56QMtG7qjuvHGLCxDbnm5uK2lQTX9cau4GLikzR41g6x22PWwTVCTjWoRJn/dnwvS5o3QUaV4h+R2OxXtRUApFwx7rwmHc9QbfhLhYpAgJRRd6+9dJwXA1GivUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004829; c=relaxed/simple;
	bh=kfHotLG9ubTPcxDFBNPzdT7c1CNvqN0/hJ1NyCjh13c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFMmDuNpWHS6Ni8D+tT2Uy6kNA0gZu0LX+Nic+mD+NF3h2w45nAwOADb3yUINhJhPoe8VpRFqhpnXNU3HaotBFRwXTwgG25YIhyY2EGYXxJcsYRNIk29wSy8CgwFmBgV4BXPu8yrznHsHj2E54XJ2+qMGJPJ2lMmrqULiPyNCmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJIyWBJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJIyWBJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6BDC2BD10;
	Wed,  3 Jul 2024 11:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004828;
	bh=kfHotLG9ubTPcxDFBNPzdT7c1CNvqN0/hJ1NyCjh13c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJIyWBJY0kCWduOfge5etqEYe1gLSks1rnMcGvwieBA3aiULjSKcpElT217gAnSju
	 hi+K+dCUptnHu82qCU40MMnwu4JyZvmmgkfWmtDz8r5cR6rwItrfNP3M0wWvjrbSc3
	 t4Q4Ho2d7ExQZpiLmkYF/+A16QbRx7cVvRzFQ6DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/290] ARM: dts: samsung: smdk4412: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:14 +0200
Message-ID: <20240703102910.708968249@linuxfoundation.org>
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

[ Upstream commit 4ac4c1d794e7ff454d191bbdab7585ed8dbf3758 ]

Although the Samsung SoC keypad binding defined
linux,keypad-no-autorepeat property, Linux driver never implemented it
and always used linux,input-no-autorepeat.  Correct the DTS to use
property actually implemented.

This also fixes dtbs_check errors like:

  exynos4412-smdk4412.dtb: keypad@100a0000: 'key-A', 'key-B', 'key-C', 'key-D', 'key-E', 'linux,keypad-no-autorepeat' do not match any of the regexes: '^key-[0-9a-z]+$', 'pinctrl-[0-9]+'

Cc: <stable@vger.kernel.org>
Fixes: c9b92dd70107 ("ARM: dts: Add keypad entries to SMDK4412")
Link: https://lore.kernel.org/r/20240312183105.715735-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-smdk4412.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-smdk4412.dts b/arch/arm/boot/dts/exynos4412-smdk4412.dts
index 49971203a8aa0..6e6bef907a72e 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -65,7 +65,7 @@ cooling_map1: map1 {
 &keypad {
 	samsung,keypad-num-rows = <3>;
 	samsung,keypad-num-columns = <8>;
-	linux,keypad-no-autorepeat;
+	linux,input-no-autorepeat;
 	wakeup-source;
 	pinctrl-0 = <&keypad_rows &keypad_cols>;
 	pinctrl-names = "default";
-- 
2.43.0



