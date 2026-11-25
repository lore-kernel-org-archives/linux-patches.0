Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623701;
	b=Or/aegNEjz93l/dNCqZPVBnDdXd74IT6bx1goKEXTcuczsiwsdXynr/jj9dd70abqVpp
	 NYUOZCDaen+4Sp+44XLeitCzzdPFL8WjCcCyjFDQtxhF1HJZCsh1ddvitJbxmfSx7PVyS
	 q04sU50ko8WKyUBJaniuFa7D7u17mnmES4IH+aooyR7HPdeqRN25zdn4VmZwmCNlin6UQ
	 b7+XpavM2RMn7M8xDh7zrwV4AX9O24d+pLTWOLlZrzl8pvrS4oEAzjZgILUlif4ZX02+5
	 PuaAy+uqdrcWxRcsoyAKgUaf50SawPz8ti5CmbeFRMvGTx3fz4+zo+8N2Lewl3BebYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=A0I6skWzgv5k0zAXWXhfSb3i2kRVte5rRdqVQUGTHeA=;
	b=QLU0pbPSGwsvhFm8UDmKCM1BjP11jKw5QSL5YBuU2CcrlQskT9jE4D6kv6zuNIIiNtpa
	 6fcbK+jM1RaJwfvHnA2XglljCSj0FlVdP1TH4c8K702rCkhETUTc/IxADa+djhTjDz2uL
	 j7WlK/3b11MymBhdOnNu5i5k3XLqxUX6QWmmN6cxyP3Pi+pgsG8JXauLfiJuLf+SAFktz
	 uxOU9dP74wxp2DE5Ibga+COX4VA3sU2dONlQrheNCbgwtqJDCjbDvYEkXEenxKnayZrUx
	 etK7Qnn+i2KuVIk54Ofmg21sKcMHotSCKmAot8rmEp5m9VH/slw6pYIshsHneLqQChw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpeqcA40;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C320606A31E;
	Wed, 25 Nov 2026 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpeqcA40
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3711F000EC;
	Wed, 25 Nov 2026 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623701;
	bh=A0I6skWzgv5k0zAXWXhfSb3i2kRVte5rRdqVQUGTHeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpeqcA40tcCHyH6keP46xf7Bc7D0H1/rnMZxhJeUUiC76nTFz9nVhNFP53xOcmeyt
	 V3XZHPsZpcvvl3vhX6fTDGk/Yam0T6ItDvVsxt5IAyCRPNit1x0AS4Fdg4X3CVjIwy
	 xJtq/niNLJmAYqqErzPDknoltM6pOaX95+GgJSxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 944/990] iio: accel: adxl313: add missing buffer selections in Kconfig
Date: Wed, 25 Nov 2026 15:38:31 +0100
Message-ID: <20261125143844.103116030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


