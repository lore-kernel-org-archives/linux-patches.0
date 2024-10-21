Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2D41E47AA;
	Mon, 21 Oct 2024 10:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506690; cv=none; b=efPOItolCqNsdaQS1L5GEb6TRH7nefx4sPUXzPNzIdn7/rq+AnANsHE1edtHReGKhobhmxhTg2FGsYAy8nqILUY+hQ/06ElObqRF/1863+ihO0yAqweLmb6GwsxjLMRMrPS6joLo0fjzv62aDw90Jn2BMDzogGKu8BrZBEpQQXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506690; c=relaxed/simple;
	bh=+kcAlYGVscT0YDhLTbJ+HDtIaPvzBfRvVO2AZT6IFAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i63jMX6xjnAbHbYGLxzWNuwBDfAUE9+HhjEgP9QLUQxLu4crspgSjn9XnQiUdqPAlazkqZB6gJ7yoqoXCdi52LwEHtxKO+UkfZq/w7H3zIMw09KfGU34ZIsJG+pOUNQ4KpMyudvunMMmgldUSq5QTaWXVPnD14CDcuxMehw5M5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlasbdGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlasbdGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6259BC4CEC3;
	Mon, 21 Oct 2024 10:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506689;
	bh=+kcAlYGVscT0YDhLTbJ+HDtIaPvzBfRvVO2AZT6IFAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlasbdGfENsiepQYGPI2a+djDzrnGQ0OIAR8pls/X0EcdiRg8utWz7dAYJrBtjnsH
	 hnQUbQW34QjLrtgf3KjX9tEqu15iCmhseDgB/M+Im35YW6TtqIjkvrXQkELIkhhDOQ
	 TO9o38s3OWBfLKKfCBN4bZiENz/gADdItZ1UP1hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 088/135] iio: adc: ti-lmp92064: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:04 +0200
Message-ID: <20241021102302.767569469@linuxfoundation.org>
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

commit a985576af824426e33100554a5958a6beda60a13 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 6c7bc1d27bb2 ("iio: adc: ti-lmp92064: add buffering support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-6-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -52,6 +52,8 @@ config AD7091R8
 	depends on SPI
 	select AD7091R
 	select REGMAP_SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Analog Devices AD7091R-2, AD7091R-4,
 	  and AD7091R-8 ADC.


