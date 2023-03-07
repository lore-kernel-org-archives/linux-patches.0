Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6F7BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D5EC433EF;
	Tue,  7 Mar 2023 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211280;
	bh=677UT4I/CLXlegLuqMbLqsmZcPjmlOw8mlXK7LME8uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNX9x/q39SMMaCeGfqqjv7RcVuTyFKydG6TRh6fb7u4+2B/02ZztjTEU9m1wX1hbM
	 vgLUo7yTkIORjalQ6WEhGbzaHnmCyTntBuaRhdKMssavqwdAVeMl+zi3UtEvf2Y4c+
	 LaT5f3QCk+eKpMrIAIkDCM8PgSwcj6SFsVjPNdCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+8ce7f8308d91e6b8bbe2@syzkaller.appspotmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Nicolas Pitre <nico@fluxnic.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 0811/1001] fs/cramfs/inode.c: initialize file_ra_state
Date: Tue,  7 Mar 2023 17:59:43 +0100
Message-Id: <20230307170056.939038073@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Morton <akpm@linux-foundation.org>

commit 3e35102666f873a135d31a726ac1ec8af4905206 upstream.

file_ra_state_init() assumes that the file_ra_state has been zeroed out.
Fixes a KMSAN used-unintialized issue (at least).

Fixes: cf948cbc35e80 ("cramfs: read_mapping_page() is synchronous")
Reported-by: syzbot <syzbot+8ce7f8308d91e6b8bbe2@syzkaller.appspotmail.com>
  Link: https://lkml.kernel.org/r/0000000000008f74e905f56df987@google.com
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cramfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -183,7 +183,7 @@ static void *cramfs_blkdev_read(struct s
 				unsigned int len)
 {
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
-	struct file_ra_state ra;
+	struct file_ra_state ra = {};
 	struct page *pages[BLKS_PER_BUF];
 	unsigned i, blocknr, buffer;
 	unsigned long devsize;


