Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC831F75B9;
	Tue,  3 Dec 2024 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241726; cv=none; b=DQvlpEzgkF7wiGMGxgWLJFcQeJCVjYt14Iyqj3LeMIDYrs7hX+70qE+4LkmexygDaDTq4WFJcATAwPCNt8fSQVNnJpS4EjTTlTapHp5rlM6hVtLP4RkVHUOS0w2hp7H326cKhMJ++L9ZJGslSgcvDKNwDBcZ8XEFKYYcstRuylY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241726; c=relaxed/simple;
	bh=yGdJLdG32CmLEvV7AhUpkp7NBCaeHesBUG6pmvaaI1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HstKQ+LzEeoYu7xshM4nggv9UZv547qVrAVZBn2c+ja/GhSJePBSmD3N2vmUgwI5teCEIFLB1FMVZhbcMs+LAQIl214N4pFCBS2DsZn9aemJwANDD3HRiAEyZAGh5SFZktOPuCGcL4s1E8aevnY1lYxp189s7N7xzfmWDkXBA88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVlrr/zV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVlrr/zV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98375C4CECF;
	Tue,  3 Dec 2024 16:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241726;
	bh=yGdJLdG32CmLEvV7AhUpkp7NBCaeHesBUG6pmvaaI1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVlrr/zVuSrTgAwekwdrxOlJgm1311Ivo8zRWPpycLdXb1cLYP80Hynvaynnq92LA
	 N5ULwrS6vXEadXWNRcFBc8L0MMM69VXoo8gZAZJb/OgHYN6zkPbR7pa82NeVsj4ne6
	 8BseRsSuQFbAMjyrzkmpWBpNqTlenAo8peQ52xPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 499/826] f2fs: Fix not used variable index
Date: Tue,  3 Dec 2024 15:43:46 +0100
Message-ID: <20241203144803.219241685@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 0c3a38a4b442893f8baca72e44a2a27d52d6cc75 ]

Fix the following compilation warning:
fs/f2fs/data.c:2391:10: warning: variable ‘index’ set but not used
[-Wunused-but-set-variable]
 2391 |  pgoff_t index;

Only define and set the variable index when the CONFIG_F2FS_FS_COMPRESSION
is enabled.

Fixes: db92e6c729d8 ("f2fs: convert f2fs_mpage_readpages() to use folio")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 94f7b084f6016..9202082a3902c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2385,10 +2385,10 @@ static int f2fs_mpage_readpages(struct inode *inode,
 		.nr_cpages = 0,
 	};
 	pgoff_t nc_cluster_idx = NULL_CLUSTER;
+	pgoff_t index;
 #endif
 	unsigned nr_pages = rac ? readahead_count(rac) : 1;
 	unsigned max_nr_pages = nr_pages;
-	pgoff_t index;
 	int ret = 0;
 
 	map.m_pblk = 0;
@@ -2406,9 +2406,9 @@ static int f2fs_mpage_readpages(struct inode *inode,
 			prefetchw(&folio->flags);
 		}
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
 		index = folio_index(folio);
 
-#ifdef CONFIG_F2FS_FS_COMPRESSION
 		if (!f2fs_compressed_file(inode))
 			goto read_single_page;
 
-- 
2.43.0



