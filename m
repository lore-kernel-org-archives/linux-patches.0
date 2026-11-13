Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585982;
	b=txN49JnTb008q4qU6fLflTsKZYmQK+lmWxqAd29MTA87ACabKy2XoHERGjC4uC3TLA0/
	 ht9FCJchjrMLJFFJ0sIxK29ZV/EyjOYUdUWLkWuRyoFqk2cIkhyWOioYJ5xRzxCtbfCwE
	 HZIBIux8t2xkHwOj436vQKJ4/CjX9TNrC+Yy+zha9IkAY+BGuym0zVM9SnKQlKM/eXnYb
	 XbVtvbH9T9v4CnL5AHBEJmUwbDaR4Pyw0c1RTyHOcT361hq5yX91qpLA/1hNTHPKQfbfg
	 +D8QIkzddBrghms3kXXnAhaRkPzcXqH8LCyYR0FUbE60hu690mLwxGyQwmpVZHC4lfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+UKwkFuQ7AoNm41mzLhl8OKe7kgDHEHQwCGhodTA7jg=;
	b=oIAlHlyYDbxDPuvMtAAGPWygIzlnNTngae6XhKqmu36fL3Ty3OdMoEMmk+U9RdBRPddn
	 ur9Z7FZKbuah6YdVhXKh2HvekygKJhHLxdDBhnBKj9hj89FWzfrsBmNvGCdoa/v/el5hC
	 b4maR3EcWThEdMKvfqmhRrkiUmfLHZFuTVSWpKakLActEg84oXu44jsDs86HAaVVxSYtS
	 l6VtWfD60QQar+9aXzzCp3kLulwrdyeARpcty0MVP3DjcZIQ7yKvJXkpIwUaGQHCjv+Kl
	 HXUHwczqmX3GLIV4P8gP44TG54KO7Sh1rfb8TG83DRAwLadQKubkMv77TJhNb92CI7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2UGe7J9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEEA6072317;
	Fri, 13 Nov 2026 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2UGe7J9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3D71F000C4;
	Fri, 13 Nov 2026 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585982;
	bh=+UKwkFuQ7AoNm41mzLhl8OKe7kgDHEHQwCGhodTA7jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2UGe7J94yv1ll0bbL/asW2tx7TjIuagQ45HRzaxC2OcAIo0yRl92KY5e1+WZ4RuI
	 MYwpscaIUad6PoMLdJr0egQpm/x952FD7gixAYgVrXrActY8+RFteJTuQMTYJgh1pK
	 1TaYBNdnEcEw4LMCFxZjrSPMrzK3GeomujD/lpOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwang Li <jinwang.li@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Siwei Zhang <oss@fourdim.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/686] Bluetooth: L2CAP: Ignore connection responses with wrong ident
Date: Fri, 13 Nov 2026 10:42:23 -0500
Message-ID: <20261113153821.275476685@linuxfoundation.org>
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
index 22bac1222fab7..d648d57299541 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4332,11 +4332,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
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



