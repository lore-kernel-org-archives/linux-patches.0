Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040318;
	b=RRVvUKjhE4s2M9xbu3KsljX8r055PmVrAehWoJ+C4yBWRC4ZJA8qS+xoK7gBV+492qS1
	 dkkx26QcPtuuHLsHr1OO+FssEOdxsmA0GFxzloOz/DxcY7DQlUcCVFfJZAKf7GKc7lDj7
	 8m60KlcyA76HX/t4oCeGdTdqF9+AYYrhCad2dmPt7X58geXbvRTfBskt9wNN8xiO0vdMz
	 tiBtGRBnn8tIpD48Q3Qc1TwsSWHG0VCeEu5I2Jiy1PCFXf7m57p+QzyKG/ZZgC/A38iyV
	 oSCv5GH4S5eEAS8FeSLG+4n+5acLpT9f+rd+pN//Gjw4SNB5nktlUq2TqZdR9Ck17sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Bc8E7NHlf+jGHMVyx6VJ+7fNbbYbA4brkwmgM1vld9A=;
	b=41kGsp2WHOsM/bfVNzIoINttRQeBXCVbSyunRm5Tan0XNHUU1twJ9qNRKbsh2wJXnOIC
	 gN25nwj+nODEnCKcyzreAKiiIDMcgmOsqZhUqYKXEbwpxgYUgOrew5vCcaN2Hpn8S+bjj
	 RH8K2OlxdDZUZCQIXAupteMt9YAE0gh3J6mOoM+601cNoLUO2LH5vpu/dePPvF27GsUTO
	 pS4PJg6FdUMASBXkuqJwtpz6vHr54T6fgh6Xm3PAEU9rhr+UGMeob13V5wkfoEh5usIBU
	 UJhpHL4wDShgdpdbIgc0jmGGKYx/sVcn6hIgK71W7ShUS4wES9Hx924mIcmLYgKWAGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iaMaISVi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36626606A32A;
	Wed, 18 Nov 2026 22:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iaMaISVi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4DC1F000C4;
	Wed, 18 Nov 2026 22:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040318;
	bh=Bc8E7NHlf+jGHMVyx6VJ+7fNbbYbA4brkwmgM1vld9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iaMaISViDos2QsT1VpZPf/FSl+9IHzThdr6LlPMnJN64PVkJjVNBA4y+qNkKHjU9p
	 YQjWjuL3NuAaAR+ubxPAka25Uuj9bDDHjA41JhwV7KRjuSZwgxBv/JjK4zp6Rghc1y
	 jp8rxs1csdt9EYGS2QTJRpy+3IyLnd4yrfynE0LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2415/3318] iio: dac: ad5758: Fix the offset calculation
Date: Wed, 18 Nov 2026 15:50:37 +0100
Message-ID: <20261118150433.938208518@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 19e8397b6ca05..b444c21719853 100644
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



