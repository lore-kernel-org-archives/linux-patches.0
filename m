Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060763;
	b=fNbGlip+/JZ0fTtYNJ4zZVuXDPjrGYTo1nCh21SeACk159WCi4nNr61h2o46xaPxcetV
	 L0uOugPmQDH2O3fssQEvtY1uD6Oo8bHsCpEpnVgHC0wtoiql3qAt4/5fCW0gKbhZN/hzJ
	 JEgMr2Er1venJDJk/ggqg7w68RfqWAr7l7gCYU1yofW2L/kIXyN9gEC+ASVX7IWQSQPJZ
	 a3U/+4GqIM1gWMXUJSX6jB9D0HAzfejTa3BtBj9fO8YBg6kmBypVjmwtS4lOJlPAq+qr5
	 XvwhExr7csnd6eXQ1+HEa3DpHGnduXduX0JFz3jfO667ss4nFAMryg/F6eg16+aIEYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QIlbtd8vSMvLdbSQ0ATFE7bkDapMlEDrlOtIvC9SWXg=;
	b=LKEXlTghbKH5DiVgx2GUdM9NtdViCWsQxhi97OuK9YycuCuwgIgzzlVv6uYjseD05R1m
	 Ejs7FInDAEMq+y9qd7o2uh2bK6f7o1bnqYhL7Zfx6oJ7yMAZHsP7HAB3ohF74p0QQrLxq
	 sjL/F7LNW1uE63ixHHFOozTgHUz7xqNq2VMXFpXq40T0Wxho+G9PN4edUqNeQHC7eJSy5
	 GEHkNKHyClP6pPidQqV2mCNlZ3sAPmgK2/YCh6zy6uC1P8UVaxi5djo3Dqn/s+X9/bGCv
	 C7id1zr7oDucGQVa2aB+V+nfplYNnpNUmyEWqTidFQ6k5BqVEHO1oB/ybxJWO7qSNaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtwDGPu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C23606A326;
	Sat,  7 Nov 2026 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtwDGPu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578551F0089F;
	Sat,  7 Nov 2026 14:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060762;
	bh=QIlbtd8vSMvLdbSQ0ATFE7bkDapMlEDrlOtIvC9SWXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtwDGPu87/Y9eOPKnQ3h8kfiwzzsNvWe0LGBS+vvISmFZhyrqCWwOP/56gQKDdsuw
	 CxyxA//7m//SuBUesN7Xmu6+zaHiOF8tmNxzPb1wL0HA3FB9hS+jBk4cvbYxexbji4
	 tz1tYATPiu6IX5Zl1lOIyB/mvYVz5x8uSGKc5zcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0175/1536] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Sat,  7 Nov 2026 08:36:31 -0500
Message-ID: <20261107135002.574808102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 822d81d51f237..1701dadf5fc65 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -256,6 +256,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.53.0



