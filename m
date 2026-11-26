Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704626;
	b=BUH5b3G2D18mhrLfVzgmRfenVzs6/34XBPihb/2YkgnmvMNZJKj1YBDNWRquV+lujb5p
	 l8HJzwaea12W5f1jcCe0FAmO+Em9nLD5UaUqY05tPkqntEnNbnAGN4dtPJhFGMdtHDdrR
	 MyQShabTXwaJzny4Z9HB0vH7Af96sKUk7N2ezyOrvHJYvQ2uiAFknqpd4El9dzuCoaY2k
	 hTBXAXnU26Q9vMPztKKvayV80dMYjvD9bzUoOKmz7YT2QyRvUyl4gVV/Fu9QEM5HeO/GX
	 N47xo+tTVvLjR3MG+RrFbwmnsxWfZl187Xn8VjWa+d8FSJSbK4Vo295veDaaFl+q+GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ogYwy0dU3kvZjxNGxP5Ki90uKMCBmAuteKXBh4ODBFM=;
	b=cgGAUJRRNf/4jNwDXAQH+n7/vgHC7wVme5JX3lnW8qg75Z+ArC96o3LfaaIE0TV16ka9
	 J9g6RwKUxA6Sqyf/N1ef+mBFxoZBEEZTgD77aVdIVhY5N0Ijr3SvDak7MgHqJAYXZaugv
	 ADojvgo9x64KFbRLP+8y75u5W1G3LD5bEXHNKmgb+ubbIRNBm9gCh1M4QdCm6uzIxQlqM
	 2Ql+XjDNuB5AuBjznzMGNqK5whX6hDedYFG2RXlV17vythyeHGyWgxBzE5C7pLPZMmeOy
	 gSHlbiX8Uqi28sFV+mhGulEhCLVYfyGVqR0c3omKdIVLjByNWKHmGEB//7b7N/qzqLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jF7cAY1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83A0606A31E;
	Thu, 26 Nov 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jF7cAY1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300E61F000C0;
	Thu, 26 Nov 2026 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704626;
	bh=ogYwy0dU3kvZjxNGxP5Ki90uKMCBmAuteKXBh4ODBFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jF7cAY1E9lw+wpemBBnJ/iKCQ5Qps4IVF1/VLJ/iBRbhOWXLJfG8xljqljz4IlvH+
	 DBM6aZ+CKlfhKS9foG7iGAF3KzNmgQxpcNKtFX6y2AH8abn5GHzUNuGxmf5oW41EP1
	 HKjb4pMQsO9peskBxmzjg99R+YDAWVw+msXpqm54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 187/265] sctp: reset stored flag for each association
Date: Thu, 26 Nov 2026 15:38:37 +0100
Message-ID: <20261126143618.278457384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit 173712d868eb20628ad82deb07f6829a68a9e064 upstream.

sctp_send_asconf_del_ip() walks every association on an endpoint. The
stored flag records that the current association took the single-homed
deferral path and therefore did not allocate an ASCONF chunk. It is
currently scoped to the whole function. Once one association sets it,
later eligible multihomed associations allocate chunks but skip
sctp_send_asconf(), leaking each chunk and its skb.

Reset stored for every association so only an association taking the
deferral path skips transmission. In an A/B kmemleak test, the
vulnerable kernel reported 210 leaked objects from this call path and the
fixed kernel reported none.

Cc: stable@vger.kernel.org
Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261108161149.2774119-1-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -806,7 +806,6 @@ static int sctp_send_asconf_del_ip(struc
 	struct sctp_sockaddr_entry *saddr;
 	int 			i;
 	int 			retval = 0;
-	int			stored = 0;
 
 	chunk = NULL;
 	sp = sctp_sk(sk);
@@ -819,6 +818,7 @@ static int sctp_send_asconf_del_ip(struc
 		 __func__, sk, addrs, addrcnt);
 
 	list_for_each_entry(asoc, &ep->asocs, asocs) {
+		int stored = 0;
 
 		if (!asoc->peer.asconf_capable)
 			continue;


