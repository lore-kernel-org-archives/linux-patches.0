Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046173;
	b=bVLzwa5Mm2NbR6G/UQzqmym4pHfHmxglKHLgzmh6N3vL7UlfS9Imkb2TcYJVQiI2uKcY
	 VWXRJiJtvIujfI8DVc8fnHMtIIw15vwwSAitQffyhQqf5x0qNnHxCpt8uli3NDxcOWEno
	 rQfvVHec4TIOzmKIeZet1dcOe+gVpnV6QfkTnUv6j+Y2pB1KM3318N022DAoHKYbrcwrX
	 GUZbYWgIJPZ0NDz2v1wo+PwzePkqhD3dyW+wlgmlTbddU0fPT/WjvvlUdcB8I/V2yaLmz
	 RNsehLweLvqLCThmZ5gXjgoDOU8AR4eboikX6ZTZeRPR73VvQQ6ZBghfE91t5EKn8Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rJRgCUQsrvDiDcGsLjF/J60lmluxtht2vUg3yIAliSA=;
	b=oime+F+YwFFkapAIhKp+3bSIW6ZFV+JfONDuI09SxOP/V2vo4gJBPCqYZKNHJcsOEg0u
	 An7s+r3HE8XDNpTfbjlWGe1Bt/104ngcpzup01hNvwYL0mGeZeEs+15IL2xAUD9w4pEPF
	 IuHNgPWlqC8JDj2L+/rGfMWs/Aq+SHNPFM7PI5o5gMFnkoEw/Ba2f3nlyIgwX6DCJD3y2
	 H832hOfLbMDCM5+wwXFsrRXr3BtN8/cLYnJfGhKy6RPjtHlBoABxrmZV/cVg/35G/1TyO
	 pcvWPEwqgJ9Fs2WoDTudTNJ4XkYQpx9Ojz/b9x/hG9rzkFalQxl4Xbo/QxjYrzHRSmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K92NpCCI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AC5606A31C;
	Wed, 18 Nov 2026 23:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K92NpCCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF321F000C4;
	Wed, 18 Nov 2026 23:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046172;
	bh=rJRgCUQsrvDiDcGsLjF/J60lmluxtht2vUg3yIAliSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K92NpCCIP2T6ia7gm5ihyYBkhODDZETnTWYPr87zNQiDoDBAgQ7jLFE2HBlvlj5Sf
	 XizOhZn8ok3Y8gPh8rDfH/EydAmrUD2L5EZXve9kwt/qwAL/by5MiV0vo+lbLmqXs1
	 Llh9XePhrGhThFstT43gMVaJ6DCTTIZw0p9bjYHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1186/2857] gpio: pca953x: Preserve wakeup accounting on parent IRQ failure
Date: Wed, 18 Nov 2026 15:37:00 +0100
Message-ID: <20261118150244.308084574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahaj Chaudhari <sahaj123.sc@gmail.com>

[ Upstream commit a38bf551726a21c9bcc001b02164f30378b64b64 ]

pca953x_irq_set_wake() updates wakeup_path before asking the parent
IRQ controller to change its wake state. If irq_set_irq_wake() fails,
the IRQ core rolls back its wake state but the driver's counter remains
changed.

A failed enable can therefore leave the expander marked as part of the
wakeup path when no child IRQ has successfully enabled wakeup. A failed
disable can make the driver stop retaining power even though wakeup is
still enabled. The suspend and resume paths use this counter to decide
whether to disable or enable the regulator.

Update wakeup_path only after the parent operation succeeds, leaving it
unchanged on error.

Fixes: f70fbc15bae2 ("gpio: pca953x: Configure wake-up path when wake-up is enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Fixes: f70fbc15bae2c89f ("gpio: pca953x: Configure wake-up path when wake-up is enabled")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20261018161042.3298045-1-sahaj123.sc@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 2af6027a260f7..4ea19500fa39d 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -739,13 +739,18 @@ static int pca953x_irq_set_wake(struct irq_data *d, unsigned int on)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct pca953x_chip *chip = gpiochip_get_data(gc);
+	int ret;
+
+	ret = irq_set_irq_wake(chip->client->irq, on);
+	if (ret)
+		return ret;
 
 	if (on)
 		atomic_inc(&chip->wakeup_path);
 	else
 		atomic_dec(&chip->wakeup_path);
 
-	return irq_set_irq_wake(chip->client->irq, on);
+	return 0;
 }
 
 static void pca953x_irq_bus_lock(struct irq_data *d)
-- 
2.53.0



