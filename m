Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033289;
	b=w9nKlqXtgtGQQb7Hj/pHIjN+im+bGppBwd27Fj9JdTTGN+KdgA2cultzKNXxL8LCnTtN
	 ofBMtTajAMV/eHsqLJi7I6aOFCuuM0z6ZRlxAPI9Nz41KaIeFeCYgHvH2qucJxm1hVBq4
	 n42ZtDvBp9qmnFOJg93yvlYgekWlFBdWg5FYrQbB6vxr6ev/AxS72iun/VrCytgqGeb7x
	 Jgkne/+ZGVw4OXInp5DgUjEB+agOe5A1bU+0YPfH3foqahpyJGHULvIhg6wwmPaI1fVwb
	 3J9bhkicybL1/k+btxGRHJDPu3w+UZEPnj+ALtwpu+J/G/L3yPqDZ44ME4PUGGjpeTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QdGgt1QUnvwlkTmOi4x4oQK2huy5REZT8GXzsxa8184=;
	b=xipI/ZfHxADfenXpmiIrdCpoRRzsbzB/Om80ZdaYQmVjU2g8nYdDAWwclhqu3bAmzUWO
	 FiAZ4UNDDmWnlUuJFe/V88a66d4M/ShIcd/HwyvwNyGJdk7v0K41l9zEzJCm1G3iYHu0w
	 77Bg5HESBa6/pWyk5itAhhBn51+AJnjAlhepcG7fs9lAHkClIT29kfQKzLNZnEqEtL2mh
	 bs7JDQynNhVbNALVGxwZr0tgk9f6Vc6K68fegfVhQ+UdWUc28QuORMGSUO8IWTfakoEa6
	 6l5OKWa3bfkekLwj6dO93mdf2FgwWCYNXiYoyLv1DMdQQ/S4zpurdHCXc1nUHrmmBHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJ7QvYpG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3521606A31C;
	Wed, 18 Nov 2026 20:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJ7QvYpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379671F000C4;
	Wed, 18 Nov 2026 20:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033289;
	bh=QdGgt1QUnvwlkTmOi4x4oQK2huy5REZT8GXzsxa8184=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJ7QvYpGd/X/NRIsPhV0byosg7aQidf/831b3splXyXk9Z8ulUXiTZxf+yO2Q9wC0
	 M9Y8Ke0DyNbRlS08kZGw2orMTefmk5CGPrCpr4OH4/4VCi3VgeD2oNsnwz1nZCXBrQ
	 YW8vCTE+p0I7Kw3KfEeowFViNIzICUkq+bl56fUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Jan Kara <jack@suse.cz>,
	syzbot+4e49728ec1cbaf3b91d2@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1716/1756] Fix a drop_nlink warning in minix_rmdir
Date: Wed, 18 Nov 2026 16:04:03 +0100
Message-ID: <20261118150117.916792462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit d3e0e8661ceb4fe3aab85af3730dbf41240d561f ]

Syzbot found a drop_nlink warning that is triggered by an easy to
detect nlink corruption of a directory. This patch adds a sanity check
to minix_rmdir to prevent the warning and instead return EFSCORRUPTED to
the caller.

The changes were tested using the syzbot reproducer as well as local
testing.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Link: https://patch.msgid.link/20251104143005.3283980-3-jkoolstra@xs4all.nl
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: syzbot+4e49728ec1cbaf3b91d2@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=4e49728ec1cbaf3b91d2
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: fc9577079df8 ("minix: reject rmdir of a directory with a corrupted link count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/namei.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 5d9c1406fe272..35e3e5947be7a 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -161,15 +161,24 @@ static int minix_unlink(struct inode * dir, struct dentry *dentry)
 static int minix_rmdir(struct inode * dir, struct dentry *dentry)
 {
 	struct inode * inode = d_inode(dentry);
-	int err = -ENOTEMPTY;
-
-	if (minix_empty_dir(inode)) {
-		err = minix_unlink(dir, dentry);
-		if (!err) {
-			inode_dec_link_count(dir);
-			inode_dec_link_count(inode);
-		}
+	int err = -EFSCORRUPTED;
+
+	if (dir->i_nlink <= 2) {
+		minix_error_inode(dir, "inode has corrupted nlink");
+		goto out;
+	}
+
+	err = -ENOTEMPTY;
+	if (!minix_empty_dir(inode))
+		goto out;
+
+	err = minix_unlink(dir, dentry);
+	if (!err) {
+		inode_dec_link_count(dir);
+		inode_dec_link_count(inode);
 	}
+
+out:
 	return err;
 }
 
-- 
2.53.0



