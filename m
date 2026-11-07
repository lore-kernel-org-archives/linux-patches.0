Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062116;
	b=ztGL4QVtXRvb7iTasrDaFpY1w/ifHVnKEa78zq9tKKDyrRAXWUIRn9VpmQ+LFepNWddy
	 hn1M/VAbiEfvCp0xxJvjTivJjhAW0xr97Qjqk7h3bM+mVLd80y1ITsjRVYmWTmRGfsDS0
	 a7zFoizJIgbRfCBVpZwR8FRpKjFQH/R5PyrOfRGSg7Moio26o0v0HO1izTQURAb3TbUmj
	 pIfMxi2FBgJU65u65CWoSqu1zxin3sFUbqeWulTh6ZMxRzQWivpNp18PGRZd87NpbsGI/
	 klf04lqdM7Dp8fuzyRS6yDz4q23cWUlAESJUJA6B1mvXG3aHT97WbDfQO6WsQUEFIjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rynri2/3ntsjW68IRiEkl0IhPhWdRK2N0vTJInsBXDs=;
	b=IKPKkhScws4YzZOh939NsPWorpWGjP1MkVDhQ27YrnEoL19BoGqJvFdt3sfEIOPNypP/
	 TKh8XoGhoTDo4KeQfiUYm2wfdgj4hi4VKRBNZhUjF+QTY5Pn7i+vO2vOHhjaXv0V874ia
	 s99FRSAOu1HHPTI2MXEC9OX/HN7RS7Td/gQ4AtGKYb67GGkWmfixQxX2EGRenYDiea8Yd
	 D+Iu9HTTjgo7odWjky/ImoCDhigef6usYbG4H8XCCR/Y/lqPUORjxQHDB4xPU5z2tEONT
	 6XJjIGxA+AU/Ezo0l5rzr8DDOCLzOaEz3FE6aW+vfcIyhAODpORYzZWu7hV7pJaT6fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKnXfApj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177DE60A3809;
	Sat,  7 Nov 2026 14:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKnXfApj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E6C1F0089F;
	Sat,  7 Nov 2026 14:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062115;
	bh=rynri2/3ntsjW68IRiEkl0IhPhWdRK2N0vTJInsBXDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKnXfApjgpX2v3o5ZxUBTHSOWts5L/aL/lbYb6BiT+VLQbsdovv0Aif/fabIHtw3i
	 OcPEJm15WoopZUJIQWes1GQqCB/xU3hQFND5sYuSm/K0ytbvpZVFEnz2j64K5Ut+T8
	 OOIfBxOwVatygaf73HYRFTFRy5caoUu6Yr71y43Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1087/1536] iio: frequency: adf4377: reject devices without match data
Date: Sat,  7 Nov 2026 08:51:43 -0500
Message-ID: <20261107135028.229697396@linuxfoundation.org>
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

[ Upstream commit 2f3196d27e3bfcee0569d23a123aedcc6ddd39f1 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but the result is later dereferenced by the property parsing and
initialization paths.

Reject devices without match data before continuing probe.

Fixes: 6140a92cd086 ("iio: frequency: adf4377: add adf4378 support")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/adf4377.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/frequency/adf4377.c b/drivers/iio/frequency/adf4377.c
index 5dc780a62cc7c..3daacd15616db 100644
--- a/drivers/iio/frequency/adf4377.c
+++ b/drivers/iio/frequency/adf4377.c
@@ -964,6 +964,9 @@ static int adf4377_probe(struct spi_device *spi)
 	st->regmap = regmap;
 	st->spi = spi;
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
+
 	mutex_init(&st->lock);
 
 	ret = adf4377_properties_parse(st);
-- 
2.53.0



