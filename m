Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062118;
	b=OPPbWjDKqz8o7cV+Vw7OkBelkQV/IL7OrBBGLp2R5y+wIfPkDVhuFSdPMEgrI+VZ0ZOA
	 559d70Rbsl68uj0wgsmJSveeLUt5g0WTrtMUlicIWWaLo4tx+jLwJQwXHfFW2vl/WBRwL
	 Z6Mqwp/SH5y/lRTHBuN67YXzPj0dh62ngLs6nnON4YzmY38138UD3hlHZdPk9/nzd8B+L
	 elw01vdbyp4aZrtF2HrqfrGKldeQPLNMYQs54DwkqH2R9o8X8WSsWeHpKiXxZcbt89/iF
	 LAVfz7cdLnMBnooWx/g0VWsxjkpF62UcpVxlkRMZkb+HbpgeoRkVuEjKHe+jD5zpFLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hlTFf+vmOkKH+7zj0T/75HQ7xGwX6ozqdGdkAubFRJo=;
	b=AttIPBCwsayg792s4KYh7Tzdf61cFZvi0NsdQ8h7L53rwlXUUXWJaeMyhTqryqcKWfph
	 qNrmvEQYopzwe0t6rMlIiLp+uORj4qhPv3Gogft+A9T9zK8z0rgzri5nMktz+ZXeCMi4C
	 PWn9N6Gxu4QqQjMnyMkWraHgTza3CXSq3G76KjCCsaXvgPZPamrZGimJB42+v+u4hzPml
	 n4PRvOwNGTnmjgWh9DmyolQ8qBSKLddNMdSCOlbU75lLV0WnBnlcfhkqxlk4LqYiAX7G6
	 IVob6gQbq58bUuXEm9OfDJ4QdrjUK8eAW65TfPSkq0AcF1VbjxBVVtTlY93iCYm7YXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGi46b9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F39606EE9E;
	Sat,  7 Nov 2026 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGi46b9P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA89A1F008A1;
	Sat,  7 Nov 2026 14:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062118;
	bh=hlTFf+vmOkKH+7zj0T/75HQ7xGwX6ozqdGdkAubFRJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGi46b9PA9gHeFubaCilORSo20xhIQcHHpnDLlWPhMi/ktP2bwiiDYYjUsisTF2Rl
	 CNZCvuqsnpMhi3+I/dgUdgFpa5mWuRqf4BAsegbzaDnIoevBQCY83yqd9DAEbvoa8J
	 mznePF8MarAet3yuNCwvGgS2o1fbC1mhu+HYVZiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1089/1536] iio: pressure: bmp280: validate SPI match data
Date: Sat,  7 Nov 2026 08:51:45 -0500
Message-ID: <20261107135028.284259312@linuxfoundation.org>
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

[ Upstream commit 206fc54554c28d76c5d8f66091b846ef1dd88f64 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but bmp280_spi_probe() immediately dereferences the result.

Validate the match data before selecting the regmap bus.

Fixes: faac4dda9a91 ("iio: pressure: bmp280: Use spi_get_device_match_data()")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/pressure/bmp280-spi.c b/drivers/iio/pressure/bmp280-spi.c
index d18549d9bb647..5d07267622b74 100644
--- a/drivers/iio/pressure/bmp280-spi.c
+++ b/drivers/iio/pressure/bmp280-spi.c
@@ -91,6 +91,8 @@ static int bmp280_spi_probe(struct spi_device *spi)
 	}
 
 	chip_info = spi_get_device_match_data(spi);
+	if (!chip_info)
+		return -ENODATA;
 
 	if (chip_info->spi_read_extra_byte)
 		bmp_regmap_bus = &bmp380_regmap_bus;
-- 
2.53.0



