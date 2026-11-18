Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051410;
	b=b46/6RZN6ehmYzJB9QgcGRVu4nhBvGN+idxRQbfcJOs+vzMDo+9+qCgJp8P70oNhs5Ah
	 heHYAKr5UC3QVzu2sbTmPFCD8SNLRCveDTNaDOmYOnEMZNkplCvz+4/+2p4DOV23GFg98
	 BiY+p5YduTOwB6s5IMvhrOLp8VmDWZUnccqxtQBTaN42NcMJXUwnGEFNfuK/sdk15v0i0
	 Eg7/WtEmOoxY+8efeqlyn/DL0YyQt+wfPe9osu8VqICfvVk1Eg3BtYvv1OgGP77g+mQsh
	 55alq0EfeKl46Usyf5IOArqdTaB8Non3FzUzWIrRdBIAYdQ/9lTYlAS/7yjbGQphCbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mNvCuPZ11rtOuGeQXxhXp9niAWLfXp3Slg4mLmjzCWE=;
	b=4uDDp7jC0bBGn3U9TQVkFWws6T128WNsFAO3YGCifdgyBV8XUD/Ui7mM0S2cNPClPVUz
	 Dy5+uL5klp00i2IFwJKxSOII+jOXJBwsU39Vy+lr741K9mCsSYe0LJQHVTGW+Qy9/MR7V
	 8tU+9YjzgUAPJCKm2LWCmhdZXDzjgWf4iCP6JXz9KxGycwPLEqwXeJlIJ9YL1SQx0EJPM
	 yu6ur62IrAeivrYXRhx1vMqTgLBiFTx6Ic5uhMqVACD4c6EmFRXm6Ey6ozFQ8zM/FKIEv
	 TqzJiAM1OxXlhvWQzQ9J0m3grQ6ZKJL0UT3Zc7kb8ffo9UREKApcWq587o97qQOWlkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qZ3rq8zQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889E0606A320;
	Thu, 19 Nov 2026 01:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qZ3rq8zQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC261F000C5;
	Thu, 19 Nov 2026 01:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051410;
	bh=mNvCuPZ11rtOuGeQXxhXp9niAWLfXp3Slg4mLmjzCWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZ3rq8zQDDM2U0bSCgo3cuq+L5escwqpvUK+ULsZxKwu4uH6RkIlIHiTMONE0l/Yo
	 6AzTLHXKeGzXiz28HmMMg1Oh8GA60zFgkGr1jUwRwzTwH1CI91kNHXaHz7K87kiqYf
	 qb97bl92+o2NTKk3UVNHIJSFkUe3NdSZDPkD810I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0198/2214] nfc: mrvl: spi: Unregister dev on allocation fail
Date: Wed, 18 Nov 2026 15:31:14 +0100
Message-ID: <20261118150018.143624927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index abd75779194cd..23273828a8a41 100644
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



