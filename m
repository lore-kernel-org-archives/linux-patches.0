Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6403D47F774;
	Thu, 20 Aug 2026 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248239; cv=none; b=cXZvjP2umGKjcI/xR96r1zmqNMtOkCUIQ5DMFghh0mj/SZaWf1eriuRHX4B8SwgwJCA85HvqGa/IpnZn27HVFcLsm3qjdNsMhG/fc2+pknmqKJvdZEdJJQm7NFJ9oxuYsQMzyD7QvdiPFCHASwn1FiZtZu6YOCXG8zmb1ydcev0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248239; c=relaxed/simple;
	bh=CnbKc1gy5S3nPfYp77/EuKzZI5I8RDdKrKdEW8dvabI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0V8DuSh5GGm/m+0GkByyR3g3W0AUxb/uqY4CplcCpbSjg4826cVNAckD/G1MsqVCQbYBaAkPQVrB+StcA75ehnsiDnEzTafck9EnH7lorGSGde/3ANNPIt3tyYP7909iZhTBTADfO1I9MuRPg1h5CS/beM4M/c38ABME4Bw1a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5VvzM8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5VvzM8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61131F000E9;
	Thu, 20 Aug 2026 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248238;
	bh=LENfD2DYZDkn7BNUeeY3otBrkUNhKt4H4dEGDg/Fhek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5VvzM8DY7kFUW8vE9IkmF+ohSGIj+3MJ6X3NGfqe/4v6Sypexm2BFDBF9eTNQtRj
	 7sQm03VX8BhkCAKbCYsXtM6Wah/ZH4UIyOYLgdCUoe9nCj2T/gSDWCl3i19VyqYgTA
	 mAZJaSxF5VhqKAgBCO3AIcOR6f3UpMP7e0n6gknE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Ahern <dsahern@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/303] espintcp: Inline do_tcp_sendpages()
Date: Thu, 20 Aug 2026 16:54:55 +0200
Message-ID: <20260820145258.078672265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 7f8816ab4bae9dd42c5720fdad4b102532d4e43a ]

do_tcp_sendpages() is now just a small wrapper around tcp_sendmsg_locked(),
so inline it, allowing do_tcp_sendpages() to be removed.  This is part of
replacing ->sendpage() with a call to sendmsg() with MSG_SPLICE_PAGES set.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steffen Klassert <steffen.klassert@secunet.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: David Ahern <dsahern@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 007800408002 ("espintcp: use sk_msg_free_partial to fix partial send")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/espintcp.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -206,14 +206,16 @@ static int espintcp_sendskb_locked(struc
 static int espintcp_sendskmsg_locked(struct sock *sk,
 				     struct espintcp_msg *emsg, int flags)
 {
+	struct msghdr msghdr = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 	struct sk_msg *skmsg = &emsg->skmsg;
 	struct scatterlist *sg;
 	int done = 0;
 	int ret;
 
-	flags |= MSG_SENDPAGE_NOTLAST;
+	msghdr.msg_flags |= MSG_SENDPAGE_NOTLAST;
 	sg = &skmsg->sg.data[skmsg->sg.start];
 	do {
+		struct bio_vec bvec;
 		size_t size = sg->length - emsg->offset;
 		int offset = sg->offset + emsg->offset;
 		struct page *p;
@@ -221,11 +223,13 @@ static int espintcp_sendskmsg_locked(str
 		emsg->offset = 0;
 
 		if (sg_is_last(sg))
-			flags &= ~MSG_SENDPAGE_NOTLAST;
+			msghdr.msg_flags &= ~MSG_SENDPAGE_NOTLAST;
 
 		p = sg_page(sg);
 retry:
-		ret = do_tcp_sendpages(sk, p, offset, size, flags);
+		bvec_set_page(&bvec, p, size, offset);
+		iov_iter_bvec(&msghdr.msg_iter, ITER_SOURCE, &bvec, 1, size);
+		ret = tcp_sendmsg_locked(sk, &msghdr, size);
 		if (ret < 0) {
 			emsg->offset = offset - sg->offset;
 			skmsg->sg.start += done;


