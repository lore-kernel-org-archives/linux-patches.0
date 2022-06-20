Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5947F6
	for <patches@lists.linux.dev>; Mon, 20 Jun 2022 12:02:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 74E301F45E;
	Mon, 20 Jun 2022 12:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1655726565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=trD6oDP/oU8K8dJxIz+dxuUeJsrMnku6W+1r4BQpCf0=;
	b=ZorN7QgrzXhLExwAn218fgIC5FfaeIv6TReRRI7xdSxJkf1e/5k649P79PRZZMLqoQfC7s
	UUudXPlwKJB+3aJTfvO/fdaXQolnKaIuCWFbzXhhvp73npz3H0lPrvXns+EQ0Vq2x6/dht
	K8XYjTgDd6IXG9K7pf/yMoTuR8FUaT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1655726565;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=trD6oDP/oU8K8dJxIz+dxuUeJsrMnku6W+1r4BQpCf0=;
	b=ZSvL4DqDEL0UObQafmOG7pduvvvPOkc9D9tk704KMNDH+CCia7xbgahqmlsA5GRSBEgJYq
	wWRifN2kVyvq31Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4CF85134CA;
	Mon, 20 Jun 2022 12:02:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id xhEnEuVhsGLoFAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 20 Jun 2022 12:02:45 +0000
Message-ID: <a8082f00-3e00-f781-f5f0-20b4853b3335@suse.cz>
Date: Mon, 20 Jun 2022 14:02:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fixes for 5.19
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

Linus

please pull the slab fixes for 5.19 from

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.19-fixup

======================================

- A slub fix for PREEMPT_RT locking semantics from Sebastian.

- A slub fix for state corruption due to a possible race scenario from Jann.

Thanks,
Vlastimil

----------------------------------------------------------------
Jann Horn (1):
      mm/slub: add missing TID updates on slab deactivation

Sebastian Andrzej Siewior (1):
      mm/slub: Move the stackdepot related allocation out of IRQ-off section.

 mm/slub.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)
