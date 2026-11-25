Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620873;
	b=MDk5UJ95UJ40P2BQTAGu+Qr3Nrlk4cgY4cPv7rmLOAj4EJ80lThhI2NsxgkVOaUc3iVa
	 H5/pkJRQvdlgSUDH69OAOfNG4kLbuO97dYeK0/zDCow8cJuhmcEOhlWZWfpzuVC7VZnTJ
	 kIJEHOb1hsFUxhqNXRG+UIcjoNJ13zHoG17j22YNfkVuMT3BcHUU+xT+hg0y4mzydzWkv
	 2FlvCWkYiphiQbczUWc0kIB+IV+x8TH8K3ckBf2ANtou3PD+RaiAAwwF9lsfLh9XwHNvj
	 7v4qnQGFYjnt138FJq5vl9ICwEARbVkg1vlMLkADB2D05UUz3ijWdhXqUS4fBhtiTNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sPkfjt4LQ7sSbxNa1YNu6EFHK0hrZK3pvTu8ejW8NbM=;
	b=nyK5Bhb9fSzU7zzmOkdzIuCHAkgizSU5g9f10/NGuC/pp78+59lknXXYQ6wrUsno1dDm
	 mVuFVR9s1z1m/5JVbM13rbpjaVYETsDnA53AhwsU6HtCJm6VmLF8NcV+uyKGy1HPxoe8w
	 6SZNc5YM3bE9U7aHiaQ01Dq6Vi0GFJB6IpB0kyT1uw5K0jUbJuNDxBTTAunMjLTtb07Wx
	 HsT3AXvU9KP3BqoWcmGfYg7GVVZlmMCXhJHAtEG/GjZSNkez5+Bhlt4/tmiTJD53DAemi
	 GA1Gp86PWJKTkcIX7RbwYOdwzL7ZBsB1urDIbXCl6sPIlIQGAR9dJdhmFdlnde2/p4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WA5l032F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB28606A323;
	Wed, 25 Nov 2026 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WA5l032F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E341F000C4;
	Wed, 25 Nov 2026 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620873;
	bh=sPkfjt4LQ7sSbxNa1YNu6EFHK0hrZK3pvTu8ejW8NbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA5l032F51WpezfpRV2z+DP9otJx5ZWu/2si9h1w3hKHGubBCeB45CADrkC6X1BD+
	 6Yh37vYU5kuTJzLrrYi2tN2TAZlsw8i7cECyICFfN04PM3d+V06hxqImWaciXzvCvg
	 c7OtmCtQnvgwTuS/6T6oQ5G3Yj1aIkj8oZ/1OJRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/990] io_uring/kbuf: initialize arg->out_len from arg->max_len in io_buffers_select()
Date: Wed, 25 Nov 2026 15:23:36 +0100
Message-ID: <20261125143823.239747149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index c091c3c462e18..6659f56e91fc6 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -355,6 +355,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 				req->flags |= REQ_F_BUF_MORE;
 		}
 	} else {
+		arg->out_len = arg->max_len;
 		ret = io_provided_buffers_select(req, &arg->out_len, sel->buf_list, arg->iovs);
 	}
 out_unlock:
-- 
2.53.0



