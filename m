Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B2A2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47B3C433C9;
	Wed, 20 Sep 2023 12:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211885;
	bh=D3Ri4FkgkVHDJF604NvIhvh5JWu9A5s8bkNKMxiGBgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XP8iQXmFjI41Uo2BZoSbSsO2EaZKnjrSnJcaYC+6/+E+XU5vROBnTTyIROaN9UtN5
	 r7BFaYAC6Tmpig2nFjOutZaS+kMP/duNk6bmhvUmaBOxKX8QK6EA9fUAB1aYN9V/9s
	 uk/10FKVFCoPP/zdmzr3mG8mCG6EsE7sZIHkvAOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengguang Xu <cgxu519@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/273] quota: add dqi_dirty_list description to comment of Dquot List Management
Date: Wed, 20 Sep 2023 13:28:32 +0200
Message-ID: <20230920112848.686946149@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengguang Xu <cgxu519@gmail.com>

[ Upstream commit f44840ad1f822d9ecee6a3f91f2d17825a361307 ]

Actually there are four lists for dquot management, so add
the description of dqui_dirty_list to comment.

Signed-off-by: Chengguang Xu <cgxu519@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: dabc8b207566 ("quota: fix dqput() to follow the guarantees dquot_srcu should provide")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index d901119e25b51..01bec330d54b1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -223,9 +223,9 @@ static void put_quota_format(struct quota_format_type *fmt)
 
 /*
  * Dquot List Management:
- * The quota code uses three lists for dquot management: the inuse_list,
- * free_dquots, and dquot_hash[] array. A single dquot structure may be
- * on all three lists, depending on its current state.
+ * The quota code uses four lists for dquot management: the inuse_list,
+ * free_dquots, dqi_dirty_list, and dquot_hash[] array. A single dquot
+ * structure may be on some of those lists, depending on its current state.
  *
  * All dquots are placed to the end of inuse_list when first created, and this
  * list is used for invalidate operation, which must look at every dquot.
@@ -236,6 +236,11 @@ static void put_quota_format(struct quota_format_type *fmt)
  * dqstats.free_dquots gives the number of dquots on the list. When
  * dquot is invalidated it's completely released from memory.
  *
+ * Dirty dquots are added to the dqi_dirty_list of quota_info when mark
+ * dirtied, and this list is searched when writing dirty dquots back to
+ * quota file. Note that some filesystems do dirty dquot tracking on their
+ * own (e.g. in a journal) and thus don't use dqi_dirty_list.
+ *
  * Dquots with a specific identity (device, type and id) are placed on
  * one of the dquot_hash[] hash chains. The provides an efficient search
  * mechanism to locate a specific dquot.
-- 
2.40.1



