Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AAC1EABD1;
	Mon, 21 Oct 2024 10:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507076; cv=none; b=gDVIIlkP/EikJ1+mm1cfZoa+6g5LcgZ6rzG4Do6ONDKDM4moikiPLMRMWeylzcvB3GsftUe/yAp6axqQqqhrK0bWerrbRxTF1SNEQpty48qzQo3xXB4kCfY47yBS3FlpY7uce7Ax8oLDdyFqvtx6THBdD1PxfSGGQa+MnPFLRC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507076; c=relaxed/simple;
	bh=UdnfTsdISyKgv0Qwp2FI/pDn6b/5OHhWkUtwVUOfVdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtgCgGdbQ9PmWqDRmXnxlkeQEeg5UOaPvvSOzyC0PF2j08ueFN8VWO5hnuJ8Yh2FLE9qZGzfG+aGY9j4Q2hWmSuc86y88Z0PN42tIbCV0rc/3u5XLiRArUobvz4c13mzPf1wZpr1dqz9blS5XWFfWfzxiadulQ01D0rtYSXLrxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbgIkOxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbgIkOxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C73C4CEC3;
	Mon, 21 Oct 2024 10:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507076;
	bh=UdnfTsdISyKgv0Qwp2FI/pDn6b/5OHhWkUtwVUOfVdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbgIkOxQUfOZ4QTd6g3uOdlQCkJ2fC8aXeBGNr4EtPg+SF+z8vuhOMHzVyZ6RtRGE
	 +Hqex8mjoER3wjoaE13ebkBVcR+UbVIzjN9N2WmEVLAsufdwHn0hQCEmChPHAEs5NN
	 mYzSXDxnS2Kv/IxsO3TMJTf6+VTw6jTFc5GoCmYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 081/124] iio: dac: ad5766: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:45 +0200
Message-ID: <20241021102259.864816666@linuxfoundation.org>
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


