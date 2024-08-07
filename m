Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6795F188CB7
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 08:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723105204; cv=none; b=mDIUYxVYNthX+dymL+Zo8Zt961cPtH27ZF/VzF8dSkYG4gin7+obVuocvUoWzz0x9t4uyUNOT990+BqxKKO9z8UO2MSiBiXh2OJMivds3TxrQ/EmkPenqZoBz64KQEFsuAql7HjygYSBm/CfcrPU1S7KyJuKQIXEfak1RS7369U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723105204; c=relaxed/simple;
	bh=/0tdQ4GyIKRolLxENjc86mazApy5VDmkfI69GjhJWtk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=H8PqjifyWQOrkecgAeaAn4i6nY2rcxtbiKAN3eiykeacoxcRtcgzW3hGbcu4IzFZn9//sZqgdyIPnAsRrRhik+JvxaDRYTDP7v9ccvwX1OpBMAxQb/e5fUH/lM0HHZepYlku9aLKcQcIsAn9KWI/UH/Ke2SUID7hiXT7xl89TEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E0F421AEE
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 08:20:00 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8224E13B06
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 08:20:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EGxzH7B/tGbaDQAAD6G6ig
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Thu, 08 Aug 2024 08:20:00 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: "patches@lists.linux.dev" <patches@lists.linux.dev>
Resent-Date: Thu, 8 Aug 2024 10:20:00 +0200
Resent-Message-ID: <76367f1e-a36f-4e01-8a36-4e70654386c5@suse.cz>
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap1.dmz-prg2.suse.org with LMTPS
	id 4BHqAE6ys2aQJgAAD6G6ig
	(envelope-from <cl@gentwo.org>)
	for <vbabka>; Wed, 07 Aug 2024 17:43:42 +0000
Received: from smtp-in1.suse.de ([2a07:de40:b281:102:10:150:64:33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by dovecot-director2.suse.de with LMTPS
	id SHQ+AE6ys2boCwAAxW7PVg
	(envelope-from <cl@gentwo.org>)
	for <vbabka@imap.suse.de>; Wed, 07 Aug 2024 17:43:42 +0000
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(No client certificate requested)
	by smtp-in1.suse.de (Postfix) with ESMTPS id 4WfHbK2v4rzZKC
	for <vbabka@suse.cz>; Wed,  7 Aug 2024 17:43:41 +0000 (UTC)
Received: by gentwo.org (Postfix, from userid 1003)
	id 9391440254; Wed,  7 Aug 2024 10:32:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 928D540253;
	Wed,  7 Aug 2024 10:32:08 -0700 (PDT)
Date: Wed, 7 Aug 2024 10:32:08 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Pedro Falcato <pedro.falcato@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
    Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@suse.cz>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] slab: Warn on duplicate cache names when DEBUG_VM=y
In-Reply-To: <20240807090746.2146479-1-pedro.falcato@gmail.com>
Message-ID: <ad85f6ee-28a9-b558-2219-5a6e49e17b75@gentwo.org>
References: <20240807090746.2146479-1-pedro.falcato@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4WfHbK2v4rzZKC
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-0.40 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	FORGED_RECIPIENTS(2.00)[m:pedro.falcato@gmail.com,m:penberg@kernel.org,m:rientjes@google.com,m:iamjoonsoo.kim@lge.com,m:akpm@linux-foundation.org,m:vbabka@suse.cz,m:roman.gushchin@linux.dev,m:42.hyeyoo@gmail.com,m:linux-mm@kvack.org,m:linux-kernel@vger.kernel.org,m:pedrofalcato@gmail.com,m:42hyeyoo@gmail.com,s:patches@lists.linux.dev];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	FORGED_SENDER(0.30)[cl@gentwo.org,vbabka@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	FROM_NEQ_ENVFROM(0.10)[cl@gentwo.org,vbabka@suse.cz];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_CC(0.00)[kernel.org,google.com,lge.com,linux-foundation.org,suse.cz,linux.dev,gmail.com,kvack.org,vger.kernel.org];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Spam-Flag: NO
X-Spam-Score: -0.40

On Wed, 7 Aug 2024, Pedro Falcato wrote:

> Duplicate slab cache names can create havoc for userspace tooling that
> expects slab cache names to be unique. This is a reasonable expectation.

Yes that is reasonable. This is done during slab creation and so is not a 
performance sensitive operation. The sanity check could be done even 
without CONFIG_DEBUG_VM

Acked-by: Christoph Lameter <cl@linux.com>

