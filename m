Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624793;
	b=Y2uXINdmGOYk/3z8fW6om6XuYw5ctPqy49L4mbsFfoskxkP2koBqHCkD/k4UQbbwlOkE
	 0rG6Npl4l7C9BB5qpcZpDQTQKSsShldkc38vewNn8w6ZglT5NyBMqgUtsz4aUeuCkfhyP
	 9KUn3Ak4NbQK24kQpsvKLczyuerriMrwKEiXHOOpFDEaFqz7I/YtZ9nUTS852AHZ0Fsvn
	 TD4NCzy9GVLgqBxaN+/KHjucv+lgD0yLzEh/MJfLSqQleX5z/iTWKnB6M2NNP/Nci0viH
	 nZwxDbmOWx2u15F3aK0Nuw/qKdP/oXtDAOG870pu77k0jk5GXNPLJFOjw5T1hsTRH1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ZTeH4ufTxRcyO2sz52D3kJy0d4d/dEbTvOcjanrwg4=;
	b=UWylHnsLc7wtug4ZfhhQSQJPOw6EP7gWu+eSC/F9B12bhnAbu8a7wXIZAnGbprfraECE
	 FOtFxFIwsVgNScCIFJyeTFLVWHNrDKBTlDJnVBGyuRGDN6N0WolJfZZWKpvcCw6V9a9mI
	 8vTCYtOXzJ6Oqd8A8UriSAg9qWEepDpPImXbLKjntNZfg7nAwRddkuP9ofYeHihPAnBrF
	 XJ8AeW7IRbHkQ8OfldiCyfXQj/9FDNz44dnp5S8zgjBXYeJuo8Nsf4UONupivusWNpCpM
	 L6fDuGf3zL3gYwaTj3aUtEw7KXF/AdFrAb8VY2pETcEtDCc1BzIAAowKmyoAfQfisxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kRyeZuZx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58AC606A329;
	Wed, 25 Nov 2026 16:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kRyeZuZx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F0E1F000D1;
	Wed, 25 Nov 2026 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624793;
	bh=9ZTeH4ufTxRcyO2sz52D3kJy0d4d/dEbTvOcjanrwg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRyeZuZxaHE3myp4Nnw9zK+bAy1JU0Yxo34VO7FoGbjbVoLs1nFrDC8haTC/qXqnM
	 FuSXtchB6X/Cb3U4Bzn8bw82G32cuxOUxmE2xXb2BEX0pTopfLNlbkA1MYRlkyJLkQ
	 8fdabOUNGuWJ/91W8UuEEv0KkkajiOeNkGISeZk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/816] af_unix: Remove gc_in_progress check in unix_peek_fpl().
Date: Wed, 25 Nov 2026 15:30:56 +0100
Message-ID: <20261125143856.330585633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 0edbc945eb9edd0086f25b151a79cfe4adc0dfa8 ]

unix_vertex_dead() and unix_peek_fpl() are synchronised
with unix_peek_seq to prevent GC from purging a live
socket's recvq.

unix_peek_fpl() skips the synchronisation if gc_in_progress
is false.

However, on weakly ordered arch, GC might have already
started working while the write to gc_in_progress is
buffered.

This does not occur on x86.

This is an unlikely path that happens only when AF_UNIX
fd is peeked so not worth complicating.

Instead of adding memory barriers in unix_gc() and
unix_peek_fpl(), let's simply remove the broken short-circuit.

Fixes: e5b31d988a41 ("af_unix: Give up GC if MSG_PEEK intervened.")
Reported-by: Qihang Tang <q.h.hack.winter@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104162858.991930-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 338769200065e..9c1afd8507c57 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -317,9 +317,6 @@ void unix_peek_fpl(struct scm_fp_list *fpl)
 	if (!fpl || !fpl->count_unix)
 		return;
 
-	if (!READ_ONCE(gc_in_progress))
-		return;
-
 	/* Invalidate the final refcnt check in unix_vertex_dead(). */
 	spin_lock(&unix_peek_lock);
 	raw_write_seqcount_barrier(&unix_peek_seq);
-- 
2.53.0



