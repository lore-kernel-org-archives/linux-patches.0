Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101492C9E
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 14:48:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0AA142294C;
	Wed,  9 Nov 2022 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1668005291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dHfD+ZvXXlGmKJfWbAPZepBWH27U3xlp0lHhbBFBNHw=;
	b=sCJfVJLj4Oztb+InMk4mmjIfyUDRVCpjk8CBux9n2niFffmBjv3jIalbGgGA0Ahzs/qtdq
	6jvWe0WekPOCYffhUV1VMpG+V9tUh1+nXkVM/464c/VCV5TFyMe65M9Ect5shpn8iBSiI9
	N8cK2uKtmP5Kqgq5r+L+ZAILEhgYDOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1668005291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dHfD+ZvXXlGmKJfWbAPZepBWH27U3xlp0lHhbBFBNHw=;
	b=wwh3XY3nmcekJuZkMd4S+vrCUE69IYKgmZ1HvoZZJMmg4k+OVBv00SnJnmqrg5V4Zsrmtl
	yRQDGebdVqUWyvBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC789139F1;
	Wed,  9 Nov 2022 14:48:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id xwYqMaq9a2NJNgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 09 Nov 2022 14:48:10 +0000
Message-ID: <87a751bc-34be-b96e-f157-9c841d153f52@suse.cz>
Date: Wed, 9 Nov 2022 15:48:10 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fixes for 6.1-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Kees Cook <keescook@chromium.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.1-rc4-fixes

Most are small fixups as described bellow, except the !CONFIG_TRACING commit
eb4940d4adf5 which would be otherwise done in the next merge window as part
of upcoming hardening changes. But we realized it can make the kmalloc waste
tracking introduced in this window inaccurate, so decided to go with it now.

Thanks, Vlastimil

======================================

* Remove !CONFIG_TRACING kmalloc() wrappers intended to save a function call,
  due to incompatilibity with recently introduced wasted space tracking and
  planned hardening changes.

* A tracing parameter regression fix, by Kees Cook.

* Two kernel-doc warning fixups, by Lukas Bulwahn and myself.
  
----------------------------------------------------------------
Kees Cook (1):
      mm/slab_common: Restore passing "caller" for tracing

Lukas Bulwahn (1):
      mm/slab_common: repair kernel-doc for __ksize()

Vlastimil Babka (2):
      mm/slab: remove !CONFIG_TRACING variants of kmalloc_[node_]trace()
      mm, slab: remove duplicate kernel-doc comment for ksize()

 include/linux/slab.h | 23 -----------------------
 mm/slab_common.c     | 24 ++++--------------------
 2 files changed, 4 insertions(+), 43 deletions(-)
