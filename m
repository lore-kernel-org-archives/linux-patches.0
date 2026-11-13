Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590223;
	b=4o6E2bIeJAeG+98IZQkZ954wQbteBfmCeGhM+SjaKpse7OOeq7DYN81WtyZo+HO/ZVag
	 VtkS5FwSqZrmaZJOHIJT+ab3h3JqpUB7DLlSeL5jf8xI84uaH9yO9zstIkgh7aZ0cPyE8
	 0v1NuiWkyZzpmonJn3uYU/HJwA54awwY3ngLs0MTA4404j0V3NZkaf40AD5uNk2MtYvdm
	 JkrVXsMlg+WC6Czfj+sT/DLqaeFZbONQVB2l+zCuYG7uPInwVlorkxBH/YZW2lP+qCH7Y
	 pP+8puVTDnN3wL3ddg6g/7NwuRFHURSZGE5647Nsgc7nnyOsXAEYtrd63hFYyvQxcsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cyOSScs9fYJ1fhlZpm/21CZfVnJ+brSKo2jnrvQL6po=;
	b=hZp8TvK6n2lFZxj7kWggqJNFLTHU5d70Vizvfyu40ipXmky/Y1sPk9YuVwodkiug+5u7
	 9Qpylo7DHrc5btHtNATWKf0XtVjIGqhnPfpzUGaeW8nXoh1VF97hsDAQ+uesVMwuqxsjD
	 pqaYjiQKfUS6pjF1+IVGje3tCRLo/Uw91qhJ6eTy3XJn0bQBbAD5ITEASDHrDB5AoaUjC
	 PYEdubtacrTwhzDUzWqgtSeK4Gsbh4chklOSilAyXg7x2+E7TKYDDSpBWr65EpNhTreBr
	 v+rZT3erY9lRLt/D93BYOlffAgBcjMONZc2HVK8OuCdFUiwF7RFgsTj9OydrYqSAnpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yr57Z2BJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19B7606C08A;
	Fri, 13 Nov 2026 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yr57Z2BJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AB41F000C4;
	Fri, 13 Nov 2026 17:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590223;
	bh=cyOSScs9fYJ1fhlZpm/21CZfVnJ+brSKo2jnrvQL6po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yr57Z2BJydYjDrXkOvAIVDjWH54YOMbSB5o+b/qV0lgZU3OaerAfnuFm2b7FgHw2H
	 kmrwxQU2IW3S0ULzfa7mmMDu70WbdjZCw76iXgQVMbAZBlbv9sW6egNalp2+ftOO4C
	 REZpLrSZQEUOOy2cp2D07JACAndS3Z+vGtikbxUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/686] net/9p/usbg: set client to Disconnected on usb9pfs_disable
Date: Fri, 13 Nov 2026 10:45:20 -0500
Message-ID: <20261113153827.336153406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit 795f8eeca01d1c9ca3d9a450385b7745ace4e53a ]

This patch is setting the client status to Disconnected, when the
client is still in use. Otherwise a disconnected usb cable would run
any use of the mount to faults.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-2-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index ff787f5fb1631..f1773749d9124 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -748,7 +748,12 @@ static int usb9pfs_set_alt(struct usb_function *f,
 static void usb9pfs_disable(struct usb_function *f)
 {
 	struct f_usb9pfs *usb9pfs = func_to_usb9pfs(f);
+	unsigned long flags;
 
+	spin_lock_irqsave(&usb9pfs->lock, flags);
+	if (usb9pfs->client)
+		usb9pfs->client->status = Disconnected;
+	spin_unlock_irqrestore(&usb9pfs->lock, flags);
 	usb9pfs_clear_tx(usb9pfs);
 }
 
-- 
2.53.0



