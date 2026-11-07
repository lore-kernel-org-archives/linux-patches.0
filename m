Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065125;
	b=xDmVWadHhQHuUPhFLiQ5mvb7zluxBzpzB2xZWQMMHdDhjpj/51BpjPFd39VoGGCcqCaz
	 ITOZ9y7wM6ZHtId8wUHnpaC82qf9ET4zKs/1wftQXgLtHWSSBSJCnIftPSiPtboaYVkM9
	 lox9C+nXtyGSXbKVb8gyx+7BXg+QuxiD45I1uZjeSaw/Q/t1qi1yobgTJGNnczuWoL38X
	 2A76Zsx1LkfSE23IWOwnYpLi+/tXpzi7o0aI9qydYPA0c/VMInVnpt47HsVmrzbnka5mF
	 PvMJVM+5qTtmPrlWPL+dQ52+Su/sp+yigBnoExr5joOg1rc/9h1flZgrvxx6fWz8szA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qyY7ynoqoUGe4Q3wRrYhKMRyXMVofh/+ZzJX2BAuZkI=;
	b=pjvXY3t0K9IWc7EsqnAXByl2IL0SRhqdHxRASsmSzWhlp5mrP1MXFPnYjmAsOuliZfa1
	 zW7VQ3xhOmSIqpzauospdHZ4Os+ng9NacZF6WDf9BKpoqIUQJjHME3CmPdAYNgJckqIIO
	 vZu0co8gTC+Kr2eSJ2fI7OVlmWSQeMnLhS2qMTns8ZtZJz3oJ1FunJ7KANc/ET/JaBn7U
	 yUKV4szSIEtNZ0bQkaJjKLdOuvsJG/2i6dgisR7dmI9EZzNCAMlzqi7sMoQwZPi+BG25t
	 JTpM4jecsgOTXsZB+8d6eT2+jl5XADDjCCk1UVNtMGcBd7CpH1RHZE42vRtrHXniDpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BcTL8Rg4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E590606A32D;
	Sat,  7 Nov 2026 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BcTL8Rg4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A3F1F0089F;
	Sat,  7 Nov 2026 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065125;
	bh=qyY7ynoqoUGe4Q3wRrYhKMRyXMVofh/+ZzJX2BAuZkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BcTL8Rg4uXWLZoLctZgsUJLgvC9uxXZGsf+n8akuEKEL90xTSYlrCZEwCcPHI15bT
	 iMGvbBUzkUCnjevODOoZrE4C3t4Ncw3n4MgCmW5Np4Au3hEMg3PgttSHficVkfI9IY
	 7Ntvun4qG4NaRkNUQKdO3CWxvNOdw47Phi/wqaNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0948/1257] gpio: pca953x: Preserve wakeup accounting on parent IRQ failure
Date: Sat,  7 Nov 2026 08:54:04 -0500
Message-ID: <20261107135005.529746434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index aac9ea7520b60..869ed4264d48a 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -838,13 +838,18 @@ static int pca953x_irq_set_wake(struct irq_data *d, unsigned int on)
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



