Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB7A262A1
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXn1oRf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5EAC433C7;
	Mon, 16 Oct 2023 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468061;
	bh=ZE/BFfwUv9MbqidmNL4eH3ckCG+LB+i2k/jqS67wQBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXn1oRf4qrq0h8TGxToP1BWiDz/HyBp/00rWqsJNAd6MjHViu4ExWPnXBCJdJY011
	 K9mAkYZjbXrdD5pMjMofSvI4qwMgCRwr6KTzwyXxRNkujDJiCMB8DvjoaHvHiOPuBL
	 HMvegoqDPLkqmykI+kMKhstzPjOpefSYg6tnB2TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.5 118/191] iio: addac: Kconfig: update ad74413r selections
Date: Mon, 16 Oct 2023 10:41:43 +0200
Message-ID: <20231016084018.135221917@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit b120dd3a15582fb7a959cecb05e4d9814fcba386 upstream.

Building ad74413r without selecting IIO_BUFFER and
IIO_TRIGGERED_BUFFER generates error with respect to the iio trigger
functions that are used within the driver.
Update the Kconfig accordingly.

Fixes: fea251b6a5db ("iio: addac: add AD74413R driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Link: https://lore.kernel.org/r/20230912085421.51102-1-antoniu.miclaus@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/addac/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/addac/Kconfig
+++ b/drivers/iio/addac/Kconfig
@@ -24,6 +24,8 @@ config AD74413R
 	depends on GPIOLIB && SPI
 	select REGMAP_SPI
 	select CRC8
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Analog Devices AD74412R/AD74413R
 	  quad-channel software configurable input/output solution.


