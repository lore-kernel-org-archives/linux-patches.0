Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617638;
	b=QL0jdcCdBGTdLsfQi0edNUWDo3S1qSJFjM50ONYi2Yfc5DVrJGQXmCTjWJs6kYuS5D6L
	 dmaSwmuN20YVR339fr+/Z4YFKPLyQ+QMCwyFb02hypBJo+SplEECi1XgEmPxztz0vPi7n
	 MvJOh0Y3dYkph813VuI2UxHOyNuyNATQFDVutC2uud1+SIS4hbsJwzrbV6knbg6tPgZoF
	 m3k+5hGvaOssDQd/lD+aZ4h1dHBTsW70mkSIC4H5IzwuuxpdK8GTSuyt7KAgEkBcBrhR8
	 XViQBqCGB8AjpCyUsbARkt8QaOcn9lOYYA49JQnYlovHlZOrQkzjrVe6B7zRpxbfraA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DOQZ84bEJvuOF/lEzbJk2SY66yCIfxt40F4Ukjq3QuQ=;
	b=TS4yPdl+XqJpAYE7e5nJrJky1kabP0mDTeD6xK/xsiGGmFRKSaWAkH+idLcL2VoNiHu8
	 qKfOiOpPdp0B1/TYP8nU8zayl+nyVgVsJ2V0YvEJlpCA+b7gLuy0U1oRQjfS1FU9ffOTX
	 JfgwVy8NaWSINQAGGM89m3OSAbUXOtewEUbXmiLtefdxHtGwbuI+8hYYclr4PA0EaJt6V
	 /Oc0B1/ogRnz9+gmJlXDMabnrRd0RUpCFEjJmKhS1juOziJe7RWn56ZsH1HMJp3TTKjDf
	 c6Bxuk0/VZ4o2jNgyPdS7DFNc3BfMLhlNxEwMr7OZhWHkh4YfSg8Jt6JQMzXYSppfuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEpdw9GP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828FC606A681;
	Wed, 25 Nov 2026 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEpdw9GP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9C71F000EF;
	Wed, 25 Nov 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617638;
	bh=DOQZ84bEJvuOF/lEzbJk2SY66yCIfxt40F4Ukjq3QuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EEpdw9GPEd03rfyJLcwtpWJCDAc+K1jJNZ9De4P4Y4JFREmO1W3nidhMcgXonTfbZ
	 ZeACQhx6Vk4yDPb0gn91uPdHmc2Cku82p1yoSrbst0iXintnQclEb5lEvV5Faf/Dah
	 o/CjerSRK32cAQsnLyCQgFKoN2hpiTp4SxXbffwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0021/1005] io_uring/kbuf: initialize arg->out_len from arg->max_len in io_buffers_select()
Date: Wed, 25 Nov 2026 15:22:39 +0100
Message-ID: <20261125143822.233506194@linuxfoundation.org>
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
index abf44f5dba26a..873d66a06b360 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -370,6 +370,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 				req->flags |= REQ_F_BUF_MORE;
 		}
 	} else {
+		arg->out_len = arg->max_len;
 		ret = io_provided_buffers_select(req, &arg->out_len, sel->buf_list, arg->iovs);
 	}
 out_unlock:
-- 
2.53.0



