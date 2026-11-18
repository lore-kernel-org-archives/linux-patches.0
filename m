Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059708;
	b=htbXoKCBh0KEWxWotWlnWXa9heHYAQH+gFpb/nZaaxRI4PHtLRb0y+kfDQhsi0ORw1x9
	 WZndl94vIgF07nHJ4jEfNdOWodcNfp9HGiA+kJeguW8jKqpmsPUXs8fgAgO0V7pCpRGQn
	 UTuBT4NBq9ye7XNC8FCmirt9h4tjlte6VC6YLwM/+gj6p6XVSQT2ir+bmRRG/K3LZF9lU
	 cDQTGB/kMSCwDMw00ffL/LZBRjcT3lMVgtGRp/E9Ivq7yiqijWS0jmCvk8D04uFDVQboY
	 PYwr/d2anrUcfJYEUxq9Varpol/HpFwF5HbnXWdTrZms1Tvy52v9ZFVUfpFYctTEDtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H3H10TqYEq2F8vNGzF6BcijB8PiOt7LFkzFClZM9ybI=;
	b=ECqFNss0O6Oq8jhQ2N+JrkNXcyURa2mosvwx60dTn0HkytL/Pt+cQEvsQW8rbtzNVKsz
	 RkNsfNCUfalo73Rpx8t1uCS3oT15RZ6mBAJVYJHVdv8Vy/XNW7/NHoZy8eD3j+lALm7ui
	 Hcrh0ihvMZvpifv/yWOckQbhl+PsA5Cz1tvaiUs5Ry7aPTxyniq925KuXpmkWGczfSjDZ
	 5zwv2ww47a8Y+DVv7aYJks3GwbvCjN/K+a/FnG28kb+WXWY63KJnPbMyzbgpXRRcXtpVP
	 W8rMjIlgrFTgSnPqPcXTp2wB8Vn9ZwRXSxQ4jsEaORAFF5nubuHYBtL2m8FNImKG5Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeO3sP78;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7958B606A320;
	Thu, 19 Nov 2026 03:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeO3sP78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE771F000C4;
	Thu, 19 Nov 2026 03:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059708;
	bh=H3H10TqYEq2F8vNGzF6BcijB8PiOt7LFkzFClZM9ybI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeO3sP78iQPydPQS00v+VX1lQmGKUlozr1oLV+YeJA702vwhQkbNm3+sJDL3rN0jU
	 6MDP3sU9E3k9FpaydtIvjic6TR/dF93LK1++N9wEuKcbMno0c7tx4+XPtfEZSW5Iqs
	 uz89ofjU7+cPqJhSRAndcdKDgO7iL+ypbgskNda8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0939/1848] gpio: pca953x: Handle direction register read errors in IRQ paths
Date: Wed, 18 Nov 2026 15:49:37 +0100
Message-ID: <20261118145956.202313365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahaj Chaudhari <sahaj123.sc@gmail.com>

[ Upstream commit a0fe269293509acdd93b9cfb3f46636f7b91b33a ]

Three IRQ paths ignore the result of reading the direction registers
and then use the destination bitmap. pca953x_read_regs() does not populate
that bitmap when regmap_bulk_read() fails, leaving the callers to use
uninitialized stack data.

This can select incorrect GPIOs for direction changes during IRQ bus
synchronization, corrupt the saved input state during IRQ setup, or
produce incorrect pending interrupt decisions.

Check the read result at all three sites. Release irq_lock without
changing GPIO directions on failure, leave the IRQ history untouched
when pending detection fails, and propagate the error from IRQ setup.
The read helper already logs the error.

Fixes: 0f25fda840a9 ("gpio: pca953x: Zap ad-hoc reg_direction cache")
Cc: stable@vger.kernel.org
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Link: https://patch.msgid.link/20261018165003.3372368-1-sahaj123.sc@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 5d71e453dc1c2..7d0c6d7303aa0 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -672,6 +672,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(irq_mask, MAX_LINE);
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
+	int ret;
 
 	if (chip->driver_data & PCA_PCAL) {
 		/* Enable latch on interrupt-enabled inputs */
@@ -684,7 +685,9 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	}
 
 	/* Switch direction to input if needed */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		goto out;
 
 	bitmap_or(irq_mask, chip->irq_trig_fall, chip->irq_trig_raise, gc->ngpio);
 	bitmap_complement(reg_direction, reg_direction, gc->ngpio);
@@ -694,6 +697,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	for_each_set_bit(level, irq_mask, gc->ngpio)
 		pca953x_gpio_direction_input(&chip->gpio_chip, level);
 
+out:
 	mutex_unlock(&chip->irq_lock);
 }
 
@@ -740,7 +744,9 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 		return false;
 
 	/* Remove output pins from the equation */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		return false;
 
 	bitmap_copy(old_stat, chip->irq_stat, gc->ngpio);
 
@@ -828,7 +834,9 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	 * interrupt.  We have to rely on the previous read for
 	 * this purpose.
 	 */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		return ret;
 	bitmap_and(chip->irq_stat, irq_stat, reg_direction, gc->ngpio);
 	mutex_init(&chip->irq_lock);
 
-- 
2.53.0



