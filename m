Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060958;
	b=LtiovQdw5qpTVbV+c3EQeHUTSUFXQ8Bm3lHGZjyqIT8Z/H2GVn7tv4SjlWfRbCiQ6etr
	 V7aWIYL8HiqhhTe1aoMuv2YSo4g5VwnM2JtPHZAI3RP/o5HDRy9p1DJbECwOns+rBSQcy
	 uYhS5Fai8PED6SMGNbOcAhSHoTIN39LY/zm+5Ae5H8Xn8i51LDG+/qrGskMOBM2vh3NlS
	 ZCpXbqwGUrr4NTDA+l7uRgGd7PAJnDkD91z09OrmbMP4nbDHxYC+ubhSHEokk/QUAvOVX
	 zHAcgQEDSLoHTE+2NT2K976b24T4c7GGbJF947DoP0CWLB9u3s/FuUc4nBDfSfZ8pvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PjdY9NtUq4jx+Xe5zirs9FTJF2NQ7X4YW20A98x5DGw=;
	b=RuXdHoiyGbvMt5tH3jPKXCyqE93SHnnsXIErlpBiikDzyt99nT1XqPTp+q1tprXla9mm
	 NvXsxp+DHWmUhEXZrGZbgY/Iw+MWhvmGPOmIizaCNyXuj1SbFvJW8ZwdDYtI5ZWPZUegD
	 oB9yY2fYFK92eE6O5X7chiqwFneVPcLrbJnyILFHa3uP9grdDUTjdBOf2MskYExKQRR9Q
	 pnoPO2folbch1t5TVqgwXmhG8SevHXdOCSpP2zKt5rXGQvUpFp7UjryGLX/+D/jJFiF+N
	 LdjIsszUrwYE3ZZD4wJMyulNRNvIYZ+t7TvmxPQfJ3U9GZ5Vo547ZV0dC20FQT7yKGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBSrA4wb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FD0606A320;
	Thu, 19 Nov 2026 04:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBSrA4wb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A901F000C4;
	Thu, 19 Nov 2026 04:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060958;
	bh=PjdY9NtUq4jx+Xe5zirs9FTJF2NQ7X4YW20A98x5DGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBSrA4wbEIoMHmgSnL/Mmi4Ins85j6y+uLX5dx+UPk6H7UerimaK1RHUwMl88/QZ9
	 dS24T1F0cqHjOHEYXmNLxqbTCZaGOWc7aFqQa0cRWZyjg2SvUzPgfJxfq1Vg5Umzfr
	 DmejAf/kmvIN1jKy0/PjMx4ydPu9oDQQzJqHTqFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1386/1848] iio: dac: ad5758: Fix the offset calculation
Date: Wed, 18 Nov 2026 15:57:04 +0100
Message-ID: <20261118150017.488761326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0b1ecc3b7a9e0..0a99f0c25f159 100644
--- a/drivers/iio/dac/ad5758.c
+++ b/drivers/iio/dac/ad5758.c
@@ -9,6 +9,7 @@
 #include <linux/bsearch.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/of.h>
@@ -542,7 +543,7 @@ static int ad5758_read_raw(struct iio_dev *indio_dev,
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



