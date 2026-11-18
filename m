Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050882;
	b=G2vHJZgUCSpKI6VD93CIcglqo4oQ9YXZDPNWXgSi2tf+irestlkdaeOE9lRsiRV8KtXe
	 TNvEsvFwceo9JxSyhIbib/vKVhhrLzKOBxIt6hTrGmI5G+vNTJwszTjd7ObTRZB79RKiH
	 uRtJ3zLSrxDtsncRlrY8AW3eYkik0UB9qGkQrqvyHC9P9HTXawNCDdaUcx6Y+198JWN40
	 GTpd4l4/dDVs85lpXY7Zj53tbvr4X4gVLSh+DYfiQJFKVYvVtfAAyGXbzCqJ+xa7UoLUO
	 1HOKd7yB0vdANG6H5U4TBUhkCbR+bGxvvtxscHLEhI8tIKigr8Wm/z14tpNgum0QGjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DcCQDrnbnN1T9fH5hYj/e892IKpfjfxGtZjMS/ibJyY=;
	b=no/63po8E+RfAMbrlwdTn7+4xvI6ZvRFTYBMIFJA9YMsW+QQESptdMeaEcjEVgwHV3eP
	 LFKpkEXzdmB7OkWTL+ZE/I45S7GOe/Sssm8XPouxLh9RNR0mjgz+oOK0xA2DuHKRZsuCH
	 qF5amg9VYlGdF++zhEL0z9gQ2u1DfR845SqFqIoQXeojDpBiWRyhzNWRrarWyKdimOhcF
	 EqjeefwQ1J61Fvkh6G2ekfJaIGFfuHjUuibHdhm6RCDHOYF092Xuna2R8IybCAcHSlXD6
	 9I3hsmL4wjcNA5NeZg8IrpJR0KoEzwoAVkGmjQo+P/+fiLd4l6lG25LvroKUx0yjg4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZKA3ZNDV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE114606A31C;
	Thu, 19 Nov 2026 01:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZKA3ZNDV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE441F000C4;
	Thu, 19 Nov 2026 01:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050881;
	bh=DcCQDrnbnN1T9fH5hYj/e892IKpfjfxGtZjMS/ibJyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKA3ZNDV9u/1JVJ48TqMfJwi6AoUfUybhV9g9ETsgTMOX8EQ5xwaEImwPfZ7Ntplb
	 kptnmCTqSbqghbnDYOmZ/PMH34a1WkyrB0ogmy18unk8+jWJVR1IC5VtNeeHD5r209
	 /E0BCG9XFuNDVvJt8J52jEQu3fWZLDHIQ2M+6+eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ihopenre-eng <ihopenre@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0004/2214] ksmbd: wait for negotiation before receiving another PDU
Date: Wed, 18 Nov 2026 15:28:00 +0100
Message-ID: <20261118150010.248017766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
 fs/ksmbd/server.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index c1b9a85f2c67e..275eeace4ba13 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -295,6 +295,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 static int queue_ksmbd_work(struct ksmbd_conn *conn)
 {
 	struct ksmbd_work *work;
+	bool wait_for_neg = ksmbd_conn_new(conn) || ksmbd_conn_need_negotiate(conn);
 	int err;
 
 	work = ksmbd_alloc_work_struct();
@@ -319,6 +320,10 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
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



