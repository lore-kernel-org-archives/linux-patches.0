Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590155;
	b=0G75uRz9kPpsAuin7+TSQ9l91R9GI8prNL1zZDec1+GVZE4nnptWvxfllobbpKULHFTY
	 D03apmG9cxttXGmfpudRttnpkFBy0NKpfSXQpHVxL32U6nv7AIK55xH1QaCqGZ6wc5mTF
	 HT7ETUUcE5kRK2nOR8L/6FWAqkODqnhGIHT8H82KbhtxVKBRd/YLgPeeyBU+43tYAIiEs
	 5AVnn/iSd9U+wu3w4AjoLHvpP+djxVcgO8av6UOfgBJ0lI4FvS1StBqbnBboqJR5YJqog
	 M/82qqBwRdG5ihe8qB5DOTjI2GKTgkNuAYXP57DYEUZwzv8vIrikQlIqVJ29yOx645g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oEnYt7bj6nLFNj5CAKmKV8Rsw94Y92krQHmFD/dWAt4=;
	b=Rag3oAD+yAYNzBTvB2fXlZyyphbu/Pk08K8cR3clP5snS4w5WaA8vnFpTzUR8XKVvdXL
	 GpHrKcztJ/mfElvqBH2wzhjS9gNBrFzFSlSF+xsyDOCpW4xN9VOc9Ae93M8LKy/Yyl0+D
	 uToLO3c9qeF3pUwljey1tZKIhynzk5k9mqXy3qBMDXjJBwgzfFWhuaAcRZ+QdyHN6wUPW
	 KrleOJodbl5Q2n3nFg3kVfpWZot2v7WywYUwRH3unbttFKZUOXrK/lT26ndmoxyNsM2I0
	 6dYg9WSBIOld5P7k83dVCFnnvfYPHRs7/a/xEyEtUghUarryj0IS7bo6bVAdnhnmCMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXOE4RPJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D317606D4A1;
	Fri, 13 Nov 2026 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXOE4RPJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E7E1F000C4;
	Fri, 13 Nov 2026 17:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590155;
	bh=oEnYt7bj6nLFNj5CAKmKV8Rsw94Y92krQHmFD/dWAt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXOE4RPJEeOTmMM3l8CutnmXM+Ua92bqZ29Pyu3TrG6M/9NHN5fu595frzXpnmINX
	 lAXw9XjLmy90YNeGyOc9Iq3NltXY50bHx/WD/qkkU+loA+uZoCA7FH98PiCqO/jHV+
	 C08PbiHm0AcbjIZYw+w5APfUrzTRdEZoPqCptPp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/686] gpio: pca953x: Preserve wakeup accounting on parent IRQ failure
Date: Fri, 13 Nov 2026 10:45:01 -0500
Message-ID: <20261113153826.603985429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 7ebc4f9662c91..99b7bc2629580 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -839,13 +839,18 @@ static int pca953x_irq_set_wake(struct irq_data *d, unsigned int on)
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



