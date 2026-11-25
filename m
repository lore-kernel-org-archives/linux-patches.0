Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620250;
	b=NqXJlthRHT1JRt4KnTifzl62DFEB6C+vbM3viGC3WuIOscyJXZeefavj+o4HkzMPPSAt
	 s9MBwjPOnE8WMBE1w3MheEb2lyr2MC2n/j04qQ9W5m3TouKKfUcKASORHQ/ngpD+8+3Xw
	 VJDiLmDvjAYIWZhEeHby4FpByDaX4m8Rj2tkfk5ZNaZ+GJqPFQ/tBS9xA9YDxj5czMQ9M
	 Uq6Mwzw37URVoNJwU7e8UTqZsw4xjzELm/x3HmZwfqqLAguFbIWQhcXpIeaiLK7V+rxVr
	 hPFLrrdeLvlE556Vn26LcnzQiLznhRdguxASxhHShz5neLQVKBLfnFFZTXYtk6z1wtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmt6psogyyAMpcxnL9H/3mGaqenSsLIOPbYeU0MV1Kg=;
	b=3IjxUVxGlZmucAjHq+0L0KX+umLm7e6mQU61+EyFIwsscbCVKTcx8uDEcwBpnywF81RM
	 CvdXAyXBnItnp8EWj4n79eP1FxypIxuYY/w/NV3JPh5TUoCPJzlfbtRdAu9WN+UcnRHLE
	 iEo4vEul9cCn4Sf7exriwR1saX0qm3VmVXigu48b4jUecZYlwCZkUlKHeC7rqF3vGwQC4
	 f83sBWMLzGSfWfnCnCAvApEOyX5k+cPZBQUTnXxuHEKxuZaW2zh7AEKmcZdd444fzADMd
	 swH7i0W2wYrNwfzKX4me3YF+MZ1rcI0BCyQApGNdJZ5Dv9ZV2rVf1kbrx/1Q54Vo0jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kRd0Ct0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FB6606A31E;
	Wed, 25 Nov 2026 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kRd0Ct0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52BA1F000D2;
	Wed, 25 Nov 2026 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620250;
	bh=kmt6psogyyAMpcxnL9H/3mGaqenSsLIOPbYeU0MV1Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kRd0Ct0OAYXvpDQf3sHCVfHL0zTXHKQByutIHIiTYLhOsQ+HH9+aRUXstuJLCxKn
	 9Ddka/9jPtn5LGGAp1C0+nHfkxDZNDmJ+oaKhquNAdFmEPK0ghXOsQ+Ek7smXTiBqK
	 mVnGyKJ+L9pPVlouNMcyVxKcQLuN36Su7Vw368Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5307e3bcacec2ce4c2f0@syzkaller.appspotmail.com,
	Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0857/1005] dm: Reject table setup after queue or disk teardown
Date: Wed, 25 Nov 2026 15:36:35 +0100
Message-ID: <20261125143841.783888368@linuxfoundation.org>
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

From: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>

commit ae310e4ad872a42f4707a596e66417f2aaa52826 upstream.

A failed table load can leave a mapped device in a state where its
queue has already been initialized or its disk has been removed, while
md->type is still DM_TYPE_NONE. A later table load then calls
blk_mq_init_allocated_queue() on the same queue. If del_gendisk() exited
the old hardware contexts, blk_mq_exit_hctx() dereferences their cleared
flush queue pointer.

Reject setup attempts after queue initialization or disk removal. A
failed request queue initialization still leaves md->tag_set NULL and
can be retried. Set the request-based disk operations only after that
initialization succeeds, so an unsuccessful attempt cannot leave a
bio-based retry with request-based operations.

Reported-by: syzbot+5307e3bcacec2ce4c2f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5307e3bcacec2ce4c2f0
Cc: stable@vger.kernel.org
Signed-off-by: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2611,13 +2611,17 @@ int dm_setup_md_queue(struct mapped_devi
 
 	WARN_ON_ONCE(type == DM_TYPE_NONE);
 
+	/* A failed setup may have left the queue initialized or the disk dead. */
+	if (md->tag_set || test_bit(GD_DEAD, &md->disk->state))
+		return -ENODEV;
+
 	if (type == DM_TYPE_REQUEST_BASED) {
-		md->disk->fops = &dm_rq_blk_dops;
 		r = dm_mq_init_request_queue(md, t);
 		if (r) {
 			DMERR("Cannot initialize queue for request-based dm mapped device");
 			return r;
 		}
+		md->disk->fops = &dm_rq_blk_dops;
 	}
 
 	r = dm_calculate_queue_limits(t, &limits);


