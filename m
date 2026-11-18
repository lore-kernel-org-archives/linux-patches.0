Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040945;
	b=ost0HIw4aWNRTPukGL9PeJEMTYBHr/EOUe5VAKnxNae/SltnoIfQQ7pmXpjuJMnq1F6Z
	 MWZXfbuuuu7tXJpdhpJ5PX8fiRW2kn5LbRxlFUSUhrpfXcw48X6TYNV9kgFpojAnRf8RA
	 v19gczPU5NnOs1uDokCqIb8jsb90m7gX0o9zCX0+kS1yoYjYOgSH7B9TRKhi918kyDGjz
	 bDQ+1CegBpFlHvTqJL/D7lKQQ5HFxdzDpZbsXcDSCK58SBkp5WMAlxUz+GjH2RlkGlGZc
	 q8Iu444/i6eS8+60aUdWwc9JLka0x7LMFDijuKT1esWhOdjxkwLAY+T6m4zWmAMrv0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dk1jbb9XuTHLo7klmmrg5G/eyTD40b7Z2i4WgRYPHA0=;
	b=BHLN7e6Z6L364VumQwN0e/yZTVJJHEhJVLYYcQ1oVn4YCAKrnrdodCs66PtlRl+bXMAR
	 +zEvzcGZNTQXI9stvzwDkjh7K2fkPm/YBrXVTM5VoJFXLRbAyMRFx+Nt4YPgmrSGKh6Zs
	 BTMZtVWTnF9NBwsufF9r0xmxrQ/qo7e4dMfopeQnt0XcP6sANXe82UmM0LPADL6N4TYcE
	 q40kUx+40KiULHCz/69/OJuiwd8l7I6J8js2z/Uae9JxvlfMt7U17oOcVeveeetkYwZ0p
	 gMGBvx/EHcV3qcGOcTONyh377jzagIpp53mxXAqVkEBMjr8undtZE5VSkY2TT1TuVtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9KtEGqo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30686606A320;
	Wed, 18 Nov 2026 22:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9KtEGqo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E84B1F000C4;
	Wed, 18 Nov 2026 22:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040945;
	bh=dk1jbb9XuTHLo7klmmrg5G/eyTD40b7Z2i4WgRYPHA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9KtEGqo0AfWXJeCtiY7Nn9FbPltKYW5C99Q4gaI29AGgrcZTcnJ7M/eJKG0s1Xk5
	 omDsxSyRLUmjCgeR5EC++xhySn8Nq4t7Hy6wDgG9bTs6mj8oPu3SkAtcaI3NTUSMBu
	 E6mt5hl5Q/GIbN87ga21i0Hmmv0Zel7x291QWlwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2638/3318] spi: sun4i: use time_left variable with wait_for_completion_timeout()
Date: Wed, 18 Nov 2026 15:54:20 +0100
Message-ID: <20261118150440.217351571@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 34bed8a33f3a4f69b0ef584ef49f04a671a4a5c2 ]

There is a confusing pattern in the kernel to use a variable named 'timeout' to
store the result of wait_for_completion_timeout() causing patterns like:

	timeout = wait_for_completion_timeout(...)
	if (!timeout) return -ETIMEDOUT;

with all kinds of permutations. Use 'time_left' as a variable to make the code
self explaining.

Fix to the proper variable type 'unsigned long' while here.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20240430114142.28551-7-wsa+renesas@sang-engineering.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 672ba6d88324 ("spi: spi-sun4i: sun4i_spi_transfer_one(): fix setting of clock rate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun4i.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 4230a5e8cd72a..9b21d3b945b35 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -212,7 +212,8 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 				  struct spi_transfer *tfr)
 {
 	struct sun4i_spi *sspi = spi_controller_get_devdata(host);
-	unsigned int mclk_rate, div, timeout;
+	unsigned int mclk_rate, div;
+	unsigned long time_left;
 	unsigned int start, end, tx_time;
 	unsigned int tx_len = 0;
 	int ret = 0;
@@ -332,10 +333,10 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 
 	tx_time = max(tfr->len * 8 * 2 / (tfr->speed_hz / 1000), 100U);
 	start = jiffies;
-	timeout = wait_for_completion_timeout(&sspi->done,
-					      msecs_to_jiffies(tx_time));
+	time_left = wait_for_completion_timeout(&sspi->done,
+						msecs_to_jiffies(tx_time));
 	end = jiffies;
-	if (!timeout) {
+	if (!time_left) {
 		dev_warn(&host->dev,
 			 "%s: timeout transferring %u bytes@%iHz for %i(%i)ms",
 			 dev_name(&spi->dev), tfr->len, tfr->speed_hz,
-- 
2.53.0



