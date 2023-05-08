Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD69A168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF89C433EF;
	Mon,  8 May 2023 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544494;
	bh=laVpb5trw94Adw1+l4d5840fl1xx2436hq1hrkQtn/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Euql5rjelP3d8Gm1iII+IrdYZR7zH2ZMNuLFoFmpfuWJc4zdq4PYndThw16AhxFTy
	 AMEaljdmDzF6Uvz83Cl1wgFiBNF5zkyCXo4aGl8xAxjOb7zflmpzRaHoz0MyIcIWvZ
	 H5PA2yZkGgPjDTFgZo1+g22NSCrfsMgOasU1KXuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 429/694] io_uring/rsrc: use nospeced indexes
Date: Mon,  8 May 2023 11:44:24 +0200
Message-Id: <20230508094447.269658638@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 953c37e066f05a3dca2d74643574b8dfe8a83983 ]

We use array_index_nospec() for registered buffer indexes, but don't use
it while poking into rsrc tags, fix that.

Fixes: 634d00df5e1cf ("io_uring: add full-fledged dynamic buffers support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f02fafc5a9c0dd69be2b0618c38831c078232ff0.1681395792.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7a43aed8e395c..e6fec9e971eac 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -577,7 +577,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		}
 
 		ctx->user_bufs[i] = imu;
-		*io_get_tag_slot(ctx->buf_data, offset) = tag;
+		*io_get_tag_slot(ctx->buf_data, i) = tag;
 	}
 
 	if (needs_switch)
-- 
2.39.2



