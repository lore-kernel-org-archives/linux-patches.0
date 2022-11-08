Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBFE15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0EBC43142;
	Tue,  8 Nov 2022 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916369;
	bh=xNwpYVzmCKJScfX6RLX2mNswnYS9xsczopbYlZyNLSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJYvfym8tjj1kcm2+TxieO5y1nl5pgTFVqqT4HAelOp4PYxnxgqqHjmxabvg7UK7Q
	 753K4KnIrF+uS7HBOL1tMyLQhnS288PC6oCv/878GrfZ2MrapiftFY1C+tvWUO0R1L
	 0NdBbvnZOjqaClk4Uc0lxMKbD2P2yE+CyvXPNfdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 104/144] btrfs: fix type of parameter generation in btrfs_get_dentry
Date: Tue,  8 Nov 2022 14:39:41 +0100
Message-Id: <20221108133349.701272213@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Sterba <dsterba@suse.com>

commit 2398091f9c2c8e0040f4f9928666787a3e8108a7 upstream.

The type of parameter generation has been u32 since the beginning,
however all callers pass a u64 generation, so unify the types to prevent
potential loss.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/export.c |    2 +-
 fs/btrfs/export.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -58,7 +58,7 @@ static int btrfs_encode_fh(struct inode
 }
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -19,7 +19,7 @@ struct btrfs_fid {
 } __attribute__ ((packed));
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation);
 struct dentry *btrfs_get_parent(struct dentry *child);
 


