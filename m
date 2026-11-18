Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051345;
	b=1xWQFrrQ1nppEKsSSrNOMm+0AmQG5B0M4cBu4t5c3cEtbGK9tD+UJIvNOQyXxaR4fJV3
	 ZW9TP3dBHQivfKH6d1e33LxAnvu3ND+UjsAL681BjQO+D7PLz4PJPHpC5/lMTh0+kQmzj
	 ArTcQuN9WteWn2t2JxOpOupVyTDhXu9lx5e3QpGvNuTBOef438z0sheSBY071USgX8Q27
	 lOjhB8GvCW8+3LeAql5XODw7YB9l6iyg/B/V6fAq4hA3m8hnMmMVwfv8imvav6LVfx1Tp
	 aBLOeX8FHzfxiGTQ8CQ2FelxrayCiTgurMUrzC7GlgB53G1iXtV8or+E+OvNbwhmhhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lWrsgLJwd2Dy4nnUywfYgiRpagNesxMhLjyTdqkX5CQ=;
	b=m1DCOXwJbloveUiq9KVq81g843nHFHL3EqU2n4bSDvcERlNQKZHE0w7bgIXQ4p9AwvCY
	 2WrSq8OTLrgkdOgiGJfUXWDiyuZJ/a9xU+8sH9fFB+90Qv5E18a1Gp4ADIgucEG3DunCr
	 DcrZejbJ7W59gff26JiAce6pcOHA/gU/3ZM3bVU44KGLziRarZOoi1DnpcX7xnAdyvNzf
	 hYwf+pEjYp1v5gr0Kh/5aPLMZxjlr/ctF4HmCh05NgZ8kDi54bWqMqOrCVzw5IH5V5MYp
	 Qj4QG6S7PrmF0ssZI0E59cjF0V9E6sVAcyZD6gKRZkTiEDhAYNuTXUbuN0UCl0paRAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0DDuW21;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED83606A320;
	Thu, 19 Nov 2026 01:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0DDuW21
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E59D1F000C4;
	Thu, 19 Nov 2026 01:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051344;
	bh=lWrsgLJwd2Dy4nnUywfYgiRpagNesxMhLjyTdqkX5CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0DDuW21PaBGpHcoer4QxCArEDtD8zWWVFscuFGMNhtmC3J9TMdTGJ9andoIk3WIv
	 bwJ+GKReHoj+RB0qN/aOra+jhPtHaFKRDGYzrJdVZC1YSuqzmFK7babUqpm0Kq0WPO
	 Uu+LDLsu2ZhfUqBcDwGEiZ4oMhsBw8rmNcHHxGvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0134/2214] ntfs3: fix info-leak in ntfs_rename()
Date: Wed, 18 Nov 2026 15:30:10 +0100
Message-ID: <20261118150015.567118314@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2fa56613b25d0c983ef3ff6d3e865d4254280abe ]

Hard to say about copy_to_user_iter(), but at least the first splat
looks correct. At the end of fill_name_de(), data layout is:

struct NTFS_DE *e = buf;
...

    |<- data_size + sizeof(struct NTFS_DE) ->|<- XXX ->|
buf |-----------------------------------------------------------
    |<- ALIGN(data_size, 8) + sizeof(struct NTFS_DE) ->|   ;; e->size

If 'buf' was allocated with kmalloc(), XXX remains uninitialized and
passed as such to memcpy() called from hdr_insert_de().

So using kzalloc() for all buffers passed to fill_name_de() looks
the simplest and most safe solution. OTOH if someone would have
said that an overhead of PAGE_SIZE'd memset() is too large, more
fine-granted solution is to memset() XXX only.

Reported-by: syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=905d785c4923bea2c1db
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 9d454b9a9c149..076a22c15e647 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -20,7 +20,7 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 {
 	int err;
 	struct NTFS_DE *e = buf;
-	u16 data_size;
+	u16 data_size, real_size, aligned_size;
 	struct ATTR_FILE_NAME *fname = (struct ATTR_FILE_NAME *)(e + 1);
 
 #ifndef CONFIG_NTFS3_64BIT_CLUSTER
@@ -51,7 +51,12 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 	fname->type = FILE_NAME_POSIX;
 	data_size = fname_full_size(fname);
 
-	e->size = cpu_to_le16(ALIGN(data_size, 8) + sizeof(struct NTFS_DE));
+	real_size = data_size + sizeof(struct NTFS_DE);
+	aligned_size = ALIGN(data_size, 8) + sizeof(struct NTFS_DE);
+	if (aligned_size > real_size)
+		memset((char *)buf + real_size, 0, aligned_size - real_size);
+
+	e->size = cpu_to_le16(aligned_size);
 	e->key_size = cpu_to_le16(data_size);
 	e->flags = 0;
 	e->res = 0;
-- 
2.53.0



