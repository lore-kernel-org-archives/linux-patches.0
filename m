Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210618;
	b=h1GZxnPN71rxZINYzh6Fu5n4he70z+aNC9b2BrsaEvhzcDu1mG4uj6o2qhwkouX9flZ+
	 C8BG8jvxa7U66blB+0LrMjccf1Yt8EVLvyQ0AWsd4Rskh/nZPB0sGp9e0M30gtWpCINpe
	 BA/OTual64xbYHdhiq20cLSAubynwhTC37C3jCH04HeHSJBnQhKk5itvycPOF/dX9+zFC
	 52NwCrmYNKOZvL5iaIvBCHxbEWTvmaVivU98RhD4t7j/znfrrQ/DJZc0qDdEmCKL1BUrV
	 QeSl3rkaY+XoneWDWrWQnA+nw9qp642QKB7bzFB5VVyPusgyDY0vgmjwR2xsYtXx5ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mZ5q4VDeseGqSCz880O1Vj+/TAaaV9vCE6x0d7RAa14=;
	b=QrySos77afN00bv/HRPYC2IJd0UeGnbuPToPgbG9D4GtvhRC/NbJYO4rLpsYwrmmARKX
	 oWhCnNI/kuPL6gHbvZHn/XPeq6yRIdC2kPWlWf1+YimMjLaO8tNyqwDcgGnqe3QyrchIj
	 oCjF6bUYqYiAJpTXjm1T/LnDrsaR7uodOLPlJnmiopSujUYNKTYzhCNsbksIZo7/ixzJK
	 DRbp1t0LOaEDudDBNQHoJl7FPM59hXyc8+OGn2bXP0LDitaDLefZXOZWMUhAronGwmCw4
	 196oQal6q7FydcnuVyhvYaNluqRHBxuVYZ6OEI2sjWlSXk330+rnQAf7Ef0Cr6WzMMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIf1wc7X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A760606A31D;
	Wed, 28 Oct 2026 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIf1wc7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0691F01825;
	Wed, 28 Oct 2026 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210617;
	bh=mZ5q4VDeseGqSCz880O1Vj+/TAaaV9vCE6x0d7RAa14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIf1wc7XNXtdyNLM/5yOr7ON4aMJWHwoL8bJMe4aaWzMwARCqWU2NwUFgMUrT00j2
	 n7Tx5W1R1AcHeVnNiuEHmvwKh5UimJJhHsbFDrC1KnpXS9RNKWQ5LPjBNK8tEjNZy8
	 guz8ezmVH4sfX80YRjNqrwyv6AhWZoJSF0Bh0TuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/571] f2fs: limit recovery filename logging to stored length
Date: Wed, 28 Oct 2026 17:53:57 +0100
Message-ID: <20261028170010.161413944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 01027b2fcb74dade59fb833b51023f6593b6a9a2 ]

F2FS stores recovery filenames as a length plus a fixed-size i_name
buffer.  The buffer is not NUL-terminated, but recover_inode() and
recover_dentry() print it with %s.

For a 255-byte filename, recovery logging can read past i_name into the
following raw inode fields.

Print the name with a precision bounded by i_namelen and F2FS_NAME_LEN.

Fixes: f356fe0cba0e ("f2fs: add debug msgs in the recovery routine")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ inlined recover_printable_name() logic into the existing page-based recovery functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 339239bb7f63c..fd17ed279f282 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -171,7 +171,8 @@ static int recover_dentry(struct inode *inode, struct page *ipage,
 	struct inode *dir, *einode;
 	struct fsync_inode_entry *entry;
 	int err = 0;
-	char *name;
+	const char *name;
+	int name_len;
 
 	entry = get_fsync_inode(dir_list, pino);
 	if (!entry) {
@@ -230,12 +231,16 @@ static int recover_dentry(struct inode *inode, struct page *ipage,
 out_put:
 	f2fs_put_page(page, 0);
 out:
-	if (file_enc_name(inode))
+	if (file_enc_name(inode)) {
 		name = "<encrypted>";
-	else
+		name_len = sizeof("<encrypted>") - 1;
+	} else {
 		name = raw_inode->i_name;
-	f2fs_notice(F2FS_I_SB(inode), "%s: ino = %x, name = %s, dir = %lx, err = %d",
-		    __func__, ino_of_node(ipage), name,
+		name_len = min_t(unsigned int, le32_to_cpu(raw_inode->i_namelen),
+				 F2FS_NAME_LEN);
+	}
+	f2fs_notice(F2FS_I_SB(inode), "%s: ino = %x, name = %.*s, dir = %lx, err = %d",
+		    __func__, ino_of_node(ipage), name_len, name,
 		    IS_ERR(dir) ? 0 : dir->i_ino, err);
 	return err;
 }
@@ -282,7 +287,8 @@ static void recover_inline_flags(struct inode *inode, struct f2fs_inode *ri)
 static int recover_inode(struct inode *inode, struct page *page)
 {
 	struct f2fs_inode *raw = F2FS_INODE(page);
-	char *name;
+	const char *name;
+	int name_len;
 	int err;
 
 	inode->i_mode = le16_to_cpu(raw->i_mode);
@@ -332,13 +338,18 @@ static int recover_inode(struct inode *inode, struct page *page)
 
 	f2fs_mark_inode_dirty_sync(inode, true);
 
-	if (file_enc_name(inode))
+	if (file_enc_name(inode)) {
 		name = "<encrypted>";
-	else
-		name = F2FS_INODE(page)->i_name;
+		name_len = sizeof("<encrypted>") - 1;
+	} else {
+		name = raw->i_name;
+		name_len = min_t(unsigned int, le32_to_cpu(raw->i_namelen),
+				 F2FS_NAME_LEN);
+	}
 
-	f2fs_notice(F2FS_I_SB(inode), "recover_inode: ino = %x, name = %s, inline = %x",
-		    ino_of_node(page), name, raw->i_inline);
+	f2fs_notice(F2FS_I_SB(inode), "%s: ino = %x, name = %.*s, inline = %x",
+		    __func__, ino_of_node(page), name_len, name,
+		    raw->i_inline);
 	return 0;
 }
 
-- 
2.53.0



