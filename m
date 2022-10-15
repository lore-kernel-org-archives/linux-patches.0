Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DFD2F52
	for <patches@lists.linux.dev>; Sat, 15 Oct 2022 20:14:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 93C071F8B2;
	Sat, 15 Oct 2022 20:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1665864368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d195GuIU1w2GH4mO1pb865I7+J+Sq8iEhi1gyiUJdtY=;
	b=Am9p6LzQDFspTjj+DpqXDdTwG9Zn5jMrTm7LIh1NNXwj1pcybri5RhdeuA+s9m63QQiRx5
	7S67yU1GHZYjgiGkEjspVysKMsktcbI0YxZkkvfrkmEIju7p7yBJR90Ns8zS+/YjCtTZDJ
	KUwQ+8slUL2Bpi+MRF8qg7oi3SnWHVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1665864368;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d195GuIU1w2GH4mO1pb865I7+J+Sq8iEhi1gyiUJdtY=;
	b=17IwrYcP0W8nM0caKmkeOzNRircviKwgCPIZgZdHVP15aCRqyU7Op6IvocIB05I6Osa1mH
	DLMeYb+d+xr5CBBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 62877132C4;
	Sat, 15 Oct 2022 20:06:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id Kh5dF7ASS2ONIQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Sat, 15 Oct 2022 20:06:08 +0000
Message-ID: <83deef1e-48ab-6e29-4611-2e7c37d023c8@suse.cz>
Date: Sat, 15 Oct 2022 22:06:08 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab hotfix for 6.1-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Kees Cook <keescook@chromium.org>,
 Feng Tang <feng.tang@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linus,

please pull the latest slab changes from:

    git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.1-rc1-hotfix

It's a single fix for the common-kmalloc series, for warnings on mips
and sparc64 reported by Guenter Roeck. It's rather last-minute, but I
thought it would be better to avoid the warnings in rc1.

Thanks,
Vlastimil

======================================

* A SLAB fix for warnings during creation of caches with off-slab
  freelist, by Hyeonggon Yoo.

----------------------------------------------------------------
Hyeonggon Yoo (1):
      mm/slab: use kmalloc_node() for off slab freelist_idx_t array allocation

 include/linux/slab_def.h |  1 -
 mm/slab.c                | 37 +++++++++++++++++++------------------
 2 files changed, 19 insertions(+), 19 deletions(-)
