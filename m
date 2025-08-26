Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7151F560B;
	Tue, 26 Aug 2025 11:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208292; cv=none; b=MISY8nlpmcUciJcJJ5/p8c1saWiLTiMtiwAgq+yOA1WT7JvQUf44NoOtfJ1mdQ5mLVqGVAZRU1Vjde7e4/PRMTmQ7aHNbyS139KgF9YmEezKLtZdl3xo1dB1AXGHU+u8M/XChbFBpHo6B2sI+MzM0pBh/G6MPZFi6H1dMfWK2iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208292; c=relaxed/simple;
	bh=i6P5IxZQFmH1nIp2KlEM3sZ33LROn4MTS7BC5bvdKAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV7qtwz38VolxNX8+DpzlzXbxosXdF6J9O0hZWcLTgpSSxP6aatt9DtEd07XkuQBhEb8P2esUZl5MyyOBjIZqhk1bWJUM/EAGfbdVirRV/13vXQdO1Ag9cYLMxyRaxE1qW6f83WqsJiZxQAhsKdKG1ECuuLOm8ZEp+i2jnpqQ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGiGFu/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGiGFu/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB32C4CEF1;
	Tue, 26 Aug 2025 11:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208292;
	bh=i6P5IxZQFmH1nIp2KlEM3sZ33LROn4MTS7BC5bvdKAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGiGFu/TdiDxJRrHZWFkORydjweghue8Soq576C41byp6WxK4KWcJVm6jIGWOmSez
	 Pp+HneAwM+WutQznyYyFspeuE2qAJ4KNouFYSbPsqFcCaGk6896QYt2eFl5ZgfT8Md
	 3GesDg0eHktWR1j1WfTzSJKR2S1gKG9OzOfa5/sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Kyoji Ogasawara <sawara04.o@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 038/322] btrfs: fix printing of mount info messages for NODATACOW/NODATASUM
Date: Tue, 26 Aug 2025 13:07:33 +0200
Message-ID: <20250826110916.305892821@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Kyoji Ogasawara <sawara04.o@gmail.com>

commit 74857fdc5dd2cdcdeb6e99bdf26976fd9299d2bb upstream.

The NODATASUM message was printed twice by mistake and the NODATACOW was
missing from the 'unset' part.  Fix the duplication and make the output
look the same.

Fixes: eddb1a433f26 ("btrfs: add reconfigure callback for fs_context")
CC: stable@vger.kernel.org # 6.8+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Kyoji Ogasawara <sawara04.o@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1438,7 +1438,7 @@ static void btrfs_emit_options(struct bt
 {
 	btrfs_info_if_set(info, old, NODATASUM, "setting nodatasum");
 	btrfs_info_if_set(info, old, DEGRADED, "allowing degraded mounts");
-	btrfs_info_if_set(info, old, NODATASUM, "setting nodatasum");
+	btrfs_info_if_set(info, old, NODATACOW, "setting nodatacow");
 	btrfs_info_if_set(info, old, SSD, "enabling ssd optimizations");
 	btrfs_info_if_set(info, old, SSD_SPREAD, "using spread ssd allocation scheme");
 	btrfs_info_if_set(info, old, NOBARRIER, "turning off barriers");
@@ -1460,6 +1460,7 @@ static void btrfs_emit_options(struct bt
 	btrfs_info_if_set(info, old, IGNOREMETACSUMS, "ignoring meta csums");
 	btrfs_info_if_set(info, old, IGNORESUPERFLAGS, "ignoring unknown super block flags");
 
+	btrfs_info_if_unset(info, old, NODATASUM, "setting datasum");
 	btrfs_info_if_unset(info, old, NODATACOW, "setting datacow");
 	btrfs_info_if_unset(info, old, SSD, "not using ssd optimizations");
 	btrfs_info_if_unset(info, old, SSD_SPREAD, "not using spread ssd allocation scheme");


