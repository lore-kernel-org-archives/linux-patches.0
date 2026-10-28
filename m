Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211098;
	b=jZl4fpvun6593ub+WwGSeDiQS8vf7GYsTX/v6nhdcBJpg9iWE9RxFh+pMtl3NVy2c5Bz
	 Svj1YRIuRlcF5H54dPKEJBlDWDEYqAUJkq9VKKuiUH0eXFVB6hWP3MpxPrr4HPOnz7cDW
	 pMHE/OwA0qbsv00jmZ+JqrS0XS1kttfd3Y2Ozwc17k43abZrhMeGt88iVPF0u9vYpaECA
	 R9VHVqHKeIjIoxN1XlycOu6vvWSy02PubJdhUgMr9IghEHFjiPUZEXd5Rh1U5a9KVlYD3
	 lzko5fjk4O0o7leY/xycie/kURjiZ5SjuM/6O2Au/FtQibI9kk2UcuGddQGRmTkMVzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zG9detQy6XTbQQl9mpSk6GflphiP9WFUQ/jIVL9Dnoc=;
	b=ZHZEXKnFLCnhJyBeGIJJsmz97eewVsqo33Wp0Y2r0tj6fqqE7iUvnjBhoXKJ9KYb1A+j
	 +h0E3lkuKWL4eD8tZDLpTS8rilNlQkOZL+4+d3cnjEgaweNnxdm9sgp5F3+/xUNfLfXi/
	 ERR0bHGAxSjWt3POskg2zI1cJjnqpFVVXbVA1l370MwpSbpsKMtrcNTk0/xD+mokyrPwJ
	 dAkoK40WcrZhB+7kVfJEIRHgPLU7U7qnZd6S33PxMR9QOBVixmdYATZO6HfJQb9LEz/YM
	 XYuf88RqEJmlmmSUjG0y5rjKRoa4f45eNBRjCya2MiLS3LXRFtcIfBHMP6YzFIhL1Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZOZY2ii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45AA60A383F;
	Wed, 28 Oct 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZOZY2ii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381601F01828;
	Wed, 28 Oct 2026 18:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211097;
	bh=zG9detQy6XTbQQl9mpSk6GflphiP9WFUQ/jIVL9Dnoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZOZY2iiseLDmm8o7l50KRbBZ8aM9a+HxRJZd9dYBqhAeWXet+bKY93FHBsLNSKuF
	 TkdCt79Y5wDzkmmqiYVqGxyJM/hhOudv0m9d0jV/oGGHI7KIXkQdRHzJYq2ZDCrI/j
	 m1oZSVsSNSE0GZwO9RtRCdE8/pvQ+9soJnKKA7Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 257/571] iio: imu: adis16480: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:56:44 +0100
Message-ID: <20261028170014.104691100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arkamondalofficial@gmail.com>

commit e1dea54496f90a62318cf4eeaa1e9ef8316e92b6 upstream.

The firmware_revision and firmware_date file operations are open coded
and never call debugfs_file_get(), which debugfs_create_file_unsafe()
requires. debugfs_remove_recursive() therefore does not wait for a read
in progress, and unbind frees the iio_dev underneath it.

Use debugfs_create_file() instead.

Fixes: 9bf94f836e32 ("imu:adis16480: fix debugfs_simple_attr.cocci warnings")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16480.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -300,9 +300,9 @@ static int adis16480_debugfs_init(struct
 	struct adis16480 *adis16480 = iio_priv(indio_dev);
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
-	debugfs_create_file_unsafe("firmware_revision", 0400,
+	debugfs_create_file("firmware_revision", 0400,
 		d, adis16480, &adis16480_firmware_revision_fops);
-	debugfs_create_file_unsafe("firmware_date", 0400,
+	debugfs_create_file("firmware_date", 0400,
 		d, adis16480, &adis16480_firmware_date_fops);
 	debugfs_create_file_unsafe("serial_number", 0400,
 		d, adis16480, &adis16480_serial_number_fops);


