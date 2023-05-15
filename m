Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D9FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9935C4339B;
	Mon, 15 May 2023 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171264;
	bh=FMYE9s9UcN/SYgWSelygdnD5Wo+vZ2xPThJ5LTHXXvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOU3VJRu7LmBweJjJjKcbvxEAcv52/dX/rCqknQp36LrWxxb8Logx2a/UxhSXgRQG
	 XCnuuhPZb8P2HqvZ5G6wr2LJ1vv++q643MTgREnC6SzwoHiY3K7mdAzEAA5twMyjID
	 FxV8cy1t43zaSF+MX5teEqeAKg7QKdQLFtNxaAvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Anastasia Belova <abelova@astralinux.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 136/242] btrfs: print-tree: parent bytenr must be aligned to sector size
Date: Mon, 15 May 2023 18:27:42 +0200
Message-Id: <20230515161725.983432685@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anastasia Belova <abelova@astralinux.ru>

commit c87f318e6f47696b4040b58f460d5c17ea0280e6 upstream.

Check nodesize to sectorsize in alignment check in print_extent_item.
The comment states that and this is correct, similar check is done
elsewhere in the functions.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: ea57788eb76d ("btrfs: require only sector size alignment for parent eb bytenr")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/print-tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -151,10 +151,10 @@ static void print_extent_item(struct ext
 			pr_cont("shared data backref parent %llu count %u\n",
 			       offset, btrfs_shared_data_ref_count(eb, sref));
 			/*
-			 * offset is supposed to be a tree block which
-			 * must be aligned to nodesize.
+			 * Offset is supposed to be a tree block which must be
+			 * aligned to sectorsize.
 			 */
-			if (!IS_ALIGNED(offset, eb->fs_info->nodesize))
+			if (!IS_ALIGNED(offset, eb->fs_info->sectorsize))
 				pr_info(
 			"\t\t\t(parent %llu not aligned to sectorsize %u)\n",
 				     offset, eb->fs_info->sectorsize);


