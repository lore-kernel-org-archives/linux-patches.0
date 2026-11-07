Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064288;
	b=w8Df8Tj+2XKUGyCNae5H5/IiodJu6IZ1XNT06byw5NyY6eXudlEW0dNpIIip+v0EP1Vx
	 1gqaMG1tBn5TpHu06o11Pj1N0wt9lHgHNqB2sV059+zTXYxqp1q7mUVrfhCfMopj/pGiV
	 VS39T6Lqff+21y0mz8mrDo5hSywC87IyzEFshWhxdaUeeLPXs6Wds5iOFrpDv8whiLBcS
	 iBPY1zIjlq+IAoa9E+2ZVv9jJMvw8N/IxuH7odc1cFO06TPKBY4KajnAidmtIk+Hw/NoO
	 GbON1SJnhX3IggPKGYbgIpW8t0L3mmhlzFpsxcR5Oc1Kk6y09qUuYTwW1aC00t9vLbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pr4MGHxuaCkbREjkZ2nJZEmfyUracUpOAX4w0+d1zpU=;
	b=5lhVWKiO82WEhtP7bbHo9TsJo01q9lEwx2GKQnjIidNy4Bbj7l2konI1akd+NmwcTzl1
	 P9w1HR0WAoMWkmgtCVZ2wYubT28+l8jgg0hGxz/jqb8AK54Zhkzq2P+khKu9N+Dl6+fSw
	 gcxiFs+0SVt8xQVdSX6x1MjcOEzceR3LPKLXxkoTdT/5U3jX4kKIyLtOvvc0bCytScNNM
	 rhV+LK8yI9AlQH7TvuioWmhcb01tEi5dGPPkVXIgUObzYE7hp57VIeJJ1Qgc52WcdFI+q
	 19okXXj9c/KNwJeSukqYx+Ol+H4XyBr1N1C7KI02Vy2lzNRqifu+0wgF3A3ExBWOZVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ag3qS2bG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC875606A9E6;
	Sat,  7 Nov 2026 15:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ag3qS2bG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5381F0089F;
	Sat,  7 Nov 2026 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064287;
	bh=Pr4MGHxuaCkbREjkZ2nJZEmfyUracUpOAX4w0+d1zpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ag3qS2bGSQnRD1tXsok3do5HDGomog363BTTcHNPq1EExrwg0VodRCoxryCMNu/p/
	 bfY7bSE4BP4kapQMzCt2BU55wIzMVGvc0ErAOVcL5IUFvhrPOBiCegpMpbLoZLp+qk
	 Vuj+kxS4zketsfnZc5K25B7MuoJfimUCrCJ+JJsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0344/1257] iio: adc: ti-ads131m02: reject devices without match data
Date: Sat,  7 Nov 2026 08:44:00 -0500
Message-ID: <20261107134948.899251753@linuxfoundation.org>
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

[ Upstream commit 9f0e96713033e5fe5a7a232e2c3aa994a8d2862f ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

ads131m_probe() immediately dereferences the returned configuration to
initialize the IIO device, causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before using the configuration.

Fixes: 4aa91223fd6c ("iio: adc: Add TI ADS131M0x ADC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads131m02.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/ti-ads131m02.c b/drivers/iio/adc/ti-ads131m02.c
index 2f8f75c8216b2..7ecfb27fd7ef0 100644
--- a/drivers/iio/adc/ti-ads131m02.c
+++ b/drivers/iio/adc/ti-ads131m02.c
@@ -897,6 +897,8 @@ static int ads131m_probe(struct spi_device *spi)
 	indio_dev->info = &ads131m_info;
 
 	config = spi_get_device_match_data(spi);
+	if (!config)
+		return -ENODATA;
 
 	priv->config = config;
 	indio_dev->name = config->name;
-- 
2.53.0



