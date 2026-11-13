Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585399;
	b=5eJkPDM858+XhCL0Tf91EWIi+c8o0sT9NrUZDpdQfQIHlXa2Z/R00WoORGrmJa52wNyD
	 BbbC2afZRhGKntECZm59BKsGp/MI/l/P+gaz4ecgsossjnh7u/pH8vecjzbwM8r1ifib9
	 vF+YXYMaxqdmj4DNwZao30fMro6TTdINfiozySM0d72i4fe8Cd9B9kCQxuXT4jHo11Y/r
	 E+5mU/cW9UdIAgIEg5J5HJnFI2kZDZI88qmsSNS/6gUOJ+s6X8N/T4eN1/p66d49/Yos6
	 e5zj/E6CGyhPL6xwO5kND9uXGdqFJ03UBtp6akt8JitGQB2EKwFX11p4Y45HSxynj8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tRI8ZCtxOvXBTuLuvfVBXwkfZUBJLi1Dn+NnVc7ZC4c=;
	b=KaA0I2mvk31pza8YTHrMb00BU5PO9MqgLlzA+NkB4ipMRDMfEDaPPkeOZKaP/pE0ThIU
	 6Xj4bzNF5KZbJycNvmFSpKoG0c+ncdCXA2aVYvhaIekfQlCkrQL6nsg/BkKlusshtvDtg
	 69mrYjzB7bkteKlFnhvqZuoEXVxoufWRtkr0JUmEb++UpWkEjw/nsb96/fYgEw2loc+or
	 IIls8Qf4gH9EQHuEFna3BCLkYcIQeDJ0Rs1TysM77cLmm16FW2CdydBBZ1Ft28kfDAYqA
	 eSbkkIZbokNo2anpCn8yTQqIX6tMCB9ZSDrA/7lBckRhLwKLb8BiwDz6L8k48iVIrqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nOawqwQK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8D8606A88E;
	Fri, 13 Nov 2026 15:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nOawqwQK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B2D1F000C7;
	Fri, 13 Nov 2026 15:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585399;
	bh=tRI8ZCtxOvXBTuLuvfVBXwkfZUBJLi1Dn+NnVc7ZC4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOawqwQK5pqfC64G7Z9IQZJ1IZmSMmaT0rxdj6vxAA9vomxdw9eRgco0qSoVtPaKk
	 2U+tGd3UXMmOrdhWv6o9OafeZ9wVFQ+kF7inPLrLGdcit8IRA186/n1IRDk0qm3WcS
	 8ZOJb/4tO9Cyxtu5l/hd6DcnnOQoJuRo3bq5Oqas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 052/507] net/9p/usbg: set client to Disconnected on usb9pfs_disable
Date: Fri, 13 Nov 2026 10:45:56 -0500
Message-ID: <20261113153755.314534571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0b7fcba4a2262..a06d0ac163b0d 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -751,7 +751,12 @@ static int usb9pfs_set_alt(struct usb_function *f,
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



