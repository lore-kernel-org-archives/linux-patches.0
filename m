Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F013F7BAFF;
	Wed, 21 Feb 2024 14:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524708; cv=none; b=uBhStSkNnSBjHdj0SwQfD0j4rEHHJJTACRbgRGgYNAHJ6sBn8UMVOHO05eveaHQfbIE62Uh9ieqGP4M0D3cgpAeBqPBTt+YHN75Y/Rr3w3z31uvLj3yoZOD5ZFauCOjLRzvkygYKcR5G9Uic0buAgT15anzasniZnmoDrR6+M7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524708; c=relaxed/simple;
	bh=3E7GiPn8x8fdDvqTdK0ZQG/AYuN8vUxwdxTF+VUJ87c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d05GIKaWco1Fx7/ayip/NT+xRe1DNcBR+MQvB8q904Gnde+u/Ig5vJTL5pbMKDtZLhibu+wrIrri2GCL9i81KeZb3iULb5Wi6IQvBDJux7FO2BTA6hqcRryCcosf+D5j81HXqK4z4iH3Wi5oOSlezrAzSo75a3u3nReoM0z6zZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXYbmzyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXYbmzyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD8DC433C7;
	Wed, 21 Feb 2024 14:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524707;
	bh=3E7GiPn8x8fdDvqTdK0ZQG/AYuN8vUxwdxTF+VUJ87c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXYbmzycRynU0DR7RaOr4jigxVsgK9p+EHAoMhFtOjXHJLAFxDF0eaOTDgpSod6WI
	 dEHhqRR2g9BGOZCgMZIghdI7TfLNGdKeiQQ/zyJF0gxnvUBzR6h0RjpQpqgau3M7t2
	 tc8Wf5DcF8k9o4ocfVg7FOVY8fiGwJJDUQ6Nir3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 325/379] iio: accel: bma400: Fix a compilation problem
Date: Wed, 21 Feb 2024 14:08:24 +0100
Message-ID: <20240221130004.567678834@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 4cb81840d8f29b66d9d05c6d7f360c9560f7e2f4 upstream.

The kernel fails when compiling without `CONFIG_REGMAP_I2C` but with
`CONFIG_BMA400`.
```
ld: drivers/iio/accel/bma400_i2c.o: in function `bma400_i2c_probe':
bma400_i2c.c:(.text+0x23): undefined reference to `__devm_regmap_init_i2c'
```

Link: https://download.01.org/0day-ci/archive/20240131/202401311634.FE5CBVwe-lkp@intel.com/config
Fixes: 465c811f1f20 ("iio: accel: Add driver for the BMA400")
Fixes: 9bea10642396 ("iio: accel: bma400: add support for bma400 spi")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20240131225246.14169-1-mario.limonciello@amd.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -128,10 +128,12 @@ config BMA400
 
 config BMA400_I2C
 	tristate
+	select REGMAP_I2C
 	depends on BMA400
 
 config BMA400_SPI
 	tristate
+	select REGMAP_SPI
 	depends on BMA400
 
 config BMC150_ACCEL


