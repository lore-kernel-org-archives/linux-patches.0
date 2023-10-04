Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A31D559
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15631C433C9;
	Wed,  4 Oct 2023 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443045;
	bh=Tbath4GWVbXx3dq7a2eUfI4u7l46ee2FWZ1x5QyvSQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqYxQyOLtPZJlv0x54GziYnP9pBxVRoot6kyvAWI0uLCI0s26AfT044Tx/1Txc1EN
	 g8Hwtt6SFYvwzpGA3hnkBRIA5Dr6kvkZClH6aJFzJDgZIMxqDd3wJrcw1mwQwzQx8E
	 /9DM+h3E4cqoCxdEE3EwxybtX0BtmgTYxwTcTW8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/259] ext4: replace the traditional ternary conditional operator with with max()/min()
Date: Wed,  4 Oct 2023 19:53:10 +0200
Message-ID: <20231004175218.224363904@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit de8bf0e5ee7482585450357c6d4eddec8efc5cb7 ]

Replace the traditional ternary conditional operator with with max()/min()

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230801143204.2284343-7-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 45e4ab320c9b ("ext4: move setting of trimmed bit into ext4_try_to_trim_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 016925b1a0908..a2c5024943d82 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6430,8 +6430,7 @@ __releases(ext4_group_lock_ptr(sb, e4b->bd_group))
 	void *bitmap;
 
 	bitmap = e4b->bd_bitmap;
-	start = (e4b->bd_info->bb_first_free > start) ?
-		e4b->bd_info->bb_first_free : start;
+	start = max(e4b->bd_info->bb_first_free, start);
 	count = 0;
 	free_count = 0;
 
@@ -6648,8 +6647,7 @@ ext4_mballoc_query_range(
 
 	ext4_lock_group(sb, group);
 
-	start = (e4b.bd_info->bb_first_free > start) ?
-		e4b.bd_info->bb_first_free : start;
+	start = max(e4b.bd_info->bb_first_free, start);
 	if (end >= EXT4_CLUSTERS_PER_GROUP(sb))
 		end = EXT4_CLUSTERS_PER_GROUP(sb) - 1;
 
-- 
2.40.1



