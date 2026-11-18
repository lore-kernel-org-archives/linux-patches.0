Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043496;
	b=RGSN5UqxC81E1nIsClu/wOj3zVUxpRHZMDesQZ6jDH/YQo4fS2dDl6UFojQhQwWzpert
	 DNJrZsINASx9rb43/aE4YzWl8nV+645CQbOt0NX8vJQXxezoh3ezZwdvL+K135FejPbwp
	 KFCIyPhrRPb8IKFV13EIXhx9BTtXt1pinruDzAOFHaQJXtPNzMyLooGV3EVh72Cn5IPxS
	 FseKRkEa6gVmSCJNafwYM6tAmYNsUJK7as/IXIm9DjayW8kOm/5Y9VwATm5a90ERxfIHz
	 K7muAqM7sGJdJyQFUJ4XkRYbJyDqL2LsEq5HbpK+ch6NKOpBUNJuLhop7yEsLpUtDhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qnvi2KU8azxWQcLFY56mgfkJAN/yxLdA0k8rI1h1jLE=;
	b=RFJ6ElXgpi4naA6LD9wxVqeiinW/PgLvywpl02TY5m6efNgWe2q0ivRDfbkCWGqmLrv9
	 raFHV6LCRkDD6pvVzDIepfsQXKLKwhdOngSs0ZPtmdYHVCwLW3n2V1v+gXBaAxZ6gBj2H
	 itFqXdeiwpaDZODH2ttalYesXXbDmZ13qL6yhuB/uI0K0uldLP/nnZt6E4anKNkmuQwjW
	 +9kFKItpE8yWzGB03104UNFYS2quc6Qwlk2RJu0P68CABW5BWLXxN6FTNtMZss5+FFTy+
	 S5SyeW4PNtpiw75+5bALZ4qzgkG0uWNCnmfXUVGCHcGvBsWskTGQsSZHQgf0dQuqHKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VihzDY7b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D84D606A320;
	Wed, 18 Nov 2026 23:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VihzDY7b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CC71F000C4;
	Wed, 18 Nov 2026 23:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043496;
	bh=qnvi2KU8azxWQcLFY56mgfkJAN/yxLdA0k8rI1h1jLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VihzDY7b8aOyNjiS2yoXtcyIjKPNIrmVZ86aiPbRPVyD46IV7ejFWgmFFpjYRb45d
	 iOtERfm4rupbrWPeLes/oC135s4Easkhsb3YMNXcjsl5yM2s8b6NuwZlp99B9gDYAS
	 4USRhcPepwBEhz8gh1qrp/+5dmpCSJAsdg5Ilj/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0230/2857] nfc: mrvl: spi: Unregister dev on allocation fail
Date: Wed, 18 Nov 2026 15:21:04 +0100
Message-ID: <20261118150209.736033519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



