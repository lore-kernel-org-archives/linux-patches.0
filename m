Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063073;
	b=376I81XA9Pee+h4jtW7Dy2Fo0KKXpw+/BtvovlRkalggvIubPYFmFAk4+DMYH0F4EH1i
	 +x4375GDkJxJFtdrBMFmcwM7y1i93zSb1VaupllNRZQ7nrd2fA2onGhDe9gcXzoh6mw7b
	 HWiCHjGkgmBAItPR6AOn0iF4KndbWWaV+OLMAg1k7iuK4IrJNlO137jSGA0d7mYxjNl+u
	 AfCydxKoOSW+wxa5ce0LliBHbfo2jXrAlPeCHCEq6FFMIeY3oSgpoRsJOeBX8Nxjb7Y2S
	 4V2ZUr0kXZjnu+PsxMSxw1pWwDDNXYnuR8Nit9RMMg6xNohfnklTVku/Z1lzv6Q4X/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fZ8F9oGtQ+f6ZInJqSXXwIHF8QSg+dC1w5lrDDUttv4=;
	b=Bvy2EU6GV4m7tWCYgqNpiPBfzRvcTPRfaPWslRCnjpbG5z7JgOnCJ1jHCKEKgDCYFRyk
	 LLNyJJk9hSiWWBG0pQzlgvtLWsz8LJ0JdL5CaJafj+GbTvPwoZtABXgcSxhjRpFgKYert
	 bkTPCH0UKN8SoVXSDLLoTdWwTPxaYx5j+F8m7h82QCtMTImYcMA9JTGGR8vh1lz0NYQA9
	 bXxQOrSrE3fGHlzh1B+6ZMW38ODGsRLTmN3+VCJ6wjAuxQep1JNyAkccjk8prgXO7pK0a
	 FEyK0cokDFg6PwH6sgUdy+eFGrbtMCStSczSjdI1a/w1NAmEz++l+hKgHyWduEh1DoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q91dZd1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D2B606D83B;
	Sat,  7 Nov 2026 14:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q91dZd1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A441F0089F;
	Sat,  7 Nov 2026 14:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063072;
	bh=fZ8F9oGtQ+f6ZInJqSXXwIHF8QSg+dC1w5lrDDUttv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q91dZd1bAVeFV5tFaZnQxFqBaV+AfsEhUDPwzAldi96hrDSBqTgNr7wsnYmjIK0TZ
	 uMvkFq2eVrBmbfnrCNH4ZW97e1fa1jddTaVFcIklGk5gCv7IzlhKGYecYGJGeFtJQp
	 7KHYImDPR8KZQnVkgQ2dkuxKe1ldqO1irJNp6jhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/869] iio: adc: ti-adc128s052: validate SPI match data
Date: Sat,  7 Nov 2026 08:49:17 -0500
Message-ID: <20261107134900.978542874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 4ac257f2fd2a9cac00e748486fa003b4e1cc453e ]

SPI driver_override allows a device to bind to this driver without
matching either the firmware tables or SPI device ID table. In that
case, spi_get_device_match_data() returns NULL.

adc128_probe() also obtains the IIO device name by dereferencing the
result of spi_get_device_id(), which is NULL on the same override path.
The probe can therefore crash before it reaches the match data access.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data and use the always available SPI
modalias for the IIO device name.

Fixes: d5f0da0c6972 ("iio: adc: ti-adc128s052: Switch to use spi_get_device_match_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-adc128s052.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti-adc128s052.c b/drivers/iio/adc/ti-adc128s052.c
index 4ae65793ad9b3..19c30d60c504c 100644
--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -196,12 +196,14 @@ static int adc128_probe(struct spi_device *spi)
 	adc = iio_priv(indio_dev);
 	adc->spi = spi;
 
-	indio_dev->name = spi_get_device_id(spi)->name;
+	config = spi_get_device_match_data(spi);
+	if (!config)
+		return -ENODATA;
+
+	indio_dev->name = spi->modalias;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &adc128_info;
 
-	config = spi_get_device_match_data(spi);
-
 	indio_dev->channels = config->channels;
 	indio_dev->num_channels = config->num_channels;
 
-- 
2.53.0



