Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619979;
	b=oGVcQbjapt9GJqY6E7HoKxau505U/y8ONqewrd+SAj9yop6ULZRMrPvX05Y6ozxu2N3f
	 vIX/L5kg4y9+pN86NIJwn7Gb0vxnXZyV+1C3jBeiLKjw1VjHHCNOoAC2J5sXw/ZSVcR4Q
	 s3OcEIN5PidChO+yhpR152gj5ZzqrOJzMCTN5MAijgY79Zh8OFSTpMHS+V6matnDtoY/+
	 8TD/KsZQPo8J9UNqraGp0BhuuqD3DXtLmxfxkDoeLEE8gfXBPnywp2iMMB1MHQ2xI1HWP
	 vHfCS5RXRNvxuGhatRgRHTe9p2rGHZKJiu8mpmv8iSoLuAPqYdukY/icm+WJjHejMpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VE9KcoSSKfAfLEqd4TIMvHBgYk6wwsf2Rw2tPjpLakU=;
	b=Kbi5VdG4lPhe9XLsB1t1LDcgaAgETjkyf5dZOGazP9EpxEb/SsYpVxMaDCLYU9JbT2fb
	 qiM2CfNOkCOrkDJKVXnynZyRA0/QlCFPzYZlfhPrxbMyGci0xpsevEe7osD9s/5+zjzuH
	 +Obax2wDRbF9/qVg21zUoDUKxplyKcvw7nMgcd2z7IxQp93/7N0AiHYexojMlOoctRXgY
	 FxUnJ0BE7jBWlOU1nXWXV77024zo8pWcn7QlGrZhOTuOK4ajUls7+QlkOSkhDtegsxILh
	 SiJvPOj8b3mP/0hHgZxUHUveCla2oOAFxfnS9jKl7MEpsaHZGKhltzvHFN5kar1IN6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lsKXImux;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4177E606A329;
	Wed, 25 Nov 2026 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lsKXImux
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB601F000C4;
	Wed, 25 Nov 2026 15:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619979;
	bh=VE9KcoSSKfAfLEqd4TIMvHBgYk6wwsf2Rw2tPjpLakU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsKXImuxVA8TNNv32cZ4uZbXHSkXsfv2pHSKamenCfxr90XI/KD9P/+m+Iz8pWjVK
	 DACfePVb/vVh+hPGecKMgNSwwDpzag/gh5zYsA93GP8/5P8vb3Po0EPmahKexWeBVt
	 Ef1Ur9W1LrY+TUGuIN8M1VQdM9UWTavDfHWs0/sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0769/1005] sctp: reset stored flag for each association
Date: Wed, 25 Nov 2026 15:35:07 +0100
Message-ID: <20261125143839.759971955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -809,7 +809,6 @@ static int sctp_send_asconf_del_ip(struc
 	struct sctp_sockaddr_entry *saddr;
 	int 			i;
 	int 			retval = 0;
-	int			stored = 0;
 
 	chunk = NULL;
 	sp = sctp_sk(sk);
@@ -822,6 +821,7 @@ static int sctp_send_asconf_del_ip(struc
 		 __func__, sk, addrs, addrcnt);
 
 	list_for_each_entry(asoc, &ep->asocs, asocs) {
+		int stored = 0;
 
 		if (!asoc->peer.asconf_capable)
 			continue;


