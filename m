Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E65544C6F;
	Thu, 13 Jun 2024 12:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280703; cv=none; b=oWUm/TecB0WcDToUbAInaJLgiZTGCnilfggnXN66nZ+Tgj269G1GKxKEztWQe53JsxKR3+9FyCa5BttWMgm+acAEQmklChPH/XdGlbXncQjNkqxVCMHNJ6881o284qfrg2G9udezKdL4RjGEeleTzw+vAlTKcau1LNdmQIHtJvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280703; c=relaxed/simple;
	bh=kFl/txhKEVmfZFxpuVvzQkwxLE3HKhjdVTkpw8fq1/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSQuW/ZtCxYC0D/qlm7YIQRkOZMpLgUqC4kt1M6vv5mXaBdpK0Pxo4ggwVJlHTYE+HY+NQMxyTl3ha3+majDNjs3Cwcf7CUwair5ncQoSK65Sbohzl8lSAgmmro500IA2qe8GEKFttpKrf08edplaASUBzwXcpYJXYUoowYYW4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ/gZA0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ/gZA0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1276C32786;
	Thu, 13 Jun 2024 12:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280703;
	bh=kFl/txhKEVmfZFxpuVvzQkwxLE3HKhjdVTkpw8fq1/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJ/gZA0w9usM1JgD8L7z4HI03X/6vLzY/dWqqr6n+bqFgSrm8UUnW0+0hrwpT1L+i
	 31MlJ+pSCGSUrkR9VOg//OdTqV/voFwuH29sx0/MxRfyADNTLZQHpI/ESsm5PvJOsA
	 UPrOUU2/aF4hG0z+d4oR/wdgSCdb7uKezW7qAfb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 113/137] ARM: dts: samsung: exynos4412-origen: fix keypad no-autorepeat
Date: Thu, 13 Jun 2024 13:34:53 +0200
Message-ID: <20240613113227.680992148@linuxfoundation.org>
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

commit 88208d3cd79821117fd3fb80d9bcab618467d37b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/samsung/exynos4412-origen.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/samsung/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/samsung/exynos4412-origen.dts
@@ -453,7 +453,7 @@
 &keypad {
 	samsung,keypad-num-rows = <3>;
 	samsung,keypad-num-columns = <2>;
-	linux,keypad-no-autorepeat;
+	linux,input-no-autorepeat;
 	wakeup-source;
 	pinctrl-0 = <&keypad_rows &keypad_cols>;
 	pinctrl-names = "default";


