Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364241E47B4;
	Mon, 21 Oct 2024 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507094; cv=none; b=cx9JuvcEEjckvOhrBpjIUKZSdrp6cqwjiwVpD7swM5rGQp6RQn3NFDyRU2fQdGxVB4Ra/lm1aeImPxau7UVA+IRpbtM7A8boLNSal4TFPyfajqYvjvJsuAYrOzdB5hTfiUgrzEb1rMfbEVPcLXB+ue3Z5kW92cFbuh6nrr46BKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507094; c=relaxed/simple;
	bh=qT3kuYnS4heWWCaae/CjABwoSgKg1DeoFO7r5Av2X50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcCURu0CeU0pTJvNCiDIpf4yj+TCWoFD6+MJ1vxlQvExwHwR5H6v2iYMo2OfwFZkosOg+MPVt5ONlzQNkXAdwFdPrB1k9L6BOarcXalwGUzfMOJUqkjdvsVLgO/eq7b6aiCvSGbyoQMIgdIrTwQKgPUp6BLixeKVf4RGxVXQ+qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mafkapzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mafkapzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2AEC4CEC7;
	Mon, 21 Oct 2024 10:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507093;
	bh=qT3kuYnS4heWWCaae/CjABwoSgKg1DeoFO7r5Av2X50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MafkapzhfaNzu8Hot/GreiQIgN/0k150A0eiUcBSSvGVPN7BFDCc4Nt4TKTkP5BMW
	 xwp7MqrFxLZu1bsHkTmvXZpZ9lyvA881ThZo1G81D8k2j8D9zOPHEGla88D6u5nRLC
	 11pBeWtrsYzdHR1KB68gBkORu5xVebwDxAOppsnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 086/124] iio: accel: kx022a: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:50 +0200
Message-ID: <20241021102300.057173319@linuxfoundation.org>
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

commit 96666f05d11acf0370cedca17a4c3ab6f9554b35 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-1-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -415,6 +415,8 @@ config IIO_ST_ACCEL_SPI_3AXIS
 
 config IIO_KX022A
 	tristate
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 
 config IIO_KX022A_SPI
 	tristate "Kionix KX022A tri-axis digital accelerometer SPI interface"


