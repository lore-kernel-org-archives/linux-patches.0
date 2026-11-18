Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038077;
	b=enPgp8Ye83PBFeset8YK0NymqP+OIkcBT3PrFxCeOO3slGV3UEHqhDXVAnufsDDGf7iR
	 Z+K7Zv6OHg/USNB8xELtTW8R9h5junPYeS+YOm37GulIBu9BWDI28dIDXXHmZJWAtgx8n
	 JUqwcgInpdjwXa/r60XVAAljvXKqUWmdIhcroONokR8ETmu3WnWwJqc33ND/FZOuCW9TD
	 zZ3bK7xXmiU4c0xnCatqpH1NYYxtCpaZ6YomvbErM6izLeTAll3I4O1GvPS5vha9Ytc3T
	 5BDbBKyTJVaD4Vv4/ODINVYYG82GSCXgTiSORmUdjzA100+ABGl8VLmVvKT8mo222JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+68L5xKwk2f0K63Tlfq2z38xbUS7kct8298P5WJY0Z0=;
	b=wBJtZye8qoDsGTBklpFbD4wU8DcC42e0c86FOJO594SMRmexgdDcqA0dHNBF3cgWj9xE
	 IAwaT7Z7M0D4a7whrgrtiu1khxXtMrPi1G6ydmQVr6Y9tufDnpPWx4mn4RXNkFnvpPOdH
	 X/82pF3mDOYChFy2INUylgfwgCoLBAbJZ/GF/TLtyf7Qqt4UIH5CwSLHS1EwGhkXTmj2M
	 K43YeHLurHP1Xh3Ga33D+tQafvt5LfL9sdXu9DpImOpjKRTPCvSnyq7iNkN3T6fu4KV2r
	 RWxYLqBRjMV9dVhotg9rfMqjeK3MhgYWqYpw+aq4z7Qjm2b+zuY07C7uDw3He1JRUZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaDja7XP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CDF606A32A;
	Wed, 18 Nov 2026 21:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaDja7XP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBEA1F000C4;
	Wed, 18 Nov 2026 21:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038077;
	bh=+68L5xKwk2f0K63Tlfq2z38xbUS7kct8298P5WJY0Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaDja7XPWFTq2YI2pPX4UI4IBgdmNpmHg7aDH/1JpYfSfVgE8Ijt/NFpC7fvY8Yut
	 kt6roki3dBtP50Bdi3bMaiuTYQ/2l8ieqlAECZaakocyBbAuhp/cACF3xtNcS6vbRf
	 kwW7epP6sJRPQfSdZhc1bz2+16kGjVEcLI+Sv5sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1619/3318] iio: adc: ad7192: Revert "properly check spi_get_device_match_data()"
Date: Wed, 18 Nov 2026 15:37:21 +0100
Message-ID: <20261118150409.763309879@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0309e66abea141f3ec339b064b8f8b8003d2a634 ]

This reverts commit b7f99fa1b64af2f696b13cec581cb4cd7d3982b8.

The added code is currently a dead code. Moreover, the driver is not
designed to have any defaults effectively making driver data a mandatory
information to work with. Taking all together, revert unneeded change.

Discussion at #1 concluded in agreeing a new policy on this for IIO.

Link: https://lore.kernel.org/linux-iio/20260217080514.1288115-1-andriy.shevchenko@linux.intel.com/ #1
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 7f7a119a370e ("iio: adc: ad7192: reject devices without match data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index fa6810aa6a4a7..ecaf87af539b0 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1039,9 +1039,6 @@ static int ad7192_probe(struct spi_device *spi)
 	st->int_vref_mv = ret / 1000;
 
 	st->chip_info = spi_get_device_match_data(spi);
-	if (!st->chip_info)
-		return -ENODEV;
-
 	indio_dev->name = st->chip_info->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
-- 
2.53.0



