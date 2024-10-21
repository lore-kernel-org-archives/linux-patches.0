Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193EF1E47B8;
	Mon, 21 Oct 2024 10:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507891; cv=none; b=HO6H2HceWsiDMXTn+K4BNP7NC4SL+hhSWcHGUxhuhbEeXRQHmrw7lKGTfvV7JaZfqMvIBcuyIKM2gnyLNn0+La/8iajx0maYMPIB39jzB237TY6/iZDZOrMZ1dDkScF4poLqykn/Zdk8v3XaCIt4wnZGG54mx4m5CsGE9xeGRFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507891; c=relaxed/simple;
	bh=thz/05KF6Ih2eJkGU1Fy89xxaZIPbIwW2gixrg6CwRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkMiHNjBaG2Nl4CnE1g6MunVehtfGRDkYmhLW7bN376+AGNCSNMN/a6WH7StBRzQlDPrpLvAuhWIBv/P9nmhj9Pv/fh/+pzJ+/FTxZMlv+kL0XrznNuc8Kh1nt+Argc7nX4A77IQ38AWCzmqXUvEfhE1zgeoxiA6v8hNIZED/20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlthxIbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlthxIbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D37BC4CEC3;
	Mon, 21 Oct 2024 10:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507890;
	bh=thz/05KF6Ih2eJkGU1Fy89xxaZIPbIwW2gixrg6CwRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlthxIbUXSb+VQ93/VNtBooMae0pj2rvhbtyAcmUWUbPldClJYXPmr4DiI/ckDMCC
	 UY2bFschjLwpyc6w60jQqQOXh0rVuFzkLtY7iZ5qtfobvdhOpC1aozaYYYvr5Fhjue
	 U5EVNh8TPV+HembYWUDysgSAA5ITNLvJl17Ci3Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 27/52] iio: dac: ltc1660: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:25:48 +0200
Message-ID: <20241021102242.688942713@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -272,6 +272,7 @@ config LPC18XX_DAC
 config LTC1660
 	tristate "Linear Technology LTC1660/LTC1665 DAC SPI driver"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Linear Technology
 	  LTC1660 and LTC1665 Digital to Analog Converters.


