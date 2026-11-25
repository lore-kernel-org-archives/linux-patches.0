Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617790;
	b=0cuWMeHP1ehxH5pZzpoDfoACip6ObmOYobbNzw0AY2FfkrS9L3XbJ2JFbJCr+OAUmVW5
	 ZlA3HORkvwgUNE5jzhDF5yaIc/m7qiTpEXhTx5bhLoN6X/QwneM/OllnbiAeHl69+s7NE
	 3y9uAMqKTvG94sEzsl/YhRhv4s3Bji707dNb2BYjY5JcTK4epnrT7Xsldafus8hk1kgeY
	 gsZghpdNLHLNOf3cmn5Hiq3GvrwheuY85GEKAf+ZUZXknDc336ba9g3NUlQbyMhRZZ8Za
	 vTPZbwZgwcExdKuJGg1QFre0MvyDsFjJ0d9Vrux078mj+wEAzxB5tt+1YMWCdrphckA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RNHACMrXBrv2QAyykzn/5IZvO8AtsIEip9tgR+TKong=;
	b=dgJ9ebHuCsZn6637ldtI+gr0s+OjzW44MPMB2T7wnmG/AU3DyugndHviwWfQbtVDdVA9
	 5yQ0dbtcBOZpQ3n9kRwk+Rq259VJFPFmz2QdFwxoYCiP2aLJ7qYzE+DlqVEapnEp4y1h2
	 6EwBlSpO6mZn5vj/Jsxhqh5cCMpw/UCuXsbCI7AGo5MaRM7X2cD4rLKgoNS83NgMTXqyO
	 w8b0lEbw5kXp2IT2O536PRUS1orLqPOxudIBrvxL6lnmvOzfXogSXeIsC5L2aL/CnaU/t
	 a6Xsztjcqy/bw0Vq5uKu/t8KUkQ9u8QySA6Wrj97uf0NEaPFyxruLjMjvDg6iiIzbVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9Dj5jpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADCA606A326;
	Wed, 25 Nov 2026 14:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9Dj5jpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BC41F000C4;
	Wed, 25 Nov 2026 14:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617790;
	bh=RNHACMrXBrv2QAyykzn/5IZvO8AtsIEip9tgR+TKong=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9Dj5jpeBnGncXGGS+jzErUAajW/Wb8k+rbsAmk3O1u7nlZua5t0fA1c5l7hzGxFZ
	 by+tjCnchR2iV3PNBRVj+8/CSvn6fEUKQEsO5mgLga23dPH3ANY8+ZBXCtDSlX8Ici
	 CJFpdG5X+BaMR0m9a03CH0rDsL5B5nDh7seSzooI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0020/1005] io_uring/rsrc: keep the old file when a file update fails
Date: Wed, 25 Nov 2026 15:22:38 +0100
Message-ID: <20261125143822.210530851@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

Commit e5a346e4309d720c47fe8331a00068608fad47dd upstream.

__io_sqe_files_update() resets the slot before it calls fget() on the
new fd. If fget() fails, the fd is an io_uring file, or the node
allocation fails, the update stops and reports that entry as not done,
but the old file has already been removed. Later requests that use the
slot fail with -EBADF, and if the old file was registered with a tag,
its tag CQE is posted as if it had been removed on purpose.

Reset the slot only after the new file has been checked and its node
allocated, as io_install_fixed_file() does. Removal with fd == -1 still
resets the slot right away.

Fixes: c3a31e605620 ("io_uring: add support for IORING_REGISTER_FILES_UPDATE")
Cc: stable@vger.kernel.org
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/20261116044531.281978-1-teel4res@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c1ab760c4591c..d1ba00390c58d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -330,8 +330,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		if (i >= ctx->file_table.data.nr)
 			break;
 		i = array_index_nospec(i, ctx->file_table.data.nr);
-		if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i))
-			io_file_bitmap_clear(&ctx->file_table, i);
 
 		if (fd != -1) {
 			struct file *file = fget(fd);
@@ -355,11 +353,15 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				fput(file);
 				break;
 			}
+			if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i))
+				io_file_bitmap_clear(&ctx->file_table, i);
 			ctx->file_table.data.nodes[i] = node;
 			if (tag)
 				node->tag = tag;
 			io_fixed_file_set(node, file);
 			io_file_bitmap_set(&ctx->file_table, i);
+		} else if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i)) {
+			io_file_bitmap_clear(&ctx->file_table, i);
 		}
 	}
 	return done ? done : err;
-- 
2.53.0



