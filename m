Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038080;
	b=XIUCR0CySkQBDEQAE4jCrxTY7+gCcR9dl+l05Rakpru88MrZDK6QaVjq9txFXgyg05nW
	 qIXeDAi4K9SDQJa+LqV0eSdr/LmC7RENPwRDP6d5bQ/lHK0T1URVp+wGFefssj8D8KeX6
	 c43wN9syVsbR45AKq4HrsoktFQPjDjv3FxM+lAyxajqrIfXT02kL3ViDpipaVFaz2a5Jd
	 3XcReBHfeFMupAbg1z0pXSmRjFAeCyOUEPzv3bNti+1qkQh0gnHFtSzBIDgkCv4sL0aZN
	 tT/v6vtNYx9MCQ/OWgC2p27jG/jjJ6GXglQSvWRhK6XPW/mS7DJw7PelbTgV9UOBtBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8KE4KRY1zMoCdvhWs2/pF8DLPEpbSz8lqgdw+alV0qA=;
	b=MqNu4qRfOZ8/znvL4pwP6uVLwSkDU6qc/p6Iclaf3pSEAhV5vTHztQu5DY5HDCq+Lq9L
	 H2aYy6YnbZ9IhgUcTGRmVOP4jzVQVi0DpZlE5pPMUA9IRs3NRq/U0YLQbgguq4u2x+Yx+
	 tde6IWXytaW2eadKB6WgQYlqWJsZFiE7ORMy1zQ9eScFrz20H9CNJWJXq3LMpAuqTtvaz
	 u3hupVDhodZXNI1Cg/4S8b9zU3Zf3mos9u7a7qAkvpqGS1g7LmamhSTmOpMb8MEWBNpXi
	 sOvz/f4BLpvU0bwPzNJ53H1Du4iQJMaw+oSOeb5V6xKpXA23un6UrYOPQNlufUTaIdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvLFZm3e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0D1606A325;
	Wed, 18 Nov 2026 21:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvLFZm3e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C39C1F000C4;
	Wed, 18 Nov 2026 21:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038079;
	bh=8KE4KRY1zMoCdvhWs2/pF8DLPEpbSz8lqgdw+alV0qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvLFZm3eN0OMqnfAm76yjL2DAlTLjgG1TIECCzh/4uV6igKANgzhiO+d1Zl2AcM+H
	 4xMMpTksL0hB71FGQHxfN8wuYHE94T+3aie70iA5xAE3+TZL3T5lmYgDfJfVYDMtIH
	 73whJXs734kvTio2+0Flu2pKSuuicQzlbC3yZA48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1620/3318] iio: adc: ad7192: reject devices without match data
Date: Wed, 18 Nov 2026 15:37:22 +0100
Message-ID: <20261118150409.793788527@linuxfoundation.org>
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

[ Upstream commit 7f7a119a370ecf6c8d4ab9e9ee0a8cdd77afedd3 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

ad7192_probe() immediately dereferences the returned chip information
to initialize the IIO device, causing a NULL pointer dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before using the chip information.

Fixes: c3708c829a06 ("iio: adc: ad7192: Convert from of specific to fwnode property handling")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index ecaf87af539b0..63aa6008e9cc1 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1039,6 +1039,9 @@ static int ad7192_probe(struct spi_device *spi)
 	st->int_vref_mv = ret / 1000;
 
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
+
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
-- 
2.53.0



