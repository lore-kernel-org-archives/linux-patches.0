Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A84D286D57;
	Wed, 28 Jan 2026 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614605; cv=none; b=HimHN0TExiOcJQAspdOmIJDO1WcNAOlPFWUjtVtGr92oK+q5RZSt4EmUEIYfMJyfvG8bn5R8gvHutgHIjom7oVDBkcwsTGaap8TCMGNVFu+uLkmLGCrhvQXrd0YNmO507gRItypBXW1dpPSccUHrhZPr2BBwUV9j8fXRN9A6I7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614605; c=relaxed/simple;
	bh=pox4De20PuP8s+hKmz6GuZpq4e1z9qYJDMj/82v7+O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZuPszuIXEZfybSpxuH+mzevA0Yf/5WKh0d6PRru2QAnDrsHyTVrZbCsR4RG7zbMlvv/iM2LKzyyZKwyiFCO4EG5MxG2ynK0afkN/b4K9he8BGrf8jssEEIttp5x1Jfj9qOQZHBv/oIOHgIonlm0Qejgag/t3thXJMtQ1qV1Mkw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPewFbeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPewFbeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8228C4CEF7;
	Wed, 28 Jan 2026 15:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614605;
	bh=pox4De20PuP8s+hKmz6GuZpq4e1z9qYJDMj/82v7+O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPewFbeLeDSAos20+5R7vIhHaWhsHC80hhSczlATkSBtzmP+J/OfnEnmgELHmjvS3
	 cYLFPHWvS1RY4P97OlDoYrPYdlMQj+4j/83X4GIIJcPWtRJdZioPWuB1lnAIk5b719
	 Aa/ShOw6rtqhoPOE04/k+mHM1EP4HvRiWSCJrt10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Tomas Melin <tomas.melin@vaisala.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 188/254] iio: adc: ad9467: fix ad9434 vref mask
Date: Wed, 28 Jan 2026 16:22:44 +0100
Message-ID: <20260128145351.566149748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Melin <tomas.melin@vaisala.com>

commit 92452b1760ff2d1d411414965d4d06f75e1bda9a upstream.

The mask setting is 5 bits wide for the ad9434
(ref. data sheet register 0x18 FLEX_VREF). Apparently the settings
from ad9265 were copied by mistake when support for the device was added
to the driver.

Fixes: 4606d0f4b05f ("iio: adc: ad9467: add support for AD9434 high-speed ADC")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad9467.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -90,7 +90,7 @@
 
 #define CHIPID_AD9434			0x6A
 #define AD9434_DEF_OUTPUT_MODE		0x00
-#define AD9434_REG_VREF_MASK		0xC0
+#define AD9434_REG_VREF_MASK		GENMASK(4, 0)
 
 /*
  * Analog Devices AD9467 16-Bit, 200/250 MSPS ADC


