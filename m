Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037141;
	b=cWt/XK3BzawwPa8V3QpAa1+6BE2NMcQwFlL9uXWwDdp7mO7gv5jpGhHjPQtKv0o4oPUG
	 NNL7X1w3gDkR4ymQ6QWALAbl2vfh+DKFI1gJ9ycwjfdns9Rn3XIi1aWJ02iGuk4Oyjw2q
	 O/sgDTnn2ssftmYiSum15RMMNtgWcUGEzbYSu8jXLYUi1UUEWpTFw6g+4orKNREYYbioe
	 nZDukZ0o88Ta0JpehGF7Wxd7SnJl/FxAHHx3NcoBIo0MPZyX+g//2q9ZJwvy/K2MVn4OK
	 Av64H6ArL4fbBQ1MQ40cvwxv9Ou3kQdB8p9mgtwaIIqaHFCw3Bz3DVes0K2kSomcdag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/2tG1T3SpAjWBYmu8fJjzx2DpSE2wYD8GpLvauYmW5o=;
	b=QwK7RQRJT+KxP6bMD1ctxZ9mV5/ECPz40w0Pa3byPAqDgWGfrXOXVywP0WVcuyjYSrmG
	 pEsNE6HPRwLYJO1uJTeh7emd1S/g1QvPQGgNJ7xtl3WvVD4pkVfJMnUjbd3IQfDfiSDMp
	 v0YK1vVB50UCzvxJNB3RsX898dow2SC6//NYD40XtATeE5XuOrFLjqoq0HD9l9dh5ZePB
	 mTttZj1EYb2H4TZs0Bu4yxa/7C2+gcVdhAjLua/3wViU5sT5ibTxqCzDO9IXPv1KkFRfu
	 aFrYVMgtuKZJICzYSOAxfxLxTAPCOGHA5+Xvj+qHyhZunExmSZZ655olxoQALmzbMgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kTOF/zW+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A523606A33D;
	Wed, 18 Nov 2026 21:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTOF/zW+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8264D1F000C7;
	Wed, 18 Nov 2026 21:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037141;
	bh=/2tG1T3SpAjWBYmu8fJjzx2DpSE2wYD8GpLvauYmW5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTOF/zW+oW5ADm8IQkDIS4YA5qB2aaGYFVUTkSKAaYUUKPMs9R19lHxyDjxKOr6M0
	 7ziScrUBzcf+I2HCYEL6Lis0BJaktDzIaw5suS3jTUHrvjUdOU73oaxzloiZNHv7qV
	 NmS+LWwQlrqUzJF899XyeVaNp8xV3d1Qsw5pPrEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwang Li <jinwang.li@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Siwei Zhang <oss@fourdim.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1308/3318] Bluetooth: L2CAP: Ignore connection responses with wrong ident
Date: Wed, 18 Nov 2026 15:32:10 +0100
Message-ID: <20261118150359.506409498@linuxfoundation.org>
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
index 24e72a40e61af..070211b7a9094 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4283,11 +4283,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
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



