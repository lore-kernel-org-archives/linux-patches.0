Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031470;
	b=hkJw8vgmXWfg85wiwbT0G5i+tag04zdhbJtR1YkMwblgySxowPiWXy4M0Ef68pdTyHXm
	 ChXazum8HpSGUQfI5Dp8wPdCRP5BguujyvToDS0Mf7cqxqOgPzGxCcyrJySmVda4zV1Qk
	 nFoGQh6mxT3bk1cSD7NsTO0aC13EzZdCxeHncBd9yWHFibEPRf1O9ylI13C9SyiRe5sKt
	 hRFM6uGb8GvbRW9P8tbDOH6VKhFjA75QVOM3guAy1oHHhyF/win2Xskz/6Soa1vr9uSl/
	 nV90BdpnuPxqtobfdplluAerUKApcVDFYmBn5VeyXjZgqLYsh1Jjmyf7ZwsYO0XGVfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DVePeToj6tzTHMYnlO+ZFQfHHHya90KLe/OuWXuHMzU=;
	b=bc9wFkya9WR5009U0+SsESkocw1EFXgrmW7gFKrGwxV78wlhHaFX4v0OM0Q7tIlwKzJj
	 yDH2k5usAR/XCPFvMSG/j0xHWKYIb4PzTq1DQhi6Img525DTN8ep0onZaip3TXe4W1URC
	 q/vGI4yhQ7d0//ZYdky3PdZJ1qmn0lrLUj9foEaMpiH4MYvujGz2lIKhXoZ7OP1lLEN/0
	 i8tbiMYGeNUgiSbCDM/5Az08p+tpE0q1LJXnqu7Lkl7SOFlwb4FJr+seccOEAnCnzkUcc
	 b4LSJIs/wJdKzmqwHMbZyxxZF+0527UzXh5hJ4X7q4pfQqRMzj7qO2+nYBPj6Cmw0BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VE54bxn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17D5606A320;
	Wed, 18 Nov 2026 19:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VE54bxn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D401F000C4;
	Wed, 18 Nov 2026 19:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031469;
	bh=DVePeToj6tzTHMYnlO+ZFQfHHHya90KLe/OuWXuHMzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VE54bxn9heu80zNkwpPN6fsrY6u/q8UW9Z4xAnzlBS+r4hHoijC49h/7zzFue7Kok
	 fUCyrv3dKJEAOSE244vQiI2COFtMhVIoxE7DeUjwBTgtp1C5xiby37taJ6I0+ffZZG
	 m5N+rGVNKyIGP4Fl0wb5mrYBbKFm0Z1oAls2anUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1071/1756] btrfs: accessors: delete token versions of set/get helpers
Date: Wed, 18 Nov 2026 15:53:18 +0100
Message-ID: <20261118150052.880096442@linuxfoundation.org>
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

[ Upstream commit b37eb352c4c6ecd8e6aa62d08dbf3f5d3ce8afd7 ]

Once upon a time there was a need to cache address of extent buffer
pages, as it was a costly operation (map_private_extent_buffer(),
cfed81a04eb555 ("Btrfs: add the ability to cache a pointer into the
eb")).  This was not even due to use of HIGHMEM, this had been removed
before that due to possible locking issues (a65917156e3459 ("Btrfs:
stop using highmem for extent_buffers")).

Over time the amount of work in the set/get helpers got reduced and
became quite straightforward bounds checking with an unaligned
read/write, commit db3756c879773c ("btrfs: remove unused
map_private_extent_buffer").

The actual caching of the page_address()/folio_address() in the token
was more work for very little gain. This depended on subsequent access
into the same page/folio, otherwise the cached pointer had to be
updated.

For metadata-heavy operations this showed up in the 'perf top' profile
where the btrfs_get_token_32() calls were at the top, on my testing
machine consuming about 2-3%. The other generic 32/64 bit helpers also
appeared in the profile with similar fraction.

After removing use of the token helpers we can remove them completely,
this leads to reduction of btrfs.ko by 6.7KiB on release config.

   text    data     bss     dec     hex filename
1463289  115665   16088 1595042  1856a2 pre/btrfs.ko
1456601  115665   16088 1588354  183c82 post/btrfs.ko

DELTA: -6688

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 08f750d9f893 ("btrfs: fix off-by-one end offset check in report_setget_bounds()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/accessors.c | 78 --------------------------------------------
 fs/btrfs/accessors.h | 37 ---------------------
 2 files changed, 115 deletions(-)

diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
index e3716516ca387..5cfb0801700e6 100644
--- a/fs/btrfs/accessors.c
+++ b/fs/btrfs/accessors.c
@@ -25,13 +25,6 @@ static bool check_setget_bounds(const struct extent_buffer *eb,
 	return true;
 }
 
-void btrfs_init_map_token(struct btrfs_map_token *token, struct extent_buffer *eb)
-{
-	token->eb = eb;
-	token->kaddr = folio_address(eb->folios[0]);
-	token->offset = 0;
-}
-
 /*
  * Macro templates that define helpers to read/write extent buffer data of a
  * given size, that are also used via ctree.h for access to item members by
@@ -41,11 +34,6 @@ void btrfs_init_map_token(struct btrfs_map_token *token, struct extent_buffer *e
  * - btrfs_set_8 (for 8/16/32/64)
  * - btrfs_get_8 (for 8/16/32/64)
  *
- * Generic helpers with a token (cached address of the most recently accessed
- * page):
- * - btrfs_set_token_8 (for 8/16/32/64)
- * - btrfs_get_token_8 (for 8/16/32/64)
- *
  * The set/get functions handle data spanning two pages transparently, in case
  * metadata block size is larger than page.  Every pointer to metadata items is
  * an offset into the extent buffer page array, cast to a specific type.  This
@@ -57,37 +45,6 @@ void btrfs_init_map_token(struct btrfs_map_token *token, struct extent_buffer *e
  */
 
 #define DEFINE_BTRFS_SETGET_BITS(bits)					\
-u##bits btrfs_get_token_##bits(struct btrfs_map_token *token,		\
-			       const void *ptr, unsigned long off)	\
-{									\
-	const unsigned long member_offset = (unsigned long)ptr + off;	\
-	const unsigned long idx = get_eb_folio_index(token->eb, member_offset); \
-	const unsigned long oil = get_eb_offset_in_folio(token->eb,	\
-							 member_offset);\
-	const int unit_size = token->eb->folio_size;			\
-	const int unit_shift = token->eb->folio_shift;			\
-	const int size = sizeof(u##bits);				\
-	u8 lebytes[sizeof(u##bits)];					\
-	const int part = unit_size - oil;				\
-									\
-	ASSERT(token);							\
-	ASSERT(token->kaddr);						\
-	ASSERT(check_setget_bounds(token->eb, ptr, off, size));		\
-	if (token->offset <= member_offset &&				\
-	    member_offset + size <= token->offset + unit_size) {	\
-		return get_unaligned_le##bits(token->kaddr + oil);	\
-	}								\
-	token->kaddr = folio_address(token->eb->folios[idx]);		\
-	token->offset = idx << unit_shift;				\
-	if (INLINE_EXTENT_BUFFER_PAGES == 1 || oil + size <= unit_size) \
-		return get_unaligned_le##bits(token->kaddr + oil);	\
-									\
-	memcpy(lebytes, token->kaddr + oil, part);			\
-	token->kaddr = folio_address(token->eb->folios[idx + 1]);	\
-	token->offset = (idx + 1) << unit_shift;			\
-	memcpy(lebytes + part, token->kaddr, size - part);		\
-	return get_unaligned_le##bits(lebytes);				\
-}									\
 u##bits btrfs_get_##bits(const struct extent_buffer *eb,		\
 			 const void *ptr, unsigned long off)		\
 {									\
@@ -110,41 +67,6 @@ u##bits btrfs_get_##bits(const struct extent_buffer *eb,		\
 	memcpy(lebytes + part, kaddr, size - part);			\
 	return get_unaligned_le##bits(lebytes);				\
 }									\
-void btrfs_set_token_##bits(struct btrfs_map_token *token,		\
-			    const void *ptr, unsigned long off,		\
-			    u##bits val)				\
-{									\
-	const unsigned long member_offset = (unsigned long)ptr + off;	\
-	const unsigned long idx = get_eb_folio_index(token->eb, member_offset); \
-	const unsigned long oil = get_eb_offset_in_folio(token->eb,	\
-							 member_offset);\
-	const int unit_size = token->eb->folio_size;			\
-	const int unit_shift = token->eb->folio_shift;			\
-	const int size = sizeof(u##bits);				\
-	u8 lebytes[sizeof(u##bits)];					\
-	const int part = unit_size - oil;				\
-									\
-	ASSERT(token);							\
-	ASSERT(token->kaddr);						\
-	ASSERT(check_setget_bounds(token->eb, ptr, off, size));		\
-	if (token->offset <= member_offset &&				\
-	    member_offset + size <= token->offset + unit_size) {	\
-		put_unaligned_le##bits(val, token->kaddr + oil);	\
-		return;							\
-	}								\
-	token->kaddr = folio_address(token->eb->folios[idx]);		\
-	token->offset = idx << unit_shift;				\
-	if (INLINE_EXTENT_BUFFER_PAGES == 1 ||				\
-	    oil + size <= unit_size) {					\
-		put_unaligned_le##bits(val, token->kaddr + oil);	\
-		return;							\
-	}								\
-	put_unaligned_le##bits(val, lebytes);				\
-	memcpy(token->kaddr + oil, lebytes, part);			\
-	token->kaddr = folio_address(token->eb->folios[idx + 1]);	\
-	token->offset = (idx + 1) << unit_shift;			\
-	memcpy(token->kaddr, lebytes + part, size - part);		\
-}									\
 void btrfs_set_##bits(const struct extent_buffer *eb, void *ptr,	\
 		      unsigned long off, u##bits val)			\
 {									\
diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index 15ea6348800b0..99b3ced12805b 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -16,14 +16,6 @@
 
 struct extent_buffer;
 
-struct btrfs_map_token {
-	struct extent_buffer *eb;
-	char *kaddr;
-	unsigned long offset;
-};
-
-void btrfs_init_map_token(struct btrfs_map_token *token, struct extent_buffer *eb);
-
 /*
  * Some macros to generate set/get functions for the struct fields.  This
  * assumes there is a lefoo_to_cpu for every type, so lets make a simple one
@@ -56,11 +48,6 @@ static inline void put_unaligned_le8(u8 val, void *p)
 			    sizeof_field(type, member)))
 
 #define DECLARE_BTRFS_SETGET_BITS(bits)					\
-u##bits btrfs_get_token_##bits(struct btrfs_map_token *token,		\
-			       const void *ptr, unsigned long off);	\
-void btrfs_set_token_##bits(struct btrfs_map_token *token,		\
-			    const void *ptr, unsigned long off,		\
-			    u##bits val);				\
 u##bits btrfs_get_##bits(const struct extent_buffer *eb,		\
 			 const void *ptr, unsigned long off);		\
 void btrfs_set_##bits(const struct extent_buffer *eb, void *ptr,	\
@@ -83,18 +70,6 @@ static inline void btrfs_set_##name(const struct extent_buffer *eb, type *s, \
 {									\
 	static_assert(sizeof(u##bits) == sizeof_field(type, member));	\
 	btrfs_set_##bits(eb, s, offsetof(type, member), val);		\
-}									\
-static inline u##bits btrfs_token_##name(struct btrfs_map_token *token,	\
-					 const type *s)			\
-{									\
-	static_assert(sizeof(u##bits) == sizeof_field(type, member));	\
-	return btrfs_get_token_##bits(token, s, offsetof(type, member));\
-}									\
-static inline void btrfs_set_token_##name(struct btrfs_map_token *token,\
-					  type *s, u##bits val)		\
-{									\
-	static_assert(sizeof(u##bits) == sizeof_field(type, member));	\
-	btrfs_set_token_##bits(token, s, offsetof(type, member), val);	\
 }
 
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
@@ -479,18 +454,6 @@ static inline void btrfs_set_item_##member(const struct extent_buffer *eb,	\
 					   int slot, u32 val)			\
 {										\
 	btrfs_set_raw_item_##member(eb, btrfs_item_nr(eb, slot), val);		\
-}										\
-static inline u32 btrfs_token_item_##member(struct btrfs_map_token *token,	\
-					    int slot)				\
-{										\
-	struct btrfs_item *item = btrfs_item_nr(token->eb, slot);		\
-	return btrfs_token_raw_item_##member(token, item);			\
-}										\
-static inline void btrfs_set_token_item_##member(struct btrfs_map_token *token,	\
-						 int slot, u32 val)		\
-{										\
-	struct btrfs_item *item = btrfs_item_nr(token->eb, slot);		\
-	btrfs_set_token_raw_item_##member(token, item, val);			\
 }
 
 BTRFS_ITEM_SETGET_FUNCS(offset)
-- 
2.53.0



