Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064243;
	b=u6nSCdRQkwpBX8LWLi5UFvwMP7T+cOgGWO6f2i4BNxJ/pKrAe7LWLHuw4nVXq9f66Vlv
	 +ay9MSzR6YhcbMpnfc9FXhuJVO/0m8Zp63fzJib4+BJGl3AnYQjVlmSonlujCTjY17S9F
	 VUikgQuQGl0cfDoSKs5/i0e388g82O2OMQyiDvQbpBOS+R/a+6/U9R/f1gZK/tbeqwUFU
	 izQkQkL7rQS7Rl8kw3Q8GToJWBXBnCOmMYWXtiBBQ5e9E1ok/i/s1pY8mSguwv4nJ7QfY
	 WezICs7ABh+n4KuJvYgFlk837hX/Up4y+2bd6vmH37pefYTXuC/gyHFBwN3/lsk/yWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UiqJg6a8XWsjI8riCPuThok5RyQG/sLZI3bdNJ0g/OA=;
	b=bwecs6KZZNYgr9fRhe/RnNHf0xGl6ECXnLOyKPCJuFIi4ym/GDqk1PBCDNUcTOgS/jI6
	 uhA/vmA+Qg1wptrG2R/PB08oRPBIzQmVo7NWfgT+WLMParrwgKyJ+qNAXkBh4GV/9OB7g
	 kUX6J+CNX9/y9SINcdRKnv+NloLdVpC6F2oLT0RINwKv7WRzslQfLo/Za07o3mClo1O7H
	 XvvKHd6XH2n3fTT7E99BP7ASDpBX8CV0wWAiBddIcnr4xNyAgCkv2+zcgvY8AxiOYT9CF
	 4ZfSmBNWqlwu7HrZfA/y4What3irtVNufhgAnZA53Upk9tYZRqFmfJaxxJ2Dy4KxBzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eOoEbbJ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3FC606A332;
	Sat,  7 Nov 2026 15:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eOoEbbJ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494C61F008A3;
	Sat,  7 Nov 2026 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064243;
	bh=UiqJg6a8XWsjI8riCPuThok5RyQG/sLZI3bdNJ0g/OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOoEbbJ1CLPhL87UaLlyl1rwZ/JXutu4Hcz5wXf+Qqbvt6nVT+jcCpmTGpodI4n9P
	 ALC+oZInWBQbFq5HqUaz25qcMz+zagDBNftYAo3ZRIsNY8ahovuTJDk/H4buVmYdkm
	 OQ66Bj59BB4sj8VbKQmjHnhMg0v5SKIIYdX6wiK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0347/1257] iio: accel: adxl372: reject devices without match data
Date: Sat,  7 Nov 2026 08:44:03 -0500
Message-ID: <20261107134948.979195798@linuxfoundation.org>
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

[ Upstream commit c72144098fa9205e9b1d08545e7d9b54a2e0aaf3 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

adxl372_spi_probe() passes the result to adxl372_probe(), which
dereferences chip_info to set the IIO device name and capabilities,
causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data in the SPI frontend.

Fixes: 23d742859a2d ("iio: accel: adxl372: introduce chip_info structure")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl372_spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/adxl372_spi.c b/drivers/iio/accel/adxl372_spi.c
index 128e148c4e96b..d54544d6df6f4 100644
--- a/drivers/iio/accel/adxl372_spi.c
+++ b/drivers/iio/accel/adxl372_spi.c
@@ -25,6 +25,8 @@ static int adxl372_spi_probe(struct spi_device *spi)
 	struct regmap *regmap;
 
 	chip_info = spi_get_device_match_data(spi);
+	if (!chip_info)
+		return -ENODATA;
 
 	regmap = devm_regmap_init_spi(spi, &adxl372_spi_regmap_config);
 	if (IS_ERR(regmap))
-- 
2.53.0



