Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216257;
	b=JAnsifkBrFunmJcmgc59tdRvDGz4eNHlMs8yGG4PqckJtyChcMKn6osZ7DQlfsqZH7bW
	 fAHogLoky5sW0ndoEL/caVqkiy6HWf4iAephEAj0eZ60069tgcWy3V5TOa28P5tGgaxCs
	 2t1b1M3IondZZEw08P0Zs34JE2+JrHbqNIpCVcUWm29BnwYpGdLhOTZT283xDy/oPYyH8
	 uobhR2i6sG6nAUD51TlepueXz3gFHhLtY0RnNOkVloOc9uZhMKEjo6qkIrKfBhAPBlxlQ
	 t3KDqRDRDn7Hv5/dweUs8m0IinOVHFCObZI2VKYM+RuDey5AHP4Cln5RSS/SLJ2MWWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dPaxjAn41peaADPAPb3llUZ1n36c9ltY2sWjXSm8RwQ=;
	b=1nLiqxoLYADnH3il+lkPi/XfVuAXme7aYwaB0YiKSw6qbUQcILOxzt8wtd2zb5eJ2W7A
	 zyrVSUPu/ZXeVkwtgdhafPybzZOEM4vGmGAbwqIvQJhvEQ0a9g+9MOF/6dtJxhvS3HFpg
	 2vcHI0O1m2LNcVFTzZPf/LMxC9XMgNIDD/JmpwaV+Iy0ib9rQKVzFGQZPCLN5WgHCZhGX
	 GzfILzCY0Jiq7MN5dy/PFt2p5a15DGl1jtHYoKxyg0MWrCvq5qURemveKHeBQpfZpZUN/
	 vi48aue6vlIRGd7hQqxffPBQakHVerV1S3Zq8MmTZftMGMT/gqWu5TCHGxT26zDZ6pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXqBHBde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22512606A31C;
	Wed, 28 Oct 2026 19:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXqBHBde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3801F01825;
	Wed, 28 Oct 2026 19:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216256;
	bh=dPaxjAn41peaADPAPb3llUZ1n36c9ltY2sWjXSm8RwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXqBHBdeJPPwCBri8BTuWJZb7eCOSFaP1qcrkNigkSHlEmegwHx2pKrLt+lqF5XQh
	 JjJHTya0abWaeDoAkMUzM7Emu+r2j+O7oeGA1rj+EL+z9p1OJ9l1rh8nISwMPONvUs
	 M+g26wcVefRg/Zl+qndU1sIXbD9//lLd2voQfpuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreeya Patel <shreeya.patel@collabora.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1494/1887] iio: light: ltrf216a: Return floating point values
Date: Wed, 28 Oct 2026 17:59:50 +0100
Message-ID: <20261028170533.453310092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shreeya Patel <shreeya.patel@collabora.com>

[ Upstream commit 00799564bafdd73db1bb0482eefbe1aba7d5e15f ]

For better precision of input light intesity, return floating point
values through sysfs instead of an integer value

Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
Link: https://lore.kernel.org/r/20231107192005.285534-1-shreeya.patel@collabora.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: c132aef0e757 ("iio: light: ltrf216a: fix runtime PM reference leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltrf216a.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/light/ltrf216a.c b/drivers/iio/light/ltrf216a.c
index 4b8ef36b69125..45011be4207b3 100644
--- a/drivers/iio/light/ltrf216a.c
+++ b/drivers/iio/light/ltrf216a.c
@@ -234,7 +234,7 @@ static int ltrf216a_read_data(struct ltrf216a_data *data, u8 addr)
 static int ltrf216a_get_lux(struct ltrf216a_data *data)
 {
 	int ret, greendata;
-	u64 lux, div;
+	u64 lux;
 
 	ret = ltrf216a_set_power_state(data, true);
 	if (ret)
@@ -246,10 +246,9 @@ static int ltrf216a_get_lux(struct ltrf216a_data *data)
 
 	ltrf216a_set_power_state(data, false);
 
-	lux = greendata * 45 * LTRF216A_WIN_FAC * 100;
-	div = data->als_gain_fac * data->int_time_fac * 100;
+	lux = greendata * 45 * LTRF216A_WIN_FAC;
 
-	return div_u64(lux, div);
+	return lux;
 }
 
 static int ltrf216a_read_raw(struct iio_dev *indio_dev,
@@ -279,7 +278,8 @@ static int ltrf216a_read_raw(struct iio_dev *indio_dev,
 		if (ret < 0)
 			return ret;
 		*val = ret;
-		return IIO_VAL_INT;
+		*val2 = data->als_gain_fac * data->int_time_fac;
+		return IIO_VAL_FRACTIONAL;
 	case IIO_CHAN_INFO_INT_TIME:
 		mutex_lock(&data->lock);
 		ret = ltrf216a_get_int_time(data, val, val2);
-- 
2.53.0



