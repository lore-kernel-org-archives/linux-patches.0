Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CA97E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2E9C433C1;
	Wed,  2 Nov 2022 02:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357164;
	bh=e/a82m/TKHuDJwPxoon1ldFJACjRTzMLgoSdAKSF3Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bi+jGOn8T1FL4JuHRy0oRW0ZCnjU52cGDJEu67vZY6aYtvMUEnTdGCFvlIxC5NnIM
	 eQgad8diA/8jE6vRZ8X9DufIGEqsyAx0SasaK/U2+Oqa/CV/uvwvWt6QS7SVOdEN2j
	 7xWOvVnoXx3AtoMizcKOs7VpYb6lMw3xNvVUnVCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siarhei Volkau <lis8215@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.0 095/240] pinctrl: Ingenic: JZ4755 bug fixes
Date: Wed,  2 Nov 2022 03:31:10 +0100
Message-Id: <20221102022113.543457639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siarhei Volkau <lis8215@gmail.com>

commit 17747577bbcb496e1b1c4096d64c2fc1e7bc0fef upstream.

Fixes UART1 function bits and MMC groups typo.

For pins 0x97,0x99 function 0 is designated to PWM3/PWM5
respectively, function is 1 designated to the UART1.

Diff from v1:
 - sent separately
 - added tag Fixes

Cc: stable@vger.kernel.org
Fixes: b582b5a434d3 ("pinctrl: Ingenic: Add pinctrl driver for JZ4755.")
Tested-by: Siarhei Volkau <lis8215@gmail.com>
Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
Link: https://lore.kernel.org/r/20221016153548.3024209-1-lis8215@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-ingenic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -667,7 +667,7 @@ static u8 jz4755_lcd_24bit_funcs[] = { 1
 static const struct group_desc jz4755_groups[] = {
 	INGENIC_PIN_GROUP("uart0-data", jz4755_uart0_data, 0),
 	INGENIC_PIN_GROUP("uart0-hwflow", jz4755_uart0_hwflow, 0),
-	INGENIC_PIN_GROUP("uart1-data", jz4755_uart1_data, 0),
+	INGENIC_PIN_GROUP("uart1-data", jz4755_uart1_data, 1),
 	INGENIC_PIN_GROUP("uart2-data", jz4755_uart2_data, 1),
 	INGENIC_PIN_GROUP("ssi-dt-b", jz4755_ssi_dt_b, 0),
 	INGENIC_PIN_GROUP("ssi-dt-f", jz4755_ssi_dt_f, 0),
@@ -721,7 +721,7 @@ static const char *jz4755_ssi_groups[] =
 	"ssi-ce1-b", "ssi-ce1-f",
 };
 static const char *jz4755_mmc0_groups[] = { "mmc0-1bit", "mmc0-4bit", };
-static const char *jz4755_mmc1_groups[] = { "mmc0-1bit", "mmc0-4bit", };
+static const char *jz4755_mmc1_groups[] = { "mmc1-1bit", "mmc1-4bit", };
 static const char *jz4755_i2c_groups[] = { "i2c-data", };
 static const char *jz4755_cim_groups[] = { "cim-data", };
 static const char *jz4755_lcd_groups[] = {


