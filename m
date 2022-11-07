Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCC57F
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 17:06:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 45E43225FE;
	Mon,  7 Nov 2022 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1667840757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rn9xQxF1SiqI3hq3m8+HEoFWEg4sEnRP9PimT44lp+o=;
	b=0+UgC16voEobAqhc3TDmlKXe49ffMkXz+JYFLH8Q2VdizXmpUKArwb4F0qb9ogZsQDV7L9
	wW88bSLIej+5QA0d0SkjpYx20LpK/CK4yjk5exZLnoBvUKdhpH81dfleDuEf+JTU9ae2XU
	qpb/UxXIPhrHnw8QddJU2nlr9N6bVeY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1667840757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rn9xQxF1SiqI3hq3m8+HEoFWEg4sEnRP9PimT44lp+o=;
	b=BthGwYjhGhVwuVLPtrRxURFYyQF/G51vCTt54KbN5k/VQTH9Bquv9SYzU8DJCQrQ/5P/ME
	vcLfqjRaY89zTbAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 17DC113AC7;
	Mon,  7 Nov 2022 17:05:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 9TkwBfU6aWOYfwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 07 Nov 2022 17:05:57 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	paulmck@kernel.org,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 0/3] rearrange struct slab fields to allow larger rcu_head
Date: Mon,  7 Nov 2022 18:05:51 +0100
Message-Id: <20221107170554.7869-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The previous version (RFC, no cover letter) is here:
https://lore.kernel.org/all/20220826090912.11292-1-vbabka@suse.cz/

Git branch is here:
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-6.2/fit_rcu_head
(also in linux-next since late last week)

The rationale for doing all this is in patch 3 - I hope there are still
plans for the rcu_head debugging, Joel?

The previous version was in linux-next, which brought crash reports due
to causing false positive __PageMovable() tests. There were several
attempts to deal with it, as explained in Patch 2, which is an updated
version of one of those attempts. It hasn't been formally posted and
reviewed yet, hence this posting.

Thanks,
Vlastimil

Vlastimil Babka (3):
  mm/slub: perform free consistency checks before call_rcu
  mm/migrate: make isolate_movable_page() skip slab pages
  mm/sl[au]b: rearrange struct slab fields to allow larger rcu_head

 mm/migrate.c | 15 ++++++++++++---
 mm/slab.c    |  6 +++++-
 mm/slab.h    | 54 +++++++++++++++++++++++++++++++---------------------
 mm/slub.c    | 26 ++++++++++++++-----------
 4 files changed, 64 insertions(+), 37 deletions(-)

-- 
2.38.0

