Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059733;
	b=Z4v9HXPbV8diKnfULCUEbcZnibyCnCzFhy9kf1L96/ezGiai7QtZ3wK5/o2nL/FCdSb7
	 VAuHASDh2ZoDxcYBR+lMa2bQG0gtO217xTOs3TH3bqQzCf1Mj+fuMkY8aRC4ID7/NPeK8
	 6QPi7wcX4URvRsmK4LJljSk0wcoqS3LSaENvEpjWJCEmKuk8ktLA0+klLXVceIk4lI0zT
	 cjN9BvlocLN4UKh+TRON+MRIoQNcRgjKqSN9/Kz9BDJl0YIMRlfrc6kTlTLqIpXCUat8W
	 YMhkBUWxuELhl8qARuDRikX9I57nYF0ZyK4oNGX639ZsTnwCp9jedA1VcWm2mNv4oVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IectXQXbLZQj63eLbm9ZUSDYtjfJ4S0cB8D2EBxXr4w=;
	b=WFbDvnWbSZ3PjUjtZkfssD7lN6SSSsLTNOtU3HwYlmZGWEw/nYlVt1cU47HmTTpnFYEW
	 +ApUEkMUOCPmx2X/mPQxXajT5sAFtxBXSkT/SMwqcEVRQz0PKRps7HO4bwVFjaJz/AH8L
	 mRuxjb7hblSh9guAM4/Kl9be95oN1vasbvPJ8OwEg7aVW07EmQ4uhbhqTyO9/PshwpCrc
	 QSLrGls8yckMPqCW4PN/pvjVFrWYe+FbhvO+AU/fA8SFHGdjvoOyzzzaQerdz3kFUH5if
	 WtMUgCOv459teI+0Y899krHhraF6qNE2B9G3AJmRjtzza+mwURHZfKRhHKJFbe8Fh3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N2q2wem3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E84D606A320;
	Thu, 19 Nov 2026 03:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N2q2wem3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8060E1F000C4;
	Thu, 19 Nov 2026 03:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059733;
	bh=IectXQXbLZQj63eLbm9ZUSDYtjfJ4S0cB8D2EBxXr4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2q2wem30MwUZ9IJTsoOnYIQb82opeOygPVGMSiLaD/McCud0K+fbwem3L0JogzD8
	 Im8PHR8knTQ0wXf3vIfUWuVNqC5Xz8cPKyFY887Byk8DxBAq849zpjWeGAKbOjMfkc
	 lZhyS+dPoFFPChX+dMmkMfUjwNlauPuz2c87pSdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0948/1848] fs: dont lose inodes that another LRU walker is isolating
Date: Wed, 18 Nov 2026 15:49:46 +0100
Message-ID: <20261118145956.726673646@linuxfoundation.org>
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

From: Nikolaos Karaolidis <nick@karaolidis.com>

[ Upstream commit 8dc4116041e2b377e5e1b62ba98b37636f9f3968 ]

When inode_lru_isolate() finds an unused inode that still has page
cache, it sets I_LRU_ISOLATING, drops i_lock and the list_lru lock,
invalidates the page cache, clears the flag again and returns
LRU_RETRY so that the restarted walk can free the inode.

Another walker of the same list can reach the inode in that window.
It sees a non-zero i_state and takes the inode off the LRU, as it
would an inode that is in use. Page cache deletion requeues the inode
once the mapping is shrinkable, so this is harmless if it happens
before the last deletion. If it happens after, nothing puts the inode
back: it stays in memory, unused, clean and without page cache, out
of reach of the shrinker and of drop_caches, until it is looked up
again or the filesystem is unmounted.

Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode
lru traversing context") the pin was an i_count reference, and the
final iput() put the inode back on the LRU.

Skip inodes that are being isolated and leave them to the walker that
pinned them, which restarts its walk once it has unpinned them.

The window is reached by any unused inode with page cache on
CONFIG_HIGHMEM kernels, and otherwise by inodes whose page cache is a
single shadow entry at index 0. On an i386 HIGHMEM guest, eight
concurrent "echo 2 > /proc/sys/vm/drop_caches" over 2000 freshly read
one-page ext4 files leave roughly 400 of the inodes off the LRU per
round; on x86_64, with the files' pages first evicted through
memory.reclaim, 3 to 4 per round. With this patch, none in either case.

Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
Cc: stable@vger.kernel.org
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
Link: https://patch.msgid.link/20261009142431.713875-1-nick@karaolidis.com
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Replaced inode_state_read(inode) with direct inode->i_state access under the existing i_lock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 9f246531ae9cb..59ad098db6c9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -787,6 +787,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	if (!spin_trylock(&inode->i_lock))
 		return LRU_SKIP;
 
+	/* Another walker is dropping its page cache, leave it to that one */
+	if (inode->i_state & I_LRU_ISOLATING) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
+
 	/*
 	 * Referenced or dirty inodes are still in use. Give them another pass
 	 * through the LRU as we canot reclaim them now.
-- 
2.53.0



