Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028384;
	b=03q4PgCQBePp1T5e4FHjmnazBxQElbEZAUWRPZ3vYuvkvtWXMOfsSRr11iJ43Al0YTZo
	 t3UvtseP8Z6yITz3dg8onwIg9z9IFjR6w7z28mgiRSd4Aq1mEw3BG5zk7SnFpJ9fZ2OrA
	 o149FGkBfBV2ndLE6PGFKb8Z2l+5zC8SfZ0XPr6XwEr3TeeyTNDgcdnQL2pn/SMQ+YmND
	 hcaippz9iAxDJN+M4Vc5WljEENwpLfpBBS/SNnJBiSmiaMLJ9IKV+QiaCjEUnT0rO4pPx
	 IieYFqm3RonTxI7wtNZRy2l1p9xwKFNH4kXyjd6RXcsoQuXzvlDqQdjNDC2D3XEpGBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2pet0MC/ppzQAUYXrTHTB6J74YbM/OTs5Uv2uyVWv4E=;
	b=FlI5xdUggTBT5PabNaVb+b85srN2W1eMlJJFT3hzv/+i5LJbUEiT9CQ/I8Ug60ZMNqq1
	 PYp2/zeLhVj1VNXWaNMmL+YXTeZnJiYZHMsAcFDCPTHlbhKa6VIOwSK1pCpNz65e8nTZl
	 QlJBgMwVBIN9yB/pKhAfN7YQI23KXTKS9zRfLGkFjTGEBz1UwgV/BNY28CrbO1lPUNODL
	 otvybpodBkLmaapp8mKuKR1QlR9MDNUGUKhLdojXGb5TBEFJmNb7tH6wiMe5XI/IuPBlf
	 E5sHfwQgm/RT+Px65lbQiFmS9EoHANELSPis3/4ME/y8eDqA59SE4/BXjteakinXP1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUmjR3Xe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513ED606A31C;
	Wed, 18 Nov 2026 18:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUmjR3Xe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF511F000C7;
	Wed, 18 Nov 2026 18:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028384;
	bh=2pet0MC/ppzQAUYXrTHTB6J74YbM/OTs5Uv2uyVWv4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUmjR3Xe9sdQ3ArvqxgUuc6RK/d2/j5956D5M8ql4YfgptV6cOseaF+U8oE01a35p
	 QFKFR0XXIkBT1tZhQ4/caV7IrA6WHZFiF4GubL9wgaJRJYgoMRXAwxNv0p2LtiT2WE
	 B0gbACm7vkhNOmmWs7OJ4n1DdVKK1+Wnn0oE1VdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Jan Kara <jack@suse.cz>,
	syzbot+4e49728ec1cbaf3b91d2@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2125/2151] Fix a drop_nlink warning in minix_rmdir
Date: Wed, 18 Nov 2026 16:04:20 +0100
Message-ID: <20261118150239.097258462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8938536d8d3cf..68d2dd75b97fb 100644
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



