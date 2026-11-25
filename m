Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618946;
	b=V1BA7wOTirOeL6ZsIrHqIOUlQn/OWARR7L7/ycTHll7VAFORCZX+QRDSiCV4Y/ox5Tuq
	 oGYeFUzfu2wvwHzlU0jRN/JtMYpFXwB+2F2GuKyOH5Txli37VcSY8JJ+1z98P1PJckLD2
	 3DE4VLi4GsKJAsWx87mB+gYUNj8Dd/Iu0TRQwby/xlO39pyzSJZQjXSjCdRTpjibOBzM4
	 Ky2VlMbQdsSWgqF6apPc1cmxMgkTpOmMOjCJGq09M02gxw0mBt+e0kUcF0sA/Z77j3H1e
	 1sXsQN95RbfVbfnGKVmDFe0VcIB0VF21yqNZ7LpMLRPhs/AH4dIwF2QKFHs3Lk+MV1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g9qgTFLdYHZ+/pn47fQRqVN4amMrloF/GCOSIPYFxJw=;
	b=oOOhfY/f5lszGSSCOQrnzKZJddKpOQR+wG+P7Lrp1WtvWUUl7dxh3EmJMiHn8iMP1+D+
	 UHo60SNbkEMJGYXzzhZxafudTlkKz8544+70aC+/XjXhtjxiqHpbv0OpLb2EKNp5DKhyj
	 yi1iy45bGybS0eBPE3Bj3aOW0YSIUw4jgIpBRoGnYNRjE6Kil08w/RKyHLu9uY5pq1+St
	 d2ieJNjPvqVPrBoWY9d2/7dX0n7ac937z5cASs8cAc0/FZgw0pVmzpoQiImGNL25j1QbG
	 LkUJKvu+fzsoQY62jazDoYtSGSK29wH/8HdZxufjqCYKQcOZTQtHmeyO6eeIjrJw5mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QeU7VXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1017606A321;
	Wed, 25 Nov 2026 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QeU7VXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFEA1F000C0;
	Wed, 25 Nov 2026 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618946;
	bh=g9qgTFLdYHZ+/pn47fQRqVN4amMrloF/GCOSIPYFxJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QeU7VXzRlfklYONPMZ4EqXRt/xfUD4Rerqj7ztTI4h+YEfxTCvC/9AdLn8Q+ETYK
	 TkKYIg4EDI57nFO1ig6VK9LL4TFkJga4ZDx/z1Vvr6yu6h2hpcHqe729FQDPSJ21Os
	 YojdI+43RlymUUmuaJ8bwmwoKwp1vZdGPzjUqyFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0438/1005] SUNRPC: Balance queue accounting when relocating a task
Date: Wed, 25 Nov 2026 15:29:36 +0100
Message-ID: <20261125143832.009843270@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit f14b157168ac106cfac6d577e08726488b1b886c ]

When rpc_task_set_transport() relocates a movable task from an
offline transport, it releases the request and drops the
transport reference without decrementing the old transport's
queuelen or the switch's xps_queuelen. Releasing the task
later only accounts for the replacement transport.

The stale counts affect transport selection and can prevent
xprt_delete_locked() from removing an otherwise idle transport.

Use rpc_task_release_xprt() to balance the previous assignment
before selecting a replacement. Pass clnt explicitly because
rpc_task_set_client() can assign a transport before tk_client
is initialized.

Fixes: 82ee41b85cef ("SUNRPC don't resend a task on an offlined transport")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 6fc36e516c1c6..33e64c0225f37 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1197,7 +1197,7 @@ void rpc_task_set_transport(struct rpc_task *task, struct rpc_clnt *clnt)
 		      (task->tk_flags & RPC_TASK_MOVEABLE)))
 			return;
 		xprt_release(task);
-		xprt_put(task->tk_xprt);
+		rpc_task_release_xprt(clnt, task->tk_xprt);
 	}
 	if (task->tk_flags & RPC_TASK_NO_ROUND_ROBIN)
 		task->tk_xprt = rpc_task_get_first_xprt(clnt);
-- 
2.53.0



