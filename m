Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6465679D0
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2EBC433D2;
	Thu, 12 Jan 2023 14:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534328;
	bh=IEsXqHYVweLuzQAYjINd9l9nUTDUu6YIw4SJDjbK5IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZdXgieQKhZ19e9WdQP4LIuUJLmZAVGQQ2ajnH+Dd3f7hMLG+4cZAuXNOTuKQ6MCv
	 XpcomcwRrf9kmQXtN03yte944Tiw4fYpbf9pyTmS/N5o4sWDnZ/d9TGo2gawrcq2Hd
	 MCPvP+gr9nii6QyssfFOQncqbS5avskA5wZnny0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10 772/783] io_uring: Fix unsigned res comparison with zero in io_fixup_rw_res()
Date: Thu, 12 Jan 2023 14:58:08 +0100
Message-Id: <20230112135600.170942359@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Smatch warning: io_fixup_rw_res() warn:
	unsigned 'res' is never less than zero.

Change type of 'res' from unsigned to long.

Fixes: d6b7efc722a2 ("io_uring/rw: fix error'ed retry return values")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2702,7 +2702,7 @@ static bool __io_complete_rw_common(stru
 	return false;
 }
 
-static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 {
 	struct io_async_rw *io = req->async_data;
 


