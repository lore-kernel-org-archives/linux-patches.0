Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063076;
	b=eeVBXR5eEiLA/uvUTROu1qnZ7CI4UuhukRXu8/G//FYgKdMJhYNA+3humkcco+bjKp5H
	 oDGsnR/OtA6ON2abLrktfBCuFC1L4lz3GrcJXACIGu2AJrouH3dWuJ8Jdishsq3wVnYsw
	 2DiBzSW1zLDQbAiv1KhPpEmyIG/L0x7gP2FhcLYqAIf3iqPWQVo3ZEEwGygmORSC/RVuZ
	 d8FsohDwRNXCG9Arrv7RSpX+yFgbNdT6m0J1ySJNp2Jf+1dfwuBevPMgbqgIkVBGiw2Z2
	 Rgdic3XjZo4GqHohNPQ4QWWOQk+7pLuX5wkjbIx3OvTg5izLj06ccWEtMMz/JM33Ayw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vYzf73joZp1BxGG7TF3aBUnQTg7F4NVOYXkL1aHp9+E=;
	b=MyYz9naePKMDstaz/3RSwVd3ckIcgEqBB8VuiK67yXmSaIotrK8FgcXFn1pbgRSG0vz1
	 8Gos9g5f/s0++wJvMy+k/RHpi4D6QIMZPGqXcMXNC8p1UCAClCWNsNxoY7C6pbWjcuuFA
	 DelwFXeqUM1lMLMeayax8wdTWvFLodyl2K7ElHk2vOKeXZQOjPNtSFm7PNSXSbe/Zw9GA
	 6dl+K1DwhM7kUe1V8xkObqglqoPt4x1UBBs540B4Cx79xjAUd1xWXfnhhy1VbG8tUiRE2
	 Xwdfex8/sXrcTxAUMZyMJeudLfinSL5/zc2CoL7TMzzeDTs/8wIZTJtB/k9skjokC1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QHPABs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8940B606D802;
	Sat,  7 Nov 2026 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QHPABs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B5F1F0089F;
	Sat,  7 Nov 2026 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063076;
	bh=vYzf73joZp1BxGG7TF3aBUnQTg7F4NVOYXkL1aHp9+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QHPABs3tkh+uk22P4W29/HU98H6klgiBZTIAyoziEn7++cBZEAxOin1LMYk9wfhT
	 9857ltHAC4Aygngr+ZLay0ansoQAQpn/d2FpfScN0A2zKVlh43/zBRXUr4M0CnR1mL
	 1YiKhH/YSDLC6bHCRpDfoqh0nxUUGditjxtJNuRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/869] iio: frequency: adf4377: reject devices without match data
Date: Sat,  7 Nov 2026 08:49:10 -0500
Message-ID: <20261107134900.790462736@linuxfoundation.org>
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
index 48aa4b015a141..0548f626bb45c 100644
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



