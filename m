Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665528F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4EDC433C8;
	Sun, 16 Jul 2023 20:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541061;
	bh=bb+x+YNfGLSwq3QwuoRB1NAmzyH3LLk+4qfqi+OPpjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVSRn12f7G1jaQJ6GktzsKYEzboXLKhc/LysDsvT/dXgC/+t3W8EoGFBSW3wnaI8L
	 Uv9JKD6PN5T3kqNrhMayt/g/pQJMe1wkIpD9Sln9AK83sgdnDY7oWFC83eWXg8lCDE
	 UJyzI6JZu3IvphyNZGXM3EJeVgPkqAA033/EI/uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 558/591] btrfs: add block-group tree to lockdep classes
Date: Sun, 16 Jul 2023 21:51:37 +0200
Message-ID: <20230716194938.292139506@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

commit 1a1b0e729d227f9f758f7b5f1c997e874e94156e upstream.

The block group tree was not present among the lockdep classes. We could
get potentially lockdep warnings but so far none has been seen, also
because block-group-tree is a relatively new feature.

CC: stable@vger.kernel.org # 6.1+
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/locking.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -56,8 +56,8 @@
 
 static struct btrfs_lockdep_keyset {
 	u64			id;		/* root objectid */
-	/* Longest entry: btrfs-free-space-00 */
-	char			names[BTRFS_MAX_LEVEL][20];
+	/* Longest entry: btrfs-block-group-00 */
+	char			names[BTRFS_MAX_LEVEL][24];
 	struct lock_class_key	keys[BTRFS_MAX_LEVEL];
 } btrfs_lockdep_keysets[] = {
 	{ .id = BTRFS_ROOT_TREE_OBJECTID,	DEFINE_NAME("root")	},
@@ -71,6 +71,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	DEFINE_NAME("dreloc")	},
 	{ .id = BTRFS_UUID_TREE_OBJECTID,	DEFINE_NAME("uuid")	},
 	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	DEFINE_NAME("free-space") },
+	{ .id = BTRFS_BLOCK_GROUP_TREE_OBJECTID, DEFINE_NAME("block-group") },
 	{ .id = 0,				DEFINE_NAME("tree")	},
 };
 


