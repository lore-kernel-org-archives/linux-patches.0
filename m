Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0937B
	for <patches@lists.linux.dev>; Wed, 23 Feb 2022 09:44:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 25CB41F3A3;
	Wed, 23 Feb 2022 09:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1645609460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kXKiiDcCtIBF1plZCamNfShYp0xDLuW1hfasrJY5ejM=;
	b=XIAgOwVokEEDv4fI3b3xCxYyoeu2tzrnWX+4DQMasEoqrL+qqjAgoMNjiE9n+O7qBLkNLF
	PlzLPj/J4k0a0dyF2k71acCYpfwysif8J4KBsq3HsO9bs+DAYp+iSl+evYT6AQ6bPGrBwW
	vhawFJiOHBj7hKBMJL1A8mAAgYsW/zg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1645609460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kXKiiDcCtIBF1plZCamNfShYp0xDLuW1hfasrJY5ejM=;
	b=fiQMZk6c8sJCCoU96/YOuJ0e5qS0s2WvO30OIl59IW/Gnmak3O6+m4vcJj2TmwmrjTPZlQ
	5ymL4Nk3izuG8xBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC40E13C6E;
	Wed, 23 Feb 2022 09:44:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id hhXYOPMBFmL9MgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 23 Feb 2022 09:44:19 +0000
Message-ID: <02623bc1-fc54-bc5d-8879-e62d548924fd@suse.cz>
Date: Wed, 23 Feb 2022 10:44:19 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fixes for 5.17-rc6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linus,

please pull the slab fixes for 5.17-rc6 from

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.17-rc6

======================================

- Build fix (workaround) for clang.

- Fix a /proc/kcore based slabinfo script broken by struct slab changes in
  5.17-rc1.

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      slab: remove __alloc_size attribute from __kmalloc_track_caller

Roman Gushchin (1):
      tools/cgroup/slabinfo: update to work with struct slab

 include/linux/slab.h           |  3 +--
 tools/cgroup/memcg_slabinfo.py | 30 +++++++++++++++---------------
 2 files changed, 16 insertions(+), 17 deletions(-)
