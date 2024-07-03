Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3E817DA3C;
	Wed,  3 Jul 2024 11:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006136; cv=none; b=aPrE79tQ+UZ9IyRGbf5MiNFonsoozK8yqg8wY61bWNl9l9yQHba49vfUgqnR/GTf+pSSLu1QJ+vPtzJJjbYo5sykOR5b4tkKJBYU0IB2a5FmrFIDmQGzIwrHOgUYaEjkUlIPwxA0G+z2uofLZ8gFhDtryRlN+kOrU2+2CD9lKkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006136; c=relaxed/simple;
	bh=mkDBXsSiYVgU+Sa5fX/n7rCy9dZ2JOkINK9PlWH/RJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx4VYHyWHsFAXSArB5hfqINh9NB8V1m62g7wB2pJZAK8qZs7U0W02GacPCeWmCkQmokeF1ebh6H0S7Rz4LArI5ADKqJtoByRl1IzAPI2xlMmJoP0C13lDAkXCJ83K5i1SU9Fji8mdHmtFXxmVlomUD1CtnJfMoLy0gkbDC0c4To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtKIKoKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtKIKoKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9EAC2BD10;
	Wed,  3 Jul 2024 11:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006136;
	bh=mkDBXsSiYVgU+Sa5fX/n7rCy9dZ2JOkINK9PlWH/RJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtKIKoKqu6Xb+45G/wAP2RuyDV4XRNc/h0aEk3z9M7g/K9zyFOzqoBQztBeke+pAT
	 6zMdKmihDAoH1N2wTBUXt2Tn3F9fDN9reMHKalmW1gONOIlItYnPv7rPKt+isn6fj6
	 9wUaLGLqIO2GcFx+C7MurzuPI3YStMtHh9kqL25E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 311/356] iio: accel: fxls8962af: select IIO_BUFFER & IIO_KFIFO_BUF
Date: Wed,  3 Jul 2024 12:40:47 +0200
Message-ID: <20240703102924.878380346@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -235,6 +235,8 @@ config DMARD10
 config FXLS8962AF
 	tristate
 	depends on I2C || !I2C # cannot be built-in for modular I2C
+	select IIO_BUFFER
+	select IIO_KFIFO_BUF
 
 config FXLS8962AF_I2C
 	tristate "NXP FXLS8962AF/FXLS8964AF Accelerometer I2C Driver"


