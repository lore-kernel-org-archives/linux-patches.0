Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063530;
	b=oarPxGV2xeIlC7mDiQO+NLpzq7Davy3CcW2t1UAvFc+BuCXJebFSHKvfToO1rh34oQM3
	 /Pngp7cbspyyaYNSPQPoMHs5tTbvO9Q0cUoDRzM7MlXaqedqkniX4qYEEEe6m55zdZC8s
	 4j/1296l3Q6kGYw5TsEvGZw8/anQh42Lx/M/jxdfE2Y7ELvWxU5d8ERSYkvXDKbBflm+i
	 lyVJwJ1FCDX5OaEILrZIEu7+4JWP8z+jRJmuM0b9QfAXVB1EgF/kuNLDZwca9bjjvDxZW
	 meVInp4jSPAfQtxEFwdzYYkG5iMB0CBga7g3KJGO9ct9pAjkUbjZXufbLqHcl8lJk+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cWYwOer8SWkeCQ0wdfBSpYeRygcnBVnunVjbM3DmPZs=;
	b=re6qyS3r6cBysI3ZXwDKt4A/UpxgUKrPsoolbMgoSVYoiLCY/3oqm/hGVQRHvoyL3637
	 4F1PQTZ20lE1XixIuiNK4Xr2IfR+pYbp97yYEfIdn9IBJHQP9DjPXnoIooDSmu6vn45gH
	 ujSN14lnr569rWKG/BuT08dFPGFgpLDOyRc3BJTa26J6NgODKdiNGrZ23tRBHQBq5cbTY
	 a1dyeyoGJfUNrUmH047psfmU5Hw6sgZ3FnxNs6BHgBpxmc0EqP0/pU/zC9Pm/zyQsfQxx
	 FEXQKVq1fTYnEqC/OOw0c1u+S1py/RKUjHRhOwLr5F1/PRxjATJY84fh8daSVOq7ugw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KN/OziHH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F079C606B8BD;
	Sat,  7 Nov 2026 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KN/OziHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558B51F008A2;
	Sat,  7 Nov 2026 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063529;
	bh=cWYwOer8SWkeCQ0wdfBSpYeRygcnBVnunVjbM3DmPZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KN/OziHHEEifX02FZCvbGJ9S8dxTjyQrkT8qaKGfCp1XztiaIivRZQeEZrV9RElpp
	 6ZQr4kdXYPgamqzv8baagOzW1UVw4OW+qrOBH7wRQQ7wd/9q9oBnFjc70YMWte7l/0
	 hGvNL5F3aFLNf2ixF9r9/avQdrNQXbTbqIyze8CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 668/869] gpio: pca953x: Handle direction register read errors in IRQ paths
Date: Sat,  7 Nov 2026 08:55:50 -0500
Message-ID: <20261107134915.776865980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4eeac12ad0ed3..7ebc4f9662c91 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -863,6 +863,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(irq_mask, MAX_LINE);
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
+	int ret;
 
 	guard(mutex)(&chip->i2c_lock);
 
@@ -877,7 +878,9 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	}
 
 	/* Switch direction to input if needed */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		goto out;
 
 	bitmap_or(irq_mask, chip->irq_trig_fall, chip->irq_trig_raise, gc->ngpio);
 	bitmap_or(irq_mask, irq_mask, chip->irq_trig_level_high, gc->ngpio);
@@ -889,6 +892,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	for_each_set_bit(level, irq_mask, gc->ngpio)
 		pca953x_gpio_direction_input_unlocked(&chip->gpio_chip, level);
 
+out:
 	mutex_unlock(&chip->irq_lock);
 }
 
@@ -983,7 +987,9 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 	}
 
 	/* Remove output pins from the equation */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		return false;
 
 	bitmap_copy(old_stat, chip->irq_stat, gc->ngpio);
 
@@ -1084,7 +1090,9 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
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



