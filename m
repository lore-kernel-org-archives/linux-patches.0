Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826762;
	b=ZsEt/W6QIGKogXbesZVmcivVAc8tZEcT+7vzpUiI1e7sBmVR3EGnRxC7CeqUx8Rhc4UP
	 ILf7VnjZRAoFchJSyuwMPsNg5P6/wMxtCHjl6QhHjyiwW3G/ovoauKJhKcKNHY7QVTOKf
	 a5w/l69hUKLLwtOMEb2gSF7ci+uJoxdzZhYBvFgACxaKC+HOgaMtXGy3LooSp+qTkO/5Y
	 StpFQ+EM6Q+1AwUDHQexQ2TqNtInLflg6g3K0yO53PEkSSjsHX0nhbDPDvgFcLgLtjFB9
	 jgnrFf2zsg3OcQg/lunFhlF5mUYGXFmXoxNk7ovvsTSSDV3lEWn2bSarInwb+DmTBhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y772foTZ2I5Z0h2i5ZTS0LbVln8h4A9vqUelHgqX3HM=;
	b=qCh8I55g728Xozx5qakf3mxfOsRDrDsl9R6HJ6Nxo1DwM+Es4R+JDd660LbjL3TQ1Lao
	 4nZEQoeiQDWl58RtLnSh+DGe/jZVc9aiFo3pwcJQalOu1mdG26b1B+Tqmw6+K5AIBwFvU
	 hIb8FMH/W7Ky28EKIolVzsYBRXZp5gyAdDroq8DTXjBfrfquplo/hqQIXVrWyFya7BeOK
	 RF5Nir55y8FzAuP2rAVsVdZzLXalXVLq4JFYLT4DIFEl3evPLkz4yVUNWqonASKbe2/KR
	 hcQIUtblRZpIWh0n7DxUcfqA2yzmH8jPIZ87Zy3GX/lwXqUSYdskpz3PZ1F+AlIAaxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jEpvBVkW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2EF60ABCFF;
	Wed,  4 Nov 2026 21:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jEpvBVkW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AAA1F00A18;
	Wed,  4 Nov 2026 21:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826761;
	bh=y772foTZ2I5Z0h2i5ZTS0LbVln8h4A9vqUelHgqX3HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEpvBVkW0DXAFdzmwHLr1XK0usuh43j3j+wrYzq26zrjHJSiDMVgQj0MLGqjM1sXu
	 LLpVUeH6+d+1s1B4J9zI3G0li95nQuntcNa+b2DT2qhjyFxJlAXPixtyRPMqR/TXFw
	 QDXyPq7zQ6AuwTPhdXL7wOj5njR6yxdXLrcgHowg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ihopenre-eng <ihopenre@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0002/1005] ksmbd: wait for negotiation before receiving another PDU
Date: Wed,  4 Nov 2026 15:55:35 -0500
Message-ID: <20261104211043.593087061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e7af6353a641f..85f14d1cc0cd3 100644
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



