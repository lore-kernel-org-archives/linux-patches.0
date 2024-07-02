Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F06C1BD031
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719935889; cv=none; b=SEyTRd2EAOMAv7Ln83pCwtVwMBTbOVKrHQBLsps7juAYA+gbtTkxfElZgtVl6Of0ET4mpXhJpk28zj1Mf7VEOrgwARj5X6nxJXp9ls8qoOQT89sycC8/xPyigmi8329+h2UsaalCV5x1M/ocG9BT+dUg16PnIRgO1WYnx7bf9ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719935889; c=relaxed/simple;
	bh=BNA7h2+hbaCtPD6zTsd/1n30CL75PtZV8rfutIRexK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A9/ijkCleuSH9TlOyVcfMnDUA+6QsveyQJLAPSrnHfA/8kRESM3fiRFfgWh9FaxrzLG8TZE4l94ZZXdpSrHxWA5olvlpD04IcMoBKYSTrilcfvuvHbAr03dYlk/LM3GGRDOikcV+0p8q3saA+j0avNhe/YiBGcE9+O3U0k7vcMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1x1+B5V6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vr79WnWh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=V3TCk0Rl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WiGNbOPw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1x1+B5V6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vr79WnWh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="V3TCk0Rl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WiGNbOPw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00B2D21AE7;
	Tue,  2 Jul 2024 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719935886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZUXJa6qZ1Z85tU8NRRhDqffNTAJHYAKpnrU2JbYigmg=;
	b=1x1+B5V6VO16gcDXPWruRSuHy3ASUQ6OSGNwuHaQw9msV3aqKnchPiCWPrX2nCX2CuFE75
	Dr2XDPshXdKkFZJZcw6v1lLoQblUazWtL2ZvXZscf9MipEteKJ5mb4vCiaG/aYG23CQTIz
	W/4gHll3tNhH1mpUELQr2wB7k0bY2vs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719935886;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZUXJa6qZ1Z85tU8NRRhDqffNTAJHYAKpnrU2JbYigmg=;
	b=vr79WnWh0OSe6gXYBRvDNQRwvXU8g6rMVkZ0jLdrYUtZvrY7laWbG58dOYscFWzoyzqpVd
	repYS55oqSmRzMAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V3TCk0Rl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WiGNbOPw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719935885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZUXJa6qZ1Z85tU8NRRhDqffNTAJHYAKpnrU2JbYigmg=;
	b=V3TCk0RlMSZAidW1rWOKh+fkjzUw7oFfX43T0DbAZnER/9hIC303LYKs4LW7f1GQa1VqPV
	6A02cVf+RaQ7rO1CI+1z6mI6zIBsb9MQDzlG/B0qpbAH3rZp/njh2w2tQ0/EvwtE0/kbSF
	Krw8tjEWELO8q2WWU+55yZTjPvxzwBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719935885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZUXJa6qZ1Z85tU8NRRhDqffNTAJHYAKpnrU2JbYigmg=;
	b=WiGNbOPwwF9Jv0WQ7/9zyFt/L3g2WIE+q1uxP8+CVW4+J/xWVCSqyhzOEKi1/sWfS/LNdn
	eS3/uG3wB+dU68BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DDD0613A9A;
	Tue,  2 Jul 2024 15:58:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G7rNNYwjhGZSMQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 02 Jul 2024 15:58:04 +0000
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
Subject: [PATCH] mm, slab: extend kmalloc() alignment for non power-of-two sizes
Date: Tue,  2 Jul 2024 17:58:01 +0200
Message-ID: <20240702155800.166503-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 00B2D21AE7
X-Spam-Score: -1.51
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.cz:+];
	FREEMAIL_CC(0.00)[gmail.com,linux.dev,chromium.org,google.com,vger.kernel.org,lists.linux.dev,suse.cz];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Slab allocators have been guaranteeing natural alignment for
power-of-two sizes since commit 59bb47985c1d ("mm, sl[aou]b: guarantee
natural alignment for kmalloc(power-of-two)"), while any other sizes are
aligned only to ARCH_KMALLOC_MINALIGN bytes.

Rust's allocator API specifies size and alignment per allocation, which
have to satisfy the following rules, per Alice Ryhl [1]:

  1. The alignment is a power of two.
  2. The size is non-zero.
  3. When you round up the size to the next multiple of the alignment,
     then it must not overflow the signed type isize / ssize_t.

In order to map this to kmalloc()'s guarantees, some requested
allocation sizes have to be enlarged to the next power-of-two size [2].
For example, an allocation of size 96 and alignment of 32 will be
enlarged to an allocation of size 128, because the existing kmalloc-96
bucket doesn't guarantee alignent above ARCH_KMALLOC_MINALIGN. Without
slab debugging active, the layout of the kmalloc-96 slabs however
naturally aligns the objects to 32 bytes, so extending the size to 128
bytes is wasteful.

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

Link: https://lore.kernel.org/all/CAH5fLggjrbdUuT-H-5vbQfMazjRDpp2%2Bk3%3DYhPyS17ezEqxwcw@mail.gmail.com/ [1]
Link: https://lore.kernel.org/all/CAH5fLghsZRemYUwVvhk77o6y1foqnCeDzW4WZv6ScEWna2+_jw@mail.gmail.com/ [2]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 Documentation/core-api/memory-allocation.rst | 6 ++++--
 include/linux/slab.h                         | 3 ++-
 mm/slab_common.c                             | 9 +++++----
 3 files changed, 11 insertions(+), 7 deletions(-)

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
-- 
2.45.2

