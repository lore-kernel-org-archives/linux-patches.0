Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781DC1953B9;
	Mon, 21 Oct 2024 10:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507397; cv=none; b=eYj1nKfQbXzRfPm/BDK1ZHPFCmSC0kXe0MZ475vBCiTWINrPda48z90MbTCmOUX33MKhpULp5kSJT9mAivEoEol0aSEBZ4SdPBJLNQT43nF/sxYDdMM+vlOUrTLWluc0LMI1V+euBiJ4OIIvHPijMYlcEk5+wUzlYm6CiOXMGkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507397; c=relaxed/simple;
	bh=dfi2R3a+T66veoGNfpa7oxqrsdE23ftMA68MLm1HqkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZbyECXWKH3pG34BS7OUgUPN3699yDhUKRO94KgNLn5NyNkPE9PhPtywBOn0C6eBOMObgAPBnpYvdNIb5xXDqxxPlt8TubOG6Om6msou08MP/NDrtNS3ME3aI0i6oxjp8ILyQe6KnLk9U0o8j8cJ4Ar2oNin6Cyxj+nGI2y9pEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPQYkWf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPQYkWf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9C0C4CEC3;
	Mon, 21 Oct 2024 10:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507397;
	bh=dfi2R3a+T66veoGNfpa7oxqrsdE23ftMA68MLm1HqkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPQYkWf+T8cWViT9mUIN8i8kWp6LfIqAlpFTv6zwOfrfNGpjoFbAAQEzOfm9F238T
	 RqGqXm+ljVyBPCbAyW6mQRK3nmwX80pyrTXV7fUkpVJCT789lDo8txsiOomjOac92k
	 2VnvuqQ3goOzcRndmeX8TwMlsuxZxnIQFssc8lSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 56/91] iio: dac: ltc1660: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:25:10 +0200
Message-ID: <20241021102252.006309433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 252ff06a4cb4e572cb3c7fcfa697db96b08a7781 upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: 8316cebd1e59 ("iio: dac: add support for ltc1660")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-7-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -315,6 +315,7 @@ config LPC18XX_DAC
 config LTC1660
 	tristate "Linear Technology LTC1660/LTC1665 DAC SPI driver"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Linear Technology
 	  LTC1660 and LTC1665 Digital to Analog Converters.


