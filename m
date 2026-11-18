Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057474;
	b=FI9Bqwj0IMPTBztHsG/EEbJmbwjG8vBVJ5Hg9DSnG3M4Mwbu1SnrlXY7QxHsYqEJdNdO
	 YMfdxLfmObsfp0V4vdDuFAI/DaKqi7QKePK6Xq6oYS3WAdWCikI3mlZJrGasziTp7lkcx
	 fDlRdTBUWOOCqWqfSBgdh6kmW6+5u9cBFiVgtxN44MrqK2ZmVo+99YUjhSrZGfpaRNdQE
	 kGPRXnfFUXrfSZYH1t8TEdTR4Yt28dZAz5oIcg4ZNQNgmliyTsphOhCxABGnbzdF6fGUw
	 ZOzMYrG7FKWYlqqxeEG7ygrWkXnEscmcLf3BJbccn1eoXu3B9MzZpZeogLSN4gC6q9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DKLg8uJcS+PByFKpXvrHmUVA2jiRLLhLI1BHwoVHQW8=;
	b=K/fLaLI/0SMqFJah7jpiah2I7HJiLSW8hSqLhLzAbPbXyrflX9EI0LmBc5L3O/egkijl
	 G3Qyc3C/QmaMRfPaIhHmscyopXgxTWt5RzwFka2TsXMBQRIhv8LEu6bcZ0qnhdgleo0Hf
	 GI5KECr7lGTmBJMnb4softiqCtiRu8Sk4kXzVTqGfCJWTlz4xrbNKuMwU7sjxwTVIWqD4
	 ehx955mJ9qrmhhSBDeW8s+hyTALWNJVyivcDiMB3WCbxqZE2KkZY0jBq9lf2r+hDpO6xn
	 tXj1vURAoAP0t7RqNt3MGYFxmkfHpdvYrOI3h0nAWfDvnjCBNCiXUexx8RF0xPXF/eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhekMO7M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CB6606A33A;
	Thu, 19 Nov 2026 03:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhekMO7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8F31F000CB;
	Thu, 19 Nov 2026 03:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057474;
	bh=DKLg8uJcS+PByFKpXvrHmUVA2jiRLLhLI1BHwoVHQW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhekMO7MTRvWm2rQZeruUvDi8qlN0xL8wOgBxEwEpxlYsT2R11YVBpyjtJtLzORaH
	 D5woZwbBt5Wx7MVSSRpjXLPwG2FDEAUb0d0coKa+b9IIWSfzi65QePme0WonTjHexX
	 2yHnUVnLm6/zmnnzic8Phw9864dCGbwtJ26lkplA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0102/1848] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Wed, 18 Nov 2026 15:35:40 +0100
Message-ID: <20261118145915.329160308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6aaa29dc8edc5..4fafcdd688330 100644
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



