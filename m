Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E325D14A4E2;
	Tue, 20 Feb 2024 20:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462759; cv=none; b=rWa04ddDuwDzobN6Rpt55w3NWJL8GB4TjLov0O3pg9VNmc8C2Y/WlaSkhQlfcLuJnafFsbEgUIVMGCYecELlO0j3YRVNDZYlv6J6S29JO82DDLuzjZPw6o+Vc5WVJin9xgZZMeF3ScWtKqw3019baKc6SfPn5WKYn3vYzW1aqVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462759; c=relaxed/simple;
	bh=hw84H+szj+RuJZpnHopG5Ia71uvNCAcezevmvWRtjFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pUIWyQynui0kl0KJ0Se2kFDQD0NNurLCoQrqMURFKMuKXYB5UtfL9w7lwD2NhoGAkUdFS89PNNcW+qcwOzo5KU8lyrKcvgfzjq1STfrrnFr822aSlJMPZ8SbxqkfoK8eJtGD0unuIwcgwyXWzT487EuuvyG0jZ6bmeODcWvYTN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwED2/pG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwED2/pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480B4C43390;
	Tue, 20 Feb 2024 20:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462758;
	bh=hw84H+szj+RuJZpnHopG5Ia71uvNCAcezevmvWRtjFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwED2/pGXYqjE/b+F5aUAb1ScsERwsAMSv7tzko8KrSuj9WAgYG0SUEIvRt39Ds3d
	 6wYSMNhWlq6rpt6Cx8U7pZwpCGOQoOl21Wel3c5axOSSEPntJKkpkd2/x097ZNwLsW
	 BqIqR5xsFgFxhmyUKou008fZUopUpqJoPce/ArzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/197] spi: ppc4xx: Drop write-only variable
Date: Tue, 20 Feb 2024 21:49:46 +0100
Message-ID: <20240220204841.892765629@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d65f047b6c82..1179a1115137 100644
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



