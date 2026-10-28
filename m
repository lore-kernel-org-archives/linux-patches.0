Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212521;
	b=HOPMyZcf/dTYEcOwrVMk6yy4uAOM8Ven/H4ytlGnl+lWAnuDe0bz1QbN3TKKNIIeWiGY
	 mFnpvpm7z1gc4AkTsOSYXzytxxNEkjubEASLPDbHWAZWkmmrN1DzzII2Gh5ss4GqhYxln
	 CZQm+cQ16zn4u8g2IpGlaw0PkJjPG940r5eQ4+/WIlF8akxMhdTHnLQ51fTVPOmebbGyi
	 bWBFtket5dmqyw+LnPqSse0ADiQwQp6QM8Jnhweti01JL4Rkb0tw/j3chgc8t8YJzNGPH
	 xufO4xhz97sQULXhos4Yj5C2AeekPdnaBC1GJEPx7+pDZg4vVSrF/G7NXE1a0/GWrgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dKlpSfRiecceRt8JjlmIY7Ej8eCeGfLZ167myljRM08=;
	b=1aN+0nZ+mberuaOghwfk/tQFQuMkhYGN4bwDtiU1PRHbne59HHug58CLXk73p7rObPDD
	 8TI+N0d3+EIq6ABtbnWt8KYg2AlSYJk6dkujBC663+QDLpZ2brmng2D1xiEUPF+EJC7kt
	 4jzhXwFuIObCWeooHz4/7ugAYd5wMbi+GLn0Pap+GPr+LakPOPqUcgKWGBnrm/m55G6v5
	 ZqQMUbGAcRnY/hk2pGLbkO2Mc4epvW4zzQJETxoAoZwuqcLnYlZKAdEmsPczytPqln5Hm
	 Kl8GlgVQP/AI6CZZBaK9ZczmEy1IlLeSHjXPDbHwbatZ+NzVQ47WWKOI2EfpdV9xtCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BHNwVLYd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D2B606A31E;
	Wed, 28 Oct 2026 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BHNwVLYd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66321F01825;
	Wed, 28 Oct 2026 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212521;
	bh=dKlpSfRiecceRt8JjlmIY7Ej8eCeGfLZ167myljRM08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHNwVLYd77wVbKosioIl2NhgN9KU+lyz2ehATN6lM2ziA2I9poI1wImSVEe373Awl
	 ls6yq1UYTp+yZAWZw9AdWVPxW8vK4PFJmABOjqmdf+w0DqklRcQJuhFIuXLENhJWDY
	 8rovXwpTCe3MXVJlOk1gfecCn4SFnzwWqRxjTk2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0183/1887] ocfs2: Avoid touching renamed directory if parent does not change
Date: Wed, 28 Oct 2026 17:37:59 +0100
Message-ID: <20261028170503.400555827@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 9d618d19b29c2943527e3a43da0a35aea91062fc ]

The VFS will not be locking moved directory if its parent does not
change. Change ocfs2 rename code to avoid touching renamed directory if
its parent does not change as without locking that can corrupt the
filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/namei.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 62f9d976c8fb3..60770904b243b 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1340,7 +1340,7 @@ static int ocfs2_rename(struct user_namespace *mnt_userns,
 		goto bail;
 	}
 
-	if (S_ISDIR(old_inode->i_mode)) {
+	if (S_ISDIR(old_inode->i_mode) && new_dir != old_dir) {
 		u64 old_inode_parent;
 
 		update_dot_dot = 1;
@@ -1357,8 +1357,7 @@ static int ocfs2_rename(struct user_namespace *mnt_userns,
 			goto bail;
 		}
 
-		if (!new_inode && new_dir != old_dir &&
-		    new_dir->i_nlink >= ocfs2_link_max(osb)) {
+		if (!new_inode && new_dir->i_nlink >= ocfs2_link_max(osb)) {
 			status = -EMLINK;
 			goto bail;
 		}
@@ -1601,6 +1600,9 @@ static int ocfs2_rename(struct user_namespace *mnt_userns,
 	if (update_dot_dot) {
 		status = ocfs2_update_entry(old_inode, handle,
 					    &old_inode_dot_dot_res, new_dir);
+	}
+
+	if (S_ISDIR(old_inode->i_mode)) {
 		drop_nlink(old_dir);
 		if (new_inode) {
 			drop_nlink(new_inode);
-- 
2.53.0



