Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A78E14B95C
	for <patches@lists.linux.dev>; Thu,  9 May 2024 14:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715264712; cv=none; b=TivYUtlFso/bqhBkoai8wV9p4sUjQ3X6AjBsBhsHZ1oDKNU97ErDtkvhh9C9evNJZ3zDmoc/W5iH9RXYHvEluXRl6p+MwYEm6IbxivYZw13MXHJdAxkN5ko0CP6QaFHgUNmHtYwhwHwOJb8HHZdFOK0M2rqedFjF3faX4QgBA4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715264712; c=relaxed/simple;
	bh=bBIpM16SSg37TkKCJcNfvZpewLdzAeXnuS8VqydFTvI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=VYM6nri+sLZ6HHvgT2M+iduGOOgAC2KRSUqQxFbhN//wAnRpS1LboSN09BMrKrO+teE5RHupXTvF1E05fiJ7bNvhtE7owafgrueBqVV4kcoJefakhPiL5m/J0pK7BYsBP7vi5Z64t6bc9bgGRAMwlwSCL5OCws3jk7A+e30eiiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zJcEjUAD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HFXPgYFu; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zJcEjUAD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HFXPgYFu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zJcEjUAD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HFXPgYFu";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zJcEjUAD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HFXPgYFu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5B5FD3872F;
	Thu,  9 May 2024 14:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715264706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=eQMUPtPgke+IOygEjdGv24BFpnZ9oI+w+PtJ6GJCSVM=;
	b=zJcEjUADgmUdzL9apTmoZkkxDpecRwKnteb9CFfPZw2Ov5IzGZA4E7wDbJk6VLpkjCMRH1
	xYz7knZJpj9GA6HVWLR9e+Ve6R1w+jQtgYX1GjQF43NVRsYoPJ+Lb353epiSkjZOR8Rdbk
	vtznahS4T9eADzcYD7p9/KFkFGJi/TA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715264706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=eQMUPtPgke+IOygEjdGv24BFpnZ9oI+w+PtJ6GJCSVM=;
	b=HFXPgYFuIowtyiHgGbYEKE2lKeURO+WWQ2/igkv6FZUvSx7Rx5hkL2SGrrpLdYgcGDQ2Nz
	S/smmm4YvlwA+uBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715264706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=eQMUPtPgke+IOygEjdGv24BFpnZ9oI+w+PtJ6GJCSVM=;
	b=zJcEjUADgmUdzL9apTmoZkkxDpecRwKnteb9CFfPZw2Ov5IzGZA4E7wDbJk6VLpkjCMRH1
	xYz7knZJpj9GA6HVWLR9e+Ve6R1w+jQtgYX1GjQF43NVRsYoPJ+Lb353epiSkjZOR8Rdbk
	vtznahS4T9eADzcYD7p9/KFkFGJi/TA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715264706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=eQMUPtPgke+IOygEjdGv24BFpnZ9oI+w+PtJ6GJCSVM=;
	b=HFXPgYFuIowtyiHgGbYEKE2lKeURO+WWQ2/igkv6FZUvSx7Rx5hkL2SGrrpLdYgcGDQ2Nz
	S/smmm4YvlwA+uBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42ABB13941;
	Thu,  9 May 2024 14:25:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rhL5D8LcPGb+AgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 09 May 2024 14:25:06 +0000
Message-ID: <587f5e6b-d543-4028-85c8-93cc8f581d02@suse.cz>
Date: Thu, 9 May 2024 16:25:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab updates for 6.10
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[google.com,lge.com,linux.com,kernel.org,linux-foundation.org,kvack.org,vger.kernel.org,lists.linux.dev,linux.dev,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.10

Sending this early due to upcoming LSF/MM travel and chances there's no rc8.

Thanks,
Vlastimil

======================================

This time it's mostly random cleanups and fixes, with two performance fixes
that might have significant impact, but limited to systems experiencing
particular bad corner case scenarios rather than general performance
improvements.

The memcg hook changes are going through the mm tree due to dependencies.

- Prevent stalls when reading /proc/slabinfo (Jianfeng Wang)

  This fixes the long-standing problem that can happen with workloads that have
  alloc/free patterns resulting in many partially used slabs (in e.g. dentry
  cache). Reading /proc/slabinfo will traverse the long partial slab list under
  spinlock with disabled irqs and thus can stall other processes or even
  trigger the lockup detection. The traversal is only done to count free
  objects so that <active_objs> column can be reported along with <num_objs>.

  To avoid affecting fast paths with another shared counter (attempted in the
  past) or complex partial list traversal schemes that allow rescheduling, the
  chosen solution resorts to approximation - when the partial list is over
  10000 slabs long, we will only traverse first 5000 slabs from head and tail
  each and use the average of those to estimate the whole list. Both head and
  tail are used as the slabs near head to tend to have more free objects than
  the slabs towards the tail.

  It is expected the approximation should not break existing /proc/slabinfo
  consumers. The <num_objs> field is still accurate and reflects the overall
  kmem_cache footprint. The <active_objs> was already imprecise due to cpu and
  percpu-partial slabs, so can't be relied upon to determine exact cache usage.
  The difference between <active_objs> and <num_objs> is mainly useful to
  determine the slab fragmentation, and that will be possible even with the
  approximation in place.

- Prevent allocating many slabs when a NUMA node is full (Chen Jun)

  Currently, on NUMA systems with a node under significantly bigger pressure
  than other nodes, the fallback strategy may result in each kmalloc_node()
  that can't be safisfied from the preferred node, to allocate a new slab on a
  fallback node, and not reuse the slabs already on that node's partial list.

  This is now fixed and partial lists of fallback nodes are checked even for
  kmalloc_node() allocations. It's still preferred to allocate a new slab on
  the requested node before a fallback, but only with a GFP_NOWAIT attempt,
  which will fail quickly when the node is under a significant memory pressure.

- More SLAB removal related cleanups (Xiu Jianfeng, Hyunmin Lee)

- Fix slub_kunit self-test with hardened freelists (Guenter Roeck)

- Mark racy accesses for KCSAN (linke li)

- Misc cleanups (Xiongwei Song, Haifeng Xu, Sangyun Kim)

----------------------------------------------------------------
Chen Jun (1):
      mm/slub: Reduce memory consumption in extreme scenarios

Guenter Roeck (1):
      mm/slub, kunit: Use inverted data to corrupt kmem cache

Haifeng Xu (1):
      slub: Set __GFP_COMP in kmem_cache by default

Hyunmin Lee (2):
      mm/slub: create kmalloc 96 and 192 caches regardless cache size order
      mm/slub: remove the check for NULL kmalloc_caches

Jianfeng Wang (2):
      slub: introduce count_partial_free_approx()
      slub: use count_partial_free_approx() in slab_out_of_memory()

Sangyun Kim (1):
      mm/slub: remove duplicate initialization for early_kmem_cache_node_alloc()

Xiongwei Song (3):
      mm/slub: remove the check of !kmem_cache_has_cpu_partial()
      mm/slub: add slub_get_cpu_partial() helper
      mm/slub: simplify get_partial_node()

Xiu Jianfeng (2):
      mm/slub: remove dummy slabinfo functions
      mm/slub: correct comment in do_slab_free()

linke li (2):
      mm/slub: mark racy accesses on slab->slabs
      mm/slub: mark racy access on slab->freelist

 lib/slub_kunit.c |   2 +-
 mm/slab.h        |   3 --
 mm/slab_common.c |  27 +++++--------
 mm/slub.c        | 118 ++++++++++++++++++++++++++++++++++++++++---------------
 4 files changed, 96 insertions(+), 54 deletions(-)
