Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094631E570F;
	Mon, 21 Oct 2024 10:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507085; cv=none; b=kjXR9S7K1REKoAFiJAIo611tvkigy2v3zsjFG5ebPGCpkJoAcPyH4rHOOj7y1iGXs5551ioj0utDJVpqD1MAuHSmdklYYmAUkbuG+ZUDQtooRa2NWCMbnOAMCB3N//rCJGBFa5fVYUfQeeLUX1FyEUxBdGpV4YwoIRY7k/OJQOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507085; c=relaxed/simple;
	bh=xyBbk2GTxMFJVMdSgyT5sb4OZtuJJpS5MhTr8fDhVnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loM2vbRDIqc17ZpI8sdrdJB+O6rkgUX6CTFIZSuXUB/ixfSKqvl8gdR88Uqm3x9qdiRbq637suA5gQNHYvl8y42/2aZu26QHTIz58CFUwr9lrd0WCfeO7e6dPFqgJhVHkv3k4zJo2SKvYXJh9twjkn6LOBzUCBuMXaSzzkH6AS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+6NnG9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+6NnG9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C290C4CEC7;
	Mon, 21 Oct 2024 10:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507084;
	bh=xyBbk2GTxMFJVMdSgyT5sb4OZtuJJpS5MhTr8fDhVnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+6NnG9Uuo+Vu9EZZLKvU9rBXEjh9HmhuVsikxrfwGRBz9TzbEAjmT76JvI9qNI8h
	 GKelW96h7eWqhR1OhfLzcnGmV3wTh8eBXFu/I/9+N66ahnnqKoKd0sMf2h5udKnkx4
	 0VdMekc1ST0YpF5ZFFnyakJ1jOM+fqqeGsS5xg8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 083/124] iio: dac: ad3552r: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:47 +0200
Message-ID: <20241021102259.942877168@linuxfoundation.org>
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

commit 5bede948670f447154df401458aef4e2fd446ba8 upstream.

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 8f2b54824b28 ("drivers:iio:dac: Add AD3552R driver support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-7-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -9,6 +9,8 @@ menu "Digital to analog converters"
 config AD3552R
 	tristate "Analog Devices AD3552R DAC driver"
 	depends on SPI_MASTER
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Analog Devices AD3552R
 	  Digital to Analog Converter.


