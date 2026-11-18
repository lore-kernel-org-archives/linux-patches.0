Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031185;
	b=ntbEw+Dodrgis8X9+tRNRy0mshwSuiEG5I8x20xAhca3Jpt2MZ/Oq2ya6Jr01gt71j6j
	 XM35rtjYtBqmy72qWXcH7NsrDPFePghviTZclvXEhNoE/VjI3bUgDXEhNpemSyy1BbqI1
	 8w4/Yi1pD7HeiXafD+ZSTuyw70/gfJHvWqzpkQ+zf+NT5Gbxy1UoPNNbWoXKJHp6Pw0Sf
	 TF2rF7VB+R64Y0/N0rWMswfXpObHXqzhAGHQkZVEK9emfE6yntIYIFXJca9HpPeZmhOlu
	 zsNDBay2Cfg9lGfkowOcMx9P2M6DdjobH6l7miPJXeI+DTwrEtivb/LW35qAoepDZSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VkK4vmjwKgA6KWxoY0b95G6iVYcqokVh5KN75xSib9M=;
	b=ZBBm3ZZ5kheCz53UvhALvUzZE8nZlfgUhjj4gEUd+zFuXuClUU8p8IO9zVtgpJ45kL9k
	 D8qm3+OjbbjDISNIKRPHsbiVRHW6N1cJfy5s1wfw5pdYZdjlFoIy5mwGjXoJTYvwL75d9
	 RY8vXVbfj4ToqHT6U4zJI4Q4kVl0Rdg8VrejNN4JYu3nYKK66LAPxHjl0W5xG0w+ZZ1rw
	 xJyKkk/A6uKUisYYhhOiPpN1dG8D/obfOW3J2LQ0P2IMav1SoyOlClicf8ccF4MOO5Nxb
	 JJLUU71V9i6QPXfInt69Ke17Ql2bgFLSjn61kk2rgEl6t+bGs/j3i7QZM4/BEU3LgXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2OTodHo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B181606A32A;
	Wed, 18 Nov 2026 19:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2OTodHo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F2C1F000C8;
	Wed, 18 Nov 2026 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031185;
	bh=VkK4vmjwKgA6KWxoY0b95G6iVYcqokVh5KN75xSib9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2OTodHo6Tlnjs0xpDK8rHCm7AxhoSfKHmygPV6PgXJhPls/y/K0aiJn/uJ0jHtqg
	 0ESaFa4mrSd+9OXhuLiCrPcrPKqShL1DJqBR8AlqUhP2AqvoFK6Js+fsMN26yvX8pH
	 QHfX4SaVPVD56FP5NHCONPDVlmY27cbNRm76kEgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0927/1756] NFS: return DENIED in decode_lock_denied if we cannot decode owner
Date: Wed, 18 Nov 2026 15:50:54 +0100
Message-ID: <20261118150046.865431266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 71f45cc0ca74d..1fbe66b460b3f 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -5102,8 +5102,7 @@ static int decode_lock_denied(struct xdr_stream *xdr, struct file_lock *fl)
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



