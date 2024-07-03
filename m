Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866E71849C2;
	Wed,  3 Jul 2024 10:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004104; cv=none; b=s9GcuEBzji6naaEV/Ys9Zoni2n4biarNtBN4B6agipaylRPJXx/V5LGj9VuHGGpwzVAeM871VqzNj+EkbY7NyXUk5JaI+7Ss9EJTBAajfChN0n4ySl8buACCV5ey9DgxjWz/OS2wmkaiwRGgIejVKIdcdep3aSfwOs//n556J8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004104; c=relaxed/simple;
	bh=Po44W9CZNbqeyoRRfblMTAzR3rC+iZa9haF1sohaZ7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcVf+JxPp7ZLsvmKEBtpbja8x0QERcg8vatSUITBKIlkhSS7wR7uM+96ALnKnMccUS6Zj4TZVvBrHzSvrsck068i3xyaCv+2rw2t9KyKGKQ8XorfAUepV4Xa/dGRvUBeo1ivd7mIFvfwsqn9W1cDYWe575cKZkeUENudwk9Bvrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYvHUA5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYvHUA5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1D2C4AF0B;
	Wed,  3 Jul 2024 10:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004104;
	bh=Po44W9CZNbqeyoRRfblMTAzR3rC+iZa9haF1sohaZ7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYvHUA5kHLKtOKyLSDDGw3ZQbF6qlVgAXGbgfIe5+BOo9Rej6zJyO2rVM5nmDo5EV
	 rTlo1IvVzw+qYYCDOk+L8HQanwbUJ6MO21kmys1MIp/sragvPQfOIuHGvXUgCi3wcF
	 4N4hHcZbLgXZgElv36QKS6AB6Co+X147CxUfDKlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/189] ARM: dts: samsung: smdk4412: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:43 +0200
Message-ID: <20240703102846.100325542@linuxfoundation.org>
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
index e70fb6e601f0e..087e1f99ba32f 100644
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



