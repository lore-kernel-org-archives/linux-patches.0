Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216162;
	b=P3IlFC7jP6UrCR5WsIez7dz1yhyElHqqWsEmJQyZAshzotml4fJg/UOFXjORw1fQrILU
	 qj9eBhHdSAwc3PD/5qkxH7a0sbzyh2JOtILceBjrkH6KzE6zn4w6NfdIM9pOAWhNSu7Y1
	 rhru6gfAoahJGWKNpTmS+VK2a4AhwsC7RxWOVZkiPG0Lgcioqq4hMjJwBBuoP5huZfqef
	 dwJw/t/imaBCN6yS02PNgPLFXlIhlVsV3Mb3ZnQCJWHSCHFqIDPlX7YSp7WHMqMa0UaRM
	 NAAZ0cDXWhvS7U9nmZRSUlOvFyAuHNtZwRKImSO+8flWys/WxnwZDlR6LgCIaz3uk1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVEXIsFYUXaq64l1M4kRbWH4LS9MRZE9Mv53kjWMN5g=;
	b=VJ7GXbY6Lzxe55fDz4QNczRRwdXyBrWnupUDeLAIE9gbBK12ST+ktsmhIwc7PKbzc9no
	 97gNuRW70RrmQ9yycttCrs1aG5Q3637dPG8e0/DdSug04fWO5CttFxVdKrF1Qof8DsJy7
	 saBly539w/efHoJQ+8/CSXjK6GURcHO/Rv3+aWTPvQ84xw/CR0Ivxvxi0RS4yNVlC4O2D
	 xGdZvER8c1Z2J41z+EiDPjd+ksHZpmANW3ERiz2g5TutKUqrzOH2YhYc9Oxw0VZ4UYHNm
	 5Tclu5dvg7GP1sXLZcLVySTioP+cAzeTPJ+XMpVHubdK321sU9JzHfgUvDRVcMXBPoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6O7eZMi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FA0606A31A;
	Wed, 28 Oct 2026 19:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6O7eZMi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6E01F01825;
	Wed, 28 Oct 2026 19:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216162;
	bh=BVEXIsFYUXaq64l1M4kRbWH4LS9MRZE9Mv53kjWMN5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6O7eZMiEdvf6YugoKY54mIfktnVEQvE1p3d6nsMxXyJiKz2VfpDUrR+++Bs7yyXP
	 3SCLGzP4fqlv23E1vVCUP4pYYkWnLGQFn6A7qtbwOG3pWD5Cw0wMClz1wips0FbQnC
	 csr/6SAbed/CEKUDK0eV6yxW1j3iBm94rlJZC4Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1419/1887] cifs: call pagecache_isize_extended() in cifs_setsize() when extending
Date: Wed, 28 Oct 2026 17:58:35 +0100
Message-ID: <20261028170531.749926628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit c510edb9734af1c274d18f4f31a471a166bbc7e8 ]

cifs_setsize() calls truncate_pagecache() but skips
pagecache_isize_extended() on extension.  truncate_setsize() shows
the correct pattern:

  i_size_write(inode, newsize);
  if (newsize > oldsize)
      pagecache_isize_extended(inode, oldsize, newsize);
  truncate_pagecache(inode, newsize);

pagecache_isize_extended() zeroes the tail of the page straddling old
EOF.  Without it, dirty bytes in that region can be written back to
the server, exposing stale data in the newly extended range.

Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index df85fcbe93907..f87a0a6d68c93 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2669,13 +2669,17 @@ int cifs_truncate_page(struct address_space *mapping, loff_t from)
 void cifs_setsize(struct inode *inode, loff_t offset)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
+	loff_t old_size;
 
 	spin_lock(&inode->i_lock);
+	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
 
 	/* Cached inode must be refreshed on truncate */
 	cifs_i->time = 0;
+	if (offset > old_size)
+		pagecache_isize_extended(inode, old_size, offset);
 	truncate_pagecache(inode, offset);
 }
 
-- 
2.53.0



