Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034149;
	b=JkfNEdLvX7nQ9r1OxzvlT5hQVQdc/pRjKLGodRe/1OHfORLYa0LHmS0YZzR29sIhouy1
	 IfkiH9o+/beFgbmRSN9Ae94Bs+pnyKPaO7Vjia9KlT99zOVRXilYgvOFqwVGpVmTJlXo1
	 dqgqP9REoyQtwstvz7t8x1WDKoWM5fRd+d3BlkN9mOOj83JIqPvOJBZWNvhkNMAKn+qt9
	 vmglSmuryAKUqrKDQFwnUPgyi0TWOTlHv5ij2Dm03DSfM14Zcbei+h0q0ZwQjN32x/xz3
	 ovnKjpl9qPI3LqHwjW7Kmb5znVqhWmgg/0x+cl9l8jfnEKu4bCO5uvRGoWfp6LJ9K2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pEOoj4J3geJmaFb/T0elQK9dmdW3pP/iAjQMt6K/Vdk=;
	b=g0mvmZB0x50qkF/QlilANPI8py8FXZsPjNT3y/3L3Z2GnIZFU0Rl5yPYKt5urOyznqgr
	 FLfDFlaJBoa5LJJsXjtaRx4zuZ8FhbMdEvTJnu7PswTZAsUV/HFAlmHGqZZHdnNv40Zlv
	 cQwRQBKEqeP7kftXZCdozWCkpDeNbr0Mi3GgZxVFDYezz16LdsLbauARILTc2bU8HAkBO
	 qYDt1EcP/wVikF9Jd39ZDcbneK2xfnlGT2byWxAwst7YzbpEuQkm55wbpHn1rJ494ewTC
	 ipt49lcqE+b3AMwfb3gZNTKOhg47V5rwmOKuv0vEEYblEihod0LkrASAHCda16ipFVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMfXdwL1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF3B606A33E;
	Wed, 18 Nov 2026 20:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMfXdwL1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9829B1F000C4;
	Wed, 18 Nov 2026 20:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034149;
	bh=pEOoj4J3geJmaFb/T0elQK9dmdW3pP/iAjQMt6K/Vdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMfXdwL1KqB/ZmXYpKumJ+sM7RkjcG47hL6D9vaRoV4vprYvVcZf07i5V68btmNuO
	 Eqfxd3RFQCfmSbTlOyZGRWVmkD/YP19vyGm3mID0UVyMJoden+5Pp0lu4MwOFllXjG
	 zI87pVqnkR6saFX/tqQ2neMpMffZts2L9US6r1rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0267/3318] nfc: mrvl: spi: Unregister dev on allocation fail
Date: Wed, 18 Nov 2026 15:14:49 +0100
Message-ID: <20261118150323.428067653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ad3359a4942c7..db30eb2f1fe15 100644
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



