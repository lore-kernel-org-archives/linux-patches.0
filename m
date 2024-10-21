Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E461F4717;
	Mon, 21 Oct 2024 10:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507493; cv=none; b=pObbQiypoKudNZ3gjjcepupf757dw2aYdEe75+oFX3WG+JnHsj7y6RAJhsbXfQuE+yHFChatJiQ5A7aeAxnT/MUT7Q6iwW8Kz8ybjAuzpeqRQu9nuGfudfHtUfc7UEJTAreFV/1hFdeJs05R0oOGMg2p1vFetN8OKjxx2CUX9lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507493; c=relaxed/simple;
	bh=4iveqZ/G9n0cBS8bPA101gBhQiJyQwnSNRhPCESjUmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8FoQ6sJ3ucSuInRedBcK2p1ZJEWdgwXAQR/DGm3jZ82/k0KY+mASrdhGHb5tQpiJdg6foa1H8HzHhMHtSnMEUoJe8030wZGU6aPb7zVnNinUVFmmgCrzFKpv7L3j7PjVNSJIydtMRWvkb5hHDzk2ZZRmrNYSQD3VgoufghSMNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lv1unOeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lv1unOeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D619AC4CEC3;
	Mon, 21 Oct 2024 10:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507493;
	bh=4iveqZ/G9n0cBS8bPA101gBhQiJyQwnSNRhPCESjUmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lv1unOegkqvIA8ioVcDimVj2duN4LzNYuV4YaHoSIRxO63sLWqJPw+sXzfoNjJvyA
	 UwNsY6kJi6Acn14Y4KcF9rSliiqlkqTpdlA6+oIiJeo50EfA22vBioCGjFasOHObWQ
	 Tn54XjxKYgQ8ayqGC4ntv2C/Udz97OuMcLKYlyx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 64/91] iio: dac: ad5766: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:25:18 +0200
Message-ID: <20241021102252.314720243@linuxfoundation.org>
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

commit 62ec3df342cca6a8eb7ed33fd4ac8d0fbfcb9391 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 885b9790c25a ("drivers:iio:dac:ad5766.c: Add trigger buffer")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-8-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -214,6 +214,8 @@ config AD5764
 config AD5766
 	tristate "Analog Devices AD5766/AD5767 DAC driver"
 	depends on SPI_MASTER
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Analog Devices AD5766, AD5767
 	  Digital to Analog Converter.


