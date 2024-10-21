Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099ED1E503D;
	Mon, 21 Oct 2024 10:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506693; cv=none; b=pJh6Yj6vF+Zac66IZ/osyphQS0T6fwLXf+hqfK08yKJ2BTOIREQJYn89d5ImCfZ6GfwR7Oi8yvdbeKLV+UCXnFi4pq7+mTKqCw5d/lhySj8HvIU7AG1SFp1kaoOCaFGYejCSJmZz8S3tbqSp/An/wj0M+CcLSnKfeVtyX2ap3OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506693; c=relaxed/simple;
	bh=vB9IKBsEcv7iglqZRJ7SaxGDrsdP/UVkN4itGAR72Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQGFidGAceJ69RAaG2F7JKy7OkO+Cm9CIdsjOPUc1evJoScaaDPbaqE2R3iS7sPbZliL3Ix5PsFD4tJSMnPwOgYo+k/dne/bFFoR8frwH74vG/R97tctH0oh8KMc162IxGUrNFoiiwCN0vf33bFQ4BIXfMeTvbiYQiybTsacnZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScyLJ2tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScyLJ2tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7FEC4CEC7;
	Mon, 21 Oct 2024 10:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506692;
	bh=vB9IKBsEcv7iglqZRJ7SaxGDrsdP/UVkN4itGAR72Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScyLJ2tryJaSQEx5Iv8YFN/K/dgBBarkfUlQBNuK8on8Ies3mwCWnwnmG/gzv30x4
	 KNkOv8jdkoa20V0OKBh8+rhi9fMAv9qI/EpI4n+aOQrtQLrPy59vn67uX8STK7sRxp
	 ZmjSmudIA4UoS97HzLNunlC7TEpdi4KTG/W1mHAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 089/135] iio: adc: ti-lmp92064: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:24:05 +0200
Message-ID: <20241021102302.807713433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit f3fe8c52c580e99c6dc0c7859472ec48176af32d upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: 627198942641 ("iio: adc: add ADC driver for the TI LMP92064 controller")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-5-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1481,6 +1481,7 @@ config TI_AM335X_ADC
 config TI_LMP92064
 	tristate "Texas Instruments LMP92064 ADC driver"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for the LMP92064 Precision Current and Voltage
 	  sensor.


