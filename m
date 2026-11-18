Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054060;
	b=UxLmtOKgzMUEyijh51xedFQ/1AEldNFM+5kb1/C3ER++JIvy+Spzdnb5t21yBZ+NA0h/
	 QSiynAhe2Lba+/hMw7zK6KcSscZJlcADQPmO2Xnb+nRoUJp771OOYP/bxc2oYl22L3bCj
	 gqkUD03xQtC2KcPxtElayI+AFMekyxwP/L/M58lR1wBKXgEMKuXhRP9DWWlPcmA8YaICu
	 ijWFqPxl9qzLCqibrPj1J1Ti9mkclArRVi6KRSZlzDJljXqnuQxZErYgEF97evfInyBtr
	 BNDgleI+N8fswUXWGnn1ULkKxWfirkEwYEYsN9dWu2oOy4PBCnCUKHk1MfiQuOQwf6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+s2z6qypt/B+nTqHIUXjrcIC+DfQUDR2KrBOssQDm4k=;
	b=arH4bXDpNZakciQC31qB9nMIWCfWEzSG9bJoFm/xzV3aWNYODyLhtbh8ax5NLAR4Lk/v
	 faCg5Z8+w7AqiaCxUijoPf2uRKsA4lHB+GMCrbOuWA5NveXlKO/Z0X8kgV02xntH4Dzj/
	 /L4vUJ8U3mlTetlk9jwiNqA2vBZQoddYTgS104SshYBZ3qAs2M/4h0/HZwc6KLJVmCZKT
	 W5KPxMH06yGZZ/BOs4wkwkboYaotnII1nS81d1T0N9+to2gpDMNU0gOzXSedoQ7Ollf9C
	 DLLWHVVKshgHlFmOyNwVyjz3tryHb3pI1Dp7k1zRdtIePyk8mP4sybtGlmMDxme5PPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7yrv1gN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B389606A31C;
	Thu, 19 Nov 2026 02:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7yrv1gN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BB01F000C4;
	Thu, 19 Nov 2026 02:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054060;
	bh=+s2z6qypt/B+nTqHIUXjrcIC+DfQUDR2KrBOssQDm4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7yrv1gNfauYHXg+5HJK3URXdM2dP9Y2iX17N/wiZCzvW5yPl6m0mjiun9HSr6fXL
	 lVLk3OjSH2H+skRREZhKoWgpkXwvTpj1Gf80NdsUXIS7GCya7P4QGT9943Fvew/8JT
	 jSMsbH+mGMrzr0ace2ZxRJTckcgUkDtDlLctdP9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1139/2214] f2fs: fix defragment writeback range truncation on 32-bit
Date: Wed, 18 Nov 2026 15:46:55 +0100
Message-ID: <20261118150057.596274011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 92154fe28c3701bebf75176dc5522bec62519a8f ]

f2fs_defragment_range() flushes the range it is about to defragment:

	filemap_write_and_wait_range(inode->i_mapping,
				pg_start << PAGE_SHIFT,
				(pg_end << PAGE_SHIFT) - 1);

pg_start and pg_end are pgoff_t, 32 bits on 32-bit kernels, so both
shifts are evaluated in 32 bits and truncated before they are widened to
the loff_t parameters.  pg_end is only capped by the file's page count,
so for a file larger than 4 GiB the shift wraps.

For a 5 GiB file pg_end is 1310720 and the range collapses from
[0, 5 GiB) to [0, 1 GiB), leaving the rest of the dirty pages unwritten
before the blocks are moved.  For 8 GiB the shift yields 0, the minus one
makes it (loff_t)-1, and the range becomes [0, LLONG_MAX].

The matching call in f2fs_collapse_range() already casts:

	filemap_write_and_wait_range(inode->i_mapping,
				(loff_t)index << PAGE_SHIFT,
				((loff_t)pg_end << PAGE_SHIFT) - 1);

Do the same here.  On i386 the shift changes from "shl $0xc,%ecx" to
"shld", i.e. from a 32-bit shift to a double-precision one.

Cc: stable@kernel.org
Fixes: d323d005ac4a ("f2fs: support file defragment")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5cf96cac8aabd..ad1cc60b588b9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2627,8 +2627,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 
 	/* writeback all dirty pages in the range */
 	err = filemap_write_and_wait_range(inode->i_mapping,
-						pg_start << PAGE_SHIFT,
-						(pg_end << PAGE_SHIFT) - 1);
+						(loff_t)pg_start << PAGE_SHIFT,
+						((loff_t)pg_end << PAGE_SHIFT) - 1);
 	if (err)
 		goto out;
 
-- 
2.53.0



