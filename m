Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EF876C9C;
	Tue, 20 Feb 2024 21:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463819; cv=none; b=PJcYyaXRU5MXD8iTvw2tzY0pE9i4hZ6naPx6IWm8EKCLSmTW4qKaaHPu8++UPr2BFrK+WhX8YE5Jhw0x8IedQO8ET1xwY94Oyi1HyQKioHLiFunLFrfc+hy3b3HhPRBr+8XHPzOgRjSQfzu9/aN2stGVTj1I9XsTBsFbPicw/lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463819; c=relaxed/simple;
	bh=TSeh8t0g39A3ruNDsLl52ZgE4l5PdojhK++dwXF8+wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUFPtjz2rznTM7twQPhxYVJgOWkHkUHSYrY86ty27PsJPEbGQTMR7wO2oB4u4/qmBGMx2rAgONF4Et+Jwc9y1ZbPnc+gTExlUwqosifukoxPOS3DXsX+1Difp59Ns0dqY8po1+p9vuwXXrwh0HatAnqZeaIRlkKLVroqUedICzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2lDUzIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2lDUzIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776CAC433C7;
	Tue, 20 Feb 2024 21:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463818;
	bh=TSeh8t0g39A3ruNDsLl52ZgE4l5PdojhK++dwXF8+wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2lDUzIo8po33ze1iIPZlFN9fmoj6MsljAfNTDhoZINAfZiosAcYXTP39/Hq5Mbxo
	 nTWyCtCccCwjOz3bDztUeBLE9lO2MedEhD+sQ5cSmLVlNZFYR4TOMrMV32905VbYt1
	 QDbUKVLh+o3RqaCj9BkBnDC3uifhdnGbvJY2QEfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 163/331] iio: pressure: bmp280: Add missing bmp085 to SPI id table
Date: Tue, 20 Feb 2024 21:54:39 +0100
Message-ID: <20240220205642.657798758@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Sam Protsenko <semen.protsenko@linaro.org>

commit b67f3e653e305abf1471934d7b9fdb9ad2df3eef upstream.

"bmp085" is missing in bmp280_spi_id[] table, which leads to the next
warning in dmesg:

    SPI driver bmp280 has no spi_device_id for bosch,bmp085

Add "bmp085" to bmp280_spi_id[] by mimicking its existing description in
bmp280_of_spi_match[] table to fix the above warning.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Fixes: b26b4e91700f ("iio: pressure: bmp280: add SPI interface driver")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-spi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/pressure/bmp280-spi.c
+++ b/drivers/iio/pressure/bmp280-spi.c
@@ -91,6 +91,7 @@ static const struct of_device_id bmp280_
 MODULE_DEVICE_TABLE(of, bmp280_of_spi_match);
 
 static const struct spi_device_id bmp280_spi_id[] = {
+	{ "bmp085", (kernel_ulong_t)&bmp180_chip_info },
 	{ "bmp180", (kernel_ulong_t)&bmp180_chip_info },
 	{ "bmp181", (kernel_ulong_t)&bmp180_chip_info },
 	{ "bmp280", (kernel_ulong_t)&bmp280_chip_info },


