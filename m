Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705658;
	b=wPvaBEhrhbtiDF1rQzD01XaIXpD8jbxoc2YSSzsGC7rSlZ/tk6QJIx66akcOOEqVTjfw
	 2LQ4T5naYB/r69jB7fWGLCz9FQ3bCKURfIQ6wTOXyjycB1mNUsscq7X+V9ICj5fkURB64
	 mfhA/rJCWiKvyKqNSr6BFuWk19q0Zw9U5S1yBPeMDcOs3hM14kysYEUpeTs5Au2Evx3Zp
	 UbCErvdVS8VE78SlFdOWgilMPm3H5sJ28lkCQuqs0HlD+dY22d/1Clfbhvkfk5u+CDf+f
	 PBrRN96rIXSla0Bl8ggKHPMFHbnJ868liqj+fqGbuq2EDH2B3+cnhK5hotbr8iF7YCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z7o+13Bq4EDQVxCjXBunDPnia4tGJWDOS6y0hTBhrtI=;
	b=xIflWf7ey3zzkEMPmL77H11Fw4OtddLrBsinmBLgMFB8rbLgQmbXxgAyUxIJNZAXAKJb
	 fIml1npbvwTYPVGDBPZ/NCTfixfNpvUzH7D9CED4H3/2mPUHL4dXGknG9VO/cM8w6abWS
	 5Ar6+QOsBWZU9+pUDsZh9vOkGqjvpWFyLtU/0sTSuDQxFvRMuvNojsf+nDyd4SNfmjkjk
	 SXp09053Gl8Thf/OLhXZFmHgc8vyP4a4u8DIrkhKq4t+UNKBV8g8fXF/J7gauEHRJ+oCI
	 IKLJyAtqXhH/yUudJMGxeHk5pDQ7rR3mNp1gczRUEMyb711UddDIxmcM9ahwQ3h9PjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYBt5dev;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07FD606A331;
	Thu, 26 Nov 2026 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYBt5dev
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E0B1F000CA;
	Thu, 26 Nov 2026 15:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705658;
	bh=Z7o+13Bq4EDQVxCjXBunDPnia4tGJWDOS6y0hTBhrtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYBt5devcRIaMj5QyCBy/rWrlq1GeAZCxkMj/YRUgW7FiYUYM+uxCxtgnWoEGNNOw
	 LJ+GiiQu9jfJWIV6mTDMVGGK/hDBXldDpeYcCUODvDLJFj7YkF64+HdBGhSG1mN0tW
	 ZcQW92kaTGNa618R9RlnNzKqvkb+xnuhTYVqtdkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 227/319] sctp: reset stored flag for each association
Date: Thu, 26 Nov 2026 15:39:55 +0100
Message-ID: <20261126144011.872695590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


