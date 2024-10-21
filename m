Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020871E503D;
	Mon, 21 Oct 2024 10:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506702; cv=none; b=jnOkR/3LLlXhFUb9ldo4YopL45LzqFuZVAvMun7S0lMo2fytlTkW1O3pd00/CervDdW3waVAN2okXZ8T0mcOErcQzISy6uAHBvvx1LJ/AyPgF/ck4ge8RLPctlvyP0teTSoxUFr9wfPFWd/KAQPrLNcdhm6w398vcu7IhttULYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506702; c=relaxed/simple;
	bh=2QiWorgfFafAtJcWl3v1H53lkDZ0OZeitBmtKVcuUDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJP14iYFKoQDgMtrSEOZl9nmPFZ3MYLPn9aOlBjryO0sDg3Gh5rQ9xeyAKjBGw7l4qy/12ATugX1gWFBO2jUAdTZ+dgbeRabHfcrIhulNrCTCzYyV8OOXletb0VpY/YECMtA7VXzr+H26rVSulXxZSrl1D4UYtly2Jn/f0jl7SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0q2a09z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0q2a09z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7F4C4CEC3;
	Mon, 21 Oct 2024 10:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506701;
	bh=2QiWorgfFafAtJcWl3v1H53lkDZ0OZeitBmtKVcuUDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0q2a09z1iasjoAXLCIJPBaMH5QFWF2vkBCsNm/Pbdw7aY/2WNR//CguYU8AEoQE7
	 eXKT5t3vLSNIUR9JhD8W/Ou2F9KTkc8Bbu7YmRY5XkDD2WTyBO1fit2kVw7HA/2OeR
	 ZlVcUK3ZF4+KPb4H4D/iUui43QgILxQScAjYpM0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 092/135] iio: adc: ad7944: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:08 +0200
Message-ID: <20241021102302.923934690@linuxfoundation.org>
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

commit f4dc96f05149d5e14d7a03c3b16171098847fee9 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: d1efcf8871db ("iio: adc: ad7944: add driver for AD7944/AD7985/AD7986")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-2-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -307,6 +307,8 @@ config AD7923
 config AD7944
 	tristate "Analog Devices AD7944 and similar ADCs driver"
 	depends on SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Analog Devices
 	  AD7944, AD7985, AD7986 ADCs.


