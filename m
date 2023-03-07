Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B378BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C3BC433D2;
	Tue,  7 Mar 2023 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209154;
	bh=xsOVThqsQh+ZVvZrztrjeT1qnorz+ErB+dbDMa4sqhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pyuph6Mkc4CeE9i+o2b2c5Za40gIjUbwNKLRav2RhBkRzCgTLsYujuBt3m2nztHn0
	 upJpDtl+oLHw/sFAFNQb9CQW2AdUXi1kF1CEF9TOpHWwP/dx822CV9m1fxu/FdNx8g
	 8AhPvVnyPuge0cop4NSNJAyqJlmUjWkDoKWLSqPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0120/1001] io_uring,audit: dont log IORING_OP_MADVISE
Date: Tue,  7 Mar 2023 17:48:12 +0100
Message-Id: <20230307170027.299854995@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit fbe870a72fd1ddc5e08c23764e23e5766f54aa87 ]

fadvise and madvise both provide hints for caching or access pattern for
file and memory respectively.  Skip them.

Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Link: https://lore.kernel.org/r/b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/opdef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3aa0d65c50e34..be45b76649a08 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -313,6 +313,7 @@ const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_MADVISE] = {
 		.name			= "MADVISE",
+		.audit_skip		= 1,
 		.prep			= io_madvise_prep,
 		.issue			= io_madvise,
 	},
-- 
2.39.2



