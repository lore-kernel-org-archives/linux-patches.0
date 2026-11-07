Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063070;
	b=vfKdo4kGaUlSiiGBODGPYUA2+Q3TYe+ASsnhMbzYcHaFII/dXgTdIWlOKrecO8vZWIr3
	 tTEv3M+80U98syOCmmvv+pnyBm9wl2MF+trZQf5b6U2SylIyAzz1gyMBSDJl5bq3sMRhx
	 NcvhXwC7K1KzdLzHVuLDLDJnvRj48b9EDlb76HycflqSyPmuKZsmyOVq+jRCdtaz1QzI6
	 CCbajJsuGb4TbRcPGubEGgSZlG7CtiPZWrNoOsR3TUUMdrNYPwXWS7SjntDNcbezK2OmX
	 QMfICaiA6rTwz1s0/ctGvZVuuzW1zjEL0y4QRJxluxnt9M5PSEwcWstKjUmIx54mjOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYgPnpzHrlvsbJVYC7cQki5KYySQSsnytgm1n8KAJHU=;
	b=pNuuiK/Ic1zML0n6L4Jsofr4wc4TLZ2l6mpB6bHp52gTLiunSQ/SdxE9ga6ckRkU+vWc
	 Zyig8RXRRsikxc+GUDl7JuKpmp4wym36F72YWxyuXL4XN7wlpGVwWXpxkXrgqG1WmcOXc
	 bn644Eu3dJYhSaoYUgcVMJceQToZQprs/TNuGtZsFWEkECh949rgWbnkX7CVvilkthSZe
	 AFBJF8nGsabPQJrKoMR7gvev62khfeGZDO3CQxj7Gc4WeISC347jpsrzhyFOMvSleuL/r
	 P+1u0VIKLJNUp27TceAF89K76eUobt3RbPy1zYYmOrqg1ESzgk4X2xHBf5rRm+0/SFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjbKwwCT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66895606D82F;
	Sat,  7 Nov 2026 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjbKwwCT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1593B1F0089F;
	Sat,  7 Nov 2026 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063070;
	bh=cYgPnpzHrlvsbJVYC7cQki5KYySQSsnytgm1n8KAJHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjbKwwCTpst3VPerFUuVfvL4rBzk72tK95DH4Z/88KOnS8n+OL4XsIctY6U9f1Fgh
	 BaqWsQNtBLScgFlzBK2le8TpLN8PmiIMKbQQJgHrmNLNDLa/GcjUgW6Ygb2RnzGD/Z
	 ugQ7CMfZUSmylIy2r1LzEYx2dELOMvGbZ4xZ5oxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 273/869] iio: adc: max11205: reject devices without match data
Date: Sat,  7 Nov 2026 08:49:15 -0500
Message-ID: <20261107134900.923936938@linuxfoundation.org>
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

[ Upstream commit a07b5db685b2a3084240f9b4a9ee44f3b478c6e3 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

max11205_probe() immediately dereferences the returned chip information
to set the IIO device name, causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before using the chip information.

Fixes: bf3c855be801 ("iio: adc: max11205: simplify with spi_get_device_match_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max11205.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/max11205.c b/drivers/iio/adc/max11205.c
index 6c803df220b6e..e8404973b01a0 100644
--- a/drivers/iio/adc/max11205.c
+++ b/drivers/iio/adc/max11205.c
@@ -117,6 +117,8 @@ static int max11205_probe(struct spi_device *spi)
 	ad_sd_init(&st->sd, indio_dev, spi, &max11205_sigma_delta_info);
 
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
 
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
-- 
2.53.0



