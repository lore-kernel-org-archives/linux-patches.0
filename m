Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620652;
	b=jJbTIjOzEHJ9MOq772IRdLKITZnxZCcZ3bsbVUW37HNwX+dyBwMV+LLwpkK3hdgAsTJI
	 yVI94B8e0o2OrLYiUn/oSK4hHlHEtq0r+LWixiXumT80hDM5e3PpYOlNGVpP21lp9pSzM
	 cZ2/2m1CjwOgsiQJg+kD6BO6SvcJDGswXxUQlc/7S9Qbv8hJHi37+GctxzkMwT59SwCOH
	 KXPxBoRqhEtj71+KXD/8ExV4uCPewumY7ZNUc1k5qJ2cDNP+Ulusr4vu5E/LuO1st8r75
	 Lw9GTNrzgvHZIuw+aE/7ZttoyOto166ysfCyRbVZ+Ls9RVG3dvWzN3mYs+e55mTtRrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/WIMme14PkKmj9essyBJ3fSXh+YkFiRm9hXlM3737V4=;
	b=J9XosLJUtCyCe6dHBjwrirVCfc4ODu9FRxF23rbS9pk2MFRCKUOGlmse8Psy9HsQrIQM
	 vOmLpTbGRRh8KBxnX2BIHZEd46IihK0gfXQsqctyGirrwyW+Fw9PqR7vg+jpomUpu/9m9
	 4TwyiXcLCN+EfHoOdkut9agH9YlLLqjeMijR5cyGObkaBb0sBGt6zX1TxZnhfERPC8oB4
	 l4HBX1AVBzykfpC4wSPFU6QjxTTZLpPuSVAJKNibzo0ZNEb69Mws4g23JfuTBqJD7m4+3
	 AUZMNUuAV0f+n9lh7TiDc37UnRvHpfwOVfA2m0ociRlzxaoaKMMPXpLlKP6iLuxeNCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zccExjxi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E6D606A323;
	Wed, 25 Nov 2026 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zccExjxi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D1E1F000C0;
	Wed, 25 Nov 2026 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620652;
	bh=/WIMme14PkKmj9essyBJ3fSXh+YkFiRm9hXlM3737V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zccExjxiEnsXtug2hj13zmberroQutrciBTK5AqEZVrt1rdEOFkZKlNmf6ytj8ZBD
	 e4D779/ZXm75/7ZUNi5xyQg4B6nnqVglZb90XeTE928oR/JGe4CF4BGxwvCQBzfZGj
	 Lo1pEBaiEXATi7NeMq+w7qRmmNvQo2TC9qcahe0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0990/1005] iio: proximity: sx9360: fix sampling frequency write and available range
Date: Wed, 25 Nov 2026 15:38:48 +0100
Message-ID: <20261125143844.847256221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnav Kapoor <kapoorarnav43@gmail.com>

commit d252425c1533bfacd5940faa3371af82196bff5b upstream.

GNRL_CTRL1/2 hold the scan period in units of 8192 / FOSC, but
sx9360_set_samp_freq() computes freq * 8192 / FOSC and mis-scales val2,
which is in micro units. Any integer frequency then programs a period
of 0, and fractional parts above ~0.26 Hz overflow the int, writing
0x10 to GNRL_CTRL1 outside the SCANPERIOD field.

Compute FOSC / (freq * 8192), rounded to the closest value, and reject
frequencies outside the 1..2047 period range.

The available range doesn't match the limits in the comments next to it
either: 4 MHz / 8192 is 488.28125 Hz, not 448.28125 Hz,
4 MHz / (8192 * 2047) is 0.238535 Hz, and (max - min) / 2047 is
0.238419 Hz. Use those values.

Fixes: 1cdb4c47f7f5 ("iio:proximity:sx9360: Add sx9360 support")
Signed-off-by: Arnav Kapoor <kapoorarnav43@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9360.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/iio/proximity/sx9360.c
+++ b/drivers/iio/proximity/sx9360.c
@@ -14,10 +14,12 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/log2.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/property.h>
 #include <linux/regmap.h>
+#include <linux/units.h>
 
 #include <linux/iio/iio.h>
 
@@ -43,6 +45,7 @@
 #define SX9360_REG_GNRL_CTRL1_SCANPERIOD_MASK GENMASK(2, 0)
 #define SX9360_REG_GNRL_CTRL2		0x12
 #define SX9360_REG_GNRL_CTRL2_PERIOD_102MS	0x32
+#define SX9360_REG_GNRL_SCANPERIOD_MAX		GENMASK(10, 0)
 #define SX9360_REG_GNRL_REG_2_PERIOD_MS(_r)	\
 	(((_r) * 8192) / (SX9360_FOSC_HZ / 1000))
 #define SX9360_REG_GNRL_FREQ_2_REG(_f)  (((_f) * 8192) / SX9360_FOSC_HZ)
@@ -182,9 +185,9 @@ static const struct {
 	int val;
 	int val2;
 } sx9360_samp_freq_interval[] = {
-	{ 0, 281250 },  /* 4MHz / (8192 * 2047) */
-	{ 0, 281250 },
-	{ 448, 281250 },  /* 4MHz / 8192 */
+	{ 0, 238535 },  /* 4MHz / (8192 * 2047) */
+	{ 0, 238419 },
+	{ 488, 281250 },  /* 4MHz / 8192 */
 };
 
 static const struct regmap_range sx9360_writable_reg_ranges[] = {
@@ -383,11 +386,25 @@ static int sx9360_read_avail(struct iio_
 static int sx9360_set_samp_freq(struct sx_common_data *data,
 				int val, int val2)
 {
-	int reg;
+	unsigned int period_ticks;
+	u64 freq_uHz;
 	__be16 buf;
 
-	reg = val * 8192 / SX9360_FOSC_HZ + val2 * 8192 / (SX9360_FOSC_MHZ);
-	buf = cpu_to_be16(reg);
+	if (val < 0 || val2 < 0)
+		return -EINVAL;
+
+	freq_uHz = (u64)val * MICROHZ_PER_HZ + val2;
+	if (!freq_uHz)
+		return -EINVAL;
+
+	/* The register holds the scan period in ticks of 8192 FOSC cycles. */
+	period_ticks = DIV64_U64_ROUND_CLOSEST((u64)SX9360_FOSC_HZ * MICROHZ_PER_HZ,
+					       freq_uHz * 8192);
+	if (!period_ticks || period_ticks > SX9360_REG_GNRL_SCANPERIOD_MAX)
+		return -EINVAL;
+
+	buf = cpu_to_be16(period_ticks);
+
 	guard(mutex)(&data->mutex);
 
 	return regmap_bulk_write(data->regmap, SX9360_REG_GNRL_CTRL1, &buf,


