Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2155240FD81;
	Wed,  4 Feb 2026 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218068; cv=none; b=BccR93pDbb27R8p7P8OxTDlFyBRPHFr2nIzGb6UK6Oin34FLpw6yskF2k0nc3iMP8pSok40u10RZYmsMuVVEzXfyIyKn+ej41BS+7fvFVM44Xgt8sJOCetYbuuE6yEB8X/RuuNSRZ7dbVR7VPfHkZxBvTtw6IdnuFVWa3W66OS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218068; c=relaxed/simple;
	bh=Z3aAqBfG0ftn65WlxrEJ6T/NyZIBh/LYWVykk2+RwPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhEkVlwNgYx3c4dVfycNTi6y35ZlTUXM0ygZhGPfIVs/7p81WUjuk2gxAkpHLxRRdFi6y9mB7rfm0FkB130oF7Oli2ajKDRdA/CRF/VVJeFZvt3xkrAF2gkf+Y/w7x/g8+nPNr72DtqRaLkDDY6JbY+wwRloVJN6EiI+M05EaXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrMydN5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrMydN5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D451C4CEF7;
	Wed,  4 Feb 2026 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218068;
	bh=Z3aAqBfG0ftn65WlxrEJ6T/NyZIBh/LYWVykk2+RwPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrMydN5GdEMQuQN4nWrpDGH6PTzP++dX3vyYJ+ZugyPhYjA6RXLIncXQnIkWp53Fe
	 gd3SI5k4+exRRLUZA2QxA7q2kxIIyNfGLVImTN/cvqIZfmYF5UzrzUco4PXJMhfy33
	 yVpGaNF7316lMfEPrGO8N3qJcTBcN2cDgonhxx8M=
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
Subject: [PATCH 6.1 158/280] iio: adc: ad9467: fix ad9434 vref mask
Date: Wed,  4 Feb 2026 15:38:52 +0100
Message-ID: <20260204143915.311146627@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


