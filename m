Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064281;
	b=kp0GnbqoWM7DkdpcgMzpJMRxMYchtLpH2zEdssV2DhdjRsX5cPeRdjp5jlLR7kQZdnn0
	 5+qNy1iLRwnWvF+N9ALSoq0WS4z+QeSxoqrFqYqsXYQqur//Vs6wnD365VPepjtbpuCKt
	 Yz5HSKfPJxUhjf0qTUSJgWhqNDrvGbxlXNdSvJ58DntLBnAxK2SseJQUi2LT5bko8kDuv
	 x4Tks4NFerjc0xOcFSLDIulHLcoyg6jSuWDbWy1gsqWtjFH8+w4GWZNdLyVy9ze6NIe7N
	 ZeYSJvXjko2hM7DCGU/LaFoVx8uNFuy9qrYAPbx1hMsydQDEwXQzt8ap3dTUuuTFRVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7TJYFohzZgFnBbcWgeYwkumDtUpZiJGanZuhVXmiPyM=;
	b=AI7xqTELA8azD4vtbrFFNTor+Wau25Mpf4k+fczhFo8vq9wTCUi6NoUETcqemMWdPF52
	 xgIgPfVewK4wcSY1t0RJa6ZrbYm/Q2nKLMaN25NivCxNoYZgcNfkLuBMFWPe/N4wI2n1d
	 4FNg3Urkqvezt+7CPvAXNLWqWqJ68tEBHBEPXEe5aKt3koh8dEYPAAyDq3/dScszvqz2k
	 mjT3EhCXAN6HGibmyjVu3mB6RyIg4UiHvNL8EEab9EeCR2VVsdhQf3X3+2t+cNSUwgRv2
	 1EdS4XLcoTLt/BDvFOy+RnLlDYEpxpFCCJYZvtvqCe5A6wpwbqVwkcuiB+r2IMssoWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziHrWAz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F276082BED;
	Sat,  7 Nov 2026 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziHrWAz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801AD1F008A1;
	Sat,  7 Nov 2026 15:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064280;
	bh=7TJYFohzZgFnBbcWgeYwkumDtUpZiJGanZuhVXmiPyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziHrWAz3DoH4wDjm78FBJsgUJLrrm/7J7FGLRUei16fV87wgGeQA05lLylVfEIxly
	 brAaVADSGhhawspKxT3pR/NZ5my/dVMZpT5//72BQHfDeZ/AiaykeLWBzGq+WYzC3b
	 bJRra9hBZ0LdITA7Nd9xl0cMeSRKeZKehdkq0O68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0339/1257] iio: adc: ad7768-1: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:55 -0500
Message-ID: <20261107134948.768891342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit e29630bd463eb40e2e86fe45a565fb1d636ac822 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

ad7768_probe() later dereferences the returned chip information to
initialize the IIO channels and device name, causing a NULL pointer
dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before continuing the probe.

Fixes: fa087f5babbc ("iio: adc: ad7768-1: introduce chip info for future multidevice support")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index e9060c1bbe6fb..3972821c295a1 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -1829,6 +1829,9 @@ static int ad7768_probe(struct spi_device *spi)
 	}
 
 	st->chip = spi_get_device_match_data(spi);
+	if (!st->chip)
+		return -ENODATA;
+
 	st->spi = spi;
 
 	st->regmap = devm_regmap_init_spi(spi, &ad7768_regmap_config);
-- 
2.53.0



