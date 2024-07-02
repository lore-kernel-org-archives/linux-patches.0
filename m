Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350316B394;
	Tue,  2 Jul 2024 17:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941005; cv=none; b=JUCvN6TOs/CDGNE+CKHF7jYUNYOrZKRHBBj+OVGkodjGx/EZDIwSK/Gml2MOLouTUz32eslKYYcVUp+kguapQ5pmpUXRJSnG1ihYbRktlauuDqT6JZHsKfIJXfHILZXT95qT83QuD26vdiJvII37tXimSRXXIn73e4/flQN5b1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941005; c=relaxed/simple;
	bh=Wgt3spuTpg/71TMO4wrKsOn5KAZbQIqIxwGJs47UDY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXiWuuNq+w/QFgjsJqNh+uhkajlTzXTWYAwvKRztM+3ut0BiCDJ/mEang9WiIzs1BLmcyuv2cEyOlNmJFoIK9TS5S1DaICEVxhb1xs+pembQBzlIo/LSQa+DrehsJMF0OF2PmkryQt0NKzl2kVhk+8KJjtQGFPS3TxbFgUFKYHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbnEvEE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbnEvEE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6566C116B1;
	Tue,  2 Jul 2024 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941005;
	bh=Wgt3spuTpg/71TMO4wrKsOn5KAZbQIqIxwGJs47UDY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbnEvEE2dtS2YARBLgEWO22WOCDH5DVmjHpWXruI/uWrNTwS/JC2JlimQclpPKLtX
	 Zyo87y8PQAVlLxFP1QYYMHyAhbmtYCc49N4Zo598CF23EtpE2FWl1cPtVfLZBJa24T
	 MBo1jW2BOFnKi4I36NXEByDy9j0V5XYD+M23VYfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 099/163] iio: accel: fxls8962af: select IIO_BUFFER & IIO_KFIFO_BUF
Date: Tue,  2 Jul 2024 19:03:33 +0200
Message-ID: <20240702170236.810351424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -325,6 +325,8 @@ config DMARD10
 config FXLS8962AF
 	tristate
 	depends on I2C || !I2C # cannot be built-in for modular I2C
+	select IIO_BUFFER
+	select IIO_KFIFO_BUF
 
 config FXLS8962AF_I2C
 	tristate "NXP FXLS8962AF/FXLS8964AF Accelerometer I2C Driver"


