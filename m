Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062123;
	b=DJHvW60b0p8A3XXEVw9gUvqc0s4tKQJ7Bu4qugb0wNaY/RRalrmJW3Z5v6vIkUmlZ5YQ
	 5ra6U/hxkPUq0CA9VmoJEOOdPpMhvD/S4gnfimlz849m9Mu4ZtZSKdGMh+kmaUmCy1zh/
	 uC7O7UPPHjHvPv+AtPiSaNtEciqh+qsEzNPIknDPyGwK/aHB0VKc0FPqVBoTNv1DNnDol
	 n3LxTubHzBFGqv1v5IW/QF/2q2//8/9OTZ6+qdNdboR70jjMV20FQf81WaotwSWJ6JFHm
	 j1+BE6TQrZyOhPMcN7KGFDFP/jChfPYizoHSrX7YujqlLpWkcmMIX7sDCLL+QEavaBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4iZACcQzTsQ9VsCshLAscQYAjD+I+xj/gQ/2onY5GRA=;
	b=Cp+rOEsdorhXjGmcVxEO6Frc3TfvP2FfeIbZtxp7Jz34SHp39B4fPv8GvfhR8sVcbz7R
	 m6lHKb4EtlJE6nXM9pI4SgzbkoVZEnYZqtdmYtSaxmni9NC845wIByDq0LPXwoF2VDL84
	 yHgy0hEWfRORCVHE1jnrV3svHGkKxTAal7QRzH6AKFyVLD81pZ7/U/bJoTLQsMcxVH6lf
	 k6ENBLFARteUIR3y6wczS1hCWqCpk3gUDgJoxjHV0Y2/JTqMX+3yK+VuJ3Ab2sZW8IVLM
	 nZ0SSfNTSfHio6oaeH9fa7LUrdEwPVcdExCrC33HBA0GzNLGjjKumVDgBpmSkp1fO0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDDtCgDl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F7606EE90;
	Sat,  7 Nov 2026 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDDtCgDl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B131F008A2;
	Sat,  7 Nov 2026 14:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062122;
	bh=4iZACcQzTsQ9VsCshLAscQYAjD+I+xj/gQ/2onY5GRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDDtCgDlmtPAbjdAUeVKvOt3fiJ1lNYY8+g9+zpC2DFj5oB0rSy0ZaYDBspCKMQl5
	 SfNoIWtUIaauwunkqoveOpYEEKBMPoYu92B3BfbGYlVD1ofBlVGEdBAyIxSjP8WaSz
	 GxOgRm0LPU1tPBknarnUglDnPBaU770Bw7X77HIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1092/1536] iio: adc: ti-adc128s052: validate SPI match data
Date: Sat,  7 Nov 2026 08:51:48 -0500
Message-ID: <20261107135028.371633259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



