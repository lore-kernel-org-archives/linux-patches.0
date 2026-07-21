Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD34414A1C;
	Tue, 21 Jul 2026 19:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660426; cv=none; b=QmMmHPXKedh4tCljIib1APr0MZQ5/f1swINcZQo/oajJWy+Rlkrqlkuk9em3jUDhfTBl2mn3jsCUOhQ2ZnGnYvV8OVeoC31hKa9qGOe88hIXXYfoOnDAxyssaoWgOzCXEOu//8QduQgQp3Kj9AZGkeTiFVYffSKOQDhje0r7rFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660426; c=relaxed/simple;
	bh=ovoEvgywTEtqgf4CHDRmkPf5cQDyo/K2KRv7/ZGgRVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWrgtI1EDfI7c4GGaLKJA1Yc9ZG67tSkX6BrUd1d/3/BEv+PeOM2K2fv1WtUqc0MVYPceNJqgoy4cc+2sqWw/KfxtZj+HZJG2ZEtPW6v1g3arj2TzyzSPY0BUDMaab3lhVBIW5DRtiF3+N9YS2fv5SwxWpgKHid/xAq2KM3/rw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+BoKPeN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+BoKPeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07451F000E9;
	Tue, 21 Jul 2026 19:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660425;
	bh=odoSmXTzf6EfESdeGWbPUHDKsZOrqVEIflx1EKXXaZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+BoKPeNVbMs5TxJR1vFkjnn4G9PRoloWw3+pu+gQJGcD5a5dcN327k0Xth74behJ
	 bRv+Zja5GYLgsdygDUnQNscVH8gW6+CpybMUxKrIKz/2M875uPqS/xtqKuaoBw0EXm
	 QtEvtjhDBN09aXhSGGwN7ZKsFTPlRLZiAChEvQFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0976/2077] lockd: Correct kernel-doc status descriptions for NLMv4 GRANTED
Date: Tue, 21 Jul 2026 17:10:49 +0200
Message-ID: <20260721152615.837533524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5412049208e669925f7b08bbfabe3cd28a598c5b ]

NLM_GRANTED is a server-to-client callback; the local node
responds in the role of the client. The kernel-doc for
nlm4svc_proc_granted attributes NLM4_DENIED and
NLM4_DENIED_GRACE_PERIOD to "the server", but per the Open
Group XNFS specification the responder for this procedure is
the client host, and NLM4_DENIED_GRACE_PERIOD identifies the
client's own grace period after a reboot, not the server's.

Rewrite the descriptions to match the spec: NLM4_DENIED
reflects the generic internal-resource-constraint failure, and
NLM4_DENIED_GRACE_PERIOD attributes the grace period to the
client host that received the callback.

Fixes: 7a9f7c8f934e ("lockd: Use xdrgen XDR functions for the NLMv4 GRANTED procedure")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc4proc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 3bf6cccae56858..f3ba2615ae77db 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -516,12 +516,12 @@ nlm4svc_proc_unlock(struct svc_rqst *rqstp)
  *   nlm4_res NLMPROC4_GRANTED(nlm4_testargs) = 5;
  *
  * Permissible procedure status codes:
- *   %NLM4_GRANTED:		The requested lock was granted.
- *   %NLM4_DENIED:		The server could not allocate the resources
- *				needed to process the request.
- *   %NLM4_DENIED_GRACE_PERIOD:	The server has recently restarted and is
- *				re-establishing existing locks, and is not
- *				yet ready to accept normal service requests.
+ *   %NLM4_GRANTED:		The granted lock was accepted.
+ *   %NLM4_DENIED:		The procedure failed, possibly due to
+ *				internal resource constraints.
+ *   %NLM4_DENIED_GRACE_PERIOD:	The client host recently restarted and
+ *				its NLM is re-establishing existing locks,
+ *				so it is not yet ready to accept callbacks.
  */
 static __be32
 nlm4svc_proc_granted(struct svc_rqst *rqstp)
-- 
2.53.0



