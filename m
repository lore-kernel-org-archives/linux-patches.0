Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049505;
	b=zv19kmwVweEHNKz/tf1XYcD3rn10Xi+kk+MosPWp6kADke7zXcR+iEd2/uDlSCFgaQSE
	 mvEBcBiFZYELPAZq4KzQuekd9KrNuNC23r4RzPWJ31PLrniAh9EomfkpM1D5yc3bZ2uZe
	 eaQL+bl+MxM2U/tAeLht+rKf5FjvO5sxX2i1z4J6v4i9/ew3muErI0FcIvmy6pDoMJT9y
	 0jXjeWvbkAQVQTmxH3lNfD2q0y3bWZadyMYyUAIWp50kv6oXDawubI0wLGXCHogFJCTq4
	 F1f9g6h+UdM2k663ArAu6guwnCmRC1jx3yBwqXnks2GE9FU4ht4NgfnIiA5qmwixJnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TSeXUgOs0k/ghxfWmnE4c1NaiHDxBhQJn7thKCJdwTU=;
	b=PNuN+CvfOrxI7XLMgSJDstUhFeHdAzzu4hpbMaocmgUx5MDBM14ap/VCHA/MJG2Oqv1+
	 KRqIb6jC3U4e7k2Ie0IKYHNKMjGGOj/lu4a9mWCoqh2Sa/QZ7Vvvwco2Ufpp3suutxsTX
	 2xg4MdxG6iv5vYGPNDnAYAx3KZFQzT8eX0XTAKcrXKTLEJkTAIH/mVxwKdm8Frq9g0Lus
	 YCfYi8pDmob3zcQPiDLJe9UDos4kLI0Bw7MFGpWQZXs1e+5si/RE/PzezpR0qA5If7uIV
	 7EUsOlDbE7zgarccLWNKEWfs9MGZ0aEEXgV5O2HB1MgaTomXX+FH4/L7fs0lpO/9IVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0o9zDkvl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43774606A320;
	Thu, 19 Nov 2026 00:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0o9zDkvl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2CD1F000C4;
	Thu, 19 Nov 2026 00:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049505;
	bh=TSeXUgOs0k/ghxfWmnE4c1NaiHDxBhQJn7thKCJdwTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0o9zDkvlhtC3i7R7hW19jN6O/TfqUfOpS7ZlNXjWozsZ+e25pqapcQ/gSqIJXgcd9
	 qxcqsJ0pVeiEe9XLlVv/i3X4/qHsXV6bLNQ45/t3kzrQfzu6/Wt+NLD6Eex760vY97
	 7n+JAYISvoHkPqM8wxmFfrDy6vI7MKRn37JnobZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2376/2857] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Wed, 18 Nov 2026 15:56:50 +0100
Message-ID: <20261118150327.075370477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 0388b5bd3a6eb8bcb20208c3b6dbee96fd30bbe0 ]

In btrfs_qgroup_trace_subtree_after_cow(), after we erase the swapped
block, iterate over all possible tree levels to check if we sill have
other swapped blocks. However the check is wrong, it considers that there
are other swapped blocks if any rbtree for any level is empty, instead of
not empty. As a consequence we set blocks->swapped to true basically every
time since we always find an empty rbtree at least at level 7, since in
practice it's nearly impossible to find such a huge btree. This makes
every future call to btrfs_qgroup_trace_subtree_after_cow() do an
unnecessary rbtree search instead of returning immediately.

Fix this by updating the condition to set swapped to true if we find an
rbtree that is not empty.

Fixes: f616f5cd9da7 ("btrfs: qgroup: Use delayed subtree rescan for balance")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h  | 2 +-
 fs/btrfs/qgroup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c1cfc03fefbe9..7f8c7b518cd46 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1306,7 +1306,7 @@ static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
  */
 struct btrfs_qgroup_swapped_blocks {
 	spinlock_t lock;
-	/* RM_EMPTY_ROOT() of above blocks[] */
+	/* True if any of the rbtrees in the blocks array below is not empty. */
 	bool swapped;
 	struct rb_root blocks[BTRFS_MAX_LEVEL];
 };
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d3cecf863d70f..8b949920b6cbd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4423,7 +4423,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 	/* Found one, remove it from @blocks first and update blocks->swapped */
 	rb_erase(&block->node, &blocks->blocks[level]);
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
-		if (RB_EMPTY_ROOT(&blocks->blocks[i])) {
+		if (!RB_EMPTY_ROOT(&blocks->blocks[i])) {
 			swapped = true;
 			break;
 		}
-- 
2.53.0



