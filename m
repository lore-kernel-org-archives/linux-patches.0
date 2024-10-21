Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1321E8820;
	Mon, 21 Oct 2024 10:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506737; cv=none; b=YBdCiH1tFFIXm9cKgT32f74q1KGGtQ3smnEu3s3EtlU8sVL1w0k/jN14oe3b9AykrdqPKPgTm3fElhO34/22cZL9N12onYFhpmS53hW07N4dBA1aPYu4LDV/KD3KzMn/dpnx1E7V/r+l7VvdE84SS32GlFJydLow1OIeeMR92Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506737; c=relaxed/simple;
	bh=DnKwP/L0xGckMJwm3oqnWi+NSYcRdRMW7Xn9Mwp09Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NU0HKx9jl11RGJ2yrBLzUIfsLcBLaOi1GdYYqmSPlsWorK/puOpPQW1514eHaxwO9CiVvvoGPlluQIQ0wGUq2QomzuoDYfeOSPV6ASAZakJ2OHj2h8R1jmDrBt4iLjoy77110i6igxNAavBZCYWSogFx5jzz2FfftrLhR019W2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFdcDj+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFdcDj+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB613C4CEE7;
	Mon, 21 Oct 2024 10:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506737;
	bh=DnKwP/L0xGckMJwm3oqnWi+NSYcRdRMW7Xn9Mwp09Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFdcDj+B2K6imy3CMX1npQn9wXlMFl8JOVraDAGhBE+9eha49RgchFFKpzhT2aOtj
	 Af2rtEG5LeJf7vGiX3zSUWETBowI81D73h6xKfjyddHCue1PGqiZCGyPddsrJnyNMB
	 WLC8JmRWVfb0Y3nU1Fpw1yTIcHxAJtkCXSZmIkFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 073/135] iio: adc: ti-ads8688: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:23:49 +0200
Message-ID: <20241021102302.185767316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 4c4834fd8696a949d1b1f1c2c5b96e1ad2083b02 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Fixes: 2a86487786b5 ("iio: adc: ti-ads8688: add trigger and buffer support")
Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-4-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1433,6 +1433,8 @@ config TI_ADS8344
 config TI_ADS8688
 	tristate "Texas Instruments ADS8688"
 	depends on SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS8684 and
 	  and ADS8688 ADC chips


