Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2472D3806C0;
	Wed, 21 Jan 2026 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020452; cv=none; b=PXcwmSNsFMtPDOAVbexq6P/t6xnrmpoQQ6MKLvXrPqEJMj7sYG1tj0fwqSyV7aBoM7AKNQ52Hc2Z641F0kbCxVY/kknhbAMEJO7gIowqyjro9X9onm9rNDcgIyr7MF1Nvo016Wi0m8ZrX9aSfSENJB7TSgYMWP2glA6SLomJxwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020452; c=relaxed/simple;
	bh=C/9BptnND1jYj8X1acAPFlhncO0lA+J4pu9dCrqHT5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHDNk8CUQ3VMfGNboIPyHW2lox3H/b14oyegr6paMbdQh/8EYHzauLqIH01EzOHxSsm33kpZsHhrdyQOLhhJeYFlkB/bfE/SjRU3KS0XFu5VogPWTpwthHgbsfL7kTLPui2rOOWUcCw7LyOoNdeBe53ZEi0/PMjmD+/iYenIUE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmyb9caC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmyb9caC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328A9C4CEF1;
	Wed, 21 Jan 2026 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020451;
	bh=C/9BptnND1jYj8X1acAPFlhncO0lA+J4pu9dCrqHT5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmyb9caCZP9/yezEA50N2ERGQ6QGyhLsKh9R09f5wanUNKv5wo7oiH6WnXNZKIanA
	 jfh13tkipXlHXKpgLvZzUO20AQNqyhIsWZ3p5J+usQ2YHs4ePSQY+GKjuMP+thMRmo
	 DZLsjT6+Q1ojpSIocqaXKRlLJfjQH5NK0S7pAI30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 162/198] LoongArch: dts: loongson-2k1000: Fix i2c-gpio node names
Date: Wed, 21 Jan 2026 19:16:30 +0100
Message-ID: <20260121181424.380892866@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


