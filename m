Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B937318138;
	Wed, 21 Jan 2026 18:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019779; cv=none; b=ISqJsKq/UMWFcm4Qj9wwUtUQWKcxmrHw8dFErnvB+v6XYraQ+YM1mvLkzAMfLq6JWEOK24BeFvuLemeKEmPEyAjYAbUnSFl0o6iagGW5H2rlY/OLXKlqm8vNYX0c7ls4IdXCRx9X1lgYqfwYCSOlOioprV2T2mmNQ/0Nc8fzZX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019779; c=relaxed/simple;
	bh=4U1zRnlmhFAlZ5+ndinJU1jisJ1oYUOebfg4F1vtrn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLssstultHqmUfe26YAJM3jMrdGsgvdv1AimSqtnUiLt/WtesrLUHw8zdUWndOevhhK+XV3kD75bmoNpQt8CbtnGeT/SJp9dNTcLkDJfP8ipF5UINdqqbYlf2DfYwYGhEP6kbdK0f+WCS5B7VvoQGa2QuEHUUI4Y1v+ZgcEx9HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHwF7b9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHwF7b9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D2BC4CEF1;
	Wed, 21 Jan 2026 18:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019778;
	bh=4U1zRnlmhFAlZ5+ndinJU1jisJ1oYUOebfg4F1vtrn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHwF7b9xfrC6iUbkYqE96joJZxeiTHdXnEkwMGhrm1dzevq1Bk+28ECprZYr02WZ8
	 qAMdBLZZh1P5Jg36arVqQ1uP4QRm89sA6Wu7TwAkZ7iOtPPOJ0ODr3UDOsiGalnOha
	 mqmweRfA+DgbZsCPl/0BybnsJft9I7FI0Ww+A0Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 106/139] LoongArch: dts: loongson-2k1000: Fix i2c-gpio node names
Date: Wed, 21 Jan 2026 19:15:54 +0100
Message-ID: <20260121181415.263546343@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit 14ea5a3625881d79f75418c66e3a7d98db8518e1 upstream.

The binding wants the node to be named "i2c-number", but those are named
"i2c-gpio-number" instead.

Thus rename those to i2c-0, i2c-1 to adhere to the binding and suppress
dtbs_check warnings.

Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/boot/dts/loongson-2k1000.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/boot/dts/loongson-2k1000.dtsi
+++ b/arch/loongarch/boot/dts/loongson-2k1000.dtsi
@@ -46,7 +46,7 @@
 	};
 
 	/* i2c of the dvi eeprom edid */
-	i2c-gpio-0 {
+	i2c-0 {
 		compatible = "i2c-gpio";
 		scl-gpios = <&gpio0 0 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 		sda-gpios = <&gpio0 1 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
@@ -57,7 +57,7 @@
 	};
 
 	/* i2c of the eeprom edid */
-	i2c-gpio-1 {
+	i2c-1 {
 		compatible = "i2c-gpio";
 		scl-gpios = <&gpio0 33 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 		sda-gpios = <&gpio0 32 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;


