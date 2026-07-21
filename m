Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C589746EF8C;
	Tue, 21 Jul 2026 20:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664279; cv=none; b=k1XIQU/9/clEB0DIPQJxur0dsQJfaqoiIITBonUkP2G9YL9Vkl5kTz27p8g9mGFcKHv6BG/Rb7I/QfrIh0AAL3nr3+3IWPEkWvgrtoRWVSD7Z/R9jR5mesEsznCUzveAg7xI9CrqH5G1Gmkjw+38aDICOQ+GkBqj2pmbt6CTBS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664279; c=relaxed/simple;
	bh=NJqoY9lsT+tF4hVox6tawhTbpKlbTm16k/rv/XIBrbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foUcz9Unmazi1rPNgFcsXUnfSdpHthzuI0CYutZABZIhADL8qDC74GQkMecjqBztrqp+aI9rQFjeBYo0BdYmTKDUzYr49gBvmO5Woz1xpe/Cz1xuE50dj2l+C6IKkC17V9paVroAVLPphCoxg8BPBZyNg1lIdu5z1WTbYtXu/uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz+uN78P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz+uN78P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364461F000E9;
	Tue, 21 Jul 2026 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664278;
	bh=BvrKu8Q3Fk/5OC7G8hKtXXuqCUKwCNisHfXXnxa/UVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tz+uN78PfT43/IiGDaEXLMV8EVS54QyEtuZedaMum+iYDsS2hbGRzBOAoTxTv2yrq
	 oqhn7gqr9Fn2fxFaPRnoMgCiYLMQR9mW5D8LweoL8lovbWKcjkkocoUI8cwqsqa1/q
	 ZBWCNQy9mz+YaipXJs2/zJu7aPECpazukCCYLw8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1139/1276] iio: pressure: Remove redundant pm_runtime_mark_last_busy() calls
Date: Tue, 21 Jul 2026 17:26:22 +0200
Message-ID: <20260721152511.493081649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit dfb68a8ebb2e8d9af6e356ae0806bfd8e854ab44 ]

pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
pm_runtime_mark_last_busy().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20250825135401.1765847-11-sakari.ailus@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: fbe67ff37a6f ("iio: pressure: mpl115: fix runtime PM leak on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |    5 -----
 drivers/iio/pressure/icp10100.c    |    1 -
 drivers/iio/pressure/mpl115.c      |    2 --
 drivers/iio/pressure/zpa2326.c     |    2 --
 4 files changed, 10 deletions(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -747,7 +747,6 @@ static int bmp280_read_raw(struct iio_de
 
 	pm_runtime_get_sync(data->dev);
 	ret = bmp280_read_raw_impl(indio_dev, chan, val, val2, mask);
-	pm_runtime_mark_last_busy(data->dev);
 	pm_runtime_put_autosuspend(data->dev);
 
 	return ret;
@@ -922,7 +921,6 @@ static int bmp280_write_raw(struct iio_d
 
 	pm_runtime_get_sync(data->dev);
 	ret = bmp280_write_raw_impl(indio_dev, chan, val, val2, mask);
-	pm_runtime_mark_last_busy(data->dev);
 	pm_runtime_put_autosuspend(data->dev);
 
 	return ret;
@@ -1951,7 +1949,6 @@ static int bmp580_nvmem_read(void *priv,
 
 	pm_runtime_get_sync(data->dev);
 	ret = bmp580_nvmem_read_impl(priv, offset, val, bytes);
-	pm_runtime_mark_last_busy(data->dev);
 	pm_runtime_put_autosuspend(data->dev);
 
 	return ret;
@@ -2026,7 +2023,6 @@ static int bmp580_nvmem_write(void *priv
 
 	pm_runtime_get_sync(data->dev);
 	ret = bmp580_nvmem_write_impl(priv, offset, val, bytes);
-	pm_runtime_mark_last_busy(data->dev);
 	pm_runtime_put_autosuspend(data->dev);
 
 	return ret;
@@ -2634,7 +2630,6 @@ static int bmp280_buffer_postdisable(str
 {
 	struct bmp280_data *data = iio_priv(indio_dev);
 
-	pm_runtime_mark_last_busy(data->dev);
 	pm_runtime_put_autosuspend(data->dev);
 
 	return 0;
--- a/drivers/iio/pressure/icp10100.c
+++ b/drivers/iio/pressure/icp10100.c
@@ -265,7 +265,6 @@ static int icp10100_get_measures(struct
 			(be16_to_cpu(measures[1]) >> 8);
 	*temperature = be16_to_cpu(measures[2]);
 
-	pm_runtime_mark_last_busy(&st->client->dev);
 error_measure:
 	pm_runtime_put_autosuspend(&st->client->dev);
 	return ret;
--- a/drivers/iio/pressure/mpl115.c
+++ b/drivers/iio/pressure/mpl115.c
@@ -108,7 +108,6 @@ static int mpl115_read_raw(struct iio_de
 		ret = mpl115_comp_pressure(data, val, val2);
 		if (ret < 0)
 			return ret;
-		pm_runtime_mark_last_busy(data->dev);
 		pm_runtime_put_autosuspend(data->dev);
 
 		return IIO_VAL_INT_PLUS_MICRO;
@@ -118,7 +117,6 @@ static int mpl115_read_raw(struct iio_de
 		ret = mpl115_read_temp(data);
 		if (ret < 0)
 			return ret;
-		pm_runtime_mark_last_busy(data->dev);
 		pm_runtime_put_autosuspend(data->dev);
 		*val = ret >> 6;
 
--- a/drivers/iio/pressure/zpa2326.c
+++ b/drivers/iio/pressure/zpa2326.c
@@ -699,7 +699,6 @@ static void zpa2326_suspend(struct iio_d
 
 	zpa2326_sleep(indio_dev);
 
-	pm_runtime_mark_last_busy(parent);
 	pm_runtime_put_autosuspend(parent);
 }
 
@@ -710,7 +709,6 @@ static void zpa2326_init_runtime(struct
 	pm_runtime_enable(parent);
 	pm_runtime_set_autosuspend_delay(parent, 1000);
 	pm_runtime_use_autosuspend(parent);
-	pm_runtime_mark_last_busy(parent);
 	pm_runtime_put_autosuspend(parent);
 }
 


