Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A53C15B0FE;
	Tue,  2 Jul 2024 17:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940384; cv=none; b=ke2ZN/I9jaIwALbgPQUa2KUsQZhtYrEwMpUirgq6vSIop0w2C8S3zT9S0onBVf/CxAEGefSJuXgNfQe2cztaVyCmz3ErRuXl092rHkbIPjYg7H8vkVQyCzfw6Lrh37WxSUarj8Nt+HI+2XRnyqYWonInFXwtlptfdkiV1cFCjfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940384; c=relaxed/simple;
	bh=ORbvQtg7StZZjvjUcTOoqlLne/2sWI3QSfZ3+CY+WzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugeSEWXK4TKuUyCZvZtoirSURSEIJNK4p2U24hcCmyL7hxef1aiw7/Q+4pmVTjtNa+dg0VmrzlnbH2oFHoygwDvlEFL8J4dkKy4WZ6nTEkGjBThrmwVgyRSSDDcmTE+wLUCOWdWyk9Lcbgi7kEhV6fmdAsM1A5JFT7HxjF3LKpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qty9uM2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qty9uM2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786ACC116B1;
	Tue,  2 Jul 2024 17:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940383;
	bh=ORbvQtg7StZZjvjUcTOoqlLne/2sWI3QSfZ3+CY+WzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qty9uM2iqABtu8FDQ3unePJxh/FlQCFUR5zjSGEdYBMDniq3aXzbJcjBZ/40ZKLWA
	 POpAeNAn8J3uoXMBTTdsyAhFylGcPuivRCvDFTld8zRTcEpCGbcd3mJ8rAR3U32RlQ
	 NajzAuBe6T++ni06MiEnZZKTV9G/K1iUJsuVMnGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 138/222] iio: accel: fxls8962af: select IIO_BUFFER & IIO_KFIFO_BUF
Date: Tue,  2 Jul 2024 19:02:56 +0200
Message-ID: <20240702170249.246936841@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit a821d7111e3f7c8869961b606714a299bfe20014 upstream.

Provide missing symbols to the module:
ERROR: modpost: iio_push_to_buffers [drivers/iio/accel/fxls8962af-core.ko] undefined!
ERROR: modpost: devm_iio_kfifo_buffer_setup_ext [drivers/iio/accel/fxls8962af-core.ko] undefined!

Cc: stable@vger.kernel.org
Fixes: 79e3a5bdd9ef ("iio: accel: fxls8962af: add hw buffered sampling")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20240605203810.2908980-2-alexander.sverdlin@siemens.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -330,6 +330,8 @@ config DMARD10
 config FXLS8962AF
 	tristate
 	depends on I2C || !I2C # cannot be built-in for modular I2C
+	select IIO_BUFFER
+	select IIO_KFIFO_BUF
 
 config FXLS8962AF_I2C
 	tristate "NXP FXLS8962AF/FXLS8964AF Accelerometer I2C Driver"


