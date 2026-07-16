Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F030D41E6D4;
	Thu, 16 Jul 2026 13:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209049; cv=none; b=uCjbShYOIcNFYyWVTt7VsfzqqeetFIcfSpzGMjQmSu2pB0AHi4bQWBeOZs3WZ/asQz/Ks7DczmxP3SRsaNyBjXGz5AHXhYsupEHYKjm8P/k2CnITxojkOTwDLNrI08SBwkI3jAxhEiNhf7FnSzLdV23dYcro3go3o+lMd8Ugjgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209049; c=relaxed/simple;
	bh=d/EomMmnqdpPssVmiWXtMsXynV14InmWad2PcnPlP/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfvGxrDFb+wjqEwvRqgIRl4pXz6jWwd2dOrnVC9s3/18vi0ixiHrCWje74X/S8sBWITp0mTf4agxjUKoPtbS/RykWn9Ku/sr3ms1m3r5NnFf5TlghOBsITHqKRx9hyot5GFy2BWvA7FaMgEnM5faqMbpRp8SOnK3FD3U7seOhTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs3y2qiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs3y2qiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F061F00A3A;
	Thu, 16 Jul 2026 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209047;
	bh=Ib6Rj/D12J3qGTeKviVZ9Jh6fjJyYloRv/2q8RDwfDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rs3y2qiMIjUp5lmTzwXm1JSkFZWeL18CxqeGV5hpbgN3hjXvQlRoYjKlEjydxMM9g
	 TFUxfNO5q5TS7z0hNSwJQ2VnHG82xEZoTChJ2HX72UO2MfgAM52vUJoS9WMt05tOX7
	 8V7BO+xn6wM5auwaKARA1VTGXmNNUfnZiiC56rIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 038/518] iio: adc: ad7779: add missing select IIO_TRIGGERED_BUFFER to Kconfig
Date: Thu, 16 Jul 2026 15:25:06 +0200
Message-ID: <20260716133048.613386406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit fd354554af1d2b33232ca6c8a3d79ed82413d715 upstream.

The Kconfig entry for the AD7779 is missing a
'select IIO_TRIGGERED_BUFFER' parameter, causing build failures.

Fixes: c9a3f8c7bfcb ("drivers: iio: adc: add support for ad777x family")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -437,6 +437,7 @@ config AD7779
 	depends on SPI
 	select CRC8
 	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	select IIO_BACKEND
 	help
 	  Say yes here to build support for Analog Devices AD777X family


