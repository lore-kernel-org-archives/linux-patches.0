Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4A3612E3
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 16:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706025949; cv=none; b=ZTjPXt4M9vfcPxCqzUY04VPVPNc5nfrZhIkzOEQ4PA0+zK4Jsc7LYJabnz186u1j9Uz392Ho1z3Re1vth1inimAljrCNBVShlrbolMRCi/wyafO/1/BXyt8K4Tp5yy8EHGa618euImkRkH/Pqudaq4QyrCgPx7bcT02ybXD8Pts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706025949; c=relaxed/simple;
	bh=lsDSqsAB17EL30f44k+DI5upW3nRQRPV/d/y8J+nIoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GZst3txuFInWX5lrlU6Iw4S3amdyGMg6E0Oh69yF31imQI5csFxrbvgWHc9uXuEJnrkwr3cPUkgHmQYBEt8uObT9ed5OcnIWU2QOpiNlGacyU7jVKbhaSlT85G5JfmySn2q7JREtIXSwibSLDdeBGj79WEicaJqBRf6hWi1lnOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RDWG7VCQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=p+IopjMY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RDWG7VCQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=p+IopjMY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RDWG7VCQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="p+IopjMY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RDWG7VCQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="p+IopjMY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BCDC922369;
	Tue, 23 Jan 2024 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706025939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J3PyYxRzifv0gmjvWYqW6SYPLIFuI67r85b+qsNKau0=;
	b=RDWG7VCQ5AEYatHDlTF9/pRuzfnctw89o1mkeG02uWOoIQAbeXCfjHMtnrY/ZwbBUg1iEW
	d0gEnr4mPLWhmwFe41eQP+nbBUkkziSdTwM1AOnSx702XUelKEq4G6TveyI28hjeXojz9Q
	tAo7i7JtzgEbkSF9hsNKEbUGNXLkrB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706025939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J3PyYxRzifv0gmjvWYqW6SYPLIFuI67r85b+qsNKau0=;
	b=p+IopjMYQqS7AJmYfU5OhPFVJvdSdYTnabN1MvQ4OJcNJzO4khHvFrLX31UXfytUiAU5vZ
	kO4rERMnvNZ3DsDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706025939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J3PyYxRzifv0gmjvWYqW6SYPLIFuI67r85b+qsNKau0=;
	b=RDWG7VCQ5AEYatHDlTF9/pRuzfnctw89o1mkeG02uWOoIQAbeXCfjHMtnrY/ZwbBUg1iEW
	d0gEnr4mPLWhmwFe41eQP+nbBUkkziSdTwM1AOnSx702XUelKEq4G6TveyI28hjeXojz9Q
	tAo7i7JtzgEbkSF9hsNKEbUGNXLkrB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706025939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J3PyYxRzifv0gmjvWYqW6SYPLIFuI67r85b+qsNKau0=;
	b=p+IopjMYQqS7AJmYfU5OhPFVJvdSdYTnabN1MvQ4OJcNJzO4khHvFrLX31UXfytUiAU5vZ
	kO4rERMnvNZ3DsDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86A93139B1;
	Tue, 23 Jan 2024 16:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UlU0H9Pjr2UGBAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 23 Jan 2024 16:05:39 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Mike Marshall <hubcap@omnibond.com>
Cc: Martin Brandenburg <martin@omnibond.com>,
	devel@lists.orangefs.org,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] fs/orangefs: remove ORANGEFS_CACHE_CREATE_FLAGS
Date: Tue, 23 Jan 2024 17:05:35 +0100
Message-ID: <20240123160534.6493-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.71
X-Spamd-Result: default: False [0.71 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[5];
	 NEURAL_HAM_LONG(-0.99)[-0.994];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Flag: NO

The flags were set to SLAB_RED_ZONE when CONFIG_DEBUG_SLAB was enabled.
With SLAB gone, this is now dead code so remove it. With SLUB, debugging
options including red zoning can be set for orangefs caches by the
slab_debug boot parameter.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 fs/orangefs/orangefs-cache.c  |  2 +-
 fs/orangefs/orangefs-kernel.h | 10 ----------
 fs/orangefs/super.c           |  2 +-
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/orangefs/orangefs-cache.c b/fs/orangefs/orangefs-cache.c
index 3b6982bf6bcf..e75e173a9186 100644
--- a/fs/orangefs/orangefs-cache.c
+++ b/fs/orangefs/orangefs-cache.c
@@ -22,7 +22,7 @@ int op_cache_initialize(void)
 	op_cache = kmem_cache_create("orangefs_op_cache",
 				     sizeof(struct orangefs_kernel_op_s),
 				     0,
-				     ORANGEFS_CACHE_CREATE_FLAGS,
+				     0,
 				     NULL);
 
 	if (!op_cache) {
diff --git a/fs/orangefs/orangefs-kernel.h b/fs/orangefs/orangefs-kernel.h
index 926d9c0a428a..e2df7eeadc7a 100644
--- a/fs/orangefs/orangefs-kernel.h
+++ b/fs/orangefs/orangefs-kernel.h
@@ -93,16 +93,6 @@ enum orangefs_vfs_op_states {
 	OP_VFS_STATE_GIVEN_UP = 16,
 };
 
-/*
- * orangefs kernel memory related flags
- */
-
-#if (defined CONFIG_DEBUG_SLAB)
-#define ORANGEFS_CACHE_CREATE_FLAGS SLAB_RED_ZONE
-#else
-#define ORANGEFS_CACHE_CREATE_FLAGS 0
-#endif
-
 extern const struct xattr_handler * const orangefs_xattr_handlers[];
 
 extern struct posix_acl *orangefs_get_acl(struct inode *inode, int type, bool rcu);
diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 5254256a224d..d5a71df63d4e 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -644,7 +644,7 @@ int orangefs_inode_cache_initialize(void)
 					"orangefs_inode_cache",
 					sizeof(struct orangefs_inode_s),
 					0,
-					ORANGEFS_CACHE_CREATE_FLAGS,
+					0,
 					offsetof(struct orangefs_inode_s,
 						link_target),
 					sizeof_field(struct orangefs_inode_s,
-- 
2.43.0

