Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618922;
	b=t0Xf8zxeSOoomkUtVMYpvmnwyh3JNPKDoO8gRE9TkOUq7i5MqecP2zfyRpaXDE47V+6x
	 hen7Th0iX4uXBBTCC2oP0UY7Z28/bSo8dkuMJ2SQZqlzHHXA2V+NgHEOvbcVAhvQhzDHm
	 Femux74B22ruuMO49Q9i2V/4eUFPf1yif3OQfbPxYVjRKtWWc86ldN2uDv0rEKG2enyFK
	 NLWjbTX7nzt4XY0UUJ6K6tcAF9m+cfvbG7X3rcOvQ+pTkEQ2utJ/GYb9sIG9GPcbSRYAk
	 kUdeniNzX3jcw9xedYukf+uyj+JJ9tN1J8Okf6OvgfxwKIEbuXHetS1ICj/Owp2z6YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s7LuOlLSgM4TrKoSiwbINLXAsH8Lk3M88NWf5mrpUxc=;
	b=EoOeb3h3qeEQ//B79whojEfgU7MlziWVgmILRrH4vaGyeiZo3LqHPI56CnzyN6raShB7
	 NqQlYwqYchUcskiWA/AawxddBBJPKSB8O8Pd+VLPP2wB2Gly3OljWl6wVxs5cPaA2QzMP
	 zr4Y/+rwyL1neGqgVV80txaYYqBJEJlJaPrxBWUFbtpEYrVQalt9ZYsChtCK92Z33PbUH
	 3avjbLFvC5M1Ws4pPzbW8nn6MC/k/2yspuofjIyEflG17wsTOCaLgb2k+AuWt0ReWBC3q
	 UcoFwHB5rbZgHV5tpUaEBiI6ZhsS1q9avh9zSpd4P6FDaZhLyTZiUo/qBdXz3QunoHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QF7ah7jn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0960E606A31E;
	Wed, 25 Nov 2026 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QF7ah7jn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595B11F000D0;
	Wed, 25 Nov 2026 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618921;
	bh=s7LuOlLSgM4TrKoSiwbINLXAsH8Lk3M88NWf5mrpUxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QF7ah7jna0beYxZr1twIrWRxP1Vagdb7QvkEupsfTk3QOl7o/sbhzy4zp+afEy6q9
	 13GtsHTvVddXtFmjCls9YcADzyO16rMOBAbyRpON4bK7auaZLaYkLoMNKzdSLG6LOf
	 3GmICAMWAcdEIu97s6WtRmhHiM3z5XDcakMrTmQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0431/1005] NFS: restore directory index when resuming readdir
Date: Wed, 25 Nov 2026 15:29:29 +0100
Message-ID: <20261125143831.848657575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 89b91409b2342e7629b1271eba315a0f06495247 ]

nfs_readdir() restores the cached folio index and cookie when
resuming directory iteration, but leaves current_index at zero.
In 32-bit index mode, nfs_readdir_search_for_cookie() then
reports a folio-relative offset instead of the absolute entry
position.

Restore current_index from the saved logical folio index before
searching the cache.

This solution relies on the current behavior of
nfs_readdir_seek_next_array(), where folio_index advances by
one and current_index advances by nfs_readdir_array_maxentries()
for each full, nonterminal folio.

Fixes: f648022faa68e ("NFS: Convert readdir page cache to use a cookie based index")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 2bf5fa015b851..ea95522f9c64b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1253,6 +1253,8 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	spin_lock(&file->f_lock);
 	desc->dir_cookie = dir_ctx->dir_cookie;
 	desc->folio_index = dir_ctx->page_index;
+	desc->current_index = (loff_t)desc->folio_index *
+			      nfs_readdir_array_maxentries();
 	desc->last_cookie = dir_ctx->last_cookie;
 	desc->attr_gencount = dir_ctx->attr_gencount;
 	desc->eof = dir_ctx->eof;
-- 
2.53.0



