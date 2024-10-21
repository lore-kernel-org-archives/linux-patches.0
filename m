Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75851EB9E1;
	Mon, 21 Oct 2024 10:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507043; cv=none; b=dwJhB4RVMo7D4Rx+ZRsK1POytCZZfrQYwlse/qlZFdC2WGTPliwLMEaS4lEkikXa/IHYQ7dw1ZUJDD4QDpFa1Bb/pIj/g7bHVzLjAwfigXTRStymsL2huSm5O2DHi2HQl5BZhJ82B3UJZagdnf/eLMmzD+IDCSwAW3F8DvYQaAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507043; c=relaxed/simple;
	bh=Eqfae5O5tvKUSdtRvkyUtHW7YCAjsfwAwhciBUcGraM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLjfsP/Q7vGek/LIOTxh8H8xNPo+d3COWz29kSPzgaS8SPrNx2s0w2tt+LTlEtTFxjqvA7nW8cNIQQKYGOxm4jRSJtZ9/947VwXHMLBjX7UlaiSP4fZGEycx1Imcw/ygjQZgxGZgTiM+HXU4g9zM5gHmX93HPQhjpo007AzKOR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0m5RCjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0m5RCjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265B7C4CEC3;
	Mon, 21 Oct 2024 10:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507043;
	bh=Eqfae5O5tvKUSdtRvkyUtHW7YCAjsfwAwhciBUcGraM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0m5RCjsBVafbIQUovN0+NEOvxU5seiAa/RGFOj6iYAXJq3a8xdqPVP8Ia/Y6bJ1X
	 vgQMNE9SzvBCrRrezI82wRdvMOPt5VOYSSj4iffRn8O6NiWXgqhuchvxoriGm74PPA
	 zPHVn9CED2a0Jc8pgb89an5BKrZ8yawhGHFizPKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 071/124] iio: dac: ltc1660: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:24:35 +0200
Message-ID: <20241021102259.480241291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -316,6 +316,7 @@ config LPC18XX_DAC
 config LTC1660
 	tristate "Linear Technology LTC1660/LTC1665 DAC SPI driver"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Linear Technology
 	  LTC1660 and LTC1665 Digital to Analog Converters.


