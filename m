Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E214814A4E6;
	Tue, 20 Feb 2024 21:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464529; cv=none; b=mmrhcc0tok2qCee7dQTVFQF6hLrcPXp31A5/Ki9GC1+C0wRACKI15Nehw5AJJQaiYXoCTll5TI7y7iO7yT8hAXjAriyjGLTkI/Ihs7tOcCrTapeGEAV7W9fVcjGbB5uteLCh8pslkUHdSTmztkLjCgrvwAtwpHlvtkQOEFERy1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464529; c=relaxed/simple;
	bh=IDRPryOeCwr5dLecK9IGG7Ev1G9+U5ytDHvx5yg5cOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I0tuvl3qjMkFzPkmALGHh6bxtws+SE+zQ5xkNs7Uy8UbY6j/3c4zgMrMui368CTIQ/QtTKj2uUBReYTubRS5KiLKBmWdgvmwiB5SVaMXJfCU/Jixn5L5ENALZGfjQYQm8Ux/DkE7RLKtol6jJpzQf2KNuLzOWa8LmgzbAwoFo48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0R46GBjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0R46GBjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C85C433C7;
	Tue, 20 Feb 2024 21:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464528;
	bh=IDRPryOeCwr5dLecK9IGG7Ev1G9+U5ytDHvx5yg5cOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0R46GBjG7MAd/KdlV3TbHXRFgTCgGFN+gvsW6SqteVd7dKT3g0USR9HwNQUDM860R
	 RAglSZwsXAm7AuiGLvxcbe/Cm35lUHoBZQnlfQ4+qSZSC5wF/I2EW13ROWXbkfiofZ
	 dpSmOjgUg0PgPJ5tebvBGJHQ27Xu21xRPiqSHNN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 053/309] spi: ppc4xx: Drop write-only variable
Date: Tue, 20 Feb 2024 21:53:32 +0100
Message-ID: <20240220205634.859179806@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit b3aa619a8b4706f35cb62f780c14e68796b37f3f ]

Since commit 24778be20f87 ("spi: convert drivers to use
bits_per_word_mask") the bits_per_word variable is only written to. The
check that was there before isn't needed any more as the spi core
ensures that only 8 bit transfers are used, so the variable can go away
together with all assignments to it.

Fixes: 24778be20f87 ("spi: convert drivers to use bits_per_word_mask")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20240210164006.208149-8-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ppc4xx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 03aab661be9d..e982d3189fdc 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -166,10 +166,8 @@ static int spi_ppc4xx_setupxfer(struct spi_device *spi, struct spi_transfer *t)
 	int scr;
 	u8 cdm = 0;
 	u32 speed;
-	u8 bits_per_word;
 
 	/* Start with the generic configuration for this device. */
-	bits_per_word = spi->bits_per_word;
 	speed = spi->max_speed_hz;
 
 	/*
@@ -177,9 +175,6 @@ static int spi_ppc4xx_setupxfer(struct spi_device *spi, struct spi_transfer *t)
 	 * the transfer to overwrite the generic configuration with zeros.
 	 */
 	if (t) {
-		if (t->bits_per_word)
-			bits_per_word = t->bits_per_word;
-
 		if (t->speed_hz)
 			speed = min(t->speed_hz, spi->max_speed_hz);
 	}
-- 
2.43.0



