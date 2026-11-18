Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039133;
	b=seY16G3iFtVZ2O+9P0mJmBlEWR7fllSrPkKCOGn7+KbJGuijJ2QTi/cNKjIAeRkNDfmi
	 T67RRRXbnQY6pYcKxA3/L1bVoiCY7v6W2K+9HyS9Mpz2Go5hIb5+88ewyrDrtHOr7iAxY
	 wz8XAmKMge5QN1TXpN2uJxN8ws3J1BswbhQQ5oaEcMl+agwD3eXD4QviIqDwV2z57Z7jP
	 f0IMIrK7FMp0xRu+U23EygM6Jkki571hI1uwBd8pvVCFfwdKehH59vzjBFdlrDL6S0rFM
	 AUjy8p1+evca98YHyPF1EgNW22zuNSLgXfTmFD7qA/GRPFmoRQK8YF3GBNjGA+vUnyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JOhWYnalAKgLSB2enB1bHm2yvB/3BJGRgieouPOWcSk=;
	b=LADLly7G/ktC2Q13Ak8CYq3fvqrJtOvKHnS9E0dElzMV6BD8yOqc2aFsToAEZonjEGti
	 r0X8K07ALC3QtyL5ti5icZaWUZ6mw7ZaveAvL0E1lMJNqu60DGEgpPVS+gXyJS51TRWjN
	 o5thZf566CyaJZKiXnuGBjQ5qLfbH+Sbuu4YOkR/CyIr/ARLNz3HQnEp543Lbc5OGz4Wx
	 KwWP7JiaSF/1lO/bUa25hj4TjwHvIY8kbFyi5cf0vZc8YogZxYU5s7nE2M+JaGR4dkOTb
	 EnxU9WDMb+qfo2PwhjmtPk3DDCezI2hKWjakLjtBtfztOQls3DGj7e02t+2oNwpYcNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gDqC5zpf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766F2606A325;
	Wed, 18 Nov 2026 21:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gDqC5zpf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2991F000C5;
	Wed, 18 Nov 2026 21:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039133;
	bh=JOhWYnalAKgLSB2enB1bHm2yvB/3BJGRgieouPOWcSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDqC5zpft0jv3WdmUG5BR4+vNiMvd+RGxqDCrmIjSvgSDnLoP+wRw5DEEBI5MLbKl
	 gov3NckdpULuoHWdmWlCW8E2Z4L7QUUzUfhSeHZfExrO2/Ye4OrQyAnV9xOd9MmpjT
	 rThmXy1yxbkpdDD5GbeHNhM0LI8/pMd27fUxEM98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adi Nata <adinata.softwareengineer@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1990/3318] iio: humidity: hts221: report available values via read_avail()
Date: Wed, 18 Nov 2026 15:43:32 +0100
Message-ID: <20261118150421.762691430@linuxfoundation.org>
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
index 2a413da87b760..2c6e27799a229 100644
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



