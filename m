Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779393D967A;
	Wed,  9 Sep 2026 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962382; cv=none; b=hpY9AMlSBLZXBr9YflPOserLUN0PUD5lvFunNnmiORMtZCd5L5kYS9DvbzhXH8nGAkq6tvFV1vXQtQvXCJfYWx0VDrzCUgB+sb1t0hZbSn7EhvzIXTupvX8B7qxVIAsw/OauVfkEs71+vLRqjMFRYTiWJA13ykheF+zZoe23QXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962382; c=relaxed/simple;
	bh=gUkodojZI0f6e5GybG/2dgFK6Rsa8e+fobGCxAPEmzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9Ane/2sNScugZsok8yN9XcK/PI9V5lkuLgKZriZIn7O21KHlALVyFxnUp9d86wDGfqwpwAL2JOk5CLFgDlEF6RL9zE9tH0NUzZf55KhmmNGx2G8y4V1Fz6za+xp7ZDfZzBnaypKVkz5XUE3qowyRbBsQmiIdEv+HSNegetv8Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJ7ZjwnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJ7ZjwnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BB41F00A3A;
	Wed,  9 Sep 2026 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962381;
	bh=k2leCMHxg49Aw7ySG9wGOWPPq8jzELs4C3p0pDgPEkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJ7ZjwnWedRGwf4UiYyXIZdFMs8JETTMKkQPxxcgd4Ft4hYhKVLFTogRl3Dgyix2i
	 MOxpT4hRYNVop8R9NzPjRBzvC7uTnLbRWR+0aa/+oZqfTMP4/loPvaC4FMWkGKUx5S
	 IkAplBFv7lRoHDJL+AV3A4uY74HzQlEqpyeWMuqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 271/556] iio: dac: ad5446: fix OF module device table
Date: Wed,  9 Sep 2026 15:39:11 +0200
Message-ID: <20260909134240.140833644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit a3c03cf36a083893dedad928915471dc8c10692e upstream.

The ad5446 I2C driver exports its OF match table with
MODULE_DEVICE_TABLE(OF, ...).

The device table type is used by modpost when generating module aliases,
and scripts/mod/file2alias.c matches the lowercase "of" type.  Using
"OF" prevents the OF table from being recognized, so no OF module alias is
generated for the I2C driver.

Use the lowercase "of" type so OF-based module autoloading works.

Fixes: 876d94024087 ("iio: dac: ad5446: Separate I2C/SPI into different drivers")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5446-i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5446-i2c.c
+++ b/drivers/iio/dac/ad5446-i2c.c
@@ -83,7 +83,7 @@ static const struct of_device_id ad5446_
 	{ .compatible = "adi,ad5622", .data = &ad5622_chip_info },
 	{ }
 };
-MODULE_DEVICE_TABLE(OF, ad5446_i2c_of_ids);
+MODULE_DEVICE_TABLE(of, ad5446_i2c_of_ids);
 
 static struct i2c_driver ad5446_i2c_driver = {
 	.driver = {


