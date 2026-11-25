Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619512;
	b=2VGlT+pUA7qH4kaK0/IW5P0favfgx/94x0292qh0SaJLHWXvK0P6uqZT5Hr0OuGEJsXt
	 Ff8fPSRlhnwttzk/IRnPKU9DKuQTOV3jm26uAa9jUZxsYXLVz9Rzdm1KNDQeuMhVRM8ft
	 i4VhRKKDNhyo4OGxKQHdm0s/vRD3LQqAgcDa4yfAycb0ih1HrFCCOr6N7llTGw18Y5/d8
	 dZwNxEH02IOU8cKIn91878iwRslj+6/h9IrYTOY1AslmAUNjTT6VulG8thlALKGDoPBn5
	 64eCusO4dbvONYSJt4tNLciw8izqMuBhIbJ+8tcrSQ8oe3Xj7tcvNjnEav6ev9Zgitg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LY5XevDSeGhKhnQIRUVD500gdXpxyo1+mlOipP2BbEs=;
	b=1PDExpoDkMjVSzWKLROb7peOU10mESlRxQeT0laX7arR/XnkewmZfrOq7LCHnVK06mZ0
	 yu20QzZPqI2c0FZLUvKJ8RYu2zbtLQUpCsRt3mnhL2oGBplOgY1A925eLlJ8kS56pq/+A
	 aNHiKAhDdBVvOa6fnx6JPck/vagVxY7JSiOC1zrJ2ge60jCnT1E2TNB+PSMGOFNQAjLZy
	 CiSBRi14o9mGUC8x8ZoEFHGRlWNRGuQ7lzvump/dJws2haRFki4Dv/lHpLhNjhS4PI1Jx
	 iUt3pJ9UtYz0rWOXGeAe/YcXXRvbnNzaMQg9QUkE1QHUAqUgH0KP3eufCI+vrc4QpTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMKddbK+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1E0606A31E;
	Wed, 25 Nov 2026 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMKddbK+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9FA1F000CF;
	Wed, 25 Nov 2026 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619512;
	bh=LY5XevDSeGhKhnQIRUVD500gdXpxyo1+mlOipP2BbEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMKddbK+tB2T7KiLk6TIA8EpEp62M++Wc7IPuVPEL+2oodaIdUKs9BJX2zVYdv0Sv
	 y93r5BHoYptXBiYsy7jK+kair+BGOWmeqm2TwtjLswTCtnGV74gPzK6VSHzksJ3hIE
	 epwbqfdcF66Pg1hKHP+49rybM9zVI7fecOnDnujI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0620/1005] mctp: accept MSG_CMSG_COMPAT in recvmsg
Date: Wed, 25 Nov 2026 15:32:38 +0100
Message-ID: <20261125143836.271204082@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

commit 350e1d0d3b386fcc0cff2d37aa920fab4800bf72 upstream.

32-bit userspace running on a 64-bit kernel is unable to receive MCTP
messages on an AF_MCTP socket, even though sending succeeds. There is
nothing for MCTP to do with it beyond not rejecting it, as af_packet,
af_key and can/isotp already do, for example.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://patch.msgid.link/20261105160704.2546031-1-dave@stgolabs.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/af_mctp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -292,7 +292,7 @@ static int mctp_recvmsg(struct socket *s
 	u8 type;
 	int rc;
 
-	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
+	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK | MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
 	skb = skb_recv_datagram(sk, flags, &rc);


