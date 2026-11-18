Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051182;
	b=pT+MVHU7RkCMc2f3N7z+ghyxwH7OKmkprAonDuAfhqoU6wKW0YY2Gns0TUyzugiYy5um
	 eEfVaS7cnwssVuXXOKk4F22iVrugPmZTd4q0HvbMFBQfalTOHKbeilM8CXxeEnqdryT8t
	 euCTWY5AfBepnwgqsS3lOp8oIImDCm4veV0TNi4vrXbp21akW2ULJl9K47K6Qm1LcgR+4
	 lVCm4mG2h1oaivPYRSBP9mczSwqZ6FWOTu6V3EvNn+sUqJEFGWm/fD50cunxH3taSYB+4
	 0k0PU5ZgJBMSj373GY0+n8PjmFjqvdu5TxKdFBFy0PB9bQyyDoqwikhtMw+yDwS/m4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gkrpHZfWwyKeCGFGGPz5WKHOqvbcmoidyjl5WBK5JvI=;
	b=EhCProLb8EgAYbCiCUIDqTqvVRSypYsI7lODRzhHUziqQ10heZFkjfS4FsZGplg0y/Jm
	 Q3LQRktziZSxSu3knFJJr5MUzX0dBZ7DmRCuDoPZQG5+7vaf0S0aHf5zQPpKr7bL9wfuY
	 M7W5xP4Tp2C+PEkvr3U4un1FWqgCWjht5s+OC/L18/F3JXCFZ5joBbmnlI0BaFIrnm806
	 oCMeRkzoytqoHSUJujF3T6DzG/ad/Y4HHOW624S36g9REvrWPpRf6okmjpE4V5QSF6TMW
	 wu3POJyVTLYz1acunK48F8b0D+xMWHJNXqLShNhP4KV9uOX7amYw4KqBhfZ4FIVlFwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gd3hgVqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E09606A325;
	Thu, 19 Nov 2026 01:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gd3hgVqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2C41F000C5;
	Thu, 19 Nov 2026 01:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051182;
	bh=gkrpHZfWwyKeCGFGGPz5WKHOqvbcmoidyjl5WBK5JvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gd3hgVqryJWjH7JI8wZhB7ZNbkBjcWYqnRij+lnQWaoOG/JvefCItHV1pv3XmrQbD
	 xC9HBseFPF0BhNTrkd1iBQiT/S9TYhqCDpqiWEK9BBNZuMHoU0dPB+57QDA0zbhnKZ
	 YzDUhEVMTygANIDUz3tz8jb9oyIeAJglGENPMe7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0117/2214] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Wed, 18 Nov 2026 15:29:53 +0100
Message-ID: <20261118150014.685493180@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 2c0e4fb511f97467dafc91b6afb3414100289081 ]

An inode being evicted will never need its extra isize expanded.  Set
EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
to make this explicit and prevent any unnecessary work in
ext4_try_to_expand_extra_isize().

This also provides defense-in-depth for the s_writepages_rwsem deadlock
during mount-time orphan cleanup, ensuring the expand path is blocked
for inodes under eviction regardless of how they are reached.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260623061903.2148767-2-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7aa37fee5d889..5d2409cd4030d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -281,6 +281,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.53.0



