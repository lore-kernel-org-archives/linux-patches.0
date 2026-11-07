Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794059974;
	b=DAtWuHZPmmp+cTLpqbEgQm5uoAOagN4Rp8AuLZX8VRmEliHX9XVp22IlNWf24BWpEPKy
	 CFna2JEsB2HdMk0dbXTRjc1FNoFlEa14scbvwkj4KL0xIXBiqdtxqnAeNOG4d5ZIyiT5G
	 mdpqXnJeSn7DFVuKnZQ88/MklhmAIyo4lugHzi+Fyv8R0UjRjnVmZ/Tg/9B6Jh3eSHqkB
	 t2wM9sKokj0y5CL9rqSI9+Q2yikJF59XTc1VC0lGWjsf+aMhfPNu8YEEfX8yQbatAx/Dz
	 unruf03ccij7P1wfuJEJV5OYeHMOe0zTWU6cYZSOLnuskJFy+tLExbantmcbgfan6iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794059974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ioUko409tRhV1+i/Urt6J8hZO31wWNmwvlgd1p+LJ3E=;
	b=JyuGVyxmRX1EWbCZ88/+Vjj13eDs2BOJ/NLYijdWuaW1Za2UUVKhfHII7LoGrj/v+qkY
	 tETE0D/QmDsdI9DNef5EX7893v91iVwzYP6jth6jIbAt2jWlncBMemdbn9bj9B7mS2o7I
	 pBPXOE62U/qJMYHrbEp8qJHYQ0269US82w37H8Cd8DqTVXTQO+fQtjEiSoyVEnxlSOKez
	 YV3uMFz6LlyastZ2sb6GvLnY03qRDcYCNtvmDiIDbAZDHj9BIkwwcQ8DbVDSsnBrGxrfC
	 c3CWjQkBkkGIHfW2jVy3mpsRk/+5hhg13uR/XqKPrkcea5coqR/XsdanTyFYL1IWoEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nntVFCQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D222606A32C;
	Sat,  7 Nov 2026 13:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nntVFCQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567391F008A1;
	Sat,  7 Nov 2026 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794059973;
	bh=ioUko409tRhV1+i/Urt6J8hZO31wWNmwvlgd1p+LJ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nntVFCQc08u3F334areCJamkIJSSBUoL526MnnfheBrDchokbSGQAHMYpBsyacpNl
	 e7DnZqATWy/l0nwDqwvKgwpYOS7vHwxUionjmLAvIsw897B3g3WMNiDnNeG0QOiZ+7
	 Qk+iXPNLGqeV5jLIn31dxByW88TKMeE54LYOtsjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ihopenre-eng <ihopenre@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0002/1536] ksmbd: wait for negotiation before receiving another PDU
Date: Sat,  7 Nov 2026 08:33:38 -0500
Message-ID: <20261107134957.734827963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index bd6891354d4a1..e81d3e4e1ee22 100644
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



