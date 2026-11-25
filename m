Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624605;
	b=jOEgpWQkEfx8SZWgqAyHPE0rmvHhlm/yLmEpMCHTUqMxJSSFT+jb+T4Tpb0WsQ8fb3Dw
	 frXQxvFhqQiKzkG2g/nQPY1qBxePFdztxWNLX8wzD2AHwv+xMJkQg1eEvC885d6XkvprE
	 UjZuSPgOEo8yI2ltWhQizcHHtPzCbvhNE8TiT5OGVWhVCjwYQjjdWyena5NOJE9ayZ9D9
	 5g0pREUrmOYIaawYJKg0bUoMZAYlgU67TNSqdgPJqyrF3ffdo18KlHUdrH0jgapxA7+JD
	 4enDVyzzBiwz+5KrL2tS3zjxhmxUA6kVswwu3z8mYp0N49wOKr3EV0PP9jk24r1pLcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j0iogLwPDUBRHRsHoqKdiqdGWCRw9BCp+iSAlmn7NPc=;
	b=pWvc6/2BaEjmsXN7e6wmk4+4vEpWmHLB2b4/7scLBPTS6zTj7SY5VHp4bQrEkQGkRsFk
	 UmHk7HEs6fewSSzXm2QekYXdb2frE9JWnfx72Eryk/A5SphIw7h9rl00nxgMRn72Q8fJ0
	 aOH9gSFCNgS6YxZijWZT8rjwwx7tHeOYgoUpvcSpnqZmJLLtSv8dBNTA7FH2LaFTZAo3x
	 SKEDz8eq4L/x82Uu3xJLTzAkNUYxwCTmlBEvhQ4OA4C/wPuirhAKSisl+S2rchaS1CijX
	 xgG0Ltb2KgOkAWjayd4S/dGSKjvNwLDbZw1UQJ70WMAdzj6Y/tUjyviXqaUC1wp2BQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0rZSSqOZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7FB606A339;
	Wed, 25 Nov 2026 16:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0rZSSqOZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C30D1F000C4;
	Wed, 25 Nov 2026 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624604;
	bh=j0iogLwPDUBRHRsHoqKdiqdGWCRw9BCp+iSAlmn7NPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rZSSqOZHaHvYa75X0a0enthhxfRz4ZjprG0YQ1NXoqCcRB1hmH5vDqfzQ6EyNVmz
	 CsZdD5f3/wnturZGTfDRYqG0OKTEmKTtP8fERUA0E8ays4CrdZpaV7hlvnkNHruHp0
	 SvxpIBzG0rvB64A/3nKJY9EAiwCJD4unAoQ1hxoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/816] statx: dont leak STATX_ATTR_CHANGE_MONOTONIC in stx_attributes_mask
Date: Wed, 25 Nov 2026 15:29:55 +0100
Message-ID: <20261125143854.926248332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 925d238324c79bcb75ad0add1d1b9d31d5f48115 ]

STATX_ATTR_CHANGE_MONOTONIC is kernel-internal. cp_statx() strips it
from stx_attributes but copies attributes_mask verbatim, so it leaks to
userland on filesystems that advertise it (nfs, ceph), e.g.
stx_attributes_mask = 0x8000000000303000 on NFS.

Add a new mask constant and apply it to both fields.

Fixes: a1175d6b1bda ("vfs: plumb i_version handling into struct kstat")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20261103-statx-v2-1-8b09aa8118ab@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/stat.c            | 6 +++---
 include/linux/stat.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 5aa8f296e8ee5..23de8d02654f9 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -681,8 +681,7 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	/* STATX_CHANGE_COOKIE is kernel-only for now */
 	tmp.stx_mask = stat->result_mask & ~STATX_CHANGE_COOKIE;
 	tmp.stx_blksize = stat->blksize;
-	/* STATX_ATTR_CHANGE_MONOTONIC is kernel-only for now */
-	tmp.stx_attributes = stat->attributes & ~STATX_ATTR_CHANGE_MONOTONIC;
+	tmp.stx_attributes = stat->attributes & ~STATX_ATTR_INTERNAL_MASK;
 	tmp.stx_nlink = stat->nlink;
 	tmp.stx_uid = from_kuid_munged(current_user_ns(), stat->uid);
 	tmp.stx_gid = from_kgid_munged(current_user_ns(), stat->gid);
@@ -690,7 +689,8 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_ino = stat->ino;
 	tmp.stx_size = stat->size;
 	tmp.stx_blocks = stat->blocks;
-	tmp.stx_attributes_mask = stat->attributes_mask;
+	tmp.stx_attributes_mask = stat->attributes_mask &
+				  ~STATX_ATTR_INTERNAL_MASK;
 	tmp.stx_atime.tv_sec = stat->atime.tv_sec;
 	tmp.stx_atime.tv_nsec = stat->atime.tv_nsec;
 	tmp.stx_btime.tv_sec = stat->btime.tv_sec;
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 3d900c86981c5..0f77837ef6ef3 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -67,4 +67,7 @@ struct kstat {
 /* file attribute values */
 #define STATX_ATTR_CHANGE_MONOTONIC	0x8000000000000000ULL /* version monotonically increases */
 
+/* mask of STATX_ATTR_* bits that is private to the kernel */
+#define STATX_ATTR_INTERNAL_MASK	(STATX_ATTR_CHANGE_MONOTONIC)
+
 #endif
-- 
2.53.0



