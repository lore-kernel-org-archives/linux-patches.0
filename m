Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6F08002F
	for <patches@lists.linux.dev>; Thu,  2 May 2024 12:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714654471; cv=none; b=i0xlwLXoONL2uO4nFmLvtgGOO2eUtwHRVxJem1wbSiD2T2+r7oR8TsvvcPwb9Yc3KAqB8Kn2uUiz/1QPAXugCpPlZT00oVnAvDutwc3DzgnEJgy4szW88VsJlpDPUG8KAQXRFYDhL1+eDJNxDSDU/CbtNKtYRTDxsv/Th0gR0JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714654471; c=relaxed/simple;
	bh=kdTygrnQamEcPVIK/OrF2PvSBzUbW01roETIuHUe1sA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gFRB17F3/DVj5YPB7r658a2gGVG42ir9DXZde7hz04jgFzx5WfgCJ2KAFQc+fUJXPXNHw3l9pzoSlFZRWw4HKlJ3rapQR8Yg46mjyidtFMkiRfjLy2gmRwmgnLZuVcgHpbIRL+S0Zto3frFUH3WI5+5fZQbdOU/hU86+8izrKq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CEFA1FBFB
	for <patches@lists.linux.dev>; Thu,  2 May 2024 12:54:28 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	dkim=none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12E891386E
	for <patches@lists.linux.dev>; Thu,  2 May 2024 12:54:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9SRlBASNM2Z4QwAAD6G6ig
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Thu, 02 May 2024 12:54:28 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Thu, 2 May 2024 14:54:44 +0200
Resent-Message-ID: <ddb8bf85-07b4-4a46-929f-08ebd546f1e1@suse.cz>
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap1.dmz-prg2.suse.org with LMTPS
	id 0NBRIXQRKWY5DgAAD6G6ig
	(envelope-from <hyunminlr@gmail.com>)
	for <vbabka>; Wed, 24 Apr 2024 14:04:36 +0000
Received: from smtp-in2.suse.de ([2a07:de40:b281:102:10:150:64:34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by dovecot-director2.suse.de with LMTPS
	id 0D6ZIHQRKWaZGQAAxW7PVg
	(envelope-from <hyunminlr@gmail.com>)
	for <vbabka@imap.suse.de>; Wed, 24 Apr 2024 14:04:36 +0000
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(No client certificate requested)
	by smtp-in2.suse.de (Postfix) with ESMTPS id 4VPgj01jDwzZKt
	for <vbabka@suse.cz>; Wed, 24 Apr 2024 14:04:36 +0000 (UTC)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1e36b7e7dd2so61747745ad.1
        for <vbabka@suse.cz>; Wed, 24 Apr 2024 07:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713967474; x=1714572274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FViU9jyfzCFR5MEL9rTk4PcZNeirlAKIqNLHVix/Crs=;
        b=RQtHxxfTLBPi+fEWEED136qim/bFcr/W8DGTdq8J7sIx9ISfHnlT9z0WAC2uvmk7SP
         79gnIlsmqehn2gNG79+2VeTA7cMpv//Kv9xofrsMsXsNr4eEdYBq4lXzxDaiy/K+XReT
         cAxX5Oxdgs5KdjhDVZ3FNlB/RMssQmRHgbU7QvgALkrQqNlq9orr47vlg22L1lXEKcM9
         E+SVvoHLHwzZ3q7VW92KWXxNHZ70aONrrNwbtqqXNBcQrACCwHeZfGOXSkew80kCCci9
         4b9J3pfIG+2aEz6PEJWbau2q8mZT0SdbOMSN/N9VTTZM5HMf450KUHYr0cA60YxxdHxF
         1+Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUgTyksmTLfjB0DyDM42sopDC7R9C3sQ4W9Vlz9InIk3ahtcenfg5ZAUHH1BbwozngFIafyPUrJW/500Dj1yg==
X-Gm-Message-State: AOJu0Yw+cS949/IRoB5VJzb2nBVEy/+jqBJ3k8Rjtxjfq8G5mnaYjEiE
	T8Wj6VHCoWM0k/P1GIupdbfjvsfTG/VCLkqD9zIRVQKPJrTYIAxQ
X-Google-Smtp-Source: AGHT+IHZAfkdw62kJUU3hLW0ohTsyp139fuDW2qL4SOXcp1p9DDB97BFe919Y1zQFLNdlY9/D1MNtQ==
X-Received: by 2002:a17:903:1252:b0:1e5:5be7:be86 with SMTP id u18-20020a170903125200b001e55be7be86mr2745190plh.52.1713967474341;
        Wed, 24 Apr 2024 07:04:34 -0700 (PDT)
Received: from MinsLaptop.localdomain ([125.177.3.166])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902bf4900b001e26b7ac950sm11891042pls.272.2024.04.24.07.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 07:04:33 -0700 (PDT)
From: Hyunmin Lee <hyunminlr@gmail.com>
To: linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Jeungwoo Yoo <casionwoo@gmail.com>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Subject: [PATCH v3 2/2] mm/slub: remove the check for NULL kmalloc_caches
Date: Wed, 24 Apr 2024 23:04:22 +0900
Message-Id: <20240424140422.12780-3-hyunminlr@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240424140422.12780-1-hyunminlr@gmail.com>
References: <20240424140422.12780-1-hyunminlr@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: ******
X-Spamd-Result: default: False [6.74 / 50.00];
	FORGED_RECIPIENTS(2.00)[m:linux-mm@kvack.org,m:cl@linux.com,m:penberg@kernel.org,m:rientjes@google.com,m:iamjoonsoo.kim@lge.com,m:akpm@linux-foundation.org,m:vbabka@suse.cz,m:roman.gushchin@linux.dev,m:42.hyeyoo@gmail.com,m:casionwoo@gmail.com,m:sangyun.kim@snu.ac.kr,m:gwan-gyeong.mun@intel.com,m:42hyeyoo@gmail.com,s:patches@lists.linux.dev];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	DATE_IN_PAST(1.00)[190];
	NEURAL_HAM_LONG(-0.96)[-0.956];
	NEURAL_SPAM_SHORT(0.91)[0.302];
	FREEMAIL_FROM(0.50)[gmail.com];
	R_MISSING_CHARSET(0.50)[];
	FORGED_SENDER(0.30)[hyunminlr@gmail.com,vbabka@suse.cz];
	FROM_NEQ_ENVFROM(0.10)[hyunminlr@gmail.com,vbabka@suse.cz];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	BAYES_HAM(-0.00)[22.96%];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_DN_SOME(0.00)[];
	R_DKIM_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:102:10:150:64:34:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_CC(0.00)[linux.com,kernel.org,google.com,lge.com,linux-foundation.org,suse.cz,linux.dev,gmail.com,snu.ac.kr,intel.com];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Spam-Flag: NO
X-Spam-Score: 6.74
X-Spamd-Bar: ++++++
X-Rspamd-Queue-Id: 1CEFA1FBFB
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

If the same size kmalloc cache already exists, it should not be created
again. So there is the check for NULL kmalloc_caches before calling the
kmalloc creation function. However, new_kmalloc_cache() itself checks NULL
kmalloc_cahces before cache creation. Therefore, the NULL check is not
necessary in this function.

Signed-off-by: Hyunmin Lee <hyunminlr@gmail.com>
Co-developed-by: Jeungwoo Yoo <casionwoo@gmail.com>
Signed-off-by: Jeungwoo Yoo <casionwoo@gmail.com>
Co-developed-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
---
 mm/slab_common.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index ed7b8592b62c..0f2675f421e9 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -917,16 +917,14 @@ void __init create_kmalloc_caches(void)
 	 */
 	for (type = KMALLOC_NORMAL; type < NR_KMALLOC_TYPES; type++) {
 		/* Caches that are NOT of the two-to-the-power-of size. */
-		if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[type][1])
+		if (KMALLOC_MIN_SIZE <= 32)
 			new_kmalloc_cache(1, type);
-		if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[type][2])
+		if (KMALLOC_MIN_SIZE <= 64)
 			new_kmalloc_cache(2, type);
 
 		/* Caches that are of the two-to-the-power-of size. */
-		for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
-			if (!kmalloc_caches[type][i])
-				new_kmalloc_cache(i, type);
-		}
+		for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
+			new_kmalloc_cache(i, type);
 	}
 #ifdef CONFIG_RANDOM_KMALLOC_CACHES
 	random_kmalloc_seed = get_random_u64();
-- 
2.34.1

