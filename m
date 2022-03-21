Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE305612C
	for <patches@lists.linux.dev>; Mon, 21 Mar 2022 19:03:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7721F210E5;
	Mon, 21 Mar 2022 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1647889379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0lPY7URDPMq8rYBVp0M/NOfMrQTutTr1yrMsLeMpnNY=;
	b=LBOFPdEmGXgywh7acCGg0RyFzCbh1fOXlP8H1MYq1W2Wk8A497m1v2R9U44NPOhWLDAviy
	8dKxCN45Ste5saMajog0Y+qkTDWqbbszDfHHXY33W2a6tFE1DZnwhzXIYnjP8RwEyJP7zR
	9bWSnqphBeXcGQmA+9p1BVk1HbbCXUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1647889379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0lPY7URDPMq8rYBVp0M/NOfMrQTutTr1yrMsLeMpnNY=;
	b=xJWAyr76OIAuzvi4/zYDNPZb7bQ8ogpWhEQVUtuck4Xywrre5po5ncRulk2AVAqvZ3I6VW
	mgfTNSLoDC0lR2Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 44FE4139F9;
	Mon, 21 Mar 2022 19:02:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id CE4lEOPLOGI1bQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 21 Mar 2022 19:02:59 +0000
Message-ID: <ee1fe9ee-c560-9f7c-c8d1-bd48c608ba90@suse.cz>
Date: Mon, 21 Mar 2022 20:02:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From: Vlastimil Babka <vbabka@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 Roman Gushchin <roman.gushchin@linux.dev>
Content-Language: en-US
Subject: [GIT PULL] slab for 5.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linus,

please pull the latest slab changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.18

======================================

- A few non-trivial SLUB code cleanups, most notably a
  refactoring of deactivate_slab().

- Bunch of trivial changes, such as removal of unused parameters,
  making stuff static, employing helpers.

Thanks,
Vlastimil

----------------------------------------------------------------
Hyeonggon Yoo (2):
      mm/slub: limit number of node partial slabs only in cache creation
      mm/slub: refactor deactivate_slab()

Lianjie Zhang (1):
      mm/slub: use helper macro __ATTR_XX_MODE for SLAB_ATTR(_RO)

Miaohe Lin (3):
      mm/slob: make kmem_cache_boot static
      mm/slab_common: use helper function is_power_of_2()
      mm/slub: remove forced_order parameter in calculate_sizes

Vlastimil Babka (2):
      Merge branch 'slab/for-5.18/trivial' into slab/for-linus
      Merge branch 'slab/for-5.18/cleanups' into slab/for-linus

Xiongwei Song (2):
      mm: slab: Delete unused SLAB_DEACTIVATED flag
      mm: slub: Delete useless parameter of alloc_slab_page()

 include/linux/slab.h |   3 --
 mm/slab_common.c     |   2 +-
 mm/slob.c            |   2 +-
 mm/slub.c            | 130 +++++++++++++++++++++------------------------------
 4 files changed, 54 insertions(+), 83 deletions(-)
