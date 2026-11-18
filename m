Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057730;
	b=oa0/79paxQAyoeuU3EdRJb3vR/75UN/+iocg8ahDD9jOhIyxIaC1olCGUSJXElVhy95F
	 R58sAtEtpO9FJ0iy7LWYD51CDnkyZQgU/gHiehUyIJ2kUhQhW066D+odZiaZPt5cwFSWw
	 VaJ3mvMHhv34qDHZD3v6jreww5YWZK6GBZYitY9HKYj7pomOekX1S1kIM/zbP8XylkIRx
	 X48i3mFRbVdqthHESnLsGgjnu2UQ+D/o199sWzGOb8XAnL1CrojUWEcIkUKm4J5haM4eT
	 KLd0klfRg9PFf892VWBRsWxxzlQ5VfEVbuTA2zL+moY2TXlf8gD0O6h9StnEFVV+eQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c6DiucTxDDhVR8hptaKh2kNGg+EgmtLs5SryrlXymxY=;
	b=udPJPqnL6mJojTMsZdymqgk+BZA854LNd2s0CxI5N/MAwZ2fdnuNtRZPFm+cwMxkAUe4
	 aT3JB9j3/bjyvj8jdbKNE6sBYipZmH8nSpsnPtouRgN+5TZ6wS+Sv+pL6feCHkaVROo2M
	 ZXbXMJMcljny4hZl2lDU6WcP6Mdieuv8XHaT2Qw/lNya9miDueNHrV+nGFgewhoSv1QAR
	 va43cnpEK3y1mZ9pfrJTTjpIwEUNbyJUScYDi2v5FvnJY/bZVGw8+dMCDUr4zlk1IC5ov
	 OJT/aaXPXRBPGNpAkDJzMUidB0JGoFApabek3XQSeJCakR7bnzAJgvRl5J+hQZj3m6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiKkkv5A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FB7606A320;
	Thu, 19 Nov 2026 03:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiKkkv5A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293DE1F000C4;
	Thu, 19 Nov 2026 03:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057729;
	bh=c6DiucTxDDhVR8hptaKh2kNGg+EgmtLs5SryrlXymxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aiKkkv5AanDIaG8pCAxTLoaqdkoNzFIEz1yVMy7mW6uh0RvMsMEMsweo3Hm8zAoEF
	 c1830xhq1WBBjco9JL4k2j2UHuMrm/n8PzLz/uUtjMi928h2FfcKM3RHK9PlKvFZMo
	 JJBTjsmGcmKdx8Xbe5jk19sGrDIEw/5aA7rZihRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Riwen Lu <luriwen@kylinos.cn>,
	xiongxin <xiongxin@kylinos.cn>,
	Serge Semin <fancer.lancer@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0235/1848] gpio: dwapb: mask/unmask IRQ when disable/enale it
Date: Wed, 18 Nov 2026 15:37:53 +0100
Message-ID: <20261118145921.792797297@linuxfoundation.org>
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

From: xiongxin <xiongxin@kylinos.cn>

commit 1cc3542c76acb5f59001e3e562eba672f1983355 upstream.

In the hardware implementation of the I2C HID driver based on DesignWare
GPIO IRQ chip, when the user continues to use the I2C HID device in the
suspend process, the I2C HID interrupt will be masked after the resume
process is finished.

This is because the disable_irq()/enable_irq() of the DesignWare GPIO
driver does not synchronize the IRQ mask register state. In normal use
of the I2C HID procedure, the GPIO IRQ irq_mask()/irq_unmask() functions
are called in pairs. In case of an exception, i2c_hid_core_suspend()
calls disable_irq() to disable the GPIO IRQ. With low probability, this
causes irq_unmask() to not be called, which causes the GPIO IRQ to be
masked and not unmasked in enable_irq(), raising an exception.

Add synchronization to the masked register state in the
dwapb_irq_enable()/dwapb_irq_disable() function. mask the GPIO IRQ
before disabling it. After enabling the GPIO IRQ, unmask the IRQ.

Fixes: 7779b3455697 ("gpio: add a driver for the Synopsys DesignWare APB GPIO block")
Cc: stable@kernel.org
Co-developed-by: Riwen Lu <luriwen@kylinos.cn>
Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-dwapb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index d6240ae0f87ca..51bed3adafc1f 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -282,13 +282,15 @@ static void dwapb_irq_enable(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 val;
 
 	spin_lock_irqsave(&gc->bgpio_lock, flags);
-	val = dwapb_read(gpio, GPIO_INTEN);
-	val |= BIT(irqd_to_hwirq(d));
+	val = dwapb_read(gpio, GPIO_INTEN) | BIT(hwirq);
 	dwapb_write(gpio, GPIO_INTEN, val);
+	val = dwapb_read(gpio, GPIO_INTMASK) & ~BIT(hwirq);
+	dwapb_write(gpio, GPIO_INTMASK, val);
 	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
@@ -296,12 +298,14 @@ static void dwapb_irq_disable(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 val;
 
 	spin_lock_irqsave(&gc->bgpio_lock, flags);
-	val = dwapb_read(gpio, GPIO_INTEN);
-	val &= ~BIT(irqd_to_hwirq(d));
+	val = dwapb_read(gpio, GPIO_INTMASK) | BIT(hwirq);
+	dwapb_write(gpio, GPIO_INTMASK, val);
+	val = dwapb_read(gpio, GPIO_INTEN) & ~BIT(hwirq);
 	dwapb_write(gpio, GPIO_INTEN, val);
 	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
-- 
2.53.0



