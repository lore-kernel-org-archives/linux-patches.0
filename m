Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038538;
	b=w8qQcGWwauvPiKnRrWxZ676HihN3LuAK8yytFYIRzil7IWQG+81rccPpLyIXIWvQCNcv
	 eGprWeWJe5RvfkRYALtSTJ101wL0TC7t4ygtObiQ96UvCmMLEd1lPl8F9L8d/+df6R9NG
	 bL1BuCgf3lqk0+/Vdub2DMxhGOFBPTttaLqParEntmO4CbNBliqprUmkGjajLrp6KmUI8
	 Wr/HuraAUNocM4lU5zFd03rm7Kmlaw9w4X+RwmBNbC4GGjlCOC0XY6FcD81S/fLKzHevH
	 LkjnqN1gIW9xWDARXQCcyHRi1IVloYolz3ITuxgPQvfmZxHq+8Y/NIdDNbFRSkLnrXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/R751FKo50WsMaQGVDcpb2qen8lbcBWlVA1EHDBE9Ss=;
	b=S4QRqpbtnmeajReoAES1P2vSsWp34NgO5EmGSYPVauOu3qksQOSPXFg3Y3kuMLZUIBum
	 TC5dweKoi/13F4zCKL25btH+QGEzogOTAknZ7Xgb4/gQVVH0zCoOi363VzXcRRs0FmPma
	 vxx0A7oKQyKyniSDHeUQR0B6NmQsgUhRPcCmAWNTnlL1rf5h73TZC0zQEE4KG14ubjvxy
	 kRPava09Bfq58uwYyYRUTbbwHMKh2rBUeZbkJ7lWdy84nFxHbm0+NGdQKRBZMD2EXVVHn
	 p2tV1WKlV6e08ZWp41bmP1cFRDsTf25Gc1TwH02q4wG1te1Zfx1STrFl+5izBEM1/0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CybyTmQS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AA3606A320;
	Wed, 18 Nov 2026 21:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CybyTmQS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4571F000C4;
	Wed, 18 Nov 2026 21:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038537;
	bh=/R751FKo50WsMaQGVDcpb2qen8lbcBWlVA1EHDBE9Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CybyTmQSkSx3cGdcLgeDk0oOSkAx2UxZi2SrluBO4+ZQ4Wum26dHNCKviIRvi0f2i
	 E+MUEKd5f+LjN4lNQN3eB/CVTaQom+iCnO7nckNonkbPjcLbTCLc9+eUgK5CFyiRQi
	 AQxFZYmuZU/00NuUVRsxBRLMI2LjdU5UZiOJca8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1776/3318] Input: matrix_keypad - switch to using managed resources
Date: Wed, 18 Nov 2026 15:39:58 +0100
Message-ID: <20261118150415.140435694@linuxfoundation.org>
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

[ Upstream commit 7d0f351da46098b3bbb147f886f059473b84ff48 ]

Switch the drivers to use managed resources (devm) to simplify error
handling and remove the need to have remove() implementation.

Link: https://lore.kernel.org/r/20240121053232.276968-3-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 1527451f87df ("Revert "Input: matrix_keypad - force switch rows to input mode"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/matrix_keypad.c | 89 +++++++-------------------
 1 file changed, 24 insertions(+), 65 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 44ef600b8f191..695c03e075b56 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -278,38 +278,41 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 
 	/* initialized strobe lines as outputs, activated */
 	for (i = 0; i < pdata->num_col_gpios; i++) {
-		err = gpio_request(pdata->col_gpios[i], "matrix_kbd_col");
+		err = devm_gpio_request(&pdev->dev,
+					pdata->col_gpios[i], "matrix_kbd_col");
 		if (err) {
 			dev_err(&pdev->dev,
 				"failed to request GPIO%d for COL%d\n",
 				pdata->col_gpios[i], i);
-			goto err_free_cols;
+			return err;
 		}
 
 		gpio_direction_output(pdata->col_gpios[i], !pdata->active_low);
 	}
 
 	for (i = 0; i < pdata->num_row_gpios; i++) {
-		err = gpio_request(pdata->row_gpios[i], "matrix_kbd_row");
+		err = devm_gpio_request(&pdev->dev,
+					pdata->row_gpios[i], "matrix_kbd_row");
 		if (err) {
 			dev_err(&pdev->dev,
 				"failed to request GPIO%d for ROW%d\n",
 				pdata->row_gpios[i], i);
-			goto err_free_rows;
+			return err;
 		}
 
 		gpio_direction_input(pdata->row_gpios[i]);
 	}
 
 	if (pdata->clustered_irq > 0) {
-		err = request_any_context_irq(pdata->clustered_irq,
+		err = devm_request_any_context_irq(&pdev->dev,
+				pdata->clustered_irq,
 				matrix_keypad_interrupt,
 				pdata->clustered_irq_flags,
 				"matrix-keypad", keypad);
 		if (err < 0) {
 			dev_err(&pdev->dev,
 				"Unable to acquire clustered interrupt\n");
-			goto err_free_rows;
+			return err;
 		}
 
 		keypad->row_irqs[0] = pdata->clustered_irq;
@@ -322,10 +325,11 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 				dev_err(&pdev->dev,
 					"Unable to convert GPIO line %i to irq: %d\n",
 					pdata->row_gpios[i], err);
-				goto err_free_irqs;
+				return err;
 			}
 
-			err = request_any_context_irq(irq,
+			err = devm_request_any_context_irq(&pdev->dev,
+					irq,
 					matrix_keypad_interrupt,
 					IRQF_TRIGGER_RISING |
 						IRQF_TRIGGER_FALLING,
@@ -334,7 +338,7 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 				dev_err(&pdev->dev,
 					"Unable to acquire interrupt for GPIO line %i\n",
 					pdata->row_gpios[i]);
-				goto err_free_irqs;
+				return err;
 			}
 
 			keypad->row_irqs[i] = irq;
@@ -345,36 +349,8 @@ static int matrix_keypad_init_gpio(struct platform_device *pdev,
 
 	/* initialized as disabled - enabled by input->open */
 	disable_row_irqs(keypad);
-	return 0;
-
-err_free_irqs:
-	while (--i >= 0)
-		free_irq(keypad->row_irqs[i], keypad);
-	i = pdata->num_row_gpios;
-err_free_rows:
-	while (--i >= 0)
-		gpio_free(pdata->row_gpios[i]);
-	i = pdata->num_col_gpios;
-err_free_cols:
-	while (--i >= 0)
-		gpio_free(pdata->col_gpios[i]);
-
-	return err;
-}
-
-static void matrix_keypad_free_gpio(struct matrix_keypad *keypad)
-{
-	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
-	int i;
-
-	for (i = 0; i < keypad->num_row_irqs; i++)
-		free_irq(keypad->row_irqs[i], keypad);
-
-	for (i = 0; i < pdata->num_row_gpios; i++)
-		gpio_free(pdata->row_gpios[i]);
 
-	for (i = 0; i < pdata->num_col_gpios; i++)
-		gpio_free(pdata->col_gpios[i]);
+	return 0;
 }
 
 #ifdef CONFIG_OF
@@ -473,12 +449,13 @@ static int matrix_keypad_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	keypad = kzalloc(sizeof(struct matrix_keypad), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!keypad || !input_dev) {
-		err = -ENOMEM;
-		goto err_free_mem;
-	}
+	keypad = devm_kzalloc(&pdev->dev, sizeof(*keypad), GFP_KERNEL);
+	if (!keypad)
+		return -ENOMEM;
+
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!input_dev)
+		return -ENOMEM;
 
 	keypad->input_dev = input_dev;
 	keypad->pdata = pdata;
@@ -489,7 +466,6 @@ static int matrix_keypad_probe(struct platform_device *pdev)
 
 	input_dev->name		= pdev->name;
 	input_dev->id.bustype	= BUS_HOST;
-	input_dev->dev.parent	= &pdev->dev;
 	input_dev->open		= matrix_keypad_start;
 	input_dev->close	= matrix_keypad_stop;
 
@@ -499,7 +475,7 @@ static int matrix_keypad_probe(struct platform_device *pdev)
 					 NULL, input_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to build keymap\n");
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	if (!pdata->no_autorepeat)
@@ -509,32 +485,16 @@ static int matrix_keypad_probe(struct platform_device *pdev)
 
 	err = matrix_keypad_init_gpio(pdev, keypad);
 	if (err)
-		goto err_free_mem;
+		return err;
 
 	err = input_register_device(keypad->input_dev);
 	if (err)
-		goto err_free_gpio;
+		return err;
 
 	device_init_wakeup(&pdev->dev, pdata->wakeup);
 	platform_set_drvdata(pdev, keypad);
 
 	return 0;
-
-err_free_gpio:
-	matrix_keypad_free_gpio(keypad);
-err_free_mem:
-	input_free_device(input_dev);
-	kfree(keypad);
-	return err;
-}
-
-static void matrix_keypad_remove(struct platform_device *pdev)
-{
-	struct matrix_keypad *keypad = platform_get_drvdata(pdev);
-
-	matrix_keypad_free_gpio(keypad);
-	input_unregister_device(keypad->input_dev);
-	kfree(keypad);
 }
 
 #ifdef CONFIG_OF
@@ -547,7 +507,6 @@ MODULE_DEVICE_TABLE(of, matrix_keypad_dt_match);
 
 static struct platform_driver matrix_keypad_driver = {
 	.probe		= matrix_keypad_probe,
-	.remove_new	= matrix_keypad_remove,
 	.driver		= {
 		.name	= "matrix-keypad",
 		.pm	= pm_sleep_ptr(&matrix_keypad_pm_ops),
-- 
2.53.0



