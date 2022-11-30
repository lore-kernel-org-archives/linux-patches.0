Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C7C79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E828C433C1;
	Wed, 30 Nov 2022 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833867;
	bh=a+lWXkobKBooK2SlHw9VowNT8LMkiOiLAwl7GsKr/TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zthLVvSKFuljY4S7ylTMjzAW2w8KZcWYmcy6lbzxasW0J4gSRKCNY8yrYwG0Tdpcw
	 DKeGrcH0sBH4I25h6J+C/SNdA2bJ5nnHlVuYYeI1ggVabliKQr9vxPViy6zUFR2Epj
	 5x//I1TGSuH7T0pVqOTV98VYCWv5RP6Xx8XoYbHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 043/289] io_uring/poll: lockdep annote io_poll_req_insert_locked
Date: Wed, 30 Nov 2022 19:20:28 +0100
Message-Id: <20221130180545.107854669@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 5576035f15dfcc6cb1cec236db40c2c0733b0ba4 ]

Add a lockdep annotation in io_poll_req_insert_locked().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/8115d8e702733754d0aea119e9b5bb63d1eb8b24.1668184658.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index ba0f68466930..055632e9092a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -116,6 +116,8 @@ static void io_poll_req_insert_locked(struct io_kiocb *req)
 	struct io_hash_table *table = &req->ctx->cancel_table_locked;
 	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
 
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
 }
 
-- 
2.35.1



