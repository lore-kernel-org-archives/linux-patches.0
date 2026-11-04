Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830930;
	b=ikcWKADR+GnjEz7prqph+tHA4kkhosVPs5QFu+MMQCtim9j1N4S7x5ljPysZatk0dbaj
	 7E0gRNTpFXnb/zmrkXwTKRNUnXHph8xbWVeY3RFsOb+jChxDRVNQH6Zu1xrv3ca/jURU3
	 jNYnOTixhcAMEU88aFqGI3sUo5UcwwHeA+4qaJCNgJwroI3ZdW8K1B3xXCZ8Hb06JkH//
	 YJCUxskWKu1WhPUDYPE3bdGLNFCrUozcsr2d1ZLEjrXFsl7x5tSRZ6MXAXofKKedttsRw
	 Zec3oiyLSGpyOMAPSP10lVK4VgH1ZmhwKA0NN503esQnckWqAjCoZo4tt5l3twHWk2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3h+TTkb90aYrwuam5cb5i8c36Qqe4L/OOfcUy8ORiVE=;
	b=YQFBGQ+sonlXsbVlGGTOmz8VpT7GZ6xStLObA6ugheP3+YlGLPDVdRS74AmaU0Hk0mGJ
	 3X89LycOASxMs1B0QR6Y7TdIWd/SkqwBYYCkt2csQB5NQR//hegSi43uG5q986G8qqNMW
	 fIl4RGb6pHeVhnlz77BQ7yB4iWeEb7DKuGG9LdZwxB6X6EwJYnJKDTUWZZx9J5RHdojHB
	 fXj0yUNgFmQh5uOpf1Vt1t44+64Q0kNkQQJxhSRelbmEdf6/9z8gQrpt3XmG+O7R5YUsL
	 SL1RlpQvMNiMlcUhgD75eCwf27fiUQtkf6J+4XhiGN5GtMSigdyu7Z15M0Acsvy6hVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhYHsFuv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891DA606A33B;
	Wed,  4 Nov 2026 22:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhYHsFuv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220691F000C1;
	Wed,  4 Nov 2026 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830930;
	bh=3h+TTkb90aYrwuam5cb5i8c36Qqe4L/OOfcUy8ORiVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhYHsFuvCiE/tMb//Yx6fBFW2PCvVSZLdceR5x2jnNIv5TnATFNJnRHh1Thuh2Caq
	 fi0bfTWZ3X5F+kJxioviJzt3xdppi8NLDUX61MDU5jJUM28LG3PJ0DWskvgMR9+CUq
	 Rbj560dIFZF416jPiT8lzVMo+ktQ2MrNGqDe1NhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0382/1005] nfc: mrvl: spi: Unregister dev on allocation fail
Date: Wed,  4 Nov 2026 16:01:55 -0500
Message-ID: <20261104211054.796891043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

[ Upstream commit d832b95697384a2b67f20b35106bbf925358cde9 ]

Call nfcmrvl_nci_unregister_dev() if nci_spi_allocate_spi() fails,
unwrapping the previous call to nfcmrvl_nci_register_dev() during the
nfcmrvl_spi_probe() function.

Assisted-by: gkh-clanker-2000
Cc: David Heidelberg <david@ixit.cz>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026070716-crucial-slouchy-b8a9@gregkh
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcmrvl/spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index 9c8cde1250fb5..dad07c8e13b84 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -168,6 +168,10 @@ static int nfcmrvl_spi_probe(struct spi_device *spi)
 
 	drv_data->nci_spi = nci_spi_allocate_spi(drv_data->spi, 0, 10,
 						 drv_data->priv->ndev);
+	if (!drv_data->nci_spi) {
+		nfcmrvl_nci_unregister_dev(drv_data->priv);
+		return -ENOMEM;
+	}
 
 	/* Init completion for slave handshake */
 	init_completion(&drv_data->handshake_completion);
-- 
2.53.0



