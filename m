Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624092;
	b=35rNqkUxg4Z/5ze0yXC8e0ejGk39MkYBnsltmfVVc+KMLNlhg+4n8ROZgNEnklmP4zni
	 sZmd6n3DABwir3PvncrgZwv4aq2PkxbdLKhSw3Vy+Z587hMuZEebjC1ZGaF5KxnOb0/VI
	 o8Xrlx8W1fG2im1mgArwi2tdnk99lCNB8356eBfErZDBykKOs92n2nOjS1TNLzadILDmn
	 xjCwdjKmC2OPvVdDC9EE1vOkojGHnd9fdDVnefxdlV6reBqDoz3Vc9uwBnTz8T3RpcQm+
	 agoFkujWxbnZ5mAW6/rOGo5br3X/mp3Q11KViqMZpbsNz5Q4BkeDX7qFSmCMCIQvx1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EFDuU2Un8gA5RqZMEaCUNvq/CtTT9vF2vLHP1lMD+/Q=;
	b=qy3l69n38t/IffyoKqjyWdpkAWS46cAa/kyjROOIYtDBFnpVncXMyKkVnkKxkI1lEJpV
	 hqVkLbZgRBz3UGAW7tUPp3g23mK0Py7o8xzIpvwnlNjHFuBhpQNr6ljfMn67RqTn7T73V
	 rXixVtQafdacJTw0Jb1gX7a+HYCiNkxrcr1vfrouAQXcZguvjvvNsv2pK0RbLeKi0ooFF
	 iyHboGxlDaQEopsLfB6TWa/jprCRcAA5GOVo/6Xj6zxuJnIKzx88tKY9e1jPk8FSGvIYG
	 0EAQbx6YjV/XAxP2lH+QBbZvA93U3ruvTsUqCKDZy5kwmLntUKBxjBKp3v8qe6dqOPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2o0o80b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CD0606A31E;
	Wed, 25 Nov 2026 16:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2o0o80b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35B91F000ED;
	Wed, 25 Nov 2026 16:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624092;
	bh=EFDuU2Un8gA5RqZMEaCUNvq/CtTT9vF2vLHP1lMD+/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2o0o80b33jywYOhD0n4nh4q/BqgPu8zCLePzegr3wI6wfWhrC+v1318e4/PICxGh
	 2d4V3fzvqjNcufDtJXybCKfd5SdmS7tnFGcm21IFlXsZMLpJ94Mj+l36trO3skaTAP
	 05prBXJZQUSfvlo1uTfWvhBnEViDMtuaKDCf1nhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/816] io_uring/kbuf: initialize arg->out_len from arg->max_len in io_buffers_select()
Date: Wed, 25 Nov 2026 15:26:26 +0100
Message-ID: <20261125143850.104157790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>

Commit b7322810d1870ccc0d293ad383d94ef583d5057b upstream.

io_buffers_select() passes &arg->out_len to io_provided_buffers_select()
on the legacy provided-buffer path. Because callers initialize
arg->max_len (from sqe->len) while leaving arg->out_len as 0,
io_provided_buffers_select() sees *len == 0 and always selects the full
buffer size buf->len, ignoring the user-specified sqe->len limit.

Initialize arg->out_len = arg->max_len before calling
io_provided_buffers_select().

Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Link: https://patch.msgid.link/20261116193146.65315-1-sidchintamaneni@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index da6b46244e6de..9d6b7c433eeaf 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -343,6 +343,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 				req->flags |= REQ_F_BUF_MORE;
 		}
 	} else {
+		arg->out_len = arg->max_len;
 		ret = io_provided_buffers_select(req, &arg->out_len, sel->buf_list, arg->iovs);
 	}
 out_unlock:
-- 
2.53.0



