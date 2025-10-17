Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1547C330B00;
	Fri, 17 Oct 2025 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716507; cv=none; b=hvP7/vIwxCWuRu62MwfVTeaV6thJKJCDTq3mnzJpmrR5M2o6Db4ASrsCYQUHTFOYCI925vDs1O2MSUg94QzaZVThnY6LGiuZ5hNIHlQIFrYVEuJYs+f3Peab5c3qBNu2YsuVWCB/9/skyRi9DIYtpeC42GOWuCQxq7WYemPfL/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716507; c=relaxed/simple;
	bh=kjQynURkHKU0EgEwKKFducw9mKuuGaGpywgbmaQajYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBKffvtxeO6FPh2PHHIoFxbeloUzf1z2rrOLjWHlqaeX3Y+idOoAFptj6h3Vz3mLmhPJ/aTX/7FE34KbRFGusvKtqsFzdU0fzrgJ5rQwnIkyyqO5VwaKxwD3I32ZEu/KVUxZ+JyaqQ5SP3uRR8H5gSkS+Qzt9M3C3/HnA44sxtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjpGmSVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjpGmSVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6E3C4CEE7;
	Fri, 17 Oct 2025 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716506;
	bh=kjQynURkHKU0EgEwKKFducw9mKuuGaGpywgbmaQajYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjpGmSVbHD+dDj8ZyjuDplKg24FM7Svb2G3zLw/gDjS4lHRO5mLyiaqBNFDKYBX5l
	 /yGLJWvs2aWDcFoHiT/sP1Fi/fmvZ4m7f5SlhBBVu2obH4cUP2spd04l65PUD7Rghg
	 7Nqz5F7zOHRjfoxxmR/EEewCfCcpkyOR4gQ62oJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 181/276] iio: dac: ad5360: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:54:34 +0200
Message-ID: <20251017145149.083644413@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

commit f9381ece76de999a2065d5b4fdd87fa17883978c upstream.

Change the 'ret' variable in ad5360_update_ctrl() from unsigned int to
int, as it needs to store either negative error codes or zero returned
by ad5360_write_unlocked().

Fixes: a3e2940c24d3 ("staging:iio:dac: Add AD5360 driver")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20250901135726.17601-2-rongqianfeng@vivo.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5360.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5360.c
+++ b/drivers/iio/dac/ad5360.c
@@ -262,7 +262,7 @@ static int ad5360_update_ctrl(struct iio
 	unsigned int clr)
 {
 	struct ad5360_state *st = iio_priv(indio_dev);
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&st->lock);
 


