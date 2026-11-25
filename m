Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623233;
	b=vgdECdBTLBADp0tdvGmUaT4VgfSbw05g8yF3m6FWNS7tYRm0XHkSlAjAAqHSpXpuO7QH
	 1oKeYizKa3Er5L8kPmVv9t5CU20i59vsJShmdrGXDnqtdeEqVolZfsxY7lfVSxAotBpWY
	 4Ws8pqVeNzIXm8uesD80lvIdgUWcTrRIavzooxRUT84BQtz7KkNwWP8COArK06wlB/pSH
	 UkX4ZBlBUluSbe48zMisXdYctWLhTOWnmN/I6ak4po8kkpOtclwfWaMJnrBT/wiXD7M1U
	 FxF/xGVo9OHg4DJ3iYNN0eeNznEf5rKE8gmBQaXI5UZ/aPNpK7NPWpHmonccC8NNM/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aR5hvyKwzGLQ3hHtuugT93giWdwJYB2fqILADUBgRHs=;
	b=YqSi86TxzZvr3MRd7S5YleYE0uw5HSoqD+exBUd8Dp1RmwiaXs+SPd+14Z5EsF0DCl+/
	 HPAKrAz49jVbcA4T9LcLmrW00s/WIDngZp8hpoxRNNcaXkHFjhew5lR7fi2HsPb85dTBg
	 EdVqxv1T6S2E1Mu61+TI507Uq1pnk6urgwtnEd2wEMHiBKXqbpjT3/fRR3EO6H0uF9yxu
	 QoOrMHXyulGMslLZO+8Xvs+oqAI8lkmoJMxixs7ZxIfwZNFHnlEuE+z4FMvXp9C0V9gHr
	 T8TlSwe7de8uk5xMfldxE5V6uob/VhhLZVfNgSACcNf9nH07+/y+5aUDWWDsl5K9QwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DU5qrbwT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BC3606A335;
	Wed, 25 Nov 2026 16:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DU5qrbwT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697891F000CF;
	Wed, 25 Nov 2026 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623233;
	bh=aR5hvyKwzGLQ3hHtuugT93giWdwJYB2fqILADUBgRHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DU5qrbwTW2JyWZ1F0O56nMye0+j/gaTu8TETFIP2PnvYEo9OBB5INhGhfzK3P48+j
	 Gg0STNpRPXG0FvTmdELBQ/0m1G3YlbWLYd99BV3pZZ1ffl/LohuIXd6fEr9QEGvlSo
	 4m0jsuJmJ8pz8AEZhW1LKYpXA18UZLjHb1cnyYHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 794/990] sctp: reset stored flag for each association
Date: Wed, 25 Nov 2026 15:36:01 +0100
Message-ID: <20261125143840.643328748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -808,7 +808,6 @@ static int sctp_send_asconf_del_ip(struc
 	struct sctp_sockaddr_entry *saddr;
 	int 			i;
 	int 			retval = 0;
-	int			stored = 0;
 
 	chunk = NULL;
 	sp = sctp_sk(sk);
@@ -821,6 +820,7 @@ static int sctp_send_asconf_del_ip(struc
 		 __func__, sk, addrs, addrcnt);
 
 	list_for_each_entry(asoc, &ep->asocs, asocs) {
+		int stored = 0;
 
 		if (!asoc->peer.asconf_capable)
 			continue;


