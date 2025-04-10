Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DE41D5143
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 09:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744275638; cv=none; b=R/HRG+UJASB6kt4VOiCXazMdWiibLvjx5jppv1Bx2VqvYtMpT27ELe5+mzmG3oXPjKdGcf+u43qF7Aov2w+4WsNLfugamxb3R7HDbC8ZRhdjnv1kDirKwg/cKOzqPYMMvmCzWlFwraA2JzyU18mkIGF3nYBegp30oTwHioliblk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744275638; c=relaxed/simple;
	bh=t7BOttEgzanFiW6Dc+oFJ7dUkC97wSoKW4/xNET1DTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qd2ufb841ZXPwP/sKrwVZMAleim/dQqdJpQFCm1zHMwAYLlQU7T3VxcXQry2NRlRu9CSJesm+KtBS2IW1H2ca8IYPBOPFujhZ0OzRfhtZnExyO3zA8pKZD9DmhpaHuYTFIH29yWbG+p5nqVSlrPvmpH7DenaKbFJjMm65TB+Q8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FGv+AO9m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oHlkGmum; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FGv+AO9m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oHlkGmum; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FGv+AO9m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oHlkGmum";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FGv+AO9m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oHlkGmum"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1C03E1F441;
	Thu, 10 Apr 2025 09:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744275635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NCW58uFTAN5+TrdqG7ZoxLkVoRVXQjENEOy4DXJ/hG4=;
	b=FGv+AO9mdjLjWwAUCCnC6XlklYeOyepRbypdjRIu0nkMdLRpMy1NB2AHXGUBkUQMAmBS2F
	K9CxXx9ht9m5OMIzUEXbpRTdgzLb2TQUEUY2sRxbXDgk6k+BizRliXY6hjfcqCrbpGP5V4
	LFkIHkSru/CfD0WNZTZXhjKxyh7f+Z4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744275635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NCW58uFTAN5+TrdqG7ZoxLkVoRVXQjENEOy4DXJ/hG4=;
	b=oHlkGmume1mmRpAdFaakLb3YTwAhuHIMZrq8gqAZNJe0mMdL8oAViSOuigfi7J3iVHE0vt
	zwdPqg1S9CogJBAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744275635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NCW58uFTAN5+TrdqG7ZoxLkVoRVXQjENEOy4DXJ/hG4=;
	b=FGv+AO9mdjLjWwAUCCnC6XlklYeOyepRbypdjRIu0nkMdLRpMy1NB2AHXGUBkUQMAmBS2F
	K9CxXx9ht9m5OMIzUEXbpRTdgzLb2TQUEUY2sRxbXDgk6k+BizRliXY6hjfcqCrbpGP5V4
	LFkIHkSru/CfD0WNZTZXhjKxyh7f+Z4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744275635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NCW58uFTAN5+TrdqG7ZoxLkVoRVXQjENEOy4DXJ/hG4=;
	b=oHlkGmume1mmRpAdFaakLb3YTwAhuHIMZrq8gqAZNJe0mMdL8oAViSOuigfi7J3iVHE0vt
	zwdPqg1S9CogJBAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04EF813886;
	Thu, 10 Apr 2025 09:00:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C3zpALOI92fqEQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 10 Apr 2025 09:00:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Christoph Lameter (Ampere)" <cl@linux.com>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH 1/2] MAINTAINERS: update SLAB ALLOCATOR maintainers
Date: Thu, 10 Apr 2025 11:00:22 +0200
Message-ID: <20250410090021.72296-3-vbabka@suse.cz>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

With permission, reduce the number of maintainers. Create a CREDITS
entry for Joonsoo (Pekka already has one). Thanks for all the work!

Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Christoph Lameter (Ampere) <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/CREDITS b/CREDITS
index 1b77fba6c27e..f74d230992d6 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2071,6 +2071,10 @@ S: 660 Harvard Ave. #7
 S: Santa Clara, CA 95051
 S: USA
 
+N: Joonsoo Kim
+E: iamjoonsoo.kim@lge.com
+D: Slab allocators
+
 N: Kukjin Kim
 E: kgene@kernel.org
 D: Samsung S3C, S5P and Exynos ARM architectures
diff --git a/MAINTAINERS b/MAINTAINERS
index de97cd54ff24..4fe7cf5fc4ea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22240,9 +22240,7 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Christoph Lameter <cl@linux.com>
-M:	Pekka Enberg <penberg@kernel.org>
 M:	David Rientjes <rientjes@google.com>
-M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
-- 
2.49.0

