Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024693;
	b=vzEB4dhJc3ufSJh05rzNdROhu7zjJUi0aYjj7cM0FaWsZxXIj4sEvpkT42IfEhcgKjrI
	 qM1y/988rI/Qqf1t9tuE3NqTwjbEW0sbA4TAgjRaLB87yRNs01VFP6+H7qs3e7bRUCdqz
	 xq8kdsigyfBuY4rEaOn3TddHimvQ6rQwfeKRttlAwHq9p9ScLjkaFW9PjSq6/XJ9YxP3N
	 WSbY1HPw6t5d9uKKt4qNrXVIYmc48zcJs00hiJuMoFEAP65lKwF3k8XNbhLK1UoKxGe1b
	 pVHja8Ujiz+U9i2lMKXz/6RMqJrxSCcpoCgNLM+Dz3SU2eMba2XMHBbF2IpN9NasW4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2WnqG4nnbpn3xN/QEdT1IAFcr5QEhCUHofZgjvxeEpQ=;
	b=swa/i7E4GUhfJGwu15oV+wQbjgGWvBH+2UCp0OKD5O2ljaIH1SEgITpeZ8fTyNZ2PPEn
	 PUGmMLNVeiVxI1i5YoX7K9nNJ9WqWPvrsOXmCOiFZRiHSAg49G9ym+0RcIwNvUAEOZnO+
	 qsZx+fayzVxYQnwJ6o7tQxMcQ2x9FJHNcX1ihdj4yw/8Zb3T8olXXHqadtIN3miKzNmdY
	 ZZtysmHSzNVLNQzhfaxabYzLKRTlQIqbN9VbuEAmvOcOyTjFMiu1j2eXdJdMBo8Fmgl2O
	 /NSt30Bc0nTs2mxSaYJqNu+77d5WZ+9nvZO7Ikn0Pro/+ppGaLTRAH4P/Oiuzqn5tgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0j6b0jzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DA9606A32F;
	Wed, 18 Nov 2026 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0j6b0jzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96581F000C5;
	Wed, 18 Nov 2026 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024693;
	bh=2WnqG4nnbpn3xN/QEdT1IAFcr5QEhCUHofZgjvxeEpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0j6b0jzI1s+fXSplGPEOgzErtZhlAYpWJJea5fNO4TjHzGGj9ZhMXVq67uQnNzI9Z
	 IDV35EqJ+8hkt6rNAZ0Q2pDZoSQcQhuUDEY48hG5rg+6Iauntm05RW5XwZLpJFweJy
	 hc4OViwlpDbGtKwOJdXtdUDwhTk+j6SWXOLZ5Dd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0815/2151] iio: dac: ad5758: Fix the offset calculation
Date: Wed, 18 Nov 2026 15:42:30 +0100
Message-ID: <20261118150151.815277008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit a3b3580713f3ac5a32dc2874ee546828977a1d68 ]

The offset is a count of DAC codes, so the microamp or microvolt units
of min and max cancel out and the final division by 1000 is wrong. For
the +-20 mA range the driver reports -32 instead of -32768. For the
+-5 V and +-10 V ranges min * (1 << 16) also overflows int, and the
reported offset is 0.

Drop the division and do the multiplication in 64 bits.

Fixes: 28d1a7ac2a0d ("iio: dac: Add AD5758 support")
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5758.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5758.c b/drivers/iio/dac/ad5758.c
index 67fdd59bd69c7..92c75d1ddce86 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -9,6 +9,7 @@
 #include <linux/bsearch.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/property.h>
@@ -541,7 +542,7 @@ static int ad5758_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_OFFSET:
 		min = st->out_range.min;
 		max = st->out_range.max;
-		*val = ((min * (1 << 16)) / (max - min)) / 1000;
+		*val = div_s64((s64)min * (1 << 16), max - min);
 		return IIO_VAL_INT;
 	default:
 		return -EINVAL;
-- 
2.53.0



