Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036151;
	b=0OcUZhmkCB/qmUOW43o5zPb6RsQrjdedLHEnBE5r3/eJGfJRjtGFNW7iTc9oYbY6pIwQ
	 MWqEQtujGe8YKaGVH/sAL64nkLfyNdJEyW60lm26rm9XCFvBLDdRFjwjwPw557qbOdcMH
	 6XB/7MhVVs2RITYrjbiKhH40ZWRNT/gHIxWg3LRxq3PWrWqNmXbiZMnBthTnGpeDmJMhF
	 CPK2R45IGQ/6wEpbqVicHMbVyvUpTht+nGrZyATBHKOSphSpJbpMb4VB7bihfPrdvZIN/
	 pSFgBBPPoIQWKFseA7k/hrWG0l6g5pGgT0krOh0/Z47jcLtSefIeo5wshWp78vV0INQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KnjY5BCEZan3veMnpaq7e7SZk8wY7tJKiljXFdeUUkc=;
	b=1wypj2bu1ageLynbM9DGEr87Bi0XrRn3m8+0Blzr7cSdX/MReBz5wFEYPIBkrtcx180g
	 RxnYBcfYw28h847TuRDgT7+WJ6hJUFp0mS+2bBS3mv9FMpkqHpd+x5dlRRFsBDymTP7lR
	 uBWros750Xvi7FFGfB3u3RZsFklomoJ2P5GPUuz4W8mME3RtUtNq6xT9VfEJG0A2k88q2
	 JdNeOdLwf6iLBgsmkQ28LPYogbsLxPDcRT4/bd8+5HknW8T3X5PPfWsBwiPETQvznE+mM
	 zCJ3XKehQC6DB7V26KPF3YeHCY+8ybqAvLCNlBvfFoM6iOA9Us2yXsrgzJd4BJwwLMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpS7hFR+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F04606A32A;
	Wed, 18 Nov 2026 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpS7hFR+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E46D1F000C4;
	Wed, 18 Nov 2026 21:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036150;
	bh=KnjY5BCEZan3veMnpaq7e7SZk8wY7tJKiljXFdeUUkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpS7hFR+qcOUJ5JiG6mjlgv45Rs0nOz8wUGpwLdvi+h5l+EpcFB5DKuZbRrUOgUhZ
	 XWe1xhG1EhIdi0Q/HaPxkojTvE5TeQPWgT65Ff3vOHCxjofZ3Yr9gho0/GgbT6qulz
	 NgjCIloKqXbxtaPhhSIyveSWQ7rWU9BrIOHfAoA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0956/3318] iio: adc: ti-adc128s052: validate SPI match data
Date: Wed, 18 Nov 2026 15:26:18 +0100
Message-ID: <20261118150348.312108843@linuxfoundation.org>
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
index a456ea78462f3..e29d752989faa 100644
--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -150,12 +150,14 @@ static int adc128_probe(struct spi_device *spi)
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



