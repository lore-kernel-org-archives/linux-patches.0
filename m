Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF9736B0E
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hjtiRAov";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gLtR4+jt"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6253F1FEF4;
	Fri, 27 Oct 2023 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1698417500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GcxaSeqkCqbDEGJ3KChrTM3TW8Y9uOZhrvKJt8xkhgo=;
	b=hjtiRAovlw0PHu4CBR62UvQmqu4/fwmF/88cH84jgQ0YH7dT842SjuxWky/1aZcejfczFl
	mTcRU8HjTRgfMaOI27KiaVYvSa87iVtyLgneYL519Cq2VSH1m6tDhpKskmYP2UE7gS0SW2
	B5I+O9yr7eKk0viPOWHm+KKgwzUyONM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1698417500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GcxaSeqkCqbDEGJ3KChrTM3TW8Y9uOZhrvKJt8xkhgo=;
	b=gLtR4+jt93eFd77ilr0us9HvpDrgPnHk1Iy20T7dUeBpWLv9HZirjosg8yoPqwsrxG9uyB
	P/F8sG4L+bKnUQCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3188213524;
	Fri, 27 Oct 2023 14:38:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id rgBlC1zLO2UdAgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 27 Oct 2023 14:38:20 +0000
Message-ID: <7f4cd48e-492c-24f7-6fef-e3b50eace6ba@suse.cz>
Date: Fri, 27 Oct 2023 16:38:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab updates for 6.7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Feng Tang <feng.tang@intel.com>,
 Jay Patel <jaypatel@linux.ibm.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

once the merge window opens, please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.7

Thanks,
Vlastimil

======================================

* SLUB: slab order calculation refactoring (Vlastimil Babka, Feng Tang)

  Recent proposals to tune the slab order calculations have prompted us to
  look at the current code and refactor it to make it easier to follow and
  eliminate some odd corner cases. The refactoring is mostly non-functional
  changes, but should make the actual tuning easier to implement and review.

----------------------------------------------------------------
Feng Tang (1):
      mm/slub: add sanity check for slub_min/max_order cmdline setup

Vlastimil Babka (4):
      mm/slub: simplify the last resort slab order calculation
      mm/slub: remove min_objects loop from calculate_order()
      mm/slub: attempt to find layouts up to 1/2 waste in calculate_order()
      mm/slub: refactor calculate_order() and calc_slab_order()

 mm/slub.c | 73 +++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 37 deletions(-)
