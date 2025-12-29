Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C9F332ECC;
	Mon, 29 Dec 2025 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026016; cv=none; b=eDwzaBZlR3mORqAGPF1Ex8DnIAa+E64Ck2jo4iUW0hdZ47daDASUdWWf/tNyxQ1smkogbXWw6ZdyNg2PYHZjS7niQMJTX7Qu0K73+Q94uqJ61C/mRZhZOvJDQBOP+jCR7JOHQ+Lifkb/+ALV06HHKHLgfP3UMrEv/xW7q5H53AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026016; c=relaxed/simple;
	bh=tmEX3SiO+uGMJJanQPYmaWfv/ItUL0+wcmeALGjGu5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR72i+MPxFTn1iimkG2DnaKj3m3+33h8gH1sDBFRzxzS1U1bYkNZIQbjxcDD2TNsakd9rfHH9sCX4BmR9F0xM/1zlWAECke5VsYCLcUXv2YLOGTAx00hVJze/hV6fP80hPd+fAjnNX3OW6qoMpUU2XZAp44XZMQeLfkkhfXETsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3MzkeIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3MzkeIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3CEC4CEF7;
	Mon, 29 Dec 2025 16:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026016;
	bh=tmEX3SiO+uGMJJanQPYmaWfv/ItUL0+wcmeALGjGu5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3MzkeIWKhoP9Nnjf7rJfOO5kPP359/gi6dAhjbLtZghfEjjzm2nghl735tjSEkGf
	 uFsWfVvns75t++FPIjWSYmGNoTfcgUp5yHET8pLIzyA0L3LmpNGAuUc6StJZPprB7T
	 t0A/WN99TbrguuPO6nizobAhj4CRNSz8eq3KRWc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.18 384/430] gpio: loongson: Switch 2K2000/3000 GPIO to BYTE_CTRL_MODE
Date: Mon, 29 Dec 2025 17:13:06 +0100
Message-ID: <20251229160738.452682162@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Xi Ruoyao <xry111@xry111.site>

commit dae9750105cf93ac1e156ef91f4beeb53bd64777 upstream.

The manuals of 2K2000 says both BIT_CTRL_MODE and BYTE_CTRL_MODE are
supported but the latter is recommended.  Also on 2K3000, per the ACPI
DSDT the GPIO controller is compatible with 2K2000, but it fails to
operate GPIOs 62 and 63 (and maybe others) using BIT_CTRL_MODE.
Using BYTE_CTRL_MODE also makes those 2K3000 GPIOs work.

Fixes: 3feb70a61740 ("gpio: loongson: add more gpio chip support")
Cc: stable@vger.kernel.org
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20251128075033.255821-1-xry111@xry111.site
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-loongson-64bit.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpio-loongson-64bit.c
+++ b/drivers/gpio/gpio-loongson-64bit.c
@@ -407,11 +407,11 @@ static const struct loongson_gpio_chip_d
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data1 = {
 	.label = "ls2k2000_gpio",
-	.mode = BIT_CTRL_MODE,
-	.conf_offset = 0x0,
-	.in_offset = 0x20,
-	.out_offset = 0x10,
-	.inten_offset = 0x30,
+	.mode = BYTE_CTRL_MODE,
+	.conf_offset = 0x800,
+	.in_offset = 0xa00,
+	.out_offset = 0x900,
+	.inten_offset = 0xb00,
 };
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data2 = {


