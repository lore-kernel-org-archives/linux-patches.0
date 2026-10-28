Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214613;
	b=LK2CEsjtARBpWhC1xblfDKnMEec1KqWvFPAx1VSIjBc4fAk3TeBDQHyPB4N/qYVqsK0r
	 tSTw3JTCTfaBhPuR4A6BjgrEXUOqJJmsJ9hrsP+Kqpe8Fi6IPW9KD0fg1vJvX42f9HEfZ
	 uqgf1fE3lI7ul2Strr14cNDdnJt35zDeyAyNnDwnUVzglng4Y8U60axQAqHNmNM9RVY6t
	 E1yPTwSgDWx2gN2rqCs2DuCbYLjs/clMYD/l/XwbgEh8N7DcXTq0DT7QvX4u9Af4GJxFm
	 Avhmv/WV6uQeze7Qpd8/OdwY4JF1mxq36nIiOx+tsMHzDLXli9X5rGu7IMqqSDb8viw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=osN7iURZgbIeEZ/+rDgRSRlWsb9Go45uDLYKep6X1QI=;
	b=MLvoZ/MNQVWfmuDcx+iSoiwtUsTbEMT/DARbOI/+Y/AeU9rpdJHWx3B3CjrOzzlKNBGV
	 1WTbKmbUMnIYWg2SvgeFkUrEFjZ96C6zK4CN1nBM2e95Iul4iSe+YEi8vYNz6ebtLMGE1
	 K2iwp721AxLvm9HMnlMyOzfcSHXuhJ4erpYmmW1Y8HeRK3tQamitMwYRPSbvpjYc2jlaF
	 DhCc/hGpZh5/e0H4Sn99WEek3FeHBTjtFj01ZVg6eHIx0p1n/etgdm5Qz9NnEy7Zr+j4F
	 Uh0grXPeIYhYBh9dzK5DfW6iWX9tqa6zCaJWtqAzy+TQPjIj6NWTN1qSElmsUi6GzxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBNOeFck;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD9E606A32E;
	Wed, 28 Oct 2026 19:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jBNOeFck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168701F01825;
	Wed, 28 Oct 2026 19:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214612;
	bh=osN7iURZgbIeEZ/+rDgRSRlWsb9Go45uDLYKep6X1QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBNOeFck2S4e1YZX+8xebaTyb7ZvM+GF9hZiA4J+Qgkcwr8OVy1i5E5swy9v4hl7B
	 mVHM0xrBC1/M8UTIU2n4eNuoxM86O12QP2v9P7K6zVl9zl2Jnm+eMiX6TzvSqfZ264
	 y2czdCbEtqBPPXyVy0K8A4Japdm/FXP3e3yV4z2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0920/1887] fs/ntfs3: handle attr_set_size() errors when truncating files
Date: Wed, 28 Oct 2026 17:50:16 +0100
Message-ID: <20261028170520.352874855@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 576248a34b927e93b2fd3fff7df735ba73ad7d01 ]

If attr_set_size() fails while truncating down, the error is silently
ignored and the inode may be left in an inconsistent state.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index b825862d74f95..81b51d5365f2c 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -390,8 +390,8 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 {
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_inode *ni = ntfs_i(inode);
-	int err, dirty = 0;
 	u64 new_valid;
+	int err;
 
 	if (!S_ISREG(inode->i_mode))
 		return 0;
@@ -407,7 +407,6 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 	}
 
 	new_valid = ntfs_up_block(sb, min_t(u64, ni->i_valid, new_size));
-
 	truncate_setsize(inode, new_size);
 
 	ni_lock(ni);
@@ -421,20 +420,19 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 		ni->i_valid = new_valid;
 
 	ni_unlock(ni);
+	if (unlikely(err))
+		return err;
 
 	ni->std_fa |= FILE_ATTRIBUTE_ARCHIVE;
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	if (!IS_DIRSYNC(inode)) {
-		dirty = 1;
+		mark_inode_dirty(inode);
 	} else {
 		err = ntfs_sync_inode(inode);
 		if (err)
 			return err;
 	}
 
-	if (dirty)
-		mark_inode_dirty(inode);
-
 	/*ntfs_flush_inodes(inode->i_sb, inode, NULL);*/
 
 	return 0;
-- 
2.53.0



