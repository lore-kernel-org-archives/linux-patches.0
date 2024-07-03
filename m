Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C22131BDD
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 07:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719991534; cv=none; b=sDywpCWjcPRkNItiS9VbqtpTYdxfdK1fI+uQObYPO/QaYOhYWC1ceKpMZbHtIq+vuZ4s3WMY2zOlcWbyyqoL/sgyiWfLfftHYt1vz5Fe13pSdtgqRkZlADEYO4G9QNz6KdrbzzgO3euJuxxrI88LMEp7hk3ejRR6i3DbMJ4vAo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719991534; c=relaxed/simple;
	bh=ZSLBHEHKKA793GTvFH6W/MHlx8oKyLVncU5l0DeXxRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KR512ExcsA6nYjTQshWDKlyXFy6IYjXQAurirIiM9aYz+sOmGk+F8UfW55AIt124nz00eZDsdo6ODy3uIG13iyucaQnAlqadNW62iu8WLnaNsNrA5xvOOqo66m6MOz6zxy7TQ8MqJuEOmJpT2cDdco7YDyRVkEbgmGxfVAm506E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=o1awERoN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0MS5+Bmr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=o1awERoN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0MS5+Bmr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="o1awERoN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0MS5+Bmr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="o1awERoN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0MS5+Bmr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21AB81FC84;
	Wed,  3 Jul 2024 07:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719991525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kH5792dO8jlMERftjnrjLzOnrCxaNxD4wMDDSAQ35CY=;
	b=o1awERoNq1ycynNcRHOcmhCqqJPnTZA6XBpKYcwZc45L/4BRGLnUBZnjTd/PVm3s3QlxYe
	EosRzfH2yl0oPgCt3Z59fu8ey+CuLo3ZS6Zr815uUMkR1cGXTOA1I2FsQk4vUKR79/Vgoa
	tBkkueH7doT/BHts+Yh0o5K/YlARamw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719991525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kH5792dO8jlMERftjnrjLzOnrCxaNxD4wMDDSAQ35CY=;
	b=0MS5+BmrfeG8qTzWVSTfn0mzWElY1nlfuTLzYYahYviNAwo/qEWksTn5O5PY6br9WsJqBG
	YBsq5y2+j9tdFTDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719991525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kH5792dO8jlMERftjnrjLzOnrCxaNxD4wMDDSAQ35CY=;
	b=o1awERoNq1ycynNcRHOcmhCqqJPnTZA6XBpKYcwZc45L/4BRGLnUBZnjTd/PVm3s3QlxYe
	EosRzfH2yl0oPgCt3Z59fu8ey+CuLo3ZS6Zr815uUMkR1cGXTOA1I2FsQk4vUKR79/Vgoa
	tBkkueH7doT/BHts+Yh0o5K/YlARamw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719991525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kH5792dO8jlMERftjnrjLzOnrCxaNxD4wMDDSAQ35CY=;
	b=0MS5+BmrfeG8qTzWVSTfn0mzWElY1nlfuTLzYYahYviNAwo/qEWksTn5O5PY6br9WsJqBG
	YBsq5y2+j9tdFTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09A4813974;
	Wed,  3 Jul 2024 07:25:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RiEDAuX8hGZKLgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Jul 2024 07:25:25 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <keescook@chromium.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2] slab, rust: extend kmalloc() alignment guarantees to remove Rust padding
Date: Wed,  3 Jul 2024 09:25:21 +0200
Message-ID: <20240703072520.45837-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-0.99)[-0.985];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,linux.dev,chromium.org,google.com,vger.kernel.org,lists.linux.dev,suse.cz];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

Slab allocators have been guaranteeing natural alignment for
power-of-two sizes since commit 59bb47985c1d ("mm, sl[aou]b: guarantee
natural alignment for kmalloc(power-of-two)"), while any other sizes are
guaranteed to be aligned only to ARCH_KMALLOC_MINALIGN bytes (although
in practice are aligned more than that in non-debug scenarios).

Rust's allocator API specifies size and alignment per allocation, which
have to satisfy the following rules, per Alice Ryhl [1]:

  1. The alignment is a power of two.
  2. The size is non-zero.
  3. When you round up the size to the next multiple of the alignment,
     then it must not overflow the signed type isize / ssize_t.

In order to map this to kmalloc()'s guarantees, some requested
allocation sizes have to be padded to the next power-of-two size [2].
For example, an allocation of size 96 and alignment of 32 will be padded
to an allocation of size 128, because the existing kmalloc-96 bucket
doesn't guarantee alignent above ARCH_KMALLOC_MINALIGN. Without slab
debugging active, the layout of the kmalloc-96 slabs however naturally
align the objects to 32 bytes, so extending the size to 128 bytes is
wasteful.

To improve the situation we can extend the kmalloc() alignment
guarantees in a way that

1) doesn't change the current slab layout (and thus does not increase
   internal fragmentation) when slab debugging is not active
2) reduces waste in the Rust allocator use case
3) is a superset of the current guarantee for power-of-two sizes.

The extended guarantee is that alignment is at least the largest
power-of-two divisor of the requested size. For power-of-two sizes the
largest divisor is the size itself, but let's keep this case documented
separately for clarity.

For current kmalloc size buckets, it means kmalloc-96 will guarantee
alignment of 32 bytes and kmalloc-196 will guarantee 64 bytes.

This covers the rules 1 and 2 above of Rust's API as long as the size is
a multiple of the alignment. The Rust layer should now only need to
round up the size to the next multiple if it isn't, while enforcing the
rule 3.

Implementation-wise, this changes the alignment calculation in
create_boot_cache(). While at it also do the calulation only for caches
with the SLAB_KMALLOC flag, because the function is also used to create
the initial kmem_cache and kmem_cache_node caches, where no alignment
guarantee is necessary.

In the Rust allocator's krealloc_aligned(), remove the code that padded
sizes to the next power of two (suggested by Alice Ryhl) as it's no
longer necessary with the new guarantees.

Reported-by: Alice Ryhl <aliceryhl@google.com>
Reported-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/all/CAH5fLggjrbdUuT-H-5vbQfMazjRDpp2%2Bk3%3DYhPyS17ezEqxwcw@mail.gmail.com/ [1]
Link: https://lore.kernel.org/all/CAH5fLghsZRemYUwVvhk77o6y1foqnCeDzW4WZv6ScEWna2+_jw@mail.gmail.com/ [2]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
v2: - add Rust side change as suggested by Alice, also thanks Boqun for fixups
- clarify that the alignment already existed (unless debugging) but was
  not guaranteed, so there's no extra fragmentation in slab
- add r-b, a-b thanks tO Boqun and Roman

If it's fine with Rust folks, I can put this in the slab.git tree.

 Documentation/core-api/memory-allocation.rst |  6 ++++--
 include/linux/slab.h                         |  3 ++-
 mm/slab_common.c                             |  9 +++++----
 rust/kernel/alloc/allocator.rs               | 19 ++++++-------------
 4 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 1c58d883b273..8b84eb4bdae7 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -144,8 +144,10 @@ configuration, but it is a good practice to use `kmalloc` for objects
 smaller than page size.
 
 The address of a chunk allocated with `kmalloc` is aligned to at least
-ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
-alignment is also guaranteed to be at least the respective size.
+ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
+alignment is also guaranteed to be at least the respective size. For other
+sizes, the alignment is guaranteed to be at least the largest power-of-two
+divisor of the size.
 
 Chunks allocated with kmalloc() can be resized with krealloc(). Similarly
 to kmalloc_array(): a helper for resizing arrays is provided in the form of
diff --git a/include/linux/slab.h b/include/linux/slab.h
index ed6bee5ec2b6..640cea6e6323 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -604,7 +604,8 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
  *
  * The allocated object address is aligned to at least ARCH_KMALLOC_MINALIGN
  * bytes. For @size of power of two bytes, the alignment is also guaranteed
- * to be at least to the size.
+ * to be at least to the size. For other sizes, the alignment is guaranteed to
+ * be at least the largest power-of-two divisor of @size.
  *
  * The @flags argument may be one of the GFP flags defined at
  * include/linux/gfp_types.h and described at
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 1560a1546bb1..7272ef7bc55f 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -617,11 +617,12 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name,
 	s->size = s->object_size = size;
 
 	/*
-	 * For power of two sizes, guarantee natural alignment for kmalloc
-	 * caches, regardless of SL*B debugging options.
+	 * kmalloc caches guarantee alignment of at least the largest
+	 * power-of-two divisor of the size. For power-of-two sizes,
+	 * it is the size itself.
 	 */
-	if (is_power_of_2(size))
-		align = max(align, size);
+	if (flags & SLAB_KMALLOC)
+		align = max(align, 1U << (ffs(size) - 1));
 	s->align = calculate_alignment(flags, align, size);
 
 #ifdef CONFIG_HARDENED_USERCOPY
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index 229642960cd1..e6ea601f38c6 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -18,23 +18,16 @@ pub(crate) unsafe fn krealloc_aligned(ptr: *mut u8, new_layout: Layout, flags: F
     // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
     let layout = new_layout.pad_to_align();
 
-    let mut size = layout.size();
-
-    if layout.align() > bindings::ARCH_SLAB_MINALIGN {
-        // The alignment requirement exceeds the slab guarantee, thus try to enlarge the size
-        // to use the "power-of-two" size/alignment guarantee (see comments in `kmalloc()` for
-        // more information).
-        //
-        // Note that `layout.size()` (after padding) is guaranteed to be a multiple of
-        // `layout.align()`, so `next_power_of_two` gives enough alignment guarantee.
-        size = size.next_power_of_two();
-    }
+    // Note that `layout.size()` (after padding) is guaranteed to be a multiple of `layout.align()`
+    // which together with the slab guarantees means the `krealloc` will return a properly aligned
+    // object (see comments in `kmalloc()` for more information).
+    let size = layout.size();
 
     // SAFETY:
     // - `ptr` is either null or a pointer returned from a previous `k{re}alloc()` by the
     //   function safety requirement.
-    // - `size` is greater than 0 since it's either a `layout.size()` (which cannot be zero
-    //   according to the function safety requirement) or a result from `next_power_of_two()`.
+    // - `size` is greater than 0 since it's from `layout.size()` (which cannot be zero according
+    //   to the function safety requirement)
     unsafe { bindings::krealloc(ptr as *const core::ffi::c_void, size, flags.0) as *mut u8 }
 }
 
-- 
2.45.2

