Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920011E0090;
	Wed,  6 Nov 2024 13:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898822; cv=none; b=QKXm5FrUac7+9FwsAYkLw2ghSbvqQXcI+KUPGqr+oYpF9H53b/+g+b/Iof0WNVA9hBtAlfm15FkUMdTDRW65tbBifQ8X4Kme0aRXKXftx+qMMOodAf7IFdpbDcP5R2N/yOfMVhzoiO9Ig9Kgw0kb/x372V4G4y3rZiKf8B8/k2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898822; c=relaxed/simple;
	bh=dcshuZMZkM2xEOJjtdAzFa/GO5Rj6APZLq6wUn2eGKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2LgkFqk5GYLrZD0tRrPPEt5AHOvORw+w6zT6syzXDrWhZwUXZJDLiWsyc+KBd8AP7q7YYEfMU6tUVtckYd0qvJEeanmQa3mE4QufDfGBiajZ+HCgl9BBWWPnrZpLi7q0nfkLFezLNu8bm/5CompBX/aOxnK+vgT2wp8jUOgrwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL85jMbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL85jMbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F64C4CECD;
	Wed,  6 Nov 2024 13:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898822;
	bh=dcshuZMZkM2xEOJjtdAzFa/GO5Rj6APZLq6wUn2eGKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mL85jMbwFbMuG74TWNBoGFmie75C3tQnBaCZajEOfcd3Y/DR+VZ4E77A9lKcIeYvW
	 kS2dTwg8E7JmNRX2ATUSnF5Zqby8a/L2ySnTjawxlhWpd+Rizt0hhYzhaLP9WA4T6n
	 MMQ+lfkhOFkcK/CvfMAaXsbIXJ1xk4wTWd5V1ikg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 367/462] iio: dac: ltc1660: add missing select REGMAP_SPI in Kconfig
Date: Wed,  6 Nov 2024 13:04:20 +0100
Message-ID: <20241106120340.594666818@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -124,6 +124,7 @@ config AD5624R_SPI
 config LTC1660
 	tristate "Linear Technology LTC1660/LTC1665 DAC SPI driver"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Linear Technology
 	  LTC1660 and LTC1665 Digital to Analog Converters.


