Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033459;
	b=ICHlywnMobtcjPjb9/67QCGaanhut1tqqh1sNo0BhHvGsdcfN+5snSpiX9/1/oO9Mgq8
	 /Oohxt5ASUkZljtB6s9dsyUdTTiZtkSZ1ahOyAtXe18+4VuTvVL/EiIXyz/x9TxNtLc3+
	 Z9+aPstFjFTjFK5ZqsVHw4/5jtaPHdXqPZPoGvBGoUc4Jb2iJRfrmF/UlQyNPRhl1EzF5
	 Tg1PCccJ0HojY1gPQSUaCqWIgxkvjt+QpkiauWlKI8AReIS5ZVDiRIoyRhqpd4dRNlPhH
	 qBr27QGIIaMSNPt3V49m4ziY5S2p3jHjTYMxu7c7SU9numYeLz9+WjPRZ6I0fdQmEvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zwVwmlEs1PZzWb0gRRxjZOkJTo0cBmt/Egfunw+g+Gc=;
	b=LzFJ5E3HMjtuU6gQKRg5TxuhM88SReVDa+RmEUbHkX8R902xLQKHMgbzNMPSKCOnBmRo
	 EZ5yzT4EPmSYwyzsibhQNeUk0FwGwT8/cXHCV/werSaaPz+Og3EhvsGdthaQqP6pblDIF
	 /st9bBkTaen0TyHLg1EDaWwl43qz5ksU483e/W2zLUBPaF6Ls9MGyPR2wNjGz7BbUKlTJ
	 grAKx/s6IvTiaPp5NIM7Wo6JDT65+azCfzT+lpABSEg60x5tzrGGSvRu87KscrHXckGsE
	 V7AvqF9uJelOBCGgA5yg9cxMCWZiPjZuFDZsE13Ag0oRsxWSJfB7zk4smo2mmxCHsXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxUiArqD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59926606A320;
	Wed, 18 Nov 2026 20:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxUiArqD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1F51F000C4;
	Wed, 18 Nov 2026 20:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033459;
	bh=zwVwmlEs1PZzWb0gRRxjZOkJTo0cBmt/Egfunw+g+Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxUiArqDhpJdN+uvd+PLIu6gSKySWeFzhVFDHCGfhOyYFKNlTdZsdJw6jdlrBxTI6
	 ApdW/8GoXKIR6MO+r9+on4rW7tXVoILoSWmNSrJdXtYCRfc5zcBpKtO1s0EJ+fxZdS
	 xVjvUOhZSPniks7wgsVzr3uOc+HfeXvm4KIxwLx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ihopenre-eng <ihopenre@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0005/3318] ksmbd: wait for negotiation before receiving another PDU
Date: Wed, 18 Nov 2026 15:10:27 +0100
Message-ID: <20261118150313.781622525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8666ff471b39f..83b89306fe533 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -291,6 +291,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 static int queue_ksmbd_work(struct ksmbd_conn *conn)
 {
 	struct ksmbd_work *work;
+	bool wait_for_neg = ksmbd_conn_new(conn) || ksmbd_conn_need_negotiate(conn);
 	int err;
 
 	err = ksmbd_init_smb_server(conn);
@@ -313,6 +314,10 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
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



