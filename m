Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060961;
	b=Q9ygTYYtoi8lugLsJT0rRokJis2NquftNWXLPGXBAqNeGQClCOHj4wXRfon4AB6bR1gw
	 ud5kl7kC00cN1E6CrOH/LfIpx8Y7st7+k7wMv4blfj7JwrEyAdtv8ZR6syRuAa/ieygAK
	 Cu4dmTTaA050HOP5Qinz6g4cjGmtqH4mhZ8+Z93oYZUzzqv4Voyb6pg39EST5xU5hi9Gp
	 /VJdmX+sFQbTfB+MZwWDoI2ei8mHAKN6PevwY90MKQsa//mpvFX0V0EF9J0kZ3YTyvw/+
	 UvjMC/s5hf5GCewA66TKVCwCFdN9qCzkS4j0NYJSUOYHG+MAxEc1s8w0tWB/z6M8OgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WpdWUCx0s3AMpdxrCtK5ET/XoXIQcZn788hFwSDxfwg=;
	b=jbOTWJ6tFIhXjen1RX3nZAJ3ujWTul23xPd6hjYdPjR8U639lLV4/8qyCa1VjPJYtlrk
	 Eu0kNL69wOT6xuwNjy7q5zbBAxS+qZwdoIUXJQKfPTfBhWzBed31iAePmaN1K1UTNy0im
	 bADNvpbh2MiPkWt8yJkz9isD8otX/HkZPP9Oz1s+Do14pWm/TOEzZQR62W/DiK0Cm91TF
	 tTiidrb4whF95e2ewJnlLUbJUeq/UKfGakd2kt2hz+NGGIK30hp6wDQSDqrpSi5lDBCtS
	 1qblcTBbxF6s08IlbWNS+TN42VAABBt+C0pl2bGiAQoyqLeLv0i8Q36Ys2KdM273DmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxUKA1Hp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2247606A33A;
	Sat,  7 Nov 2026 14:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxUKA1Hp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDCB1F0089F;
	Sat,  7 Nov 2026 14:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060960;
	bh=WpdWUCx0s3AMpdxrCtK5ET/XoXIQcZn788hFwSDxfwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxUKA1HplUKCycKbeAP4iJULX+IUK0EM6l9KhHrTMzMwX3vXPpD23XSL30TWjgS3v
	 JRLkpcFCq4W6gl4ivpeHM1fjaMD1eXNXmrenmCmymU4kUDfOuuq4pnT8xirtgdpCqR
	 eLrY1aTf3HWLVNTHTDOmYJTOXp4V8B8p8/5SojtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0317/1536] nfc: mrvl: spi: Unregister dev on allocation fail
Date: Sat,  7 Nov 2026 08:38:53 -0500
Message-ID: <20261107135006.626308891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



