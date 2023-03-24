Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF94C6FA1
	for <patches@lists.linux.dev>; Fri, 24 Mar 2023 15:04:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D5371FE75;
	Fri, 24 Mar 2023 15:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1679670294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xjkqv3qq9lK96uvcM7L0CVxArtqI/M2tYrb00mpOZgs=;
	b=XJmQhelex9Pe558wjy7zSA5HVTx9K5GMSp/7YFlYBWIVLCA4lRe+gwMEl3QiQ7yhmhnmPH
	sEcBYVWSqPsw88GeWH9CCxL0d4e/SfEPUaasN4mThWh6vdV+c398lCrDpImNsTCMod/DpR
	6FwHuuNOzGaGeJDH7GdfJGmkGVXlZBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1679670294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xjkqv3qq9lK96uvcM7L0CVxArtqI/M2tYrb00mpOZgs=;
	b=3LNK4UHNz0nq73vpRKyQECwfTyjCgucIkqWQTI1qZKK7/ikw9rfRXSN0i1lz2KF6Q5PLCC
	pfx6Vnew1MNFNPAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF28D138ED;
	Fri, 24 Mar 2023 15:04:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id NBjWNRW8HWRcYAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 24 Mar 2023 15:04:53 +0000
Message-ID: <a329d2a9-9617-e00f-3bb8-3f5dcf07329f@suse.cz>
Date: Fri, 24 Mar 2023 16:04:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.3-rc4
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

please pull the latest slab fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fix-for-6.3-rc4

Note the tag was signed with a new subkey (of same gpg key). I'm not sure if
it's transparent for your tooling or not. It was uploaded to korg-pgpkeys git
(also ubuntu and keys.openpgp.org keyservers) a few weeks ago. The timing
with github ssh key rotation is pre coincidence :)

======================================

There's a single build fix for a corner case configuration that is
apparently possible to achieve on some arches, from Geert.

----------------------------------------------------------------
Geert Uytterhoeven (1):
      mm/slab: Fix undefined init_cache_node_node() for NUMA and !SMP

 mm/slab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
