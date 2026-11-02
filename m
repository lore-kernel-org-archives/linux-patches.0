Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653608;
	b=OhdNyFwEa19duY3boN3cie6AC4vYHl3X1sNqn06/puLpkOByhKeCXZ/TOwTTF+CbBPqV
	 TaHqIXsdd7jQE1DVY6DPZh4bHyac8pafqxpdkCiqGJ6mpLmlJFG2eJ+2l1OjNxrNw1Pjy
	 OuI6hmR468hd8TJdWxtFV8q6MBfbbhViCCkgYe8nTp+/+/wlaBnIlqq5tFSFn1ewbPrGn
	 FzXz6s7ISEntiQLlr3FmiNZ2vaSUqTcCjUd+a/iBen1SRshIcFnjJ42IOvZITY38CINv+
	 HOm3WmiWiIx6B9bi/+KKgsCVpGM3UAoJzQQ8GDBlqtGCVCKEDBuG5gd05Z7ztpwselQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653608;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=dUjQaUJN+hKn7gRiFVtfqB1QPp5lNz7tAcdpNDm6UXY=;
	b=dWW75iubRxPOKZkA2Qr/6ONf9ckNBbeRVXT8CrHFlHUIZv7G4iwTRuNYJl7PwQbK2Csk
	 4P1cJBkhNPJY+IvOvWPjkTlMIKVY3AxegEbfdZeLH3UCa7bj8+pqPMImN9UMy0BfoauT+
	 z3N01+Pc25FqyyOLrS8wtdXeKZ8nxh7O8fOhbAixQOt4e+9s+RvwpUWmKeHZBF8YvDols
	 aH5LrAL5/aV4Jc7gmEHpMG1TBQeDvSiZxS9ax4tRoGf7R1vJOsHn5M3Tw6eY8dT4oj8t6
	 NM2QFzebvxxfiGF7WkOIy7B3aSP8yR3GbRQ83Jql2+ebYZjREbK+bAWSlEcvIzZon5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=HGBrm9o3;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BB8606A324
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 21:06:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84BB8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=HGBrm9o3
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-536717a4d83so33676231cf.2
        for <patches@lists.linux.dev>; Mon, 02 Nov 2026 13:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1793653606; x=1794258406; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dUjQaUJN+hKn7gRiFVtfqB1QPp5lNz7tAcdpNDm6UXY=;
        b=HGBrm9o3z7yK1tirEpSQW8tIwBvVH+EZhUPha2iahTf8jAAomZcAozynX07BtuV1p/
         KobUcpc3j6xWB3gD2mQSi7j0h4h82JQAAAJwRSo3z31N1puvMinckTrBNLElYIbWhxdc
         l7flFi4wJ8hFGBhhSxdAKQmpQFLp8X1fydoj4PJHzmoQcROrunklVahnqu983hFde0JV
         4vTiIScoyUwaohccDIrMLnJYkp9COK3aG0GURZbnp9KL/A3r/LD4nMoeSImnP3Md/B48
         cdJZf/F2KI7tQqq+FcaZ4mhQZWyYfsPI+606HlJ7oiSKdzeYa7Kcgjnp53q6+0+Rlvf3
         ew0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793653606; x=1794258406;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dUjQaUJN+hKn7gRiFVtfqB1QPp5lNz7tAcdpNDm6UXY=;
        b=Xi6+wczUtOG0nfZ2PpAOaa3kgL3pbQ8gWNdjGIbAh/B7UAd9g+j2HkGkXXSblnnWwD
         FjEVmcbMgFYVWYKZ5ebG8HmEwLUNm1Wq5kqHg2BjUdqmCAjJE4GTD+sPFjYN97vyNci1
         T4Z+rnIG2PYbjhV22OIplpRtXb0c4AoRK0Z5NQ02cpRB8I2N2DlFvLsW+SJS2CI0PnQ8
         j5CKmPnkK5zI1WlXt1pOCG0cwIZiLfvFPkUVt2dz2F+ADOBxlp/dunuz7iHdpskqrb/n
         W1zfwafnvrl9+26hq46wIEYH97AKdwxaJM945rbds5AfS4pchIHx7sVoLgv0qjvicYUK
         fNeA==
X-Forwarded-Encrypted: i=1; AKwUvBwOF8DY39x1msuEewbN8ElaRsQkiboNHZdfO5mvGsQlABZWiQzlW3YY7p2epzJUxH0H8cOeQu6y@lists.linux.dev
X-Gm-Message-State: APuU4Z/96sUAFgplySDAv0MhX1c7PFDRPYn3fYi1k/HBnQbAqhE3iFRU
	R2P3ptH4dJG2vhD7vHMLQY/eu63xw6XKGPvQuKJRsQ593QxgJhtQuk0S5EJe64m9Ai8RdLxn96v
	TYwBQ4aw=
X-Gm-Gg: AYBFou3KIQMvmE5Eb4/7YwKVKBOiN4uEPsnJv4JoMzFVyuhV8u4gpa2CV9MzxL206tk
	F5IBIXzUKDIZQFEiObDY6a9m1C97lEdStxzFB6Oulo1/fhaSN2p6w5Sdn/H5hCeH/rWhFpLojaM
	nyFi3Drae/xBmJXc+zZZcOSP3G+nX8S5BvRR6qmZ9DQdu9G7UI5XHrfXGG4t4ItlGT1JwUziEyx
	sOFH2xyaGpIw68xtwBfS6BNlH6avVOByyAXKHROyskQWa4NAcs6Zc4+yp61ECmM8ygA7jFwp+/U
	md3IyeYrCNSW1m/L2ZK58QaLzvis5yaCQz0RTKjcnSsQdD7l2xVA89xN9ofeU6TXNGgjDWfmn+i
	Y5aFNkbYdWjT3/F/94TKQId8cjD84bpYx0Ng6vPF49byrR9xm0QDGZJKLn5Q1lZN19Tr+mzPg8B
	PQV+W9JIachriyx5+LMgMC6irBROddJkF0TQkIOpzjSc/0gP1kraUi7jINdpl09kh/ldp0yKewB
	P5hGYp6OP1879GEXFB7fCGhUrlLK4KNuOYjaNK16fULztGeNgFIyLgTiCfXAN5uLaIKurVa7II0
	fCTBC45EMDRQ71Gv3goUZ83PN9Rxi48Fv6zQRUk8GNvC5yqaEncwoHOiW5O3s00xYAiVFxVbya4
	RK/zH+HlFIA==
X-Received: by 2002:ac8:5d46:0:b0:536:2936:6ca3 with SMTP id d75a77b69052e-542b6a72b22mr192751401cf.14.1793653606308;
        Mon, 02 Nov 2026 13:06:46 -0800 (PST)
Received: from localhost ([204.244.107.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca8071408sm99734356d6.40.2026.11.02.13.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 13:06:45 -0800 (PST)
Date: Mon, 2 Nov 2026 16:06:45 -0500
From: Ralph Siemsen <ralph.siemsen@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 159/595] gpio: dwapb: Mask interrupts at hardware
 initialization
Message-ID: <auj7ZUcOlNC-rEnk@maple.netwinder.org>
References: <20260930152347.700140858@linuxfoundation.org>
 <20260930152351.156698628@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260930152351.156698628@linuxfoundation.org>

Hello Greg,

This caused a small regression on 5.10, details below.

On Wed, Sep 30, 2026 at 05:20:52PM +0200, Greg Kroah-Hartman wrote:
>5.10-stable review patch.  If anyone has any objections, please let me know.
>
>------------------
>
>From: Liang Hao <haohlliang@gmail.com>
>
>[ Upstream commit aaf7766ba3b99a3834319e7cf939838afc705574 ]
>
>GPIO interrupts may retain stale state across warm reboots when
>peripherals remain powered. If a GPIO line is not explicitly
>configured for interrupts, this can result in interrupt storms
>due to missing handlers.
>
>Fix this by ensuring all interrupts are masked and disabled at
>hardware initialization time via the init_hw() callback. Pending
>interrupts are also cleared to start from a known-safe state.
>
>Interrupts will be unmasked only when explicitly configured by
>userspace or kernel drivers.
>
>Signed-off-by: Liang Hao <haohlliang@gmail.com>
>Link: https://patch.msgid.link/20260705074759.47863-1-haohlliang@gmail.com
>Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>Signed-off-by: Sasha Levin <sashal@kernel.org>
>---
> drivers/gpio/gpio-dwapb.c | 17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
>
>diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
>index ea2e2618b7945..d6240ae0f87ca 100644
>--- a/drivers/gpio/gpio-dwapb.c
>+++ b/drivers/gpio/gpio-dwapb.c
>@@ -189,6 +189,22 @@ static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
> 	dwapb_write(gpio, GPIO_INT_POLARITY, pol);
> }
>
>+static int dwapb_irq_init_hw(struct gpio_chip *gc)
>+{
>+	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
>+
>+	/*
>+	 * GPIO interrupts may retain stale state across warm reboots when
>+	 * peripherals stay powered. Force a known-safe state before the GPIO
>+	 * irqchip and irq domain are set up.
>+	 */
>+	dwapb_write(gpio, GPIO_INTEN, 0);
>+	dwapb_write(gpio, GPIO_INTMASK, 0xffffffff);
>+	dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
>+
>+	return 0;
>+}
>+
> static u32 dwapb_do_irq(struct dwapb_gpio *gpio)
> {
> 	struct gpio_chip *gc = &gpio->ports[0].gc;
>@@ -428,6 +444,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
> 	girq = &gc->irq;
> 	girq->handler = handle_bad_irq;
> 	girq->default_type = IRQ_TYPE_NONE;
>+	girq->init_hw = dwapb_irq_init_hw;
>
> 	port->pirq = pirq;
> 	pirq->irqchip.name = DWAPB_DRIVER_NAME;
>-- 

This causes a small regression in 5.10: the gpio-dwapb controller no 
longer produces interrupts, because nothing undoes the GPIO_INTMASK 
added in this commit.

Only 5.10 is affected, because the following commit was not backported:
1cc3542c76ac ("gpio: dwapb: mask/unmask IRQ when disable/enale it")

The earlier commit does not apply cleanly, due to changes in the 
context, but it is straightforward to apply by hand. For reference I 
tested with the following and it restored the interrupts.

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 265b7e14f346..eb4f2872cc60 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -283,13 +283,15 @@ static void dwapb_irq_enable(struct irq_data *d)
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
  
@@ -297,12 +299,14 @@ static void dwapb_irq_disable(struct irq_data *d)
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
2.55.0

Regards,
Ralph
