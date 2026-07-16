Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1EB3191C8;
	Thu, 16 Jul 2026 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210559; cv=none; b=s/Z3PuMdmb7NmLn++w3yFjjmVV6p5eYsIJrOrZ63QgkVFXCfM+4W1EH7jCfkrnoaBiF4Ov04DKr6EV2tI8pCfRLaOHH1nzyd8WKVsITD78Yj1lTPPeXslwQAvltu99G+HOqcHUZy7ERSjQlP/UTLrub+fkRGFuIz5WxNJACdTzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210559; c=relaxed/simple;
	bh=fF0vjpXX32u7cag4a7SkOo/vysDfA7mLw8RJY+xblVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDvZybPdk4WCb22NQYG3LZJ39rdd5SAWSj44xRYFLl8QV+M9UEdTpZe/xsWPJGQ2lzAJxL3rHQiuM5/iPhCu7ZWFOhXkhjzWoDhT3FiAgdDb4fWVjpFH2bZltSBTn7VTBRldCpwrjdsFY7G65Zq4Cy+wlDGThEkUnO5GRz/d5SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pj0YpTK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pj0YpTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32421F000E9;
	Thu, 16 Jul 2026 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210558;
	bh=54VmTkxDFUZicf6CXWfDJYE9dLkNmFMXVFP/A7kplhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pj0YpTKRtztEHaswxviICddIthpgXj1XqVMi6vSSTP7oEQo4NGdqjZTnzXfcko7C
	 PR6P1cX3SeSCh//2jqGUNGRmBr8me0/l8yYI6u29omgaMIm2JIpqK1fwLTYWVSWPDw
	 KowBQZRfj96r5fH/QPo5tTjEpZJuzHWS3h+zjEII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <samuel.moelius@trailofbits.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 050/480] iio: adc: ad7380: select REGMAP
Date: Thu, 16 Jul 2026 15:26:37 +0200
Message-ID: <20260716133045.791591345@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -282,6 +282,7 @@ config AD7298
 config AD7380
 	tristate "Analog Devices AD7380 ADC driver"
 	depends on SPI_MASTER
+	select REGMAP
 	select SPI_OFFLOAD
 	select IIO_BUFFER
 	select IIO_BUFFER_DMAENGINE


