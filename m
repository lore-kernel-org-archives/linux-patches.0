Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D141E570F;
	Mon, 21 Oct 2024 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507091; cv=none; b=VRBT/cucaKqea3CR3whaTSxdJLedD2SsQyOjdA6CadyFKnnk+xJeLORKZ8oxca6YzDVR5ty+p6I+K5gjyOL24Bk+oNaq4l9uEShJ6cpCucbWMZazeQTGipI/Kv26THJA+0w4Iu4hWneLQDsSqq5nTyv2a+Ga04zz8v/7r6sY/Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507091; c=relaxed/simple;
	bh=S71VahxyRTnttYdiwC3Lf8jkq5y0kp3b46Tm5m+wXds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4iYqiPjURRMDoA/8Ad720BpegKrBr6/NkwMmKjJWvjJsVzfyFh25m3S4h0zx+ZWl25fE9sYz1mVAMvXXVT3IKkgtY5jio+/thpOEp21VgytGYfr99tcDuscJEQR4hAonX+AsHoyOzf73xXHoZLskfD/gvpmszzuUoA8MOZqdWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+TsPe51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+TsPe51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C8BC4CEC3;
	Mon, 21 Oct 2024 10:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507090;
	bh=S71VahxyRTnttYdiwC3Lf8jkq5y0kp3b46Tm5m+wXds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+TsPe51eHpN/j3GFhwIykBkvkFVt/duBh+xo33wun2y+alwX7EnirgjCSYyyGr0F
	 hjqbbBiuMaEEEOJz82dFzIyxvQEsAezvD8JdBwT7HU++tSBpuo0wDDJbbgK5pnQK1E
	 1OVvMSazv4v3Ge0Hu1wjQhy8HMjEWVQaxt2dRO1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 085/124] iio: adc: ti-ads124s08: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:49 +0200
Message-ID: <20241021102300.019105421@linuxfoundation.org>
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

commit eb143d05def52bc6d193e813018e5fa1a0e47c77 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-3-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1298,6 +1298,8 @@ config TI_ADS8688
 config TI_ADS124S08
 	tristate "Texas Instruments ADS124S08"
 	depends on SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS124S08
 	  and ADS124S06 ADC chips


