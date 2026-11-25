Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617784;
	b=dfpXcvddzs3ss32tcZE14Am/xCYuM1eeiUbsRIqb7PCEtDOrQt58OQTHv3yRfvrO8vyV
	 c3f8i4NvDs0qu4iTToSidCEGJRdBUtek15GyGy+F0jPy4BjRwb1K0UTUqhD+ETFn/M4wz
	 gD2S0WIauxL9tJTbEd4fL3bxlYWjHK7txKy+z8wixiP4zM9+h97JpBnDc9WXPPy+4vRHI
	 elDZv1Ke6JUF+CwwhSrt0JstSUiFGjTSfKLYsYqvv6AWhiKSj0HwRjhhbawxMUtdwxXdy
	 uvHO7OD1farRmregfsXe5HocmNZSBL62uFq4ob4olzUE+dnj1zHZeGVhYwA8RUlxdew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S83JqPK0Hu8mXkd9TeT8Clt9jT7pcXBoqmJAETw2ODg=;
	b=DV95NzPiM91EboBIMf3pFgCYWmWzTYiwux95o49bgBny8Ukj8quMCov22jMnJYfxItS1
	 EFIAIxJJrnXC6KCb1CpKbqntZx//0fKz5+bzaIIc+iItqFzDRVVIbciKweT0T2iKeP/E8
	 Gp3bQR6BAHtrtFOgOjr4DSyYQ8KDvcvgi7P7NZWma+wnra1GoGgX1yeV97xXVnfLAHMO9
	 pfyFIRLqQrmtgNrmi+ENXU79svYLL5TyT58yPxqdKW7z0PTv957ZHku/D0uvVnarvC9sB
	 OOXZQALDcuhzH7NJeoCxQc7pPFvUcRDVgTgzYmjINeaSUkAE9EFcQNk9DbzCdkpO4aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iqv5+rSD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A38606A31E;
	Wed, 25 Nov 2026 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iqv5+rSD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167BD1F000D4;
	Wed, 25 Nov 2026 14:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617783;
	bh=S83JqPK0Hu8mXkd9TeT8Clt9jT7pcXBoqmJAETw2ODg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iqv5+rSDRysmGf93QKWyR+XrDxBN+3zvu6DE8WfE3yEXuZZOUDweyn7uh4M9z8XMV
	 Im/j0Gc1dGQ9HyKaIYgiQNG2H4BE09Eny0eVNPQjGcdtYbBUul+penIVIacxnvq1BH
	 9OivguVuefaJwqKJhoGGV44j4NMuNXS8K4mJGIdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0028/1005] 9p: use fc->net_ns for network namespace in RDMA and socket transports
Date: Wed, 25 Nov 2026 15:22:46 +0100
Message-ID: <20261125143822.396647942@linuxfoundation.org>
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

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 37dce65a0b4356d7ec289a5d09cece5db241c302 ]

The 9p RDMA transport currently passes &init_net to rdma_create_id().
As a result, RDMA address resolution and connection setup are performed
in the initial network namespace, even when the mount is initiated from
a non-initial network namespace.

This differs from the socket-based 9p transports, which create sockets
in current->nsproxy->net_ns.  Use fc->net_ns for both the RDMA and
socket transports instead, so that transport setup follows the VFS
mount namespace context rather than depending on the calling process's
current namespace.

This avoids surprising behaviour where a 9p RDMA mount from a container
or other non-initial network namespace may use the host namespace for
RDMA CM operations.

Fixes: fa20105e09e9 ("IB/cma: Add support for network namespaces")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Suggested-by: Dominique Martinet <asmadeus@codewreck.org>
Assisted-by: GLM:GLM-5.1
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Message-ID: <20260529090625.78761-1-zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c   | 11 +++++------
 net/9p/trans_rdma.c |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index eb685b52aeb26..dce963332a046 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -887,8 +887,8 @@ p9_fd_create_tcp(struct p9_client *client, struct fs_context *fc)
 		return -EINVAL;
 
 	sprintf(port_str, "%u", opts.port);
-	err = inet_pton_with_scope(current->nsproxy->net_ns, AF_UNSPEC, addr,
-				   port_str, &stor);
+	err = inet_pton_with_scope(fc->net_ns, AF_UNSPEC, addr, port_str,
+				   &stor);
 	if (err < 0)
 		return err;
 
@@ -896,8 +896,8 @@ p9_fd_create_tcp(struct p9_client *client, struct fs_context *fc)
 
 	client->trans_opts.tcp.port = opts.port;
 	client->trans_opts.tcp.privport = opts.privport;
-	err = __sock_create(current->nsproxy->net_ns, stor.ss_family,
-			    SOCK_STREAM, IPPROTO_TCP, &csocket, 1);
+	err = __sock_create(fc->net_ns, stor.ss_family, SOCK_STREAM,
+			    IPPROTO_TCP, &csocket, 1);
 	if (err) {
 		pr_err("%s (%d): problem creating socket\n",
 		       __func__, task_pid_nr(current));
@@ -946,8 +946,7 @@ p9_fd_create_unix(struct p9_client *client, struct fs_context *fc)
 		       __func__, task_pid_nr(current), addr);
 		return -ENAMETOOLONG;
 	}
-	err = __sock_create(current->nsproxy->net_ns, PF_UNIX,
-			    SOCK_STREAM, 0, &csocket, 1);
+	err = __sock_create(fc->net_ns, PF_UNIX, SOCK_STREAM, 0, &csocket, 1);
 	if (err < 0) {
 		pr_err("%s (%d): problem creating socket\n",
 		       __func__, task_pid_nr(current));
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index b4274f10fa448..f4450e779a791 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -556,7 +556,7 @@ rdma_create_trans(struct p9_client *client, struct fs_context *fc)
 		return -ENOMEM;
 
 	/* Create the RDMA CM ID */
-	rdma->cm_id = rdma_create_id(&init_net, p9_cm_event_handler, client,
+	rdma->cm_id = rdma_create_id(fc->net_ns, p9_cm_event_handler, client,
 				     RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(rdma->cm_id))
 		goto error;
-- 
2.53.0



