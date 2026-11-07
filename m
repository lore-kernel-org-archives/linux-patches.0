Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063074;
	b=yk9ii8MOFqOqnwMDpako691l+QRQzcX9S+pRV+egUbhil730cAIK4h3Lo/545n/1PgFl
	 FtNQJL1f7DJWbqwrB1MYK6cQdemzKNcoKtF4rXszcl2eBHRobAjX2jVE1Dek89/FLaxKr
	 semHWkbBIyCyiUgzX3lXkAUaeNhaT6Y3GGNRfgm5aHXcstRBw86IpSY2ekQU6ROAtFwJP
	 LxauketTcysa2WLdy1bqOiNBL2bG1WwBZqikaIUG9VvI4Oa82DKo+f0s4wQpDH6j9R9Ru
	 mAed/z0oY8Mr13V0D1HlFgPjGf0+J1d8GO5wav8POb+8dq7yDqJJJxJyZA9sQLNiJ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Juh/0+Yfnpzh+W/E3AnD7BzQLaW2OLjEbBORarAF1zI=;
	b=hJz5oYMMzpSSobEFclw5LXKM9DKk9Tf/OUePP5sudYQGW7oHzmRzP7q7IhQewnHWdiwF
	 WNA+3SoMEUJnJS5rkN05vupZnzSVXIw7lMy4SFkptgXMXRhWLeH+riZPSG8RF+/UN/ML+
	 oYsTUjZQoEYazOONLVYg/EZxVN8zkxC2mHjBxMX4dLI0mLwnFPO3dI7RMigMPf7Rf63YI
	 VD6IqBNFmYap3VN/9hAadOQgurHJh/dlc4fHCtIwvDtNJdPoUR/KUxAtv/7fj/cOBRmEh
	 NArhOG4tu8s/xP2sZysYB1IleExwpXPXkZ0gJbxqkPTLxIXFR9Cl593pzrm5BU1lE+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFrl5Fuf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110A7606D802;
	Sat,  7 Nov 2026 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFrl5Fuf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56AF1F0089F;
	Sat,  7 Nov 2026 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063073;
	bh=Juh/0+Yfnpzh+W/E3AnD7BzQLaW2OLjEbBORarAF1zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFrl5Fuf/Q+5/9u1cjsji9WIsG6TvsYnN6bSkcyNgG0GPD36L2ZyLDv9huL3a7EKX
	 Ftw/EPcVBYp+tTvxryqiejAzTe4D8fNxg0B5OgCxjgh4abYRbkowXtaRtvXBBJ1P6F
	 IeSCkgDo6SDh23THqrH2p1wFg9qN+5QQnPLbj8Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 276/869] iio: accel: adxl313: reject devices without match data
Date: Sat,  7 Nov 2026 08:49:18 -0500
Message-ID: <20261107134901.007808007@linuxfoundation.org>
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

[ Upstream commit defd4c0b29f1cd17caa5feebac33fc5fdf4e1916 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

adxl313_spi_probe() dereferences chip_data to select the regmap
configuration, causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before selecting the configuration.

Fixes: d6e3ee74d16f ("iio: accel: adxl313: simplify with spi_get_device_match_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl313_spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/adxl313_spi.c b/drivers/iio/accel/adxl313_spi.c
index dedb0885c2772..b2287f4f4442f 100644
--- a/drivers/iio/accel/adxl313_spi.c
+++ b/drivers/iio/accel/adxl313_spi.c
@@ -79,6 +79,8 @@ static int adxl313_spi_probe(struct spi_device *spi)
 		return ret;
 
 	chip_data = spi_get_device_match_data(spi);
+	if (!chip_data)
+		return -ENODATA;
 
 	regmap = devm_regmap_init_spi(spi,
 				      &adxl31x_spi_regmap_config[chip_data->type]);
-- 
2.53.0



