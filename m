Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829577;
	b=q1gfS3c4eTHncpRGy5eASnhQ61DvfkmV4MAxcTuHcK99F0JdJ8245ZtTXZeQwkABBhjm
	 pc7XYpcyMPft+CG8e5+RJIlzgkic/Pg+J4vPmlPVCPynaFZrLXnaJpoQ7cALuPFsUGVMy
	 7EN8vdRrZsBpdl/uZazDZEf02Wxlket3b3MJxOOyDxWdEAv9f/pARWQujTQgymuGxvgEq
	 v9WDszUWyMX9TicGRMloxpmlrWGyJAJU91dyKnKvqqsATxL3g8N0ogEJ6ekNKBzBFqFJX
	 UbtYZmLqjwbNfzNYkS7xcAL6iRfJcwPjpieXsaTxAGBp1BN4Xwo2n7Z5tUt68FtAKXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E9g5Zznw6O4zic5OUOl2MjpRLZsKARvVqtDDPhsOqNk=;
	b=p+VCVEWZ2jIUuB5tmPe6uGV7woD1Z+H+hu/twNJqxdLIn+iLK7Fbay8wVfmdonqT4yoL
	 0EVxrrKjjgDBHkGEu5/JIYKFIG7wMhhbnvCGXx6TtfNnsqYEQNqEleultLRv/yvx6U1BA
	 smRVZT371M3vo1nrT6GoRnS498b62oWwuMVuY1Wmwucb81ahs0HIiEhCYx61kMcqgjXBB
	 jlQwXLXoc5/uVFuNF5RqW/CYtkhWfotmV739KLxjhDlhJx81ETpwlhCebSkmHh/7gqMKV
	 2LEUYoicMzz1zqmynwrgdXDxYi0iuS+pvfv3/igaQQ2C23JRqTDKCDC50FvZq7mAwBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dcNAXhBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110BC606B396;
	Wed,  4 Nov 2026 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dcNAXhBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60B21F000C1;
	Wed,  4 Nov 2026 21:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829576;
	bh=E9g5Zznw6O4zic5OUOl2MjpRLZsKARvVqtDDPhsOqNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcNAXhBtEmsQmcP8VjBvLbkqk+R+7gf/DElCmeOzlyudY7Tmd6oGbnlt/9wMIZqFH
	 g6FhMX1dG1ociOBvPlNPSa/KU/cm4z7IR7vgDzsNdA634C8eDxtfajgOJ0BR6IQCeU
	 OBJE9KilH/PZfLHPtO1j3dDFu/W253aAT0pgms4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0212/1005] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Wed,  4 Nov 2026 15:59:05 -0500
Message-ID: <20261104211049.750897084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index bbc437be5e63b..9a5c08650bd1e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -261,6 +261,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.53.0



