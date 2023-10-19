Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAFF2FE1D
	for <patches@lists.linux.dev>; Thu, 19 Oct 2023 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h5QSSCr9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C+41ztZd"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E6FC921A2E;
	Thu, 19 Oct 2023 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1697728800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=65/Bc7TuJYYcxrrKAWOW2AlaW26JNILOkKbFFPEwZfs=;
	b=h5QSSCr9dnxMPgdsclqt3BnTz2QSzVgfhsepPC89GnWrvKmme+fNb6DM3/D4MsUxv+0OK/
	521IkdE/G4EsRzFm0sF57PqDDH1un2jb5HJbWLx9/h8S7KBGhvZPeYFFLG0cANEggVGyXn
	e8KrlQFVPVPKAwy1fUPZQZTFxzOLu0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1697728800;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=65/Bc7TuJYYcxrrKAWOW2AlaW26JNILOkKbFFPEwZfs=;
	b=C+41ztZdjQtvRhIj+I2dEKZxbsNUWmB8GG5LplOZeYcqgMmaiuIjDF22EuYdCXDIhmRSMJ
	ata/kE3INTvdusAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B19B11357F;
	Thu, 19 Oct 2023 15:20:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id OAN8KiBJMWUVHwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 19 Oct 2023 15:20:00 +0000
Message-ID: <06eb77e9-a058-6b0d-d0f6-2f4733e6ca00@suse.cz>
Date: Thu, 19 Oct 2023 17:20:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fixes for 6.6-rc6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
 patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Catalin Marinas <Catalin.Marinas@arm.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.10
X-Spamd-Result: default: False [-4.10 / 50.00];
	 ARC_NA(0.00)[];
	 TO_DN_EQ_ADDR_SOME(0.00)[];
	 FREEMAIL_CC(0.00)[google.com,lge.com,linux.com,kernel.org,kvack.org,vger.kernel.org,lists.linux.dev,linux.dev,gmail.com,arm.com];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 BAYES_HAM(-1.50)[91.71%];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[11];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Flag: NO

Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fixes-for-6.6-rc6

There's a single stable fix sent last week [1] and due to swiotlb
changes in 6.6 I based it on 6.6-rc5 to apply cleanly:

- stable fix to prevent kernel warnings with KASAN_HW_TAGS on
  arm64 due to improperly resolved kmalloc alignment restrictions
  (Catalin Marinas)

Thanks,
Vlastimil

[1] https://lore.kernel.org/all/20231006163934.3273940-1-catalin.marinas@arm.com/

----------------------------------------------------------------
Catalin Marinas (1):
      mm: slab: Do not create kmalloc caches smaller than arch_slab_minalign()

 mm/slab_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
