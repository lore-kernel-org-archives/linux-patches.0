Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ED613C90B;
	Tue, 25 Jun 2024 10:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309752; cv=none; b=MN/gmIaWcVoxAJqWXYA3I8/pCpRT88WpO5U4VwJ+L1624XE50K+Cxc32w9nAmxd6Uigvqc+Xbsj8L4WxfRk2qlxWklr4Qyh9tZJqmTtDiDgVSEjGkZEuHwL4Pup7n7nZfbUuus7AWo8rVKjJtnTgMy2E9/SDsS1u56T8y6mKFVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309752; c=relaxed/simple;
	bh=74UuOFCvNJWHYX1M6L0ZLRprOyespQI//HJbHcFayX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iszfS8QoUeWNaC+2+YmhiT4bv5x5If+ajZX9Gv9oo5se0jgN58YaNH0fzAFJbK4rnLvSCtEw3NevomoJm9/yXwcmV45ZNa25z9Eex6ovcTvVvk66r278WUt5TtxPudwIjaaeEQTLZvh7zJxgWT4B3AOdwu8FBxm5JTo1oQJOXIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmO3XmjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmO3XmjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D85EC32781;
	Tue, 25 Jun 2024 10:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309750;
	bh=74UuOFCvNJWHYX1M6L0ZLRprOyespQI//HJbHcFayX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmO3XmjE0fljjf5Fqev0xSbMkE2FgFVPxAtDd5kNswyIT8Hjz+pQO6t87giMRMvju
	 roXL9YdofIb+JijDDJDF7j8ZR4pzxeM690KUxHbk+9SAxoyHdgYuXe4Wau92fE8ASa
	 y6mObn+KaFdhVPxRkgObNPxqwC3FuaOHSwQ79kl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/131] ARM: dts: samsung: smdk4412: fix keypad no-autorepeat
Date: Tue, 25 Jun 2024 11:34:36 +0200
Message-ID: <20240625085530.532995664@linuxfoundation.org>
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
index a40ff394977c0..7e0d01498ce3e 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -65,7 +65,7 @@
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



