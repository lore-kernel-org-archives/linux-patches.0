Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037413;
	b=Y+fWTOGhcY7m/v5OLISXrZl0ZcaOjw69XK82U9LBnPYiPZLN0d0B+M81n4Xrv1A/p3Eb
	 FPlT1XhSuBbYmsoMbyhRBf76Zp3JwYY78EPkBruX10Jv8Hdc1NdJ7aUeALQVKxQwL1Jfw
	 1UXIXqj32DpwHWRkkn2sZkXIQ8bwZCm93Xd+fDERW12W+CK8rtNmMzpj0C4MbOsQip22p
	 OWppkKyw4N9WPkix/OIPsQY4q2AeBo2Saj9SGe/G2tT1QCtAI8EIMsV4nDGDwaKlsZI2W
	 CIq+36mviylOjFeJNstXe8UdzDGTJZ3WGRcJD+kxFYDYp4qfTHBo7/oD9CBMQgvtLMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EqIVAzmnzI1XfXio3we2X4gZt8/X+JUyszUVVT2rMnw=;
	b=greEA22mjJnjQ+iCPZiCeIHrHaK8CklVYyZlbIuy8MrMFey7kyRmSUu8GW9BFD9O9EXt
	 L6Kd5LRTxDqzoIK9KdUU9sBKBgCZuMvUVQPpNPXE98Sm84+8s0aBpJFdzvFd4Ibav70Ds
	 MC9LKKIEuFdRvfPNs8iezgtmAivpbHXjq8BVpAjbtj7gJ1rdmpLrtbO2yJXhGn6bmNUWh
	 ZRF+Sef7ZTf5Drda1bPJLbFvTYtzZjb5QreUuoRYGsxIBnu/OgdTQZAiQVrEzkwnpkvpH
	 pHAi0abPkyjES2OlNw49YwlG0Kq3iEu5PPYN1mAoz7zzzWqC6uqInVD0qFnB2zt3rEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8kzVv4p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0898606A32C;
	Wed, 18 Nov 2026 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8kzVv4p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FB41F000C4;
	Wed, 18 Nov 2026 21:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037413;
	bh=EqIVAzmnzI1XfXio3we2X4gZt8/X+JUyszUVVT2rMnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8kzVv4pk8ZdHt4mxrCgJraReMsYQJAkN68x44NCh6n4Bf5/mChETJiXslpg+Oitp
	 gVYBPJWzCHArTGA16i3CtY8bhk7CdogxkHlfbeaOvuAy6Kkn+X76Z6MEVXcTPjzqmy
	 MhKRKPpVVXCkIPJIxCzvMq8gmts5eQackXUFAtNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1393/3318] gpio: pca953x: Preserve wakeup accounting on parent IRQ failure
Date: Wed, 18 Nov 2026 15:33:35 +0100
Message-ID: <20261118150402.380263451@linuxfoundation.org>
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
index f2a3961664cd5..e13fac2132745 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -736,13 +736,18 @@ static int pca953x_irq_set_wake(struct irq_data *d, unsigned int on)
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



