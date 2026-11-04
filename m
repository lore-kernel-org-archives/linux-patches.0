Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831726;
	b=HSKfKJcaJuU/+BLvyk04NAGcpcAAEiSH8EFcrM4y8Q/+hWqhZuUTS6FYQEMMQCtD/yYp
	 pkC2FCwekEg2mo7ob2HSlaB5tRtkbQlRKggblazFW7ZhRnv4cPVXO17yZzIwvtVHB3Bnw
	 GUKzJLYA19/CLY/m+U5Uuw+5MT97ipSZ6365UiEwE35w9b3b3cR2lRoZXZeArs8Di3wxx
	 GEUERol1sRBQ9Hm+Cq0gH3EXH2kMJ316BKGN+f3q8cq9mvHaoeo+KctzvImOHYeM+WJR7
	 oJs67YhJQrtUuJx9eqIqNpDKyB/jt405WFosl5hIarb8F2RP099NSEJz99ayLja0waA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3fojTfqAgojNcMHdFyHVxjGoM8XE0fBJ8d3y7aYrZVM=;
	b=mJRNZvyHCd7xZ4/OdNw6LsSK76JxlmveBon6pnN5oX7NiewRCu6wdNOQ39JNj+j1GBKQ
	 P7svMDSIau01nPTyP6858JcXLVEKIbVh2yzNGjCh4DV4M6mpUvukftvjYrC8p4fkRlujj
	 akogw2Twz6HPtjOXJ/ClHhOUavTbY5gkPbakTomj9/4/vNTeouFR/Kr1WjjjBth1WtwWj
	 jCzQqrx7CacExrMvbdoAe4evBQVwgfxYw3JP0t7dGhh0z4Wf/oXu/EVHbsOhgeL/7wgrc
	 jwzN3Bmm0cp4xEOjqaS8MiWi1dDV7dNwXvDnsGHdsS729qOgIAsSfVAEOZYabIxqA/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uz6TgPOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F27D606A842;
	Wed,  4 Nov 2026 22:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uz6TgPOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BBC1F000C1;
	Wed,  4 Nov 2026 22:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831726;
	bh=3fojTfqAgojNcMHdFyHVxjGoM8XE0fBJ8d3y7aYrZVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uz6TgPORl5Bo44U+/+eQWoQU6hhr3shoOJ043uhDdQYjAZ0wLpJSCwTvG43WuxSwQ
	 KKb+MbG6ThX4gV1psSRkTV67BXGcoZ0XUwr9UdpcofmgigzeFwIPB9NDu4wawuc2n0
	 gMZ2pXsYichFWmg7DEy4JClT1Qis+9zu67JwhS/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 0876/1005] NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL from LAYOUTGET
Date: Wed,  4 Nov 2026 16:10:09 -0500
Message-ID: <20261104211107.790389664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 28c950413605fb5b6cb3863c5e3274ea69701097 upstream.

If the layout for the requested range is larger than the size the
client advertised in loga_maxcount, RFC 8881 Section 18.43.3 has the
metadata server return NFS4ERR_TOOSMALL.  The client caps
loga_maxcount at a single page, so a flexfiles server that stripes a
layout segment across several dozen data servers produces this error
today.

The client has no handling for it: nfs4_stat_to_errno() maps the
error to -ETOOSMALL during decode, which nothing in the layoutget
path recognizes and nfs_error_is_fatal() does not consider fatal, so
pnfs_update_layout() clears the layout fail bit and returns no
segment.  The I/O falls back to the MDS, but because no fail bit was
set, every subsequent pageio attempt sends another LAYOUTGET that is
doomed to the same NFS4ERR_TOOSMALL.  Files whose layouts do not fit
the reply buffer never use pNFS and pay an extra round trip on every
pageio.

Map -ETOOSMALL to -EMSGSIZE in the layoutget exception handler and
have pnfs_update_layout() treat it like NFS4ERR_LAYOUTUNAVAILABLE:
mark the layout mode as failed and fall back to I/O through the MDS.

Fixes: d600ad1f2bdb ("NFS41: pop some layoutget errors to application")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    8 ++++++++
 fs/nfs/pnfs.c     |    2 ++
 2 files changed, 10 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9938,6 +9938,14 @@ nfs4_layoutget_handle_exception(struct r
 		status = -EOVERFLOW;
 		goto out;
 	/*
+	 * NFS4ERR_TOOSMALL means the layout for the requested range
+	 * exceeds what the client advertised in loga_maxcount (see
+	 * RFC8881 section 18.43.3).
+	 */
+	case -ETOOSMALL:
+		status = -EMSGSIZE;
+		goto out;
+	/*
 	 * NFS4ERR_LAYOUTTRYLATER is a conflict with another client
 	 * (or clients) writing to the same RAID stripe except when
 	 * the minlength argument is 0 (see RFC5661 section 18.43.3).
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2319,6 +2319,8 @@ lookup_again:
 			break;
 		case -ENODATA:
 			/* The server returned NFS4ERR_LAYOUTUNAVAILABLE */
+		case -EMSGSIZE:
+			/* The layout exceeded loga_maxcount (NFS4ERR_TOOSMALL) */
 			pnfs_layout_set_fail_bit(
 				lo, pnfs_iomode_to_fail_bit(iomode));
 			lseg = NULL;


