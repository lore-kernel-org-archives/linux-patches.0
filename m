Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618943;
	b=3nh0ATNGw2PTlXI9xEAekKWr+F9AjjnTI+NnuDvfuiSSaHejujfiPMaI8ZXgIUlMn2+j
	 O1DgE31yw2NS19RP5vZ8QNTu/0zt3WPf1wF+jR27h9pqOQvrDUJdeLeyLZ2MrEIXMyzUd
	 YRlenfyrXZMaWQu4v0r5SAghaUNcoX+JdJUrHNqAhwkHV1T7KsFjGb3BX5iAMrDbMD1QH
	 /X6JZcwGSzgviVc1vaXiEB4AvI0bAaAsNL6vosuanN91K4w8BFR+OtXm3YygMxxAJOn+g
	 1LIJ1wRK1bzfA9dKOnsFjzHw1tNs8DjY95gLwE+qvRazsAG2s/7YGtnHgaxG9zfCa4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTp+m6nj8ust3funPe0YVLWlH3d1Z3ry/r79OOODS+c=;
	b=JZRsz9rfql+5xOazD0PsxKn/PJWZEP1hJwDWwn2hroD7EYvqWpgvB9AXR1DB6vp5Qtrg
	 rV/PoLdZzW35XYDuoDGCcy/2kxOT+5icJyv/JwC/FeLjY00gUvFzwLYmD6Nc54KRHYJPS
	 EBrkR9cu/SKGgADov/aNfQOtBIJ/SuSPlY/itG1I6WjPSmiw2yq2LbuzeMPJh8dQEXPkg
	 asGmbTawHB3h7lQQ3Z3mvESYydI3k7O5xAYVp5EOzQYiYsKHfziVsJIx5EVRu7gkWQBB4
	 1wssBnujMHBdyRfZMv+ycVXsZydwp15SGGioEvt74st0/puQZTyYu9jLkd0Q0+tX5og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fqso3uUh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C8D606A327;
	Wed, 25 Nov 2026 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fqso3uUh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68791F000C4;
	Wed, 25 Nov 2026 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618943;
	bh=QTp+m6nj8ust3funPe0YVLWlH3d1Z3ry/r79OOODS+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fqso3uUhXzcZq/kDpoJH1L7AvoHS0QGgL9/ijOALcVvbTa1zzLsoRD6LFANSrG6Mj
	 PxLZsXoPMykXbt/ZMxl5UW8dfcF1yfrdhfY5J8J4WgihH6psolTYUqQLH/sMmgOXSD
	 Cz7CgXi3agHx2x6HkyYN0c3Py80T1eT+xuZwx1h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0437/1005] SUNRPC: Balance switch queue length on transport removal
Date: Wed, 25 Nov 2026 15:29:35 +0100
Message-ID: <20261125143831.987867336@linuxfoundation.org>
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

[ Upstream commit 8acd94f02a960c8936df25a7af9c02c8ea87064d ]

When call_connect_status() moves a task off a transport marked for
removal, it decrements xprt->queuelen but leaves the switch's
xps_queuelen unchanged. The stale count persists after the task
finishes and skews multipath transport selection.

Decrement xps_queuelen alongside xprt->queuelen, matching the normal
transport release path.

Fixes: 6f081693e7b2 ("sunrpc: remove an offlined xprt using sysfs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index ba6fdd70414db..6fc36e516c1c6 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2262,6 +2262,7 @@ call_connect_status(struct rpc_task *task)
 
 				xprt_release(task);
 				value = atomic_long_dec_return(&xprt->queuelen);
+				atomic_long_dec(&xps->xps_queuelen);
 				if (value == 0)
 					rpc_xprt_switch_remove_xprt(xps, saved,
 								    true);
-- 
2.53.0



