Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECDE1C5793;
	Tue, 27 Aug 2024 15:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772337; cv=none; b=i75x89cdKYx5pkZL94dHj7kvPAzQMNlEkV2WH9jFy6gTOnl0HkmFGMFQcn/FL45mPA9TL9XfarwUnYrfBaPYSaMCTfi/mRCOecASxJxmenep/wAlZz4/HiSZfQxCZ+Y9PGlz5B6bNzWFdlqwnC9Mqj/P0kE3AgCsezxHtZsguus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772337; c=relaxed/simple;
	bh=8VKs0Oxc6Hs5ujcg+INT7+fLhVfnS25ltLPFAPx8j94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iamyUN2WmYBbbSdQo0ePCIrDSO0/U6J85Knfi8LmhXYZLDmJXfM0ogb3yYCCdvi9Iio2wABp4qFfoyh2N6baxdrICdpnJMcP8yuSrIpFano3ookTPBBx0fdWkLvvRt9clU+M7kHxK1L0ARDeCcWXZ4SuQL2aqmogK69tDnbmGss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9LvcuCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9LvcuCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32565C61071;
	Tue, 27 Aug 2024 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772337;
	bh=8VKs0Oxc6Hs5ujcg+INT7+fLhVfnS25ltLPFAPx8j94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9LvcuCReRd7YByisJ9bqYfD5Gu1NaPN02oKXQdKGvGpeemaTS76LRdkgHj1RVPse
	 7k8FkkWVsZyd8ZlMnTXun69RREdcPtxvnpiTh5d3CCwU4ghvC7SyPgiVbGTCh1518J
	 GdFzEy5wYvrjnY4HuYEwaJDTmioc7Y8xymKfl/uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/321] btrfs: change BUG_ON to assertion in tree_move_down()
Date: Tue, 27 Aug 2024 16:38:13 +0200
Message-ID: <20240827143845.270945411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 56f335e043ae73c32dbb70ba95488845dc0f1e6e ]

There's only one caller of tree_move_down() that does not pass level 0
so the assertion is better suited here.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index cfbd3ab679117..cc57a97860d8a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7185,8 +7185,8 @@ static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen
 	u64 reada_done = 0;
 
 	lockdep_assert_held_read(&parent->fs_info->commit_root_sem);
+	ASSERT(*level != 0);
 
-	BUG_ON(*level == 0);
 	eb = btrfs_read_node_slot(parent, slot);
 	if (IS_ERR(eb))
 		return PTR_ERR(eb);
-- 
2.43.0



