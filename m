Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F84C3C26
	for <patches@lists.linux.dev>; Thu, 19 Jan 2023 09:54:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1062B21EC5;
	Thu, 19 Jan 2023 09:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1674122061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hcS69wWsSt5pDJW4qP76I03rkns1V0Aa65dXfTwGlGc=;
	b=l/2txuWS0i4EXkBxbzQNu8fv1VDOZ52fByWAcBkgA8gpejCpNMmqo2AZ8QFBWpIvSzhVXI
	ZRY7O/drNLTvdBJUjcQi2aN2WqWjauMcaupjFAR7vfM3aURTfv93Xv8IaSghHx4hPO7RTi
	pANjRX59lZ5FBCYWdiucqvS7jtopxTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1674122061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hcS69wWsSt5pDJW4qP76I03rkns1V0Aa65dXfTwGlGc=;
	b=PTFK8cjbvLLLa7TUgQbNU5LifAI+4iMmidzHgvmrxge/dQYixPjM3JpLGJP8zrcHksBCIc
	SSN8soldpVGGsaDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DA111134F5;
	Thu, 19 Jan 2023 09:54:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id boxiNEwTyWNUCwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 19 Jan 2023 09:54:20 +0000
Message-ID: <0d10c2ed-7a1a-e94a-af73-d56b0ba98086@suse.cz>
Date: Thu, 19 Jan 2023 10:54:20 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.2-rc5
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

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.2-rc5

There is just a single fix, after the lkp report originally for a slub-tiny
commit ended up to be a gcov/compiler bug.

- periodically resched in SLAB's drain_freelist(), by David Rientjes

----------------------------------------------------------------
David Rientjes (1):
      mm, slab: periodically resched in drain_freelist()

 mm/slab.c | 2 ++
 1 file changed, 2 insertions(+)
