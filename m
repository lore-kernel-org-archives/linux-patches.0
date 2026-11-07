Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062020;
	b=F+vtKQ19rSsqBwGNMkYDurO6HBZCZS27HPFSzAQIB3jeK1P+jUhFIbQ3FkFibN9CoLcy
	 PzaGnYdRvSUO9pD77nT6LfBv06iBtI83rr2Taw+xXI6iRnEy18csorj10HDO06H4vr5A6
	 5Bsg5aSWfGgnDFCpFE7miTPhxgNSgN8LwV3YnfYi2rNhY5HRzsVJhqZUaP0xm3CQh/Ofh
	 rOsgeY4HwI5Ca/uQ6HZ1A0Ag1oFgjyJoKV40fl1PkbsgZmns+wF+22z45F6SFN1stCqh2
	 kgbeuNgVUcbj0BhXKLs1tDLPgWg8u9HA5f9xY/yLiqSszMJS+GvV0yID/WYFTH4GHlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=djJ5AC6wL57lXSw9yRiNbpaFN4ZFF9FfvYd7D5Zszzo=;
	b=BlpHeaXHgs9PxYe3fZZiFUHrE74CaOux4bGQ54lVNzZAQ6BQMlnefst85wBiZecYmsZ0
	 ZkKiw66RAmJ+3C5wcU4A/bytnro0SXUjiX4AOyj5qE7MD8gO8tcXxvOooT9pFO28QKQB6
	 TzymBsE5ofsSlLun+c1JdnD2EM8rff+5uxoylLl7/Jr/AqD8LhsOMUYmbqA/1VNJ8qfva
	 SQn3XbXwqrFuG6kZwh8kUWyHwBObURdKFPVdJnREEU8yQ8zYoYHkF89lms7xIE/kY0VgZ
	 L065vwcRpOlHoCbxDdUkGn09hsrJyWSk7wZe6xKcBFgxPO8WteodwJIVfxOitN2Z6ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUg0YhLU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D27D606A333;
	Sat,  7 Nov 2026 14:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUg0YhLU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6DD1F008A4;
	Sat,  7 Nov 2026 14:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062020;
	bh=djJ5AC6wL57lXSw9yRiNbpaFN4ZFF9FfvYd7D5Zszzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUg0YhLUOdv8m2ar4SgcVI17BgliMPbL4dIdZrdBO31hkKaLjRQpMHj4+lLIbWAiU
	 ayVClGIiP7CS5dc62K824LUDQg4u8VcpQygEJNRtHj4HJM7v53ZzEi4mJjqZopBtkT
	 dbBLdd2NaJHTRlVfYfBSpe8GAqkLOb0n8TqSqq80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0990/1536] ntfs3: bound index head insertions by buffer capacity
Date: Sat,  7 Nov 2026 08:50:06 -0500
Message-ID: <20261107135025.463520489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 2f497d23652ff23da07b08cfb4b4a1c2a87f1892 ]

hdr_insert_head() shifts the existing index entries by ins_bytes without
checking that the resulting used size fits within hdr->total. A directory
index root larger than the newly allocated index buffer can therefore make
the memmove write beyond the buffer.

Reject insertions whose size would exceed the index header capacity and
make both split callers unwind the new node when that happens.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=45ef5a8d661162757547
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 03ae5a817c1b4..97cbe176a83e5 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -596,6 +596,8 @@ static const struct NTFS_DE *hdr_insert_head(struct INDEX_HDR *hdr,
 
 	if (!e)
 		return NULL;
+	if (size_add(used, ins_bytes) > le32_to_cpu(hdr->total))
+		return NULL;
 
 	/* Now we just make room for the inserted entries and jam it in. */
 	to_move = used - le32_to_cpu(hdr->de_off);
@@ -1800,7 +1802,10 @@ static int indx_insert_into_root(struct ntfs_index *indx, struct ntfs_inode *ni,
 	}
 
 	/* Copy root entries into new buffer. */
-	hdr_insert_head(hdr, re, to_move);
+	if (!hdr_insert_head(hdr, re, to_move)) {
+		err = -EINVAL;
+		goto out_put_n;
+	}
 
 	/* Update bitmap attribute. */
 	indx_mark_used(indx, ni, new_vbn >> indx->idx2vbn_bits);
@@ -1952,7 +1957,11 @@ indx_insert_into_buffer(struct ntfs_index *indx, struct ntfs_inode *ni,
 	/* Copy all the entries <= sp into the new buffer. */
 	de_t = hdr_first_de(hdr1);
 	to_copy = PtrOffset(de_t, sp);
-	hdr_insert_head(hdr2, de_t, to_copy);
+	if (!hdr_insert_head(hdr2, de_t, to_copy)) {
+		err = -EINVAL;
+		put_indx_node(n2);
+		goto out;
+	}
 
 	/* Remove all entries (sp including) from hdr1. */
 	used = used1 - to_copy - sp_size;
-- 
2.53.0



