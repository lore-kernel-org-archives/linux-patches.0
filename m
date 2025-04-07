Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7BB21B8F8
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 20:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744056321; cv=none; b=scmZKoOQ4i9RKhgRIewA3rHh7JG3oWc5bHvBxg7Q6MztYGwKiLXyMlEegtbQztH6050Ko+wSfTZNYW7IrPUd9bxzj1WMM7iNdYHMUBeBWZoZZh9j3ZsWYgGj+ZKmJKOIFDZ0vc4mSWCRjjrqi04q7HkWKL0moFWeqj/7to+vqjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744056321; c=relaxed/simple;
	bh=NP+yHtjiA26BlPv4Bo3yN9TI5kAu4URcNDPeBV9A2/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OdEvfKmTaT0j+xwoFkeO4sYA+o+t7F1CC+kJb6SFndq5gyWoFWSUW/+cChpcvyYk6LqvSS52UwQnk/an02dk2rBhy3Zu13YYmx6h5Idsucgigp1hJXfTxRW9rROfbtEYBgSx9WoQVDBb3YfCvCTGRyCZ3I8P3WJCngvQFjPZtNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XK/XrRuI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ko8Gx4VV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XK/XrRuI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ko8Gx4VV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XK/XrRuI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ko8Gx4VV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XK/XrRuI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ko8Gx4VV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 756AA21171;
	Mon,  7 Apr 2025 20:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744056316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VuhCAbQSV1o1JMMT7kCYGC2V7mp5pOInaVYqF8BPnl4=;
	b=XK/XrRuI1j+fdKZEZQQ621/5KlH+uWek+1tRYBWbWMwCN3qJQzb21e4duE6+Ocemu6BAyE
	5mAAb1uBqWQ4XUFkg/Pw6TwN/dfyjB8YGB2AVL7fnA6aO7A9cBV3gdPfcGzqwDGEylei8d
	O2gjAKxD/F1KkFGqblLUoHmXhI5JRMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744056316;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VuhCAbQSV1o1JMMT7kCYGC2V7mp5pOInaVYqF8BPnl4=;
	b=Ko8Gx4VVbs46pnLDyF21asvIk13rf70QovJyIEqT+O4YW2MSGEw8djxYXDS0RDIultphfM
	8dIl3/4MsZX90hBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1744056316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VuhCAbQSV1o1JMMT7kCYGC2V7mp5pOInaVYqF8BPnl4=;
	b=XK/XrRuI1j+fdKZEZQQ621/5KlH+uWek+1tRYBWbWMwCN3qJQzb21e4duE6+Ocemu6BAyE
	5mAAb1uBqWQ4XUFkg/Pw6TwN/dfyjB8YGB2AVL7fnA6aO7A9cBV3gdPfcGzqwDGEylei8d
	O2gjAKxD/F1KkFGqblLUoHmXhI5JRMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1744056316;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VuhCAbQSV1o1JMMT7kCYGC2V7mp5pOInaVYqF8BPnl4=;
	b=Ko8Gx4VVbs46pnLDyF21asvIk13rf70QovJyIEqT+O4YW2MSGEw8djxYXDS0RDIultphfM
	8dIl3/4MsZX90hBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5EC2A13A4B;
	Mon,  7 Apr 2025 20:05:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U7/MFvwv9GclDQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 07 Apr 2025 20:05:16 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Subject: [RFC PATCH 1/2] MAINTAINERS: update SLAB ALLOCATOR maintainers
Date: Mon,  7 Apr 2025 22:05:09 +0200
Message-ID: <20250407200508.121357-3-vbabka@suse.cz>
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
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Flag: NO

With permission, reduce the number of active maintainers. Create a
CREDITS entry for Joonsoo (Pekka already has one). Thanks both for all
the work!

Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Thanks again both for all your work. Please let me know if you'd like to
adjust the CREDITS record while at it. Pekka has currently:

N: Pekka Enberg
E: penberg@cs.helsinki.fi
W: http://www.cs.helsinki.fi/u/penberg/
D: Various kernel hacks, fixes, and cleanups.
D: Slab allocators
S: Finland

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

