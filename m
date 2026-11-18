Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049244;
	b=MZ/LuUnL/PVzXaGLcbgnbiSfM00Y2tNiKlpc7pXs6c1Lg7uldkzr6SOlpkZcwkgy+i+7
	 +jSeGjIrWBJkbj6c8V/d7YDODshTbbnTS0G9fes4lB8jj//sQ2m2ANNUq6Rbszhoe2xQ6
	 2xMPQTh/RZaG/jOzb08lL0duY8Z8jQki3FHue7J3hOJAYEPZfi2EKThLxq2oyMryZF5P1
	 gzu25GijFqdNJNkf6yVyyOGTFzxV5h0k7jQ7+kMwbbdUfC6n91nh+u4SVe5FaBr4RHfL6
	 HMH9qZTtzjqmlzbHr7o+gyb7H0WP0advmIqDruwXVRHaRjLPRW0MRTcN8OGccaXVoxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rtSS0Z+79eBFbnKKl1NlbaKpE/mlCcPQ9iT7Q8PFWgM=;
	b=ANzR7tyBleYFUK+7tmiSyST53WYjn96lS8dQktAkKB90AgJ0DtmAo/G0hDR2uKCj1Bz2
	 NC0uP2scfE1qtI2X/pfE6bfq+vG6K183oO4hyNhP2f/WbvPpY5eb1wJnBXd0D0GBUPgJR
	 qFj5sQgKZiEwcmamytQXgWOnSj9KaeWNELTYuggEcbHWUsGFYdjpWNHNNmSMI/rYfs9gB
	 n+6ElqfsUJTZWt6kuTzldQ46q29KL6TaMQ3fw2hnqcThxd2RfJsTRu2x+T8ILvyQ3GY19
	 Cb65Zuz8JqVJMPd6zhaAL3+a43cd4nzuci6/P58e4pNokxbAGiP6UM5gyRiySetJuFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAIrE0FB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5177F606A325;
	Thu, 19 Nov 2026 00:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAIrE0FB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5AD1F000C4;
	Thu, 19 Nov 2026 00:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049244;
	bh=rtSS0Z+79eBFbnKKl1NlbaKpE/mlCcPQ9iT7Q8PFWgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAIrE0FBQgt5yzHh+PjLKmgdtUMKlr+3HOP3OMustIt1H9zDQrpsk/XoWY91wJwvk
	 8LGWdwv/jhkKFq/kCS8oDbu8X7v3F76WvvAzwP2oSXrm4DGh0cQvYTHKIbQmL+dd63
	 kzpil2DL1UUzjqNtC2phI25bXf/EE3kCkZx81sE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2283/2857] spi: sun4i: use time_left variable with wait_for_completion_timeout()
Date: Wed, 18 Nov 2026 15:55:17 +0100
Message-ID: <20261118150323.666052860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b761b2a0307a7..7e8b7dce31a4b 100644
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



