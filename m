Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58D27F7E8;
	Wed, 21 Feb 2024 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524595; cv=none; b=oP8fHwudz4Phui+dICoj1iWG7ILw0+s7aETW//Vih+gldkxJtUpnANTd+oTjFzBBVuHE6311FHI01sv1qfHQ+c7Cg8SgmvIBWlM4BuiARefs2DfXxfQbnmvhE3ZT6+2oG8M5/po21UJnKt3swTZmIeuibVIrOtiTnkj0VC8Ubbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524595; c=relaxed/simple;
	bh=f8vBwz4+4UEjZES6TjqhsOwwbJT+UpRPprjzDsKoShM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SOONlKlwp5heDLQPeTWI894/QYF9n4TD2/tlbG7tpar8Kxl6+4tV4YhCQig8ON/8XTWPKQAZHnHLW61bkkzXzkH4lw933Cv1n451gqTOWqdxlROEaRU9dhnz//YqbGr1tGR8YZrwlSqPxMW4dR5zuK9oJDB32kVbx+3m1mL8UTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CnUcv++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CnUcv++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D794C433C7;
	Wed, 21 Feb 2024 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524595;
	bh=f8vBwz4+4UEjZES6TjqhsOwwbJT+UpRPprjzDsKoShM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CnUcv++Dmwx+Vz9WukW5N4wAt807vtNrSlcTjhip7/xarTC4d4qT7ESFbIHCre6z
	 wNDAPWTIaHhM0Ac8QGo0aWCgPEZsyWN6v3o9nukHdN0Skatlo46mTRwyjZpfqJBsI+
	 GySvL/ZfED4egPL8Xwgn6i1aDUaPF+/W9gI+pl3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/379] spi: ppc4xx: Drop write-only variable
Date: Wed, 21 Feb 2024 14:07:51 +0100
Message-ID: <20240221130003.546117886@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d8ee363fb714..4200b12fc347 100644
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



