Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E4E29D265;
	Thu, 16 Jul 2026 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210562; cv=none; b=PBmWTNrGVVJbei5F8Udi+WeK4rxjMKRrJUnXbt7tqqVM9hA0xqiurP24o875YMnbRanURyaVtCXO67Je3NXKq+N/r43h4fvVO4I+nSSeZoVeTXfPiT6pRJIxO+piBnUvFrOn22Fem/wFXClv9I3TT/tSdSAYsFLnMCdZtCs3TIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210562; c=relaxed/simple;
	bh=7BviYQBABeC+M2svBlUVm6EHR6CoBHh/kH/jWbOuJBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxv9cP2r8ddTIS0ki+ysaxSsUt+nHhXbij5BVJ6AnnnLkuezRmTEMCf7pPCGjxykKVVg4ZmD7YwtcZbz0T1IVo7Yq052JxDXTtQMfFGOCVAFCKSE4UGHf2UzK9xbFSHRGQFAs4aNXTwXDLJotegnnm9Upf3DWa7PYvXKcVZJpDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTMY7/lX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTMY7/lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550401F000E9;
	Thu, 16 Jul 2026 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210560;
	bh=p/mqsbeb1N8+r4/cvdH+Y348P2vBwsSYjmJPskW6plc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTMY7/lXRoDjz2wgetbVVw+bIQv6jJ1IamcVqCAOCt6mnhG5ygGA8qv3vJ+EG4vYd
	 7tFZTSN3Hy68dnY/wzl9oQBzLZ0zVYEaIdRu6/wfYAjA50N1E9KE8WARk4N+RA3Tz0
	 CWf55wMailzwAszREP/ldLBTK32BcacyRRToHvN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 051/480] iio: adc: ad7768-1: Select GPIOLIB
Date: Thu, 16 Jul 2026 15:26:38 +0200
Message-ID: <20260716133045.814255671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 5a9c90350be4f6f175bdd193e8bd60a7aedfb4d2 upstream.

This driver provides a gpio chip a some related functions are not
stubbed if GPIOLIB is not built.

ad7768-1.c:420: undefined reference to `gpiochip_get_data'
ad7768-1.c:498: undefined reference to `devm_gpiochip_add_data_with_key'

Dual sign off reflects change of affiliation whilst this was under review.

Fixes: d569ae0f052e ("iio: adc: ad7768-1: Add GPIO controller support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512271235.WwAmAbOa-lkp@intel.com/
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -386,6 +386,7 @@ config AD7766
 config AD7768_1
 	tristate "Analog Devices AD7768-1 ADC driver"
 	depends on SPI
+	select GPIOLIB
 	select REGULATOR
 	select REGMAP_SPI
 	select IIO_BUFFER


