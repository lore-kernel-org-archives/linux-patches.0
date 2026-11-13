Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591006;
	b=AXf71o/te5TlMDljEZgeioSQF5MLjtAOrlZ5jIkLbcPQ6G18Cpvp3KryCSQS6irkCJ27
	 qDQhj3RP7kwTO0u/1afbDvsvKO6wKhw/X3iYvWH8zYlpjHvY9cuDs23/N1sUs6sSv8WHy
	 ELDQ0xutUBI5/NACm/f/Dj2A7v6CLCfq2aMeVoVtbr76X3lVVLVlSHgP5lYIEN/fiUYum
	 dUg+mr02QMZRxnjg8utchA0JaBV3cKUo1CujeiGqQhhrq4BDxPHY2gH/T+wWOY6hxUTgl
	 MiIM+FLoA1ph7brxix78BXDJE4rBdKWBmfq4yKkA5Eqj/G49kUIDFvMuMYMN+pqJrQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eo1XZWGw/JI+Ur/bKpLsEhFcad9brmx+AceQnbZqKrU=;
	b=SFbq8IJMl3+HZq50JO0VkAitnk/OehePrxdBkjyUAf0jM8DOcbfl/0ARqLk75y/yCR1U
	 Fw3KXz0O0kxORMWZ2GKWN347EA+6iIuijgKCipxtpZzDMtqRDQVxV6JwMQzn7yZHtbC4v
	 rZkIsAhMZMm+DTXvHiCdiPml7cUav7i+mwAk1vT4JBPisFPYCFAoE6BBS1hxL0dCX/CHa
	 dtC7//uK1iSnaVHAEc9PPRnLit3Nfu8E5iAgxZ6/6O9ij4GkjBzRd4EIs+XKPNZYZ9S2e
	 e/qZoBOSrpDtGhZCzTsGV0vl/QeVfrw+WrYxGiSnjNpbMiNbCWegonutSFSFBO2sXoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VZ3/aKup";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F2860703FD;
	Fri, 13 Nov 2026 17:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZ3/aKup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069411F000C4;
	Fri, 13 Nov 2026 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591006;
	bh=eo1XZWGw/JI+Ur/bKpLsEhFcad9brmx+AceQnbZqKrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZ3/aKupmZQieDVMKj/uLXjt2TjbYWRzmxcbe9ehaLBTT1XyTl0T5MdWnTo7oZ4mt
	 4tHuuSt9c5zCAQ6v059dTFxtfjZTljT5yNVV8SGpY5VaD6hIOay8hvoJtK/M+xEv7T
	 f+2AoSp8DHzAFhblh2MGsYjBxkp6Zsl28kJWzvjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/670] net/9p/usbg: set client to Disconnected on usb9pfs_disable
Date: Fri, 13 Nov 2026 10:45:40 -0500
Message-ID: <20261113153818.013620694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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



