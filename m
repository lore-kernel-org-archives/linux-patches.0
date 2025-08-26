Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1EE18DF9D;
	Tue, 26 Aug 2025 11:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208768; cv=none; b=J6NhiXi+kmenjzXLs0f7mJh4exzJ/2lNpQCbAa4Mh6f30l09RNrEgQ2z+cYY9A8nJPPHCPS46mKxTK+051Oxk8yfOKwCDkC/cm19TdQBdh0bTPHXBvhBDlOnMPDuB0BdkWQlUqWtQqcpUYtA2v55KVZkomC+XW7NsAPRPao/8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208768; c=relaxed/simple;
	bh=k5OrKneY9nsJnglzQMCYEf6vhH4RzWUU49iDO0F9zeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZM1wU6DK1XvHgwgg1StGJzRpmwDw3fIGoP/6uRgevWz1wY8KSd0FXqeuk1wytUxqfna26bYsUuNhU29wU9cVv3RB8ep376ZQqAp9Jsn1QPRrfKwXcPA4btWGvnrt7CjXOv05zCsbXhylGGBO4qimScgjQ0SUJqUTrhaGmB1Pqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYhEp2v0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYhEp2v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1783EC4CEF1;
	Tue, 26 Aug 2025 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208767;
	bh=k5OrKneY9nsJnglzQMCYEf6vhH4RzWUU49iDO0F9zeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYhEp2v0mISvRNujZXjefaj+y5iVP9txYM2JQykqhSakPJM9xIzPjaoH4OJLkrRDE
	 ds2ga0N7IjkFJfuwfRXW+c7nT1gv0jyHAvOD7LMmSX1kSwk59Ngrv9F5mhLmdMXxvl
	 9Q4zHrR69CF7Iwmlu+s4fOlJtYiTL8dNInihfycE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	Matti Vaittinen <mazziesaccount@gmail.com>
Subject: [PATCH 6.12 236/322] iio: light: Use aligned_s64 instead of open coding alignment.
Date: Tue, 26 Aug 2025 13:10:51 +0200
Message-ID: <20250826110921.731912820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit a801016da0bbb955acf1a551584790e3816bb4db ]

Use this new type to both slightly simplify the code and avoid
confusing static analysis tools. Mostly this series is about consistency
to avoid this code pattern getting copied into more drivers.

Acked-By: Matti Vaittinen <mazziesaccount@gmail.com> #For bu27034, rpr0521
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20241215182912.481706-9-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 433b99e92294 ("iio: light: as73211: Ensure buffer holes are zeroed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/adjd_s311.c    |    2 +-
 drivers/iio/light/as73211.c      |    2 +-
 drivers/iio/light/bh1745.c       |    2 +-
 drivers/iio/light/isl29125.c     |    2 +-
 drivers/iio/light/ltr501.c       |    2 +-
 drivers/iio/light/max44000.c     |    2 +-
 drivers/iio/light/rohm-bu27034.c |    2 +-
 drivers/iio/light/rpr0521.c      |    2 +-
 drivers/iio/light/st_uvis25.h    |    2 +-
 drivers/iio/light/tcs3414.c      |    2 +-
 drivers/iio/light/tcs3472.c      |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/iio/light/adjd_s311.c
+++ b/drivers/iio/light/adjd_s311.c
@@ -56,7 +56,7 @@ struct adjd_s311_data {
 	struct i2c_client *client;
 	struct {
 		s16 chans[4];
-		s64 ts __aligned(8);
+		aligned_s64 ts;
 	} scan;
 };
 
--- a/drivers/iio/light/as73211.c
+++ b/drivers/iio/light/as73211.c
@@ -642,7 +642,7 @@ static irqreturn_t as73211_trigger_handl
 	struct as73211_data *data = iio_priv(indio_dev);
 	struct {
 		__le16 chan[4];
-		s64 ts __aligned(8);
+		aligned_s64 ts;
 	} scan;
 	int data_result, ret;
 
--- a/drivers/iio/light/bh1745.c
+++ b/drivers/iio/light/bh1745.c
@@ -743,7 +743,7 @@ static irqreturn_t bh1745_trigger_handle
 	struct bh1745_data *data = iio_priv(indio_dev);
 	struct {
 		u16 chans[4];
-		s64 timestamp __aligned(8);
+		aligned_s64 timestamp;
 	} scan;
 	u16 value;
 	int ret;
--- a/drivers/iio/light/isl29125.c
+++ b/drivers/iio/light/isl29125.c
@@ -54,7 +54,7 @@ struct isl29125_data {
 	/* Ensure timestamp is naturally aligned */
 	struct {
 		u16 chans[3];
-		s64 timestamp __aligned(8);
+		aligned_s64 timestamp;
 	} scan;
 };
 
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1285,7 +1285,7 @@ static irqreturn_t ltr501_trigger_handle
 	struct ltr501_data *data = iio_priv(indio_dev);
 	struct {
 		u16 channels[3];
-		s64 ts __aligned(8);
+		aligned_s64 ts;
 	} scan;
 	__le16 als_buf[2];
 	u8 mask = 0;
--- a/drivers/iio/light/max44000.c
+++ b/drivers/iio/light/max44000.c
@@ -78,7 +78,7 @@ struct max44000_data {
 	/* Ensure naturally aligned timestamp */
 	struct {
 		u16 channels[2];
-		s64 ts __aligned(8);
+		aligned_s64 ts;
 	} scan;
 };
 
--- a/drivers/iio/light/rohm-bu27034.c
+++ b/drivers/iio/light/rohm-bu27034.c
@@ -205,7 +205,7 @@ struct bu27034_data {
 	struct {
 		u32 mlux;
 		__le16 channels[BU27034_NUM_HW_DATA_CHANS];
-		s64 ts __aligned(8);
+		aligned_s64 ts;
 	} scan;
 };
 
--- a/drivers/iio/light/rpr0521.c
+++ b/drivers/iio/light/rpr0521.c
@@ -203,7 +203,7 @@ struct rpr0521_data {
 	struct {
 		__le16 channels[3];
 		u8 garbage;
-		s64 ts __aligned(8);
+		aligned_s64 ts;
 	} scan;
 };
 
--- a/drivers/iio/light/st_uvis25.h
+++ b/drivers/iio/light/st_uvis25.h
@@ -30,7 +30,7 @@ struct st_uvis25_hw {
 	/* Ensure timestamp is naturally aligned */
 	struct {
 		u8 chan;
-		s64 ts __aligned(8);
+		aligned_s64 ts;
 	} scan;
 };
 
--- a/drivers/iio/light/tcs3414.c
+++ b/drivers/iio/light/tcs3414.c
@@ -56,7 +56,7 @@ struct tcs3414_data {
 	/* Ensure timestamp is naturally aligned */
 	struct {
 		u16 chans[4];
-		s64 timestamp __aligned(8);
+		aligned_s64 timestamp;
 	} scan;
 };
 
--- a/drivers/iio/light/tcs3472.c
+++ b/drivers/iio/light/tcs3472.c
@@ -67,7 +67,7 @@ struct tcs3472_data {
 	/* Ensure timestamp is naturally aligned */
 	struct {
 		u16 chans[4];
-		s64 timestamp __aligned(8);
+		aligned_s64 timestamp;
 	} scan;
 };
 


