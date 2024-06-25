Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2983913C90B;
	Tue, 25 Jun 2024 10:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309748; cv=none; b=OYYjCywuWeaT82letB6sSrVKOAok0gC4VlzEBxwXKb/cDaompQlEp9L6jm+glJFQIJV1//rR8mRx9zBqdnyOTX2nTZxOFaL3/nvJD2PWQ45JzAB0oAG4eCRZxMC51jVOY1YXOAMLNtBf+CPb4t/tOevdXduyYFvp4u9YfrAwPHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309748; c=relaxed/simple;
	bh=LMWlORGywd9cKR/C3ZTixaRfFa43FDsZ0BKghhZOLjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcym7Gxqb4Z/26OYbXMpoCY7riD3Yb94q2+6oq3kqFPkn3dsxH1407eNkMAjz/19ssr1iY8GmVj+88RmqFowXnJxUgpEs0UajCAaGJ70kk72f4YTE7Lh8eelRZUDN3xB1lNCbwmcN9xXxS1AoH/qZryFPD+5YslBwDVDVL3QETE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeN4YVYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeN4YVYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D65C32781;
	Tue, 25 Jun 2024 10:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309748;
	bh=LMWlORGywd9cKR/C3ZTixaRfFa43FDsZ0BKghhZOLjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeN4YVYbVfycuTqTBEUaozFGqBtB0xPiPqwEs/YRjk2g4v99/cU/V116vbOmhJoOw
	 hTBO8EPR5cYIOUxUx4XaL5znFPrScWf9R8wikrOLjgf5oTON1Rq3jQdNSp+IQS/7Wr
	 ppo0FC/etGyEhGQlhF0/iGrr+F20LwSh8QNaGuNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/131] ARM: dts: samsung: exynos4412-origen: fix keypad no-autorepeat
Date: Tue, 25 Jun 2024 11:34:35 +0200
Message-ID: <20240625085530.495383739@linuxfoundation.org>
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
index a3905e27b9cd9..473aad848848a 100644
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



