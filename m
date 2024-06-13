Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C544C6F;
	Thu, 13 Jun 2024 12:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280697; cv=none; b=n3Q6UzzZIAICoKmKPw9zQej0Uedl4743FpnmsfkEWRCORX+OtCZtgV3TMtpQQR4iKvvJ10fVbZVriHDdi8l9MM09cpg0IGvc0QU0VooxaqvGYjJM40flwhse9dBTE9cJlii0ATAA4stI1pDbu3CFyRNiiyv3nWjJe4rFYFZLNBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280697; c=relaxed/simple;
	bh=8ybEX3IrBsefmquAzQdP9e5nRLp99qyMq7BbLJbGacc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emhoBc64x0ggm8q3CNTUs4QIibDD5M280o8yDpxDIXld9r6wa1P2iD6V/dqm2kakXoIoaAs2bZjmjqR9li3f2vDdolrcHUwClxPIUF3zuApuAfMB7XxC4Bd6GPt2KD6SJjrrozRdkQtiEezWp3W+vpU8uo/KQJsxmHScbEG77ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTnqgIn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTnqgIn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74CDC2BBFC;
	Thu, 13 Jun 2024 12:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280697;
	bh=8ybEX3IrBsefmquAzQdP9e5nRLp99qyMq7BbLJbGacc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTnqgIn9Zvx4lgn5onRET6x79s8RCU9Bx7nZMdPcrX5WSQx1ENPuMF8BVAjLv8rtm
	 40oDIzc6SThVQ6a3xGWRk9cEInu2PohK4pI/Q6Qto/Iq7QZNztWNd1NAysiSk+7gUX
	 3kgXS6c7MLBQ9yegkNBQ1zJeGvdrP1Dim3q94wCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 111/137] ARM: dts: samsung: smdkv310: fix keypad no-autorepeat
Date: Thu, 13 Jun 2024 13:34:51 +0200
Message-ID: <20240613113227.603958522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


