Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B96DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA01C433D2;
	Mon, 15 May 2023 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168586;
	bh=/UwcKq3xHbPFW3dvyImAJscEsUBc7iF3s3BiRikiwN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0HylB0OGX8fZFakKVLQDZVQnWWNZXWTXDopZK5Cn7soLWYcLkffO8L/A7YowNOjl
	 9uGFrgOkbzXVCDvjrUbTrMhmtuSwxNGgu+XQpG2Io6+Fms7yQbRDyh/6DHaFlzzNFF
	 do514JmSMcAxEZZSPhI4dRZGF5mQnXPmjFwfUX4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Anastasia Belova <abelova@astralinux.ru>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 098/116] btrfs: print-tree: parent bytenr must be aligned to sector size
Date: Mon, 15 May 2023 18:26:35 +0200
Message-Id: <20230515161701.505595210@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
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
@@ -130,10 +130,10 @@ static void print_extent_item(struct ext
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


