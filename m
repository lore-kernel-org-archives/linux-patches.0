Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025674;
	b=xSZGIEQ/3MCXg7cpjQ3/uDVCZKGnqTp/KaChh0HoTve5HDghsFrsVJkLYCKU7pKIKN33
	 MsfNYM+HnibV9l5Rrj68QS10uE187Uj5Ecv6duoz9FwdeXUjdUrRZ+nqDNjg81V/3wcvt
	 HIDzBbG8WTDL40l5CqBsvPl2uKwHbz2lsCryZfHjsTIKgW9v6Fp6sTJO8NRBDU+Eo7DPx
	 4enkpLrgu/ka/QrboIR1hxjsi87H90s63i34DBuE2WsytqVrVkB0FEcy5yg8EkwD1Lk8q
	 dTueeioo2iRMiyeoGhqM1DULgCPHtUJxX82yafsszxFQ/cKXufERabcNdmAsRuWBrGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jvMhoP9r5hMcktvay//fXFKQmAjxVGx3at+S9xN3DnA=;
	b=vMatSvII9UrrIdY9aDcWVnh5sF1M3kytZdmQVXg/viX+psi161h+ruorQ8VWUxFJI0e+
	 vHAouiTe5e8GVSNWd34MkUO06OLB+6BuI+oTf98VmruBcWR514iYlGERATA/5tJzXrILv
	 1GbPAGec6SeHx5gVRh03CuoGrzSBtcTifqvYlWOPLqExyTt6vlhPGdPOuR2khFnw/Fzvj
	 BjaAfSGhuwbhPyaMlVARJ4DmBYqAz6gEQySSEI5M98KJZ0oXED7nXw8YpVFjQ6OeHwOuF
	 VHSc6JS11SgATBufqDUvr2/2E3D/fJjjz64v5eLYkadY6s2oLQbhzTlG/CSFHkgkelg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uO2aIEVb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF4C606A31C;
	Wed, 18 Nov 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uO2aIEVb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203471F000C6;
	Wed, 18 Nov 2026 18:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025674;
	bh=jvMhoP9r5hMcktvay//fXFKQmAjxVGx3at+S9xN3DnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uO2aIEVbDoWq2OR3qi3KXiV/ONI5s9JiYTMprLnlYenKHt396Lmod4irebeki7+Yo
	 l5iY1mLYs+7FSns1vHBIEeX/6EJxBC447qKBfDkkhPAprtahupq/VmTc11Oc7OD9h4
	 URdqgwsGESsAikuTUqJ27htl8TndeCXYTQ0zRBGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1164/2151] NFS: return DENIED in decode_lock_denied if we cannot decode owner
Date: Wed, 18 Nov 2026 15:48:19 +0100
Message-ID: <20261118150204.557655429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 1d0e6c10f921f..d7875e7171927 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -5126,8 +5126,7 @@ static int decode_lock_denied(struct xdr_stream *xdr, struct file_lock *fl)
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



