Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027632;
	b=jqCxo+o9bXaklC/GEy12VopGosQ9BXulgoMw5apkbFG4/+kUMQyi+VZuEZSPtEO1o8ws
	 vvkvGf6IulomsNhc+7JZmiLwbV71ycke3SlJQ7fNgb2UV+Zm7Y49AJoRxk23z5aDNyFSl
	 IUki3lRAa3AK9xhMPlFGESXzfBo9cl5Ck3X797vLX6YhVc6Qx23z8YVlpvVh7AIsPuMAW
	 Cj67sC51PM69xV/xrLD2hAep8TcuqvTX69WmO+grfcJh8zRVvNVuenAL5V4g8j/yTRYim
	 9IY5WPXnB0hbAYJdr5KP4GgnO2mYJiY83GMlOLk8mdYOi8E1BoKNchBkO0swe5HUYbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kdr+dLkspABzD7QrDEShOPA3ebdHjbVGSnznNf/MGLY=;
	b=aNtxZzqP4DwNd4Te+5NXhkbkjFUu71zIcMR0POdL8ANX20Gu5J6TxDx1w/70vUfNtBO+
	 or/DkPKg33ASZpwMNIJrKBmt2sGshvB817951yWdKkM/CwC/DTY0RS6gyNOx4PmgeNLKO
	 a/qCXXuSwMs0HfLU4lQBsN6lmWOlb+EKf/jTN9/Ql6OOiMjSXcYYEh0NXCUgX5fjec4eW
	 tqeMNFnZzsYIEOunf0+nMfk67EVWVr4Bn1KwjDYBbxUY6ZuFf+EWZPF42gXqS1c/Y1mkq
	 5vvP3GM3thsXwNYYbUNOrkNEGxANSCwIb/ywem/kjDrBDebSsbFisv7w5ApW7LAHLhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv4dLeyU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A228606A33B;
	Wed, 18 Nov 2026 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv4dLeyU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643101F000C4;
	Wed, 18 Nov 2026 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027631;
	bh=kdr+dLkspABzD7QrDEShOPA3ebdHjbVGSnznNf/MGLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uv4dLeyU8AzSYrHmmDWC+FV8MFhp7m3EjY1Q02B3hINnjwfny7OHLZcvyXl7ahWTI
	 4J8/0gpGxYRYPlPprzrEAQwiST191GTDpvGetTKC/UBmYehV70Sbol+OLpficA0wl8
	 MuD0l8YNBRW6UqEOiddl3TtdMkIG7csUe3AtmowI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <shodan.ai@mcst.ru>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1857/2151] tcp_bpf: propagate error code in tcp_bpf_sendmsg()
Date: Wed, 18 Nov 2026 15:59:52 +0100
Message-ID: <20261118150229.439708766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 82e31923c0553fdbfcddcd910ca07952880ca9b9 ]

In tcp_bpf_sendmsg(), the value returned by sk_msg_memcopy_from_iter()
is checked for error but not propagated to 'out_err' label, so error
handling may not work as expected. Fix this by assigning error value
to 'err', thus making sure that error won't be silently ignored.

Reported-by: Sashiko <shodan.ai@mcst.ru>
Fixes: 5153a75ef34b ("tcp_bpf: Fix copied value in tcp_bpf_sendmsg")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261019082214.102398-1-dmantipov@yandex.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 6027cd33a9fdc..ae0b3a84115af 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -581,6 +581,7 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 					       copy);
 		if (ret < 0) {
 			sk_msg_trim(sk, msg_tx, osize);
+			err = ret;
 			goto out_err;
 		}
 
-- 
2.53.0



