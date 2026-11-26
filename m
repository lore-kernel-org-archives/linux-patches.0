Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704524;
	b=0yH1hTTWj+UvTCizhTLXxDXT00RuWZhPu6HJdkmeC+szcWx/KVEaGQEZKf6wMUSkzAwW
	 BpC5jP3tGbUGJfCACKf0Uv6YRvM98nuolWoXuPfTC+q9tajizS/ZA3Jjr1aKdBkVtHXd9
	 HJgFrR4481mZN5OTXerExQ2Bnqt9ZbecYv8hQvd7aaaVY3qQl/J+W4nRpElVjhr2LhomU
	 TAYjnhBmhWpgqKd5qlYhZtnvgIuvRW+ufLXxrXWr2ZKZO1SrOdkMbCy4e/bPCPBGGfPAu
	 dNbEnGFGFagWwdQvf3vOKUj51UMaM36uR9HWyUiL4bcBDlz23Niyplrgb2hYUInoO1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8sEzKtAEIwdbH9f4Bnnr/i+ZQlaNtzsf+b5OqlJ9bWw=;
	b=327SFgdVWFKAvTJwzNJDcyq310WAjNXgPutai8xaRsFhR4Fw796mVilEAEZldilai/zd
	 autAgecKOBHleH2GBemHenGqBjoZ2fRdnHQYhgRfLqncR0/Xwzj9pgmSGwW+Q+ePf7YeK
	 hESzCzxKrsmASfZvvSrEHt/Fqnf1J6nZ0yVa3aqmd2rHQ+wxlxel6lnTU9aMtLWRGk60I
	 GwoH7msSIr4qU4RLebvZKIePXcNMs8Z9+SxCL2bDTZ5/mQqHytuzBYctSYXEsCK9sfaoM
	 qWZScQsmHYTQX1sZbTD8zSCm5FGcM/++giaL0osK99bB8Eui9VKmqcqtbCtZ6uoTaxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrEh1yCB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE6E606A323;
	Thu, 26 Nov 2026 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrEh1yCB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA641F000CF;
	Thu, 26 Nov 2026 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704523;
	bh=8sEzKtAEIwdbH9f4Bnnr/i+ZQlaNtzsf+b5OqlJ9bWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrEh1yCBwdLTWuDEBxK5HtifcZhj0qqsNGIgzYDIgjTmSCMqnF4dCWcGI6/FkXYYB
	 mGq4YJ4DCFWXzrT/I9tjmHHm6KN0i5lYcsLDYuJfU6IZU9sZlwXODNCJDnIjjepG5z
	 z+CzE7xyoXq2fZfljWo01wasr3UHzD3Thx7Bg5/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	Allison Henderson <achender@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 5.10 155/265] net/rds: Do not unpin a page after a failed atomic pin
Date: Thu, 26 Nov 2026 15:38:05 +0100
Message-ID: <20261126143615.916891385@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 8d5ce4751fad9499ea408163af7f410f18a85782 upstream.

rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
represents a pin that it owns. However, pin_user_pages_fast() can roll
back a fast-GUP pin after racing fork() and then fail in the slow path,
for example after a concurrent mprotect(PROT_NONE). The output slot can
still contain the already-unpinned page.

The common error path calls unpin_user_page() on that stale pointer.
This can consume another subsystem's pin and allow the page to be freed
while it is still in use. A local unprivileged reproducer triggers a
KASAN use-after-free write through an io_uring registered buffer.

Clear page when rds_pin_pages() does not return one. The error path
continues to release the page on errors after a successful pin, and
successful requests retain their existing ownership and behavior. All
four RDS atomic ancillary operations share this path.

The issue was found by an LLM.

Fixes: 15133f6e67d8 ("RDS: Implement atomic operations")
Cc: stable@kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/rdma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -960,8 +960,11 @@ int rds_cmsg_atomic(struct rds_sock *rs,
 	}
 
 	ret = rds_pin_pages(args->local_addr, 1, &page, 1);
-	if (ret != 1)
+	if (ret != 1) {
+		/* A failed pin can leave a stale page pointer. */
+		page = NULL;
 		goto err;
+	}
 	ret = 0;
 
 	sg_set_page(rm->atomic.op_sg, page, 8, offset_in_page(args->local_addr));


