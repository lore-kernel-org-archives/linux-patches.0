Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ADE1E47B4;
	Mon, 21 Oct 2024 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507088; cv=none; b=P1gMPMOYzdBI1a6dXI8ORaujO6qZK3xuKJN7t0Y11dNdXi6FkOa62DpLfPVegFFAA/OwH/2YxI7eZp9YWfMV+fbubKBqEV/f8iOuogCXclizFf2pbCMFouk0VzmEzZc7SyZWTCNVSDmVg9i+9TqakQaZtyZKt1mbIU5OEAs5oVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507088; c=relaxed/simple;
	bh=6/HB31VyYrbXvYl0T5QUADyR1IULBmXFDjFL7N8KNJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhpiAzk/8rXga5wB6ZSUjUOLHhX4oy3nPe/98HRTTAeptgugWbJdznn5l3HMJSZY6o0Zivvxl3qp8Ep2P+Gh7cd+a7aWN5P1n8+l+v935imLBH4LIZINGEGhWFWh/aAzyeVr8v14HR4x3HNqNGlGbmwc8yYq1kw5BkQcCNAUXwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGK6rp6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGK6rp6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E9AC4CEC3;
	Mon, 21 Oct 2024 10:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507087;
	bh=6/HB31VyYrbXvYl0T5QUADyR1IULBmXFDjFL7N8KNJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGK6rp6gB9Y1ygg1DJkUEeUiclfyi3vjHhZ8wRxkLxLIWvMXw1fCtFhY2H21EOQTu
	 /7Gs4QRLDLHmIumRQqWrhYOdX1/vDfYvS7nlf6KG8Xf9eBnB5ZcH6g2mTl+6Mej1j1
	 eXAnfc0Zvoi5onGVyAHTvWTX1kKRHYO5DmAyu+nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 084/124] iio: adc: ti-lmp92064: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:24:48 +0200
Message-ID: <20241021102259.981233242@linuxfoundation.org>
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

commit f3fe8c52c580e99c6dc0c7859472ec48176af32d upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: 627198942641 ("iio: adc: add ADC driver for the TI LMP92064 controller")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-5-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1332,6 +1332,7 @@ config TI_AM335X_ADC
 config TI_LMP92064
 	tristate "Texas Instruments LMP92064 ADC driver"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for the LMP92064 Precision Current and Voltage
 	  sensor.


