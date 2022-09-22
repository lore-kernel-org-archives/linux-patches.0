Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72BC8B04
	for <patches@lists.linux.dev>; Thu, 22 Sep 2022 20:13:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8AAC321A5D;
	Thu, 22 Sep 2022 20:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1663877631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1W6wFEitTt/nhSdHj7yZiLv4d1qoZb6zO8/D6IdlseI=;
	b=qDvQiWrDOyear9G46F/Ssx9IaXcMM2dSt/Kdolj43zZhDoLZDkGAWAdmvzLxJiuaS+tgxa
	KaHnSgSV9z/iu0CviUQwCyNLOXq7noDFSI4K90x0LFhnl8QRu4j45RA1JZQm31+grMwxqa
	HkRy5vLKr0i6kCI8O0iqVuCbs6FJghE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1663877631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1W6wFEitTt/nhSdHj7yZiLv4d1qoZb6zO8/D6IdlseI=;
	b=BoJgUNn5AFEN+F+Jx/Dfh+xV4c/l84Ibg9dVksUKrtF4jgLr2kyL21qLbSMWdf2JEco27q
	/DJapVf3iVPC2vCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 593FC13AA5;
	Thu, 22 Sep 2022 20:13:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id tSuDFP/BLGMOFwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 22 Sep 2022 20:13:51 +0000
Message-ID: <9c0abd9f-5976-31e2-8802-e40270ad0014@suse.cz>
Date: Thu, 22 Sep 2022 22:13:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.0-rc7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linus,

please pull the latest slab changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.0-rc7

======================================

- Fix a possible use-after-free in SLUB's kmem_cache removal, introduced in
  this cycle, by Feng Tang.

- WQ_MEM_RECLAIM dependency fix for the workqueue-based cpu slab flushing
  introduced in 5.15, by Maurizio Lombardi.

- Add missing KASAN hooks in two kmalloc entry paths, by Peter Collingbourne.

- A BUG_ON() removal in SLUB's kmem_cache creation when allocation fails (too
  small to possibly happen in practice, syzbot used fault injection), by Chao
  Yu.

Thanks,
Vlastimil
----------------------------------------------------------------
Chao Yu (1):
      mm/slub: fix to return errno if kmalloc() fails

Feng Tang (1):
      mm/slab_common: fix possible double free of kmem_cache

Maurizio Lombardi (1):
      mm: slub: fix flush_cpu_slab()/__free_slab() invocations in task context.

Peter Collingbourne (1):
      kasan: call kasan_malloc() from __kmalloc_*track_caller()

 mm/slab_common.c |  5 ++++-
 mm/slub.c        | 18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)
