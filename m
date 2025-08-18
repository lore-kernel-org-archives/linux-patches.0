Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05A7320CA0;
	Mon, 18 Aug 2025 13:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524381; cv=none; b=In3ny47UbZeIPAKfr0liKp7fFvRH2mcnPrwEX9bRMqyBuYFvh9reb21HrECvfmInI8R18EbXq/Jnxuvth1BxlwiVbsSbQCYA/HPT9J9fJvbjKjFlQzkG35jQ8lsTzkA3g0Hu27Fmzv4AdVL5c2FUzQ+RgDQSzvIzY8LahQhBO5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524381; c=relaxed/simple;
	bh=Vt62sD6yXxfkv8kfnW+SgvfEDRWYE092D9JAIH4+lOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ze1LU1DKdkqEJFx/1CIJFjSLtnrPqQK69eFpmj2w1AqHKNxMrHsN9Mz7dGuM3ZHbDKJ93qXvHdp0Cpi2Qw29EMCI9ZO1N9KftUTKrKi+ethzUQx//pxDfARnKjbHt2P9fUL1AdXhnSen22IlVq9vhKweIUmnddXI9MxJsRsZulg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ/5VJ+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ/5VJ+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FA1C4CEEB;
	Mon, 18 Aug 2025 13:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524380;
	bh=Vt62sD6yXxfkv8kfnW+SgvfEDRWYE092D9JAIH4+lOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ/5VJ+fC6xGtS5wyNL9UIqjz47C+hKRZThCAvKC6tYOpEM9IrZkHmRyZBgudaBuG
	 ++8f1jyNJQT/K6mpZvcQblVRShnH4IyVqet34Xa8DbOFqlY77ksAoBOzwziicRJ/hm
	 7vd7d3T2iZ+DxVOSnOnTU+RHaVGrH+3KTaeMe13U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.15 454/515] ext4: initialize superblock fields in the kballoc-test.c kunit tests
Date: Mon, 18 Aug 2025 14:47:20 +0200
Message-ID: <20250818124515.897538978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -802,6 +803,10 @@ static void test_mb_mark_used(struct kun
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	grp->bb_free = EXT4_CLUSTERS_PER_GROUP(sb);
+	grp->bb_largest_free_order = -1;
+	grp->bb_avg_fragment_size_order = -1;
+	INIT_LIST_HEAD(&grp->bb_largest_free_order_node);
+	INIT_LIST_HEAD(&grp->bb_avg_fragment_size_node);
 	mbt_generate_test_ranges(sb, ranges, TEST_RANGE_COUNT);
 	for (i = 0; i < TEST_RANGE_COUNT; i++)
 		test_mb_mark_used_range(test, &e4b, ranges[i].start,
@@ -875,6 +880,10 @@ static void test_mb_free_blocks(struct k
 	ext4_unlock_group(sb, TEST_GOAL_GROUP);
 
 	grp->bb_free = 0;
+	grp->bb_largest_free_order = -1;
+	grp->bb_avg_fragment_size_order = -1;
+	INIT_LIST_HEAD(&grp->bb_largest_free_order_node);
+	INIT_LIST_HEAD(&grp->bb_avg_fragment_size_node);
 	memset(bitmap, 0xff, sb->s_blocksize);
 
 	mbt_generate_test_ranges(sb, ranges, TEST_RANGE_COUNT);


