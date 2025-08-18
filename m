Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4072E22A6;
	Mon, 18 Aug 2025 13:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522668; cv=none; b=EJgUU86NhF8dKx5PH2bhYpvj1WzlCUfYEs2nffyhxpCdJaC3AmW4TZG/7rmOZo1G8VFsPRRNvXPN0wBKeDeEwdZL7O9yYSfdY4BPL9igTz6J3bT9KSDPTU0PXbzww0hECDFjBTnwSayBhjNQn9wGb3s0VZuev0P0XuIGoe5oNLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522668; c=relaxed/simple;
	bh=izU4lxhtx1gkBtQ/q2i50X0Ox3uRijOgxZo9b9wCq0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOiOXkE/p9jTIH/6vtKKjMjRQyfptm07OztMzMOJtj1/1PsHhd9kJgt20P1WHhi35QxWOsIccULBE0insWi3hJsoBMOvwrs1lnf9OSnVVntsOtp4TXj/OthkVatW1ZPwWkAmvL0Ly/iH2qLxI+1cPa8/saxfjyXQ278qGHRCtgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFFkEB1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFFkEB1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884EBC4CEEB;
	Mon, 18 Aug 2025 13:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522668;
	bh=izU4lxhtx1gkBtQ/q2i50X0Ox3uRijOgxZo9b9wCq0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFFkEB1BUAZD+3MWk27BPU/1MwUacon0faysSj52IhlktPtk0CkeyRZNQnUMGjh32
	 F/asnjNL92gLM8jExo154+6Em0XyGLmB25Q1ISTVAcd/5a2vN2bwQ1U8BBjYzxhU83
	 oO9kA/BN0Ke5RoxV9dsLcRf3tchNq6FKURP7WdmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 384/444] ext4: initialize superblock fields in the kballoc-test.c kunit tests
Date: Mon, 18 Aug 2025 14:46:50 +0200
Message-ID: <20250818124503.297841426@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 82e6381e23f1ea7a14f418215068aaa2ca046c84 upstream.

Various changes in the "ext4: better scalability for ext4 block
allocation" patch series have resulted in kunit test failures, most
notably in the test_new_blocks_simple and the test_mb_mark_used tests.
The root cause of these failures is that various in-memory ext4 data
structures were not getting initialized, and while previous versions
of the functions exercised by the unit tests didn't use these
structure members, this was arguably a test bug.

Since one of the patches in the block allocation scalability patches
is a fix which is has a cc:stable tag, this commit also has a
cc:stable tag.

CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250714130327.1830534-1-libaokun1@huawei.com
Link: https://patch.msgid.link/20250725021550.3177573-1-yi.zhang@huaweicloud.com
Link: https://patch.msgid.link/20250725021654.3188798-1-yi.zhang@huaweicloud.com
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/linux-ext4/b0635ad0-7ebf-4152-a69b-58e7e87d5085@roeck-us.net/
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc-test.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -155,6 +155,7 @@ static struct super_block *mbt_ext4_allo
 	bgl_lock_init(sbi->s_blockgroup_lock);
 
 	sbi->s_es = &fsb->es;
+	sbi->s_sb = sb;
 	sb->s_fs_info = sbi;
 
 	up_write(&sb->s_umount);
@@ -801,6 +802,10 @@ static void test_mb_mark_used(struct kun
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	grp->bb_free = EXT4_CLUSTERS_PER_GROUP(sb);
+	grp->bb_largest_free_order = -1;
+	grp->bb_avg_fragment_size_order = -1;
+	INIT_LIST_HEAD(&grp->bb_largest_free_order_node);
+	INIT_LIST_HEAD(&grp->bb_avg_fragment_size_node);
 	mbt_generate_test_ranges(sb, ranges, TEST_RANGE_COUNT);
 	for (i = 0; i < TEST_RANGE_COUNT; i++)
 		test_mb_mark_used_range(test, &e4b, ranges[i].start,
@@ -873,6 +878,10 @@ static void test_mb_free_blocks(struct k
 	ext4_unlock_group(sb, TEST_GOAL_GROUP);
 
 	grp->bb_free = 0;
+	grp->bb_largest_free_order = -1;
+	grp->bb_avg_fragment_size_order = -1;
+	INIT_LIST_HEAD(&grp->bb_largest_free_order_node);
+	INIT_LIST_HEAD(&grp->bb_avg_fragment_size_node);
 	memset(bitmap, 0xff, sb->s_blocksize);
 
 	mbt_generate_test_ranges(sb, ranges, TEST_RANGE_COUNT);


