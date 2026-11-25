Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620581;
	b=sFdAtfpMe6nE5SBRQkSZBHL0DFFBRVVeOM5QXVFrKuK+xkJYs7c2SNxkn1VfXKfYPTDj
	 zN3jhdOTAxQ8SAtVSSjVBkIlKX0c93M9XvXAwnm6QWBfhhVTZmZ5uhnlATppgqb54FVtR
	 aSBltfX2AHZF82BIJvKKtOTCP/NZCErj6Is3aSRslzvlc+SVkstd0U0rx5xqFISuEf6p6
	 n8GlgG/n6oRQuHRq6Vy0BKCJlGB6aELNLaT6gpw97j8knxyB4+r5LUDFOkqBwuU3gDiHl
	 qQp9z2x0zWJe/lCwp4MUzIT30u5xY9V1m5qPYYromGZhy8WSJNnpLOOROKdwtm8Vmuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=F086xffrg/zxq9TVp2qqVTQUwcc4JuU7Zva06ueXHgQ=;
	b=SfsStaxRJBSJUZpputqsvhs9KOpNB5vErz9wfM3GOE7y/wsIvUWFOYRzRPTU+Npgn1vD
	 5r+NYN/mIM59TK39Upw436wVbRfrq0Qv/tQPfbksW+dHqMGKlkT3L+V6Dx6mALCw54RUj
	 P6ykuSDfB3z5MfYZOJBrayQ7AsGAkaKw8cj1XcJZBfAU+HjcuESNIuHkAHMfcaGZDpAGN
	 EPcOSjk7tQQTouq05yTwzlirKYRIdTXwiIO4jdizwSTiKvW0N2RJdRolFEnedHSYpZrgE
	 du2iGH7dtxLMVAQNNmgYjafgYDcSKRaLYgf6Sl3Y/D8ryycLvOoyq5+TnmFiLORqesA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPWDkn7M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE536606A321;
	Wed, 25 Nov 2026 15:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPWDkn7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDEA1F000C0;
	Wed, 25 Nov 2026 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620581;
	bh=F086xffrg/zxq9TVp2qqVTQUwcc4JuU7Zva06ueXHgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPWDkn7MuAWBO1+4Ndw8DnhgNMLWvSBh3OvPGcHZYeOdxbpSpM2KgDMDxXtElm8vE
	 zisAO4bBwwG7464EHklWqcdFh4HItesV9MLOZ6ZvSOq+V4+jRoOyn5TPCUy35DGgYA
	 xARc4Nto26kxzuUg/heaPTcwp6hYbumOJbmo+yq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0964/1005] iio: accel: adxl313: add missing buffer selections in Kconfig
Date: Wed, 25 Nov 2026 15:38:22 +0100
Message-ID: <20261125143844.250610909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>

commit 4e9f192f997dc56f309090233352d62edbea42ce upstream.

The FIFO support added to the ADXL313 core uses
devm_iio_kfifo_buffer_setup() and iio_push_to_buffers(), but its Kconfig
entry does not select the required buffer support. Enabling either
frontend without IIO_BUFFER or IIO_KFIFO_BUF causes undefined references
to devm_iio_kfifo_buffer_setup_ext() and iio_push_to_buffers().

Select IIO_BUFFER and IIO_KFIFO_BUF from the shared ADXL313 core symbol
so both the I2C and SPI frontends have the required dependencies.

Fixes: ff8093fa6ba4 ("iio: accel: adxl313: add buffered FIFO watermark with interrupt handling")
Cc: stable@vger.kernel.org
Signed-off-by: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
Tested-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -32,6 +32,8 @@ config ADIS16209
 
 config ADXL313
 	tristate
+	select IIO_BUFFER
+	select IIO_KFIFO_BUF
 
 config ADXL313_I2C
 	tristate "Analog Devices ADXL313 3-Axis Digital Accelerometer I2C Driver"


