Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059411;
	b=E3rTk5xDz0plBardRXlScqKFRqzZrRih8Sz+haX/j/tZXKnfPph51Dn2aDYHk7zexT/j
	 nAfA2Au+27YfYiUkybJ9crrtywN45/SDrD8cgNvYhWpezHkLC8T41+6FsYiuPXqcuw07E
	 Jw2oPg6VlEhnYNtxJIzM/2w8WhxkBH/v0nFywRBbYipnv1S9aqwlBAAPRQBHh84wGkUsa
	 KluJfN/VSCXO4wmv2XW5ap7zHttvkpzk9QgTFk/NAVoUqI+WX6F0a0NJ8CKj49N81hIoP
	 PMeLwngwhbwUhAvU04p6AxkIxWfTo/FLzfRykeb1WxBxznsmhS8dviqVCXA0bJimVyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t3yZ+WFpG0YF+5x/UnxrTlIhB2HMvC1ERSy7aaKuoSw=;
	b=V9satiXpmdyC5vXuB9jx8Eoi/UP5MWPOtGOpHG6QmjNlfVRjsr0wRSAHqMlEV/NwD4nx
	 B2bGiVWuXFN/uT2XBrYIbVrPrN15TmEvxY9n/0XOXT5nTKAbU6XUEFB18CDtuZLgJyUPL
	 RF4FrJ6sGFJeijy4wAgC6VJtxI5bf5RkjETyiTaDiGGZgXfh7RFer+y8hRAyxPmq0oF+q
	 YLo8bE69Sfhdc5HkriaUc6QgifsTnZtNz46YU+ZOj5GULSevTsfD6H42QJEaf/gcK334y
	 jjqOtfeO5UMoeL9z2yNT9RLw/q1P8iWQFrBZ4TJTTmDMMyGtICxG+cJYDRSyeiGQrxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxOoVNvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99779606A32C;
	Thu, 19 Nov 2026 03:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxOoVNvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67EA1F000C8;
	Thu, 19 Nov 2026 03:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059411;
	bh=t3yZ+WFpG0YF+5x/UnxrTlIhB2HMvC1ERSy7aaKuoSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxOoVNvuv6cdAbiiggRzUiF/zlTjsCmMdh4TrMfjW1v06YHGKb8awjWNkkQ0nZwwX
	 wTTppNt6YMcS/4T6ircZs8YuWzD5SJrHpm1yTQnuMu85MfJCrxKGGlEHXbmZEAsxX7
	 wRcoOTtPHcFbyDyqtlVufeC0MLTJzkSzp7zdFAKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwang Li <jinwang.li@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Siwei Zhang <oss@fourdim.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0831/1848] Bluetooth: L2CAP: Ignore connection responses with wrong ident
Date: Wed, 18 Nov 2026 15:47:49 +0100
Message-ID: <20261118145951.485619330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinwang Li <jinwang.li@oss.qualcomm.com>

commit a9f9eeb5344fc7dc625e5700ccf09891bc2603b5 upstream.

Adjusted context as stable does not have the lockdep_assert_held()
call in l2cap_connect_create_rsp().

L2CAP/COS/CED/BI-28-C requires the IUT to ignore a Connection Response
that carries an invalid Identifier.

l2cap_connect_create_rsp() only checks that a connection request is
outstanding, not that the response answers it. Add an ident check
against the pending request so that a mismatched response is dropped.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jinwang Li <jinwang.li@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a44d4cce05275..98f82f4613e93 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4502,11 +4502,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
 	l2cap_chan_lock(chan);
 
-	/* Only accept a response to a connection request we sent and that
-	 * is still outstanding. A channel waiting in BT_CONNECT for security
-	 * or the feature mask has not sent one yet.
+	/* Only accept a response matching a connection request we sent and
+	 * that is still outstanding. A channel waiting in BT_CONNECT for
+	 * security or the feature mask has not sent one yet.
 	 */
-	if (!l2cap_chan_connect_pending(chan))
+	if (!l2cap_chan_connect_pending(chan) || chan->ident != cmd->ident)
 		goto done;
 
 	switch (result) {
-- 
2.53.0



