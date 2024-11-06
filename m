Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7E21DF726;
	Wed,  6 Nov 2024 12:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895626; cv=none; b=HHSz2hqZ72tzvGPJb0RhVSl/avKnJ7quYDioptlu1gjaCg1zUh4chmpBp+6R+nJaQkxW9fgfsin8i+PExqfkJnXXpEltBHnHpOxJTijpqyiVO1X/QrhtmurJfsXNM0wNi0MqNgSPAS0wYWtEC0r64ZeWfhxrWjYAqFfbJ7rzjDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895626; c=relaxed/simple;
	bh=h6ZbSamXyjrtZeOcoeHQZZ+fAJROmFovey4UNREuXEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDMjA1+GDSxTHp5ijf7Iqac/xT1CJKCUhm0q+mfu5p2ocsvzdqDMqOr91ePkQHj3IlCTihpdwycCNZAqgb5oly+FlTgn1Qsj2b2WRCqpJSQ719Y05YQejKvhKGeUWE7vHegXK3pIksNZcqSdoUYnZVm+C3i2hFIc48hzmFTHRMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/8C/2h9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/8C/2h9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56587C4CECD;
	Wed,  6 Nov 2024 12:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895626;
	bh=h6ZbSamXyjrtZeOcoeHQZZ+fAJROmFovey4UNREuXEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/8C/2h9ApT88R1wue/Q05Kpp0YojCgFZzITjkVIfR6kydWtSEbAjf99xzBjHq7zL
	 cQ7eQiYgjOGL0I3wVL/5GaXmOYdIXxhut89OGhrSZZbMRhKCAmfndPNh7EW+XnmWUM
	 SX/Pim4ovT4xR4YF5u4V9UxENbI4v0y2gNvIXGzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 280/350] iio: adc: ti-ads8688: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Wed,  6 Nov 2024 13:03:28 +0100
Message-ID: <20241106120327.774986360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -852,6 +852,8 @@ config TI_ADS7950
 config TI_ADS8688
 	tristate "Texas Instruments ADS8688"
 	depends on SPI && OF
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  If you say yes here you get support for Texas Instruments ADS8684 and
 	  and ADS8688 ADC chips


