Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7973A187FF1
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 08:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723105204; cv=none; b=ikI8h2WUZFhPC6xhsd0t83uXTaP2k2FThdMyGuchE7njBZ0tnoKKi7vPjWqbs6JIGK2baEFxkiDMHYDoYE7poyTjgjuj5//BxV+w6NX/3UyPU5VhXdPYxpQLUHeIf4FKny2n10o/xDRWoMUsSsvfwEDBMTIAiUftloyYTHVjwUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723105204; c=relaxed/simple;
	bh=qwNB2tjS13f2zdPuw8e/z1JrEZSg+Ef+xOcyvFNduPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J0D4HY4uq6+61Enk/f2eIYfRzIf0j80eVHLBpc8WUWpmT2LPHs8YivAQf+cG/dVBWkkUJl1oKa78nXXlVy3ru+ZI0GE+KIfIbA410l8ilrqNkKWQJNTZACFhPBLcPdtXw4cWSHo02irZpVKSRD9ohP0TKvvlsCgq8TLAakbDhjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 83DF11F365
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 08:20:00 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	dkim=none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 727F313946
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 08:20:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +uI+G7B/tGbaDQAAD6G6ig
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Thu, 08 Aug 2024 08:20:00 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: "patches@lists.linux.dev" <patches@lists.linux.dev>
Resent-Date: Thu, 8 Aug 2024 10:20:00 +0200
Resent-Message-ID: <b5037b18-e05f-4adb-8560-e6299df092e1@suse.cz>
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap1.dmz-prg2.suse.org with LMTPS
	id 6ClXKGc5s2YxBQAAD6G6ig
	(envelope-from <pedro.falcato@gmail.com>)
	for <vbabka>; Wed, 07 Aug 2024 09:07:51 +0000
Received: from smtp-in2.suse.de ([10.150.64.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by dovecot-director2.suse.de with LMTPS
	id EPyoJ2c5s2bSFwAAxW7PVg
	(envelope-from <pedro.falcato@gmail.com>)
	for <vbabka@imap.suse.de>; Wed, 07 Aug 2024 09:07:51 +0000
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(No client certificate requested)
	by smtp-in2.suse.de (Postfix) with ESMTPS id 4Wf4872bT4zZLt
	for <vbabka@suse.cz>; Wed,  7 Aug 2024 09:07:51 +0000 (UTC)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-530ad969360so1964381e87.0
        for <vbabka@suse.cz>; Wed, 07 Aug 2024 02:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723021671; x=1723626471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9aekX4Ai49itZEMXwDFZ07/9+NmTVOLMBb1LFbpcmU=;
        b=bNoLn/3Y32XPVuhVt0bdKBj14yAkiBn2BsZ0Yg1Kve3RR1F4ImyMk+uWdcZmFNMhGi
         0jKpq8AVf0mbrisVY++sYDgYJJ5KCHBiRHYrxjBRQ43rd87hN4VrvK6VF4VPxEQ/gUz+
         qPpvGNiMVfI72LjsOIy8NDcdZln+MaxX89Rj1i25EJBFxQ+3K7ZIxUGOU7fk0jEPHvgE
         3Vh9hTdSlOsAVME11UNNVSBiJXgxp42JbUFf9xoW67pvS5TT2Ruu7qcVgOcEmTXO7J3O
         SIvzSZbwgZvzIgPa0qK5c1/4w0yS+XeCiW8V0F9Uoz9pTMAFlUjJLAaiu5CIIZ+B6VTl
         5Bqw==
X-Forwarded-Encrypted: i=1; AJvYcCUbY5jTCIx7N5pyZ3cypeSEcNi5pOw0tw372vPWWoq9FOeTMWMTllDwQJsVDo6CpEvNwsd1EL/xUx1oQbEhyg==
X-Gm-Message-State: AOJu0YwFcgUH+i11aJ2/eOUHyykSOja2RMfzBRN0hMnaXfa06YbzRlId
	+fElHITQBnU0WGPdc6XQlllFLzpwmuKGCwA7VTM4jPQRezD0Z+a5
X-Google-Smtp-Source: AGHT+IG9tMVI6f5eJFxMYkpEPA7ctok0k184c63EXvKfi0/ajz/LpIWYpZT0XkILF/xv7TPfyZB4IA==
X-Received: by 2002:a05:6512:239e:b0:530:ae22:a6f0 with SMTP id 2adb3069b0e04-530bb3929c7mr13275760e87.5.1723021670163;
        Wed, 07 Aug 2024 02:07:50 -0700 (PDT)
Received: from PC-PEDRO-ARCH.lan ([2001:818:e92f:6400:96b:aa92:afc0:2d3d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd26fc0bsm15368722f8f.117.2024.08.07.02.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 02:07:49 -0700 (PDT)
From: Pedro Falcato <pedro.falcato@gmail.com>
To: Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH v2] slab: Warn on duplicate cache names when DEBUG_VM=y
Date: Wed,  7 Aug 2024 10:07:46 +0100
Message-ID: <20240807090746.2146479-1-pedro.falcato@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [3.31 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	R_DKIM_NA(2.20)[];
	FORGED_RECIPIENTS(2.00)[m:cl@linux.com,m:penberg@kernel.org,m:rientjes@google.com,m:iamjoonsoo.kim@lge.com,m:akpm@linux-foundation.org,m:vbabka@suse.cz,m:roman.gushchin@linux.dev,m:42.hyeyoo@gmail.com,m:linux-mm@kvack.org,m:linux-kernel@vger.kernel.org,m:pedro.falcato@gmail.com,m:42hyeyoo@gmail.com,m:pedrofalcato@gmail.com,s:patches@lists.linux.dev];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-0.61)[-0.608];
	FREEMAIL_FROM(0.50)[gmail.com];
	R_MISSING_CHARSET(0.50)[];
	FORGED_SENDER(0.30)[pedrofalcato@gmail.com,vbabka@suse.cz];
	MIME_GOOD(-0.10)[text/plain];
	FROM_NEQ_ENVFROM(0.10)[pedrofalcato@gmail.com,vbabka@suse.cz];
	NEURAL_HAM_SHORT(-0.08)[-0.379];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a00:1450:4864:20::132:received];
	TAGGED_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,gmail.com,kvack.org,vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Spamd-Bar: +++
X-Rspamd-Queue-Id: 83DF11F365
X-Rspamd-Action: no action
X-Spam-Score: 3.31
X-Spam-Level: ***
X-Spam-Flag: NO
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Duplicate slab cache names can create havoc for userspace tooling that
expects slab cache names to be unique. This is a reasonable expectation.

Sadly, too many duplicate name problems are out there in the wild, so
simply pr_warn instead of pr_err() + failing the sanity check.

Link: https://lore.kernel.org/linux-fsdevel/2d1d053da1cafb3e7940c4f25952da4f0af34e38.1722293276.git.osandov@fb.com/
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
---
v2:
 - Replace the pr_err() + failure with a simple pr_warn

Contrary to Vlastimil's suggestion, we don't seem to require a refcount
== 0 check, because shutdown_cache already synchronously deletes the cache from the list (even reusing
the same list_head for TYPESAFE_BY_RCU).

 mm/slab_common.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 40b582a014b..1abe6a577d5 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -88,6 +88,19 @@ unsigned int kmem_cache_size(struct kmem_cache *s)
 EXPORT_SYMBOL(kmem_cache_size);
 
 #ifdef CONFIG_DEBUG_VM
+
+static bool kmem_cache_is_duplicate_name(const char *name)
+{
+	struct kmem_cache *s;
+
+	list_for_each_entry(s, &slab_caches, list) {
+		if (!strcmp(s->name, name))
+			return true;
+	}
+
+	return false;
+}
+
 static int kmem_cache_sanity_check(const char *name, unsigned int size)
 {
 	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
@@ -95,6 +108,11 @@ static int kmem_cache_sanity_check(const char *name, unsigned int size)
 		return -EINVAL;
 	}
 
+	if (kmem_cache_is_duplicate_name(name)) {
+		/* Duplicate names will confuse slabtop, et al */
+		pr_warn("%s: name %s already exists as a cache\n", __func__, name);
+	}
+
 	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
 	return 0;
 }
-- 
2.46.0

