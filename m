Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042877;
	b=qT4SOVW5MJ4vJPjsJcKKRvSY4h20petWcoZkfqECwPfYd+CJVREX0eBLjLa0/stgRqqM
	 +qYEIj2NYxP1gPNr+jZo6hg2ZxsUCXptsly0d838kew7OIubKK9kCeyQ4WXd0Fk9Gy6iX
	 ki8h6kZW7k+CSouGE+smFNJIeK8WY4TI8dfwi6VAYcOwercE4c3A30lBfhuKD/6SRzfAD
	 RsYl0Q9ksve78PcTjQ+ZNvDubg02C8FaXj5y4L0N3WHxQW49qwRrClvdtYbYGPm8vBRw9
	 2v3tByC1pbHWj5GB+cYVI3W6chwmR9yqJ4xYB4K7y7sQzConAxQ9nTXVZkH0fBYJvDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iNBA/9DMYTV5SyYrhKfNVvlCMah+7KQXTIUUWr4EAII=;
	b=Z2qaKSg6Yj8H0ehUACCMDyr82mDwMwPNhfOnpQXnLNLjboN1eiYG74rnYPQqX4dZCq4a
	 s6DFZCZJUT4eElvJSuH4LbY2BWcZwiwGEVnwwqgKoKM6hGXltEYgkyPGSeDXy1dANgMKk
	 RlqZVnYWvHl0jJBqHsHjgOchfw+Y2aOoKBkZbZZaXKPGzYPRPMKbZraQ/lzEd4qTQ2Eum
	 rcKJE6jj1K6uJ4vDhmRl4nOTB6rygodNIDJvH0oNJrWHuLKG5JF+PtOMQrBw2YVD0xOxi
	 YkGipa7Lt4LRErOVoCmiAKuKCJh8v2dPKpqQqT7zGxftODiMaLhWmzvevGfBEbKHo1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4BvFOAP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740C8606A31C;
	Wed, 18 Nov 2026 23:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4BvFOAP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90291F000C4;
	Wed, 18 Nov 2026 23:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042877;
	bh=iNBA/9DMYTV5SyYrhKfNVvlCMah+7KQXTIUUWr4EAII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4BvFOAPxyAo7TxFLrvV4EXffcem5DmiRyMab5CLodwdMV5X9+wiOOLCiDOJHQq5y
	 FKLK8ivE+v26rriiXTgnVOLsJrLKH28kK5/lY6W2ZXjs27RsrCKsxh4pzCqiCAw+Em
	 +LeHPq19b/lqrpkweyVKRgPBjBsACWrxiO7LNro4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ihopenre-eng <ihopenre@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0004/2857] ksmbd: wait for negotiation before receiving another PDU
Date: Wed, 18 Nov 2026 15:17:18 +0100
Message-ID: <20261118150201.479487266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 68f410faedaf6ee74d81e574733c50ebcc1bd8ed ]

The receive thread queues a request and can read the next PDU before
the negotiation worker finishes. While need_neg is set, the next PDU
can cause ksmbd_init_smb_server() to replace conn->ops. A pipelined
SMB2 request can therefore make the worker handle an earlier, shorter
SMB1 request with SMB2 operations and read beyond its buffer.

An SMB1 multi-protocol negotiate may be followed by an SMB2 NEGOTIATE
that changes conn->ops again. Wait for work queued while the connection
is new or needs negotiation to complete before reading another PDU.
This keeps the operations stable for both stages of negotiation without
changing when need_neg is cleared.

Fixes: dc8289f91238 ("ksmbd: fix slab-out-of-bounds in init_smb2_rsp_hdr")
Reported-by: ihopenre-eng <ihopenre@gmail.com>
Reviewed-by: ihopenre-eng <ihopenre@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 08fe608ac75a2..85edc24ca9cdc 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -304,6 +304,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 static int queue_ksmbd_work(struct ksmbd_conn *conn)
 {
 	struct ksmbd_work *work;
+	bool wait_for_neg = ksmbd_conn_new(conn) || ksmbd_conn_need_negotiate(conn);
 	int err;
 
 	err = ksmbd_init_smb_server(conn);
@@ -331,6 +332,10 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	conn->last_active = jiffies;
 	INIT_WORK(&work->work, handle_ksmbd_work);
 	ksmbd_queue_work(work);
+	/* Negotiation can change conn->ops, finish it before reading another PDU. */
+	if (wait_for_neg)
+		wait_event(conn->req_running_q,
+			   atomic_read(&conn->req_running) == 0);
 	return 0;
 }
 
-- 
2.53.0



