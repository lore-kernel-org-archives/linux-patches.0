Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038690;
	b=sFN6vKmhMTPAedYeQ0lg3c/cBznUaIiQ/Ja7652nGylNG3wrAbcrAp6mIOU/oktmyL/T
	 y7vEvXsR9ToZoClSQZViS6FxKORpqDEF+aLVkYionyRvVRsMFgn0xOVOSe94786vYVu1Z
	 6rD9NOoVBJSevXtFHiFQ54u2VXl8fQbGR3t+y0aXFTQp/S7WZAzMuU5kBqLGpzPBhb1u7
	 TBeqiol1oqAUNhSx+2ZrtB2GkXycGOezEJ0t98ptG9cz7/G5Yt79cZXbVF3UT+DbDoluK
	 gT7OGG/zJs6f1rGTBCqZ01rAK99GXwLFBsuRNCQ9KunvYC9UQ94YrHIwv+iYOxoLE4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ycVP1Rb5f2wcVNQt9ZITjAPQ4LhUI3geEpOeJzULxq8=;
	b=IGPbIMBK8F764P5J3JhM7uBRxxYyG1YvnqcTfyCC1qep0MbbSVOFRk0cFbynZJDxxsfP
	 uCnVEwCS1PXW7rcu0x5NTSawLOeKSTCKnGoAF99SR3Xr42RFza2QY2XdxNOerYmnxjbSL
	 IDBWNeEimZEwlg6VqsYcs39aAStvkbY88fUgGCLNNZrQ/WLGJQng1YKqGpjKfUF+Vb5PZ
	 5Twq7sGyIys1AxVdqtgg2PWQtpnDLUjl7KbbMsNOgW7IaFVD1vSd123h9bVPtq8JehLE0
	 0L6USsM6PgeZtu+RGe5u7w2FVBnQLK2v0aLchkJs5v4hsOy2OfZMMdlNiHErMBCCykA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Qit/FPPv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7263606A31C;
	Wed, 18 Nov 2026 21:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qit/FPPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6C51F000C4;
	Wed, 18 Nov 2026 21:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038690;
	bh=ycVP1Rb5f2wcVNQt9ZITjAPQ4LhUI3geEpOeJzULxq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qit/FPPv+QLGYvXlpKXxaKxhhypnwnhk8nIAj7RAIWt5OPEGOub+1FFNxsS402oph
	 r4O4sqoVH0MjccD2IH/9ZnPc9o+5qeHhY8X93mf++sU6qFIQfsG287jsv0Ua1SUU3X
	 VhGRg0mAK6XYgCq6UZL4b0bDHDwqkjKSnOgSe1zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1781/3318] gpio: pca953x: Handle direction register read errors in IRQ paths
Date: Wed, 18 Nov 2026 15:40:03 +0100
Message-ID: <20261118150415.290616444@linuxfoundation.org>
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
index 6384c0760e0ee..dacb936ead643 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -763,6 +763,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(irq_mask, MAX_LINE);
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
+	int ret;
 
 	guard(mutex)(&chip->i2c_lock);
 
@@ -777,7 +778,9 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	}
 
 	/* Switch direction to input if needed */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		goto out;
 
 	bitmap_or(irq_mask, chip->irq_trig_fall, chip->irq_trig_raise, gc->ngpio);
 	bitmap_or(irq_mask, irq_mask, chip->irq_trig_level_high, gc->ngpio);
@@ -789,6 +792,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	for_each_set_bit(level, irq_mask, gc->ngpio)
 		pca953x_gpio_direction_input_unlocked(&chip->gpio_chip, level);
 
+out:
 	mutex_unlock(&chip->irq_lock);
 }
 
@@ -883,7 +887,9 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 	}
 
 	/* Remove output pins from the equation */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		return false;
 
 	bitmap_copy(old_stat, chip->irq_stat, gc->ngpio);
 
@@ -984,7 +990,9 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
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



