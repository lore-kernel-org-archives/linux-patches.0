Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043259;
	b=rQu089p6tJT/1HPdxo/BGaaYJfqCLHqATYGu+0LQjL3+o0GCA/bfOP7x8+a0g7XHe0jW
	 qTN0fgVxpuvQdstBF/UfXqN9WRJH70CwtBVYH0MtkPMaypnxrMjOVTOZG5KOubFrVtPJi
	 V9MXpma19Kxx5WGvSOtQ/cydVWhDd7WDnjftagGhqnhf/mYyN4xGqNWR/XKS44cA9orzR
	 uCdLWh3/+j9xpCvh9zUkGdtaE7S/K4XbTk7ncEtKJKMnhSKh46uyU79DoY5oiQ2A3EOIU
	 uk+DbkXQ47XKEqSvx/3PdxLCceRMyGr5Q0LBlOp8HoSVkWw6ZU1jztUWWXqhyZfmq1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eN6yc2ErzT7vZ3XimcRb94FEel99YFzy6EJ+UwofLLU=;
	b=C0EmL1GRQiOoYehPgAvXnAK/vjb+gnKoHb8SWo6lbxQbydgT5+f/UZGdPHnQzRKp1dsy
	 lbx4y8xvLAjuaGNtkc0X3oaQIxavQ+slNhBro8NDdneGI26MoohzkXPMlTRLJBkhegG2L
	 K/muYjoAh9xdeptZc4yOhbyA/WRAa4AdMpaoRfBdn/6c4oS4ShjCd4vvVdkcv/xzfbkJW
	 QOcDhu3FVeKncY3cpkclcIZmRuTv3GxIkKljJJ4DOPG+QA4UhDjyVnlNwr8HOKLz3675/
	 JVzIqPyF2vfLS2baNVztsetsHc/rOW7FjsaQa0LF5/5ivXA2E5hcSh3ghNuJIdmVi6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMnZDhXc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD53606A320;
	Wed, 18 Nov 2026 23:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMnZDhXc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7A01F000C4;
	Wed, 18 Nov 2026 23:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043259;
	bh=eN6yc2ErzT7vZ3XimcRb94FEel99YFzy6EJ+UwofLLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMnZDhXcfzzJGAcV+noYOwYAZLbxRX2dZGR+qkDcfOBD2/rZGobTYWi5FA3O47k5j
	 P6RgIxSVrldohJkSzlM+7RRADlDoBmpQBi3YmFK8ElcU9VnwIz13fRMy3k7gyXFdRX
	 a8uv8bkF924+zMNjyYflXvUsu1jR314o2AezdZls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0145/2857] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
Date: Wed, 18 Nov 2026 15:19:39 +0100
Message-ID: <20261118150206.568676169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 705a3fd3bac167f1dabe3d3bba46cd484c5528dd ]

ext4_load_tail_bh() ignores the return value of ext4_get_block(), so an
I/O or allocation failure is silently discarded. buffer_mapped(bh) stays
false and the function returns NULL, which callers such as
ext4_block_do_zero_range() treat as "nothing to do" and return success.
This can mask real failures during zero-range, truncate, or punch-hole
operations, potentially exposing stale data if the block was not
actually a hole and needed zeroing. So propagate the error to the
callers.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5f0cd1f74b6f2..b17d13cea6c72 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3792,7 +3792,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	}
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
-		ext4_get_block(inode, iblock, bh, 0);
+		err = ext4_get_block(inode, iblock, bh, 0);
+		if (err < 0)
+			goto unlock;
 		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
-- 
2.53.0



