Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018842;
	b=hbXsc+cj9+LtWPaGqpS8f7XudFgeZQU0tmDDHgH0Qg10UBPCgQ0y4Jq2p5G8NYYzvkCp
	 XXTlCh9SsLB9tEBdoR5hjTt2YFMUgCzwSgCNGmXAz+znvtAuHNeQYXsxhPSvcTSAF8PR/
	 V5ojjb1STBA915pNHQFkxDra6K4MVNPIEbN/fHBVDrWXtwbcLsIjzTIl/cnDE4k3WPpK1
	 Yr3D953ndJY0aab296+Xim3o0r14voLXKUiLYVCGg9Dha5bv4xjAZqV30Z4bDK0yxEY3/
	 a1dsSDJLYi19MxvBbNd/1DmvfhDKbdkX62jhotx4vOnvrTO1P2sp4Wj6pfr/e8i7XoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ij9R7bwOFSHGeJVlwCoQSm0AhUjVL2wM1tV1VWaEX7U=;
	b=SmlP0Ti2r6BMKpf7gq2iXwXs/cE/l14dKPwkVKQWJ+4C9j6p4dCZV4DC7U/bs90DtzTg
	 3Pf2Tma4xry0f8jqUxYtiBUvc2mKrTu7QTSS89g8gpCruv8jPl9sKqibCbZXoZMKLn1Yt
	 ptkkyjVh9qlKWGDsFbhb2dXfzhKA9Rp8SApSB7EjPQWfT9kQf3irudWJdb1qomGd592LW
	 As1qdvgj1fAZz0WBqmJvNRItHjN3qGjNnQdo4mSIVdwx+ZXnoYk6hDPXW83HTVQl2gyRn
	 shhItWlNHZ9LEKgoUHQ4jly/5tT13Bd9Sd/AXY0JLrX6zftRE/9jKwi2MIsv096Zujg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ivOQzq79;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91BA606A325;
	Wed, 18 Nov 2026 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ivOQzq79
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373E91F000C4;
	Wed, 18 Nov 2026 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018842;
	bh=ij9R7bwOFSHGeJVlwCoQSm0AhUjVL2wM1tV1VWaEX7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivOQzq79nJOJFkF/wGr3LdfyTjz1knYx1P3U14F9fNoNx+xtrD7aekedXOn36F+T9
	 394HOiopYf5ht8mIleJYGDrufW7mWn39Wj/65stmObUOLxU4HlxXAfVb9k3SIa1QZW
	 F98+StlY0H8+l6LQi1Z+FRkbMMKfHKr3WIbopaz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1383/2651] NFS: return DENIED in decode_lock_denied if we cannot decode owner
Date: Wed, 18 Nov 2026 15:43:43 +0100
Message-ID: <20261118150337.809552847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

[ Upstream commit 4fdfe2312cbed99b1438dcf20b348e72393f9633 ]

After commit 43502f6e8d1e ("NFS: fix open_owner_id_maxsz and related
fields.") we dramatically changed the size of the LOCK/LOCKT reply buffer
from 164 to 52 bytes. This made visible a situation on a buggy NFS
server that sent oversized denied responses which led to us returning
EIO instead of DENIED.

Now, apart from buggy server issue, this poses an interesting question:
what if other implementations have legitimate but bigger than we expect
lock owner response, especially now that we have reduced the size we
allocate for it (20 bytes for the lock owner part).

This change proposes to tackle that issue returning DENIED instead of
EIO regardless of whether we manage to decode the owner or not:

- At this point of decode_lock_denied we know there is an owner.
- Server legitimately denied the lock request, with an owner that fits on
  NFS4_OPAQUE_LIMIT but we returned EIO instead to userspace.
- The owner data is decoded but actually never used, decode_lock path
  simply retries, and decode_lockt turns it into 0 on file_lock and
  returns it to userspace.
- LOCK/LOCKT are the last operations on the compound so it's not relevant
  if we didn't advance the pointer.
- Also removes an inverted likely(!p) hint.

Fixes: 43502f6e8d1e ("NFS: fix open_owner_id_maxsz and related fields.")
Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Reviewed-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index fc049ce4ba8ac..9d0f7ad7525a7 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -5169,8 +5169,7 @@ static int decode_lock_denied(struct xdr_stream *xdr, struct file_lock *fl)
 	p = xdr_decode_hyper(p, &clientid); /* read 8 bytes */
 	namelen = be32_to_cpup(p); /* read 4 bytes */  /* have read all 32 bytes now */
 	p = xdr_inline_decode(xdr, namelen); /* variable size field */
-	if (likely(!p))
-		return -EIO;
+	/* We have an owner here, return DENIED */
 	return -NFS4ERR_DENIED;
 }
 
-- 
2.53.0



