Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6228B424673;
	Thu, 16 Jul 2026 13:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209043; cv=none; b=eNV0+DueCH0bmXhGnNbHJgzvJ6S46vp1PSVDFGVx/BaGizaKyVbM653QMuSSNrgJs+MbzeZv+Jf0XBBrApqvlgimgnPmeNVGhOvn13eSaLIeWnuL1gQFWcWqg1oiOl74pd3dmKxE1hm6aMsO+JNqgUZ5ijk2luqqZdvGlQKyi4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209043; c=relaxed/simple;
	bh=n2/mQxtXCzBes+IVWLX5e/F44V/R+Op8rPkoxsiHYZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STiLkj7czryLg+Xd0MvOPowHNMhgdp8USZ1C/fJqCL+iUVk6A9duoZycQKsdmVNauX2M4F7syCnylrDb3BXh/AjQ43EvM1Kw1+khbSnLQk6/zVmKppNk+VPEaAMJqlvjqz4o9IoiRNTqxRVG3+LOtYEGPaZ2xzHI7t6U+SuX9Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jf8oiRCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jf8oiRCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B3E1F000E9;
	Thu, 16 Jul 2026 13:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209042;
	bh=sOijDjjmFvSUuoo+oogH1nBpA5qWJBuvlY5j1FcRELA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jf8oiRCH+S/Bhu/BqcVm4DZ+DdR4B8JC05AjtUwDzDICFABoC+Fc0ky49rJFd/XPJ
	 2kFOz16UeBr5mf8AQgLNoH+wuoojn6zi3UJQjrfhAkd1qPiv5OHpU5ov2E3H55KaVy
	 KrtcInOMClOIBcOtWMptoaNsZnTZocYLBTZWD8pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 036/518] iio: adc: ad7380: select REGMAP
Date: Thu, 16 Jul 2026 15:25:04 +0200
Message-ID: <20260716133048.569332526@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <samuel.moelius@trailofbits.com>

commit 6697091b386a4e2830bdd38512c87a4befff2b32 upstream.

The AD7380 driver uses generic regmap types and APIs. However, its
Kconfig entry does not select REGMAP.

As a result, AD7380 can be enabled from an allnoconfig-derived config
with SPI_MASTER=y while REGMAP remains unset, causing ad7380.o to fail
to build.

Fixes: b095217c104b ("iio: adc: ad7380: new driver for AD7380 ADCs")
Signed-off-by: Samuel Moelius <samuel.moelius@trailofbits.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -312,6 +312,7 @@ config AD7298
 config AD7380
 	tristate "Analog Devices AD7380 ADC driver"
 	depends on SPI_MASTER
+	select REGMAP
 	select SPI_OFFLOAD
 	select IIO_BUFFER
 	select IIO_BUFFER_DMAENGINE


