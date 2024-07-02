Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3809963D;
	Tue,  2 Jul 2024 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941481; cv=none; b=c3TD3gF9Tb8EoEp0bh+sFrA/sYRhpZ2dVNqnSkXIyirw9PPqkFeVmOBevAtzYRoik4UcVLQdWx+EpfKPsQ2lpJE9NkCLqBCllRVDk8MHyobixBug4OkE+hVtUxoQuBeE0QUzZ2y66Xq997OUyPt/EMIFHyyCMNtzdhUhIywDOIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941481; c=relaxed/simple;
	bh=j+2M6NajW4KX/Ms2a1v6jsG200YknMSztQen+CbtvS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbGyJPdp8OYbHXpj3cfav3qV2Ntcye8Pm+96CPsd55ATrfOskQK6/dydo/QapPpHpEOF/pSNyDU1QYkY6KiDRHrphzaewdoBm/2TmOG4Iafb8qiMZTrG/63868fK0PXywuh4mWyucfjNqKKfIn6Pfegtn2DYE4IlLbawvzI+JgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baL3fuoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baL3fuoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B9DC116B1;
	Tue,  2 Jul 2024 17:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941481;
	bh=j+2M6NajW4KX/Ms2a1v6jsG200YknMSztQen+CbtvS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baL3fuoRWl04QUXXhobjvASE0oyR/B6vIbMxZT1vuPOAH3/lRdvBkXtixaH8d9oyH
	 S0ALkWvO6AZtNOyAUZH/LPPihpAmHEKDNWz2GceoA2WoyJkc1vkMfu+6/bL3O7H4GO
	 VsJbWWi2gqcALX4vR8o8mspI/QyChnhZ6hP1fsyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 077/128] iio: accel: fxls8962af: select IIO_BUFFER & IIO_KFIFO_BUF
Date: Tue,  2 Jul 2024 19:04:38 +0200
Message-ID: <20240702170229.142288645@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


