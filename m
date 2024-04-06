Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F967FBC0
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 09:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712654901; cv=none; b=d63IdL7/QqZBwz2BCPeka2mKh+caV0apSsLmxhl3uHnwPUuuwVWZK9YrvqCntJ7ekb+txKbBRj54gmYMnnpx0+59h7exdbgQ8MSF/0w2ioKJ7PBymlIHYy/QzQp2QzEJqLtvm6Wzm9jPRoCqL1zY45cdE4ScDkmzM17+9kFS0Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712654901; c=relaxed/simple;
	bh=Z1Ml2k0JBvU/PRR+0Q8mkqwSS2bS8163enZmu/THs7c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FYbN7cA9ANahzBXGTmWA5wRwGThcmTCD7EMASCXwwTFMwSn0ROyVGQ3rodCa8dqiELBJ7sH2w9TQwBnGRHxF1lCCE/IfQEoLW7UEaHrdZ2av8Ljh4WXj01KYbTaEbcCBTvuNAN7xGjO3UObGfOUE0jXnZzY+5qkufP1aNUvJoDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CE2F6338E6
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 09:28:17 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6A22136D9
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 09:28:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xp0cMDEKFWYDXAAAD6G6ig
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Tue, 09 Apr 2024 09:28:17 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: "patches@lists.linux.dev" <patches@lists.linux.dev>
Resent-Date: Tue, 9 Apr 2024 11:28:17 +0200
Resent-Message-ID: <5c58b627-4471-46ba-a893-ced8c29d071c@suse.cz>
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.dmz-prg2.suse.org with LMTPS
	id aLy7FZb9EGbeWwAAn2gu4w
	(envelope-from <sangyun.kim@snu.ac.kr>)
	for <vbabka>; Sat, 06 Apr 2024 07:45:26 +0000
Received: from smtp-in1.suse.de ([10.150.64.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by dovecot-director2.suse.de with LMTPS
	id KGoIFZb9EGYQEgAAxW7PVg
	(envelope-from <sangyun.kim@snu.ac.kr>)
	for <vbabka@imap.suse.de>; Sat, 06 Apr 2024 07:45:26 +0000
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(No client certificate requested)
	by smtp-in1.suse.de (Postfix) with ESMTPS id 4VBS7k4NppzZvG
	for <vbabka@suse.cz>; Sat,  6 Apr 2024 07:45:22 +0000 (UTC)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1e3ca546d40so9421425ad.3
        for <vbabka@suse.cz>; Sat, 06 Apr 2024 00:45:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712389520; x=1712994320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfM6bwCPNBuCVqt7hQupQZM7S7lz7NOtLge1I68/si4=;
        b=mJwOvArRiivSJWu+oM6n3rQz4I0YVnF385Sfpemev3gi+haAcm7gR2WRXfjuntZLmM
         S20HUqeSsysxm2FsU6jfoGIbj3XrW4WyUqq5wWd5r6ubSnHM413uraIREtdIkBa9fNYS
         0Mqic2N5ELS4jq03fONLpJ7LFOvtoPiEAaZG5R8FDRSZRLXphOThzXPu52zLKJ9eDbg+
         VbMiefzWJzyrJDmAB66Qz4hdTH3XPR0Mlcl3Q/nBbntcpQ0fXILd4Zlf6330x9rWnEgB
         zpqv5m1xDdTuMT+eWSNNhofM4w9QpW/2vGNYkyr8ihcFlYbyNttLmxwkWwjMb3o62BlO
         PcpA==
X-Forwarded-Encrypted: i=1; AJvYcCXdhy8qkNkHeJtkI5m/peO4u5bFmHbdxuwSfOlFTvuxogW8hG/xLmgobsTHvIhbYtlgXxgZkAMDrUSHjyfQzg==
X-Gm-Message-State: AOJu0Yzcy/fB4VyA2u4MtCxadYSZLUs9Vpf2je+YwgXObcylCYwW10HC
	RL2rEhIdjb/DLANgPfPhlgtnIzL+5alKPXZM1kwUxYYIwoFnEOuaE6abDAs/G+I=
X-Google-Smtp-Source: AGHT+IF0SbuzsPcYrTB4Y6YXPcTY+8eHxJFRWS02s+dPaoex+DdT+h7M6b+lXcTfQQsXmKTLXSFiUA==
X-Received: by 2002:a17:902:f813:b0:1dd:c288:899f with SMTP id ix19-20020a170902f81300b001ddc288899fmr3037152plb.18.1712389520316;
        Sat, 06 Apr 2024 00:45:20 -0700 (PDT)
Received: from localhost.localdomain ([147.46.121.48])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902e54800b001e26b7a6785sm2844232plf.86.2024.04.06.00.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 00:45:19 -0700 (PDT)
From: Sangyun Kim <sangyun.kim@snu.ac.kr>
To: linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Hyunmin Lee <hyunminlr@gmail.com>,
	Jeungwoo Yoo <casionwoo@gmail.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Subject: [PATCH] mm/slub: remove duplicate initialization for early_kmem_cache_node_alloc()
Date: Sat,  6 Apr 2024 16:44:49 +0900
Message-Id: <20240406074449.563704-1-sangyun.kim@snu.ac.kr>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +
X-Rspamd-Queue-Id: 4VBS7k4NppzZvG
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: 5.09
X-Spam-Level: *****
X-Spamd-Result: default: False [5.09 / 50.00];
	FORGED_RECIPIENTS(2.00)[m:linux-mm@kvack.org,m:cl@linux.com,m:penberg@kernel.org,m:rientjes@google.com,m:iamjoonsoo.kim@lge.com,m:akpm@linux-foundation.org,m:vbabka@suse.cz,m:roman.gushchin@linux.dev,m:42.hyeyoo@gmail.com,m:sangyun.kim@snu.ac.kr,m:hyunminlr@gmail.com,m:casionwoo@gmail.com,m:gwan-gyeong.mun@intel.com,m:42hyeyoo@gmail.com,s:patches@lists.linux.dev];
	SUSPICIOUS_RECIPS(1.50)[];
	DATE_IN_PAST(1.00)[73];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	FORGED_SENDER(0.30)[sangyun.kim@snu.ac.kr,vbabka@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_NEQ_ENVFROM(0.10)[sangyun.kim@snu.ac.kr,vbabka@suse.cz];
	BAYES_HAM(-0.01)[47.41%];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_CC(0.00)[linux.com,kernel.org,google.com,lge.com,linux-foundation.org,suse.cz,linux.dev,gmail.com,snu.ac.kr,intel.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,snu.ac.kr:email];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]

The struct track for every object in a new slab is already set up by
new_slab(),
so remove the duplicate initialization in early_kmem_cache_node_alloc().

Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>

Co-developed-by: Hyunmin Lee <hyunminlr@gmail.com>
Signed-off-by: Hyunmin Lee <hyunminlr@gmail.com>

Co-developed-by: Jeungwoo Yoo <casionwoo@gmail.com>
Signed-off-by: Jeungwoo Yoo <casionwoo@gmail.com>

Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
---
 mm/slub.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0dfc0c18a78b..5ffe46843b36 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4938,7 +4938,6 @@ static void early_kmem_cache_node_alloc(int node)
 	BUG_ON(!n);
 #ifdef CONFIG_SLUB_DEBUG
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
-	init_tracking(kmem_cache_node, n);
 #endif
 	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
 	slab->freelist = get_freepointer(kmem_cache_node, n);
-- 
2.25.1

