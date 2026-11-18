Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028878;
	b=SXx/LKrFTyOzqqN60QY3hU5v/0X5kJ2hHyfgGA9M48NjD4Js72sOpjuB8eJz/q8Drbiy
	 vFI1/Wibg884GvGBLwOq0qDTexX/MGoXsJve+ZDcqGeFFAShOHn4FRcOIAtfJMKxVcNzn
	 N/HDud8pt7WJmqOsmcBlk0SVn1zjRi2r96App4T00e68HMCFBhxCxlw7B8GiCYd1jPxN7
	 nFKRLv/j9VEl9U1dt3VFdmcCgiyb/8PMrve+NAMpRjW/B3l7RQSpt0yn5Jpe79eok0pgO
	 pKV3L1y89/eJ/3XbgjIOWPc1xS0I9bPVXzDR0KPV5Lqa6wMTW7MpDhUPwGZyo4XgYXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z1XB2rHeuct40rS7gb3v8bqUQJfGQzKIYRJL8d8XvJM=;
	b=OKm6s9Vtxn6N14HBcn5jobHZPJEZnekNm99WrICNbAMJiwN35UX1QF53gc1rbpKI+BJH
	 aR+YYm8TQpC9gzm3XAXr4e2+puyLHz1mOpCnE8o93Gwekh8dt4iOMDH7Cg0734laZipjt
	 T0siTNwU0/a6TJnugiRJsZJpEZS4d0OviHSAMrpwSSfPh4G81lqJl5XHekLgj5Alk/uPs
	 74S2VGev6LzD32xPdEw6UxCOMFg7JNdW6AakAyWeTc8Vndm32kFk/Uk6ImpaFF+i+cUkZ
	 4uAlmPOnZClHXfdjU9kijy+r0O0BbHCKPscv5s8+sX30OuWkGYVijgpfos7eMrnZgoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wNp/rbpv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFCD606A338;
	Wed, 18 Nov 2026 19:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNp/rbpv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341A41F000C5;
	Wed, 18 Nov 2026 19:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028877;
	bh=z1XB2rHeuct40rS7gb3v8bqUQJfGQzKIYRJL8d8XvJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNp/rbpvEtn56Ap3mkk01COnQE+RMoYeLpdqmWMcEZfjxc7PMXVlUbatqNEhWu91e
	 3MnKhZophDeys/niNfknxWqdpjw9LCU1LmIEtUpNqMk77mYzHVgnIxGr9s2pV5u5wQ
	 5HTizZY6aoQRty6n2E5Q2CLm/gbsk6Eq1rXcB3t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adi Nata <adinata.softwareengineer@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0149/1756] iio: humidity: hts221: report available values via read_avail()
Date: Wed, 18 Nov 2026 15:37:56 +0100
Message-ID: <20261118150014.070287141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Adi Nata <adinata.softwareengineer@gmail.com>

[ Upstream commit 003e99cf33e344a380ba10b3e04ccb862f3d9dc3 ]

Replace the custom oversampling_ratio_available sysfs attributes with
the standard IIO read_avail() callback. This lets the IIO core create
and format *_available attributes and exposes the lists to
in-kernel consumers.

As a consequence, the incorrectly named
in_humidity_oversampling_ratio_available attribute is replaced by the
standard in_humidityrelative_oversampling_ratio_available name for the
IIO_HUMIDITYRELATIVE channel. The temperature oversampling and sampling
frequency available attribute names are unchanged.

Fixes: e4a70e3e7d84 ("iio: humidity: add support to hts221 rh/temp combo device")
Signed-off-by: Adi Nata <adinata.softwareengineer@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/humidity/hts221_core.c | 106 +++++++++++------------------
 1 file changed, 40 insertions(+), 66 deletions(-)

diff --git a/drivers/iio/humidity/hts221_core.c b/drivers/iio/humidity/hts221_core.c
index 87627d116eff0..e685107f4b4bf 100644
--- a/drivers/iio/humidity/hts221_core.c
+++ b/drivers/iio/humidity/hts221_core.c
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/iio/sysfs.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/regmap.h>
@@ -49,7 +48,7 @@ struct hts221_odr {
 struct hts221_avg {
 	u8 addr;
 	u8 mask;
-	u16 avg_avl[HTS221_AVG_DEPTH];
+	int avg_avl[HTS221_AVG_DEPTH];
 };
 
 static const struct hts221_odr hts221_odr_table[] = {
@@ -58,6 +57,8 @@ static const struct hts221_odr hts221_odr_table[] = {
 	{ 13, 0x03 },	/* 12.5Hz */
 };
 
+static const int hts221_odr_avail[] = { 1, 7, 13 };
+
 static const struct hts221_avg hts221_avg_list[] = {
 	{
 		.addr = 0x10,
@@ -97,7 +98,11 @@ static const struct iio_chan_spec hts221_channels[] = {
 				      BIT(IIO_CHAN_INFO_OFFSET) |
 				      BIT(IIO_CHAN_INFO_SCALE) |
 				      BIT(IIO_CHAN_INFO_OVERSAMPLING_RATIO),
+		.info_mask_separate_available =
+				BIT(IIO_CHAN_INFO_OVERSAMPLING_RATIO),
 		.info_mask_shared_by_all = BIT(IIO_CHAN_INFO_SAMP_FREQ),
+		.info_mask_shared_by_all_available =
+				BIT(IIO_CHAN_INFO_SAMP_FREQ),
 		.scan_index = 0,
 		.scan_type = {
 			.sign = 's',
@@ -113,7 +118,11 @@ static const struct iio_chan_spec hts221_channels[] = {
 				      BIT(IIO_CHAN_INFO_OFFSET) |
 				      BIT(IIO_CHAN_INFO_SCALE) |
 				      BIT(IIO_CHAN_INFO_OVERSAMPLING_RATIO),
+		.info_mask_separate_available =
+				BIT(IIO_CHAN_INFO_OVERSAMPLING_RATIO),
 		.info_mask_shared_by_all = BIT(IIO_CHAN_INFO_SAMP_FREQ),
+		.info_mask_shared_by_all_available =
+				BIT(IIO_CHAN_INFO_SAMP_FREQ),
 		.scan_index = 1,
 		.scan_type = {
 			.sign = 's',
@@ -192,53 +201,35 @@ static int hts221_update_avg(struct hts221_hw *hw,
 	return 0;
 }
 
-static ssize_t hts221_sysfs_sampling_freq(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	int i;
-	ssize_t len = 0;
-
-	for (i = 0; i < ARRAY_SIZE(hts221_odr_table); i++)
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%d ",
-				 hts221_odr_table[i].hz);
-	buf[len - 1] = '\n';
-
-	return len;
-}
-
-static ssize_t
-hts221_sysfs_rh_oversampling_avail(struct device *dev,
-				   struct device_attribute *attr,
-				   char *buf)
-{
-	const struct hts221_avg *avg = &hts221_avg_list[HTS221_SENSOR_H];
-	ssize_t len = 0;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(avg->avg_avl); i++)
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%d ",
-				 avg->avg_avl[i]);
-	buf[len - 1] = '\n';
-
-	return len;
-}
-
-static ssize_t
-hts221_sysfs_temp_oversampling_avail(struct device *dev,
-				     struct device_attribute *attr,
-				     char *buf)
+static int hts221_read_avail(struct iio_dev *indio_dev,
+			     struct iio_chan_spec const *chan,
+			     const int **vals, int *type, int *length,
+			     long mask)
 {
-	const struct hts221_avg *avg = &hts221_avg_list[HTS221_SENSOR_T];
-	ssize_t len = 0;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(avg->avg_avl); i++)
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%d ",
-				 avg->avg_avl[i]);
-	buf[len - 1] = '\n';
-
-	return len;
+	switch (mask) {
+	case IIO_CHAN_INFO_OVERSAMPLING_RATIO:
+		switch (chan->type) {
+		case IIO_HUMIDITYRELATIVE:
+			*vals = hts221_avg_list[HTS221_SENSOR_H].avg_avl;
+			*length = ARRAY_SIZE(hts221_avg_list[HTS221_SENSOR_H].avg_avl);
+			break;
+		case IIO_TEMP:
+			*vals = hts221_avg_list[HTS221_SENSOR_T].avg_avl;
+			*length = ARRAY_SIZE(hts221_avg_list[HTS221_SENSOR_T].avg_avl);
+			break;
+		default:
+			return -EINVAL;
+		}
+		*type = IIO_VAL_INT;
+		return IIO_AVAIL_LIST;
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		*vals = hts221_odr_avail;
+		*type = IIO_VAL_INT;
+		*length = ARRAY_SIZE(hts221_odr_avail);
+		return IIO_AVAIL_LIST;
+	default:
+		return -EINVAL;
+	}
 }
 
 int hts221_set_enable(struct hts221_hw *hw, bool enable)
@@ -522,27 +513,10 @@ static int hts221_validate_trigger(struct iio_dev *iio_dev,
 	return hw->trig == trig ? 0 : -EINVAL;
 }
 
-static IIO_DEVICE_ATTR(in_humidity_oversampling_ratio_available, S_IRUGO,
-		       hts221_sysfs_rh_oversampling_avail, NULL, 0);
-static IIO_DEVICE_ATTR(in_temp_oversampling_ratio_available, S_IRUGO,
-		       hts221_sysfs_temp_oversampling_avail, NULL, 0);
-static IIO_DEV_ATTR_SAMP_FREQ_AVAIL(hts221_sysfs_sampling_freq);
-
-static struct attribute *hts221_attributes[] = {
-	&iio_dev_attr_sampling_frequency_available.dev_attr.attr,
-	&iio_dev_attr_in_humidity_oversampling_ratio_available.dev_attr.attr,
-	&iio_dev_attr_in_temp_oversampling_ratio_available.dev_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group hts221_attribute_group = {
-	.attrs = hts221_attributes,
-};
-
 static const struct iio_info hts221_info = {
-	.attrs = &hts221_attribute_group,
 	.read_raw = hts221_read_raw,
 	.write_raw = hts221_write_raw,
+	.read_avail = hts221_read_avail,
 	.validate_trigger = hts221_validate_trigger,
 };
 
-- 
2.53.0



