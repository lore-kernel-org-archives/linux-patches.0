Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038540;
	b=Dyz5MOCwH+NR7easmToKPNcO46ckNhZunPmKxy97iREopmPmuyY3ZHtABn+3fXEqjtQ6
	 /5EbZW3BkU5IPZ1qjJynY+58ZA7eCYcilq0HzFPZqZbMOHWvqJPbOIOZSG1i8IQntWyAv
	 cxmHFFKxytl4eKw4YNT4/dv60lP8ddizv2I6rCTjXFRyWE+5vFTs6PLxkJ8quPSklblIb
	 JmnIQQZPOlW/Rzlvkyz1PvVUeD7Jj4+RgR6VZa5BXVFOZ9fM4iipliPqzRFbFM8Jrqs7V
	 nscQhLHkLqx7jeuZ8hFP63ssuOifb0lyvC1XKr0OD0Tz/09Q24XexuikWPilWCEdqaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2O2NtH/e1bR8S/Q372pC/ElxTPtkNzptCWXvl7+ORZU=;
	b=gRKjvkURHoanZMfZA7NgD7m3xjSzMp2Bn6prD0fawZ5scVf9hxbhoD3GJJoVoYYVkSKo
	 vuuKntsVq1pw7DlUpY+fAziGDWnMEYqelawyYOIXSqsi3qoQhX7dOYduJKUJA2SFipW48
	 aisWKe1aMaSwmGlKhNZ68gDy9wPgkVaasyc/Rdm8CFFtHcGVXUey9qHtn33uw6GqfaDmw
	 PKsRae3zo8iOg8Bz7Qpy0qeXXNyY6l3L2U1Mrz1EpsEQbzbzLGQ97wIryawhSVCXKp8GY
	 40QKUkTLGANxkgvdmzjJAf2L6ftsP0J62whLPiuaCQa6pwa+ieyGTIeEBfX6Wk8+03g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NW9Icice;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D4D606A31C;
	Wed, 18 Nov 2026 21:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NW9Icice
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0581F000C4;
	Wed, 18 Nov 2026 21:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038540;
	bh=2O2NtH/e1bR8S/Q372pC/ElxTPtkNzptCWXvl7+ORZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NW9IciceC4lXCLJ5FsqM2oFSsDwIyE0OtI+aamSUBc+eknUHQeSHtAUtZFldoIkDD
	 yE3HlfVSSGXLOlkGlWUwJP2pq/8gpglTuTbA/Fa2rYxvOe8xQnWyljDBPpVMWKPRdl
	 Cw4XeMz5y8upvs6J6u3r9dfGcefxHGisoZkGi3iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1777/3318] Input: matrix_keypad - remove support for clustered interrupt
Date: Wed, 18 Nov 2026 15:39:59 +0100
Message-ID: <20261118150415.169089410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 5080f62adb126e28d316298505272efea0aed81a ]

There are no users of this functionality in the mainline kernel (it was
only available to boards using platform data and not device tree).
Remove it to simplify the code.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240805014710.1961677-2-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 1527451f87df ("Revert "Input: matrix_keypad - force switch rows to input mode"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/matrix_keypad.c | 61 ++++++++++----------------
 1 file changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 695c03e075b56..9e6837217f441 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -29,7 +29,6 @@ struct matrix_keypad {
 	unsigned int row_shift;
 
 	unsigned int row_irqs[MATRIX_MAX_ROWS];
-	unsigned int num_row_irqs;
 	DECLARE_BITMAP(wakeup_enabled_irqs, MATRIX_MAX_ROWS);
 
 	uint32_t last_key_state[MATRIX_MAX_COLS];
@@ -89,7 +88,7 @@ static void enable_row_irqs(struct matrix_keypad *keypad)
 {
 	int i;
 
-	for (i = 0; i < keypad->num_row_irqs; i++)
+	for (i = 0; i < keypad->pdata->num_row_gpios; i++)
 		enable_irq(keypad->row_irqs[i]);
 }
 
@@ -97,7 +96,7 @@ static void disable_row_irqs(struct matrix_keypad *keypad)
 {
 	int i;
 
-	for (i = 0; i < keypad->num_row_irqs; i++)
+	for (i = 0; i < keypad->pdata->num_row_gpios; i++)
 		disable_irq_nosync(keypad->row_irqs[i]);
 }
 
@@ -226,7 +225,8 @@ static void matrix_keypad_enable_wakeup(struct matrix_keypad *keypad)
 {
 	int i;
 
-	for_each_clear_bit(i, keypad->wakeup_enabled_irqs, keypad->num_row_irqs)
+	for_each_clear_bit(i, keypad->wakeup_enabled_irqs,
+			   keypad->pdata->num_row_gpios)
 		if (enable_irq_wake(keypad->row_irqs[i]) == 0)
 			__set_bit(i, keypad->wakeup_enabled_irqs);
 }
@@ -235,7 +235,8 @@ static void matrix_keypad_disable_wakeup(struct matrix_keypad *keypad)
 {
 	int i;
 
-	for_each_set_bit(i, keypad->wakeup_enabled_irqs, keypad->num_row_irqs) {
+	for_each_set_bit(i, keypad->wakeup_enabled_irqs,
+			 keypad->pdata->num_row_gpios) {
 		disable_irq_wake(keypad->row_irqs[i]);
 		__clear_bit(i, keypad->wakeup_enabled_irqs);
 	}
@@ -303,48 +304,30 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 		gpio_direction_input(pdata->row_gpios[i]);
 	}
 
-	if (pdata->clustered_irq > 0) {
+	for (i = 0; i < pdata->num_row_gpios; i++) {
+		irq = gpio_to_irq(pdata->row_gpios[i]);
+		if (irq < 0) {
+			err = irq;
+			dev_err(&pdev->dev,
+				"Unable to convert GPIO line %i to irq: %d\n",
+				pdata->row_gpios[i], err);
+			return err;
+		}
+
 		err = devm_request_any_context_irq(&pdev->dev,
-				pdata->clustered_irq,
+				irq,
 				matrix_keypad_interrupt,
-				pdata->clustered_irq_flags,
+				IRQF_TRIGGER_RISING |
+					IRQF_TRIGGER_FALLING,
 				"matrix-keypad", keypad);
 		if (err < 0) {
 			dev_err(&pdev->dev,
-				"Unable to acquire clustered interrupt\n");
+				"Unable to acquire interrupt for GPIO line %i\n",
+				pdata->row_gpios[i]);
 			return err;
 		}
 
-		keypad->row_irqs[0] = pdata->clustered_irq;
-		keypad->num_row_irqs = 1;
-	} else {
-		for (i = 0; i < pdata->num_row_gpios; i++) {
-			irq = gpio_to_irq(pdata->row_gpios[i]);
-			if (irq < 0) {
-				err = irq;
-				dev_err(&pdev->dev,
-					"Unable to convert GPIO line %i to irq: %d\n",
-					pdata->row_gpios[i], err);
-				return err;
-			}
-
-			err = devm_request_any_context_irq(&pdev->dev,
-					irq,
-					matrix_keypad_interrupt,
-					IRQF_TRIGGER_RISING |
-						IRQF_TRIGGER_FALLING,
-					"matrix-keypad", keypad);
-			if (err < 0) {
-				dev_err(&pdev->dev,
-					"Unable to acquire interrupt for GPIO line %i\n",
-					pdata->row_gpios[i]);
-				return err;
-			}
-
-			keypad->row_irqs[i] = irq;
-		}
-
-		keypad->num_row_irqs = pdata->num_row_gpios;
+		keypad->row_irqs[i] = irq;
 	}
 
 	/* initialized as disabled - enabled by input->open */
-- 
2.53.0



