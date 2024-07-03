Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C325413D61B;
	Wed,  3 Jul 2024 11:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005908; cv=none; b=l8qqJG89Qx5R0sPeRpqpgdeaxmkZq5k6Q+a0QWzMdIerqw+FpEDnhYUUk978YpS2/rjUdDMbR4oSmOXPaYcwZ6fb4/crJmjM+yjS6tXjvcXeEqiz7PE+JiLbRIbXeqfdepqpZwZlX4ZS4Iyr7zx2BbcjGF2BkOpgn6E5T8kyx5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005908; c=relaxed/simple;
	bh=JYdOM3qKS0qio1H7P4n8EQads23bxxspKfKPP8xdi7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9ZhDKq4mVigB7z6J9T/ysWmTVh8j/YCtCHKuAkcj1wQ7TY8NKfo2ZQpUDZmPezoPx+DTNs3YQOgv2U4eXR7O+PTSz1xcUepBNY7faQWQPg/C4+pq27JQceRYl6c8i+ldJU+/e+xsZWPVhgtLQBepPZbHiabODqAWLPKzCp0VLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uORBpy5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uORBpy5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4571AC2BD10;
	Wed,  3 Jul 2024 11:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005908;
	bh=JYdOM3qKS0qio1H7P4n8EQads23bxxspKfKPP8xdi7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uORBpy5Gey2jhMgvSy3r0WLKGEn4qkvyOXoNg+hiGuXE8QXLojOj1xU2RowVS8PFm
	 hr7QePJFXzGHvGA0JdwfOb+/v8w60g0LOwmpIY5aYLLJe5y0034DxXMJGDzhJWJsyI
	 02ZF0V86FUIXwRpSrUfpFuHEB3G+q3br4pKwZdwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/356] ARM: dts: samsung: smdk4412: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:32 +0200
Message-ID: <20240703102922.043664820@linuxfoundation.org>
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
index cc99b955af0c8..deebed6ea0031 100644
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



