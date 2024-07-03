Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228C11741D1;
	Wed,  3 Jul 2024 11:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004822; cv=none; b=JTDDvAC07cblgMA1FStsZx18xZ8EnLId3s3hMIoH7pDElNQU+KI7FDNe4YIDErC8Qtatn4bT8MiLQ2l7bSTbDZJudnqEgOQyhJDLDwgJNpzr6dFOxRDN6WBIgV+A1Preh+05okcDLp2NXdgHWqnoU0X5LuXyGzx85IhrlEpxrvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004822; c=relaxed/simple;
	bh=8JJzlb1W/hSg6gRJ9yGcDX3QhaV690GSIBBsd0T4qHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZnYBtZuggUNU2+Uv4C7l0qLQbqDg8HX3eHiq1oZIqXWCJBdtO8JIIpNCk2QFgMWlASQsxbOnvJCbQV44COMcLkYgR0TWqVLHM9fXq59++PP8WxxXZbHRss5NMgKLIIrWYnL/sPSpQPwpuXV+Juv7Uh0lTWsKvFq2trX2zNV8ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqFHJ1CF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqFHJ1CF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E382C2BD10;
	Wed,  3 Jul 2024 11:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004822;
	bh=8JJzlb1W/hSg6gRJ9yGcDX3QhaV690GSIBBsd0T4qHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqFHJ1CFINki+S/4E7vr1n82HzbmWciEy0axEYeupf2IuCHChonjMR7raXmlY/8ky
	 pkq+9z+DgJnG/s6eNErqUddD6X5gvK3/g732qQbJh86jyMRufEsbQM6Zw1GiZ/HKKV
	 lXf+3xAIZwETSPi1NmhGDSsUorOxu/5wfqDfGeUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/290] ARM: dts: samsung: smdkv310: fix keypad no-autorepeat
Date: Wed,  3 Jul 2024 12:39:12 +0200
Message-ID: <20240703102910.633889055@linuxfoundation.org>
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
index c5609afa6101c..a6622a0d9b58b 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -84,7 +84,7 @@ eeprom@52 {
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



