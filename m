Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031464;
	b=L4Na4xn9HHaaWqercfGrHnG6yfiHdO46T1feZBILcJS56UgJQQE6Vp6/NetBxRhK5mhX
	 wosyDp+/nuCIMypguEbQmWf5qi4fsn0TUMVm5vmTIBopB6s+Axzpm+XKW06KL6Ouqtvys
	 92lrDMqM+CC20/TlHIKt+5NEwbxbEgttpyKKR5WqTMJC7615Qpz5l8MiHOZTx4wCYFZ7Z
	 aHFN+uvR0AjanLO3BlPtGNKGmFTfNUyAs7a412Idc1oTD5TAN51DFybJCjQ4+YrUqxZ5Q
	 s/6TCj0C/Q1LDh4HdYsU0bmDEhvJu8JWEtNNNFRwcEu8ZVjcF6SbR0nz70sJL/E0KtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AHISauvA6GxPagU55QM7fqKOVpVyD4g3h39qsdPUSbI=;
	b=kY0Q5TyUo3qbU/X+904OIQnJpZ+BmK4G41r+agXM10m/b+Yl5opYzJYpENUyPzY8+2K1
	 iTb+T9ZYrQ82KTwfkaUyZgeCyPaZG01tkWL58cjHAH3V3Pv5/LZvs7aNYLp7ZsVUzQYyq
	 78Igy8qZmMSO3i6y/ERZS5klRGBBDx983H0jo4eANugGGwUCfdZtTAfu/sVVp4OfX0Hkr
	 f/h+gOI62Q2tnjQb32Km7tOnnhWgdHQ0aUuDcFmJUckutWij7VglG8QSb/sQNlqoY+VaO
	 QpH6oQI34gUwWOXGou5j816WmVoV0e8q10Dw4AyhH+XIRSXqI6ozaS412/R7/sRnKbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KVVADVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D320606A32C;
	Wed, 18 Nov 2026 19:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KVVADVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB571F000C4;
	Wed, 18 Nov 2026 19:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031464;
	bh=AHISauvA6GxPagU55QM7fqKOVpVyD4g3h39qsdPUSbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KVVADVTgkC44S9MG23UZgpav1xYUcz+/VxArC0O2MOOwBi8WcBZV5rLVrpzz2DHL
	 Mlq6cJKNWZy6p0dF51n/kb3y+7DKlNBqNOWWa7onB3k9hcOwzfCma9AckEIMk5G3EX
	 ldfRBEZ7j95WfEmm7K7fRZrlREMwqqpOqzqnS79w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1069/1756] btrfs: dont use token set/get accessors for btrfs_item members
Date: Wed, 18 Nov 2026 15:53:16 +0100
Message-ID: <20261118150052.809590715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 114b806a733ffbd3906fca3493d47529dbc8210b ]

The token versions of set/get accessors will be removed, use the normal
helpers. The btrfs_item members use that interface the most but there
are no real benefits anymore.

This reduces stack consumption on x86_64 release config:

setup_items_for_insert                           -32 (144 -> 112)
__push_leaf_left                                 -32 (176 -> 144)
btrfs_extend_item                                -16 (104 -> 88)
copy_for_split                                   -32 (144 -> 112)
btrfs_del_items                                  -16 (144 -> 128)
btrfs_truncate_item                              -24 (152 -> 128)
__push_leaf_right                                -24 (168 -> 144)

and module size:

   text    data     bss     dec     hex filename
1463615  115665   16088 1595368  1857e8 pre/btrfs.ko
1463413  115665   16088 1595166  18571e post/btrfs.ko

DELTA: -202

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 08f750d9f893 ("btrfs: fix off-by-one end offset check in report_setget_bounds()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 51 +++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 362df6e96717c..1abd3f7c3f064 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3137,7 +3137,6 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = right->fs_info;
 	struct extent_buffer *left = path->nodes[0];
 	struct extent_buffer *upper = path->nodes[1];
-	struct btrfs_map_token token;
 	struct btrfs_disk_key disk_key;
 	int slot;
 	u32 i;
@@ -3211,13 +3210,12 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	copy_leaf_items(right, left, 0, left_nritems - push_items, push_items);
 
 	/* update the item pointers */
-	btrfs_init_map_token(&token, right);
 	right_nritems += push_items;
 	btrfs_set_header_nritems(right, right_nritems);
 	push_space = BTRFS_LEAF_DATA_SIZE(fs_info);
 	for (i = 0; i < right_nritems; i++) {
-		push_space -= btrfs_token_item_size(&token, i);
-		btrfs_set_token_item_offset(&token, i, push_space);
+		push_space -= btrfs_item_size(right, i);
+		btrfs_set_item_offset(right, i, push_space);
 	}
 
 	left_nritems -= push_items;
@@ -3360,7 +3358,6 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	u32 this_item_size;
 	u32 old_left_item_size;
-	struct btrfs_map_token token;
 
 	if (empty)
 		nr = min(right_nritems, max_slot);
@@ -3408,13 +3405,12 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	old_left_nritems = btrfs_header_nritems(left);
 	BUG_ON(old_left_nritems <= 0);
 
-	btrfs_init_map_token(&token, left);
 	old_left_item_size = btrfs_item_offset(left, old_left_nritems - 1);
 	for (i = old_left_nritems; i < old_left_nritems + push_items; i++) {
 		u32 ioff;
 
-		ioff = btrfs_token_item_offset(&token, i);
-		btrfs_set_token_item_offset(&token, i,
+		ioff = btrfs_item_offset(left, i);
+		btrfs_set_item_offset(left, i,
 		      ioff - (BTRFS_LEAF_DATA_SIZE(fs_info) - old_left_item_size));
 	}
 	btrfs_set_header_nritems(left, old_left_nritems + push_items);
@@ -3435,13 +3431,12 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 				   btrfs_header_nritems(right) - push_items);
 	}
 
-	btrfs_init_map_token(&token, right);
 	right_nritems -= push_items;
 	btrfs_set_header_nritems(right, right_nritems);
 	push_space = BTRFS_LEAF_DATA_SIZE(fs_info);
 	for (i = 0; i < right_nritems; i++) {
-		push_space = push_space - btrfs_token_item_size(&token, i);
-		btrfs_set_token_item_offset(&token, i, push_space);
+		push_space = push_space - btrfs_item_size(right, i);
+		btrfs_set_item_offset(right, i, push_space);
 	}
 
 	btrfs_mark_buffer_dirty(trans, left);
@@ -3555,7 +3550,6 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 	int i;
 	int ret;
 	struct btrfs_disk_key disk_key;
-	struct btrfs_map_token token;
 
 	nritems = nritems - mid;
 	btrfs_set_header_nritems(right, nritems);
@@ -3568,12 +3562,11 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 
 	rt_data_off = BTRFS_LEAF_DATA_SIZE(fs_info) - btrfs_item_data_end(l, mid);
 
-	btrfs_init_map_token(&token, right);
 	for (i = 0; i < nritems; i++) {
 		u32 ioff;
 
-		ioff = btrfs_token_item_offset(&token, i);
-		btrfs_set_token_item_offset(&token, i, ioff + rt_data_off);
+		ioff = btrfs_item_offset(right, i);
+		btrfs_set_item_offset(right, i, ioff + rt_data_off);
 	}
 
 	btrfs_set_header_nritems(l, mid);
@@ -4038,7 +4031,6 @@ void btrfs_truncate_item(struct btrfs_trans_handle *trans,
 	unsigned int old_size;
 	unsigned int size_diff;
 	int i;
-	struct btrfs_map_token token;
 
 	leaf = path->nodes[0];
 	slot = path->slots[0];
@@ -4061,12 +4053,11 @@ void btrfs_truncate_item(struct btrfs_trans_handle *trans,
 	 * item0..itemN ... dataN.offset..dataN.size .. data0.size
 	 */
 	/* first correct the data pointers */
-	btrfs_init_map_token(&token, leaf);
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
 
-		ioff = btrfs_token_item_offset(&token, i);
-		btrfs_set_token_item_offset(&token, i, ioff + size_diff);
+		ioff = btrfs_item_offset(leaf, i);
+		btrfs_set_item_offset(leaf, i, ioff + size_diff);
 	}
 
 	/* shift the data */
@@ -4129,7 +4120,6 @@ void btrfs_extend_item(struct btrfs_trans_handle *trans,
 	unsigned int old_data;
 	unsigned int old_size;
 	int i;
-	struct btrfs_map_token token;
 
 	leaf = path->nodes[0];
 
@@ -4155,12 +4145,11 @@ void btrfs_extend_item(struct btrfs_trans_handle *trans,
 	 * item0..itemN ... dataN.offset..dataN.size .. data0.size
 	 */
 	/* first correct the data pointers */
-	btrfs_init_map_token(&token, leaf);
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
 
-		ioff = btrfs_token_item_offset(&token, i);
-		btrfs_set_token_item_offset(&token, i, ioff - data_size);
+		ioff = btrfs_item_offset(leaf, i);
+		btrfs_set_item_offset(leaf, i, ioff - data_size);
 	}
 
 	/* shift the data */
@@ -4200,7 +4189,6 @@ static void setup_items_for_insert(struct btrfs_trans_handle *trans,
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *leaf;
 	int slot;
-	struct btrfs_map_token token;
 	u32 total_size;
 
 	/*
@@ -4228,7 +4216,6 @@ static void setup_items_for_insert(struct btrfs_trans_handle *trans,
 		BUG();
 	}
 
-	btrfs_init_map_token(&token, leaf);
 	if (slot != nritems) {
 		unsigned int old_data = btrfs_item_data_end(leaf, slot);
 
@@ -4246,8 +4233,8 @@ static void setup_items_for_insert(struct btrfs_trans_handle *trans,
 		for (i = slot; i < nritems; i++) {
 			u32 ioff;
 
-			ioff = btrfs_token_item_offset(&token, i);
-			btrfs_set_token_item_offset(&token, i,
+			ioff = btrfs_item_offset(leaf, i);
+			btrfs_set_item_offset(leaf, i,
 						       ioff - batch->total_data_size);
 		}
 		/* shift the items */
@@ -4264,8 +4251,8 @@ static void setup_items_for_insert(struct btrfs_trans_handle *trans,
 		btrfs_cpu_key_to_disk(&disk_key, &batch->keys[i]);
 		btrfs_set_item_key(leaf, &disk_key, slot + i);
 		data_end -= batch->data_sizes[i];
-		btrfs_set_token_item_offset(&token, slot + i, data_end);
-		btrfs_set_token_item_size(&token, slot + i, batch->data_sizes[i]);
+		btrfs_set_item_offset(leaf, slot + i, data_end);
+		btrfs_set_item_size(leaf, slot + i, batch->data_sizes[i]);
 	}
 
 	btrfs_set_header_nritems(leaf, nritems + batch->nr);
@@ -4506,7 +4493,6 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (slot + nr != nritems) {
 		const u32 last_off = btrfs_item_offset(leaf, slot + nr - 1);
 		const int data_end = leaf_data_end(leaf);
-		struct btrfs_map_token token;
 		u32 dsize = 0;
 		int i;
 
@@ -4516,12 +4502,11 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		memmove_leaf_data(leaf, data_end + dsize, data_end,
 				  last_off - data_end);
 
-		btrfs_init_map_token(&token, leaf);
 		for (i = slot + nr; i < nritems; i++) {
 			u32 ioff;
 
-			ioff = btrfs_token_item_offset(&token, i);
-			btrfs_set_token_item_offset(&token, i, ioff + dsize);
+			ioff = btrfs_item_offset(leaf, i);
+			btrfs_set_item_offset(leaf, i, ioff + dsize);
 		}
 
 		memmove_leaf_items(leaf, slot, slot + nr, nritems - slot - nr);
-- 
2.53.0



