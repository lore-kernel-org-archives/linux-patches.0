Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214493;
	b=ThYiOr5PQMS1Emvph0wlZdCd8iEocH9k85EBdx6PZzZ6zbFk1hl2aEzE/3Prwt9NBhvG
	 8exLO1d7XHquNc2uRNfUn7ErnyfSWWC5ujaf9MCdDe2GBpwt52B9G3gkvrpROmdiju4Vg
	 J4b4eJfUZzpkccUAG6sVNSFjBxb+6D5lhhCAp14R2wks6Mxk5eHpS2F9E+dQoICynHI1W
	 T0spAQ7bDoOgg1wpd+0iHd+ywFWksF84wcuaIsav2CYgQLvfU4TyilhZqSDi6ZUYJaWxf
	 SL+NBEecl5hivA03Cabc2l/UvwsFXbt3mZFxLeXHECDG0GFEf+HbUbca2Ix6P/AHndw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8fhCqYNDezWyesX5xYWp5w0JIJ+/F/UAK5/YzAOv818=;
	b=IVmcTij6GODmMW8XdIBXNfDwxY8YE3AksnGOVu+3tLDxY3aMjQlZbLKRdIzzOVhTzArI
	 5YOz9DcG5GR/DYdQ6o4WwsvgjvtSwkHWF0VUUHMaPQrtldiEmhewuAdgxIizkoe76XrGw
	 kJfHud9evm8WbdDj0ZhO15DPMKRcPfEyLSNUbLHh5pWcEXserOYWfs3ewSmLK98YWYmGQ
	 IiCtvWO1lGqkFLpq06YK9JrfF/w5yjQ+V1hC/0M6LgxIPqxgHP7ugC75grUaBShDI0pGK
	 wdtLoj3k8yG8YkWU5W3su6L+M872veGZzWSLwiOsm6nI2t2EeSovL0V1gqWdFAHoK+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/sbCssV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555FC606A31F;
	Wed, 28 Oct 2026 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/sbCssV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9E51F01828;
	Wed, 28 Oct 2026 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214493;
	bh=8fhCqYNDezWyesX5xYWp5w0JIJ+/F/UAK5/YzAOv818=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/sbCssVyb8SevwVaODzRez/NUhXAZ7R0MDGhp72n1coWHLO91pIWZpAIDPB7CHnu
	 mCrf1UJNUQ4uyALEGSBW8hxPKbkCYpvTGabilbSBBkiJ8NsL4y6v/StFNS5/nmBQl7
	 4WpU/BSoDAxWrCQ6GQ6VaXbcU84tkrh0sC+B40s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0878/1887] mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop
Date: Wed, 28 Oct 2026 17:49:34 +0100
Message-ID: <20261028170519.397639730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Harini T <harini.t@amd.com>

[ Upstream commit 0aead8197fc1a85b0a89646e418feb49a564b029 ]

The cleanup loop was starting at the wrong array index, causing
out-of-bounds access.
Start the loop at the correct index for zero-indexed arrays to prevent
accessing memory beyond the allocated array bounds.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index b3428c714e2f6..c89989c234111 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -646,7 +646,7 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	struct zynqmp_ipi_mbox *ipi_mbox;
 	int i;
 
-	i = pdata->num_mboxes;
+	i = pdata->num_mboxes - 1;
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (device_is_registered(&ipi_mbox->dev))
-- 
2.53.0



