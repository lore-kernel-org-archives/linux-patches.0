Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625861;
	b=YTC99gqjYAUlfGCBd7tSoxOMsHsZPhcnzKUE3nb3cbSel/oBJqaElhvOXGBgnNuKh69S
	 P+vJxB/u77vKoXJ4Itt5bQNqE7+NB2yopHWl+qiKDnZbeqAtP9cUj9299Kr+bEO6vY6Uk
	 wrWK1aLb29zIML0YOuIjcEqoxKD3U83EbgQUd7fv2rERxS0GRs7tuM2pRsNIQU59d7Q78
	 0nMCg5zDAyoCzH2ZNCqO0nOHezjivZ/cwlxIYCA6nD+Dxk45XJmv4WJQbjEZe49mJ3D6q
	 Zd/GVbuVoYi1Lg/JlHIJvjmSnC6Ao6FsBax8Dy8TjHWo5Rupmk1sD7hRGY03tsdlnAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=516ci6ctBq7CcJbyUOjdyq+ugY/z9zIU2WED7xbkzU0=;
	b=mSUrdWrswblkMJK6594x2rUgGshEDtBlkPt0yiMP5WQ7vJ84Q0ET6sy2LuSSdRi7qu8d
	 3x0FQxsCrCr4kW1Fr+pltLWA+Dkp99KHpn8aAahyg/OwKZKkhqjXj3xvBQtng3CzuM0c1
	 /G+28Vf7Onfxe8tIDdz7HHS1GS4LJeluAznwN/Yf0h3Ge7Xez62Z2P/fJ0quQeLEvNDSW
	 QrOA0E2yVVLexKvMEUVqTbQZgj9dMl8MhB3BAWIQucyKkl89fNcUytRqlo+o+54DCoxKB
	 mqg+j89KnvZ0cx2/dIR8i4yTKdMBa4yqe7Ijcf9OlStvOvlyK9VO41wup2tv9qJWI5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+IGghEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3B1606A323;
	Wed, 25 Nov 2026 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+IGghEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4DE1F000C6;
	Wed, 25 Nov 2026 16:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625860;
	bh=516ci6ctBq7CcJbyUOjdyq+ugY/z9zIU2WED7xbkzU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+IGghEzTAYj5SGBx97B/2H05jxPyS3cbWkc5Z0adAfqV8RoXTI/Z1WbZqpcQY66s
	 OoAAm2zZTEZ1kMjg74c2eVv1mPGgGVxaP4Yj75ekMLOiYYuy6gJrDx//BEVFzLD0fF
	 E0zW+PShrzTZnvLtf2vx3OPKUAp2eXIvx4IlKzaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 652/816] sctp: reset stored flag for each association
Date: Wed, 25 Nov 2026 15:36:40 +0100
Message-ID: <20261125143904.274348995@linuxfoundation.org>
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


