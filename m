Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E32E1EF09D;
	Mon, 21 Oct 2024 10:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506680; cv=none; b=IqVC/T/Ucp6lKVo9vxbecik8dpwDLF8i37OWR5kE5x14YWMJLDL2p0hMuQUFtl/p4Xf1hOYOz43wsTnNs+8XQ7jqUnjTbb3XY5fYUfoSAqHMRUrREdxomAe3jhuF+J58gsc2SUa5GT8Pe18DeKD8IQb0+JEOFsILyopxDA0od2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506680; c=relaxed/simple;
	bh=diXriNpZrmWlNyi5j0o25fNynpm96qbaHKTG91JfZ3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljxxK8TgsHfBxKAB8UnENwYkwnAWtECBcnT6e4VkoFKf9hfsEThkvFlbSkMD+vvcdKUj/RjKkkEUX6Q7bVGeI1voEOR3xpawPZBQNCAANT9c+sXiCx4LAB4HBLfigXZMm+F92WgSjqKENPpsuots93QNv9WHXqlFVeTUGHffGLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bcp3ptA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bcp3ptA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C3BC4CEC3;
	Mon, 21 Oct 2024 10:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506678;
	bh=diXriNpZrmWlNyi5j0o25fNynpm96qbaHKTG91JfZ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bcp3ptA6ryBYVpQ4H+smZfv1cLeB2tDPYf7BpxfFsQNFHUL1n7zsy49pv1rk7lmRK
	 G5HfKzVCoCRzcYgnrctz1nAdhCXB7mzVbMe7pXocr5uACuLZIs1sGZk+f3I2uNvrR6
	 QTu9066klZGoXGuPTv3LXb7ZJMYL1W0DjziJqPWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 085/135] iio: dac: ad5766: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 21 Oct 2024 12:24:01 +0200
Message-ID: <20241021102302.651165653@linuxfoundation.org>
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
@@ -252,6 +252,8 @@ config AD5764
 config AD5766
 	tristate "Analog Devices AD5766/AD5767 DAC driver"
 	depends on SPI_MASTER
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Analog Devices AD5766, AD5767
 	  Digital to Analog Converter.


