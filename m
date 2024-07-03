Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D0316DC2C;
	Wed,  3 Jul 2024 10:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003550; cv=none; b=Q1TCafHjfrKGwjfA+F5n8hJzQE2XF77NHBO41tN/tHCaGhqLTz70UFmNTKEQW5bIuBo3Gmv6n7sWxPMI5FKPhMutAmI8jcEz47oHK96FYlYAL3ZJUgDS0/nZTM4Dg8W5xQdEWCFgboYK3i6rBSfO2/fPKxu2o1kzDfNcYqNWd34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003550; c=relaxed/simple;
	bh=3ItHE7g27YBgUsVHOyMUDF+Gb9/CSU9hj8pn91u2cWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYKOKyOzLAm5cCE9gK0jHqn1iWf0m4g3KjA5XCn1B9LYM3GyhXlSqhB60ccewfFv9cb887lVY0GDlYFbt3mgWnqBEfSd+Mlx696eX/T4c/GNlksSUfnAGXjLzYRnakDjmrAsWbhHdCjO9YYFcjF7C5q9n98pvjbjZPRlNjfYovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rC8jRsCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rC8jRsCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151BEC2BD10;
	Wed,  3 Jul 2024 10:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003550;
	bh=3ItHE7g27YBgUsVHOyMUDF+Gb9/CSU9hj8pn91u2cWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rC8jRsCSqNNMSUQEW31ld3n8jqQfJf26GWNhG1ZmB4rRPSIKk2FSdJL2WUk8OGqjD
	 F3BbglBg0PI+LxSELJ6tXW56cvylF5UoR9gpGqE0g+NdcDTesW7oBkY2ZUeZuv/yZd
	 k55hoX/VKc0RyLrsv2+efCZh622yr+6BVME7Q3nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/139] ARM: dts: samsung: smdk4412: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:41 +0200
Message-ID: <20240703102833.613183900@linuxfoundation.org>
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
index 5c5c2887c14fb..9a1f609d36d01 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -43,7 +43,7 @@ xusbxti {
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



