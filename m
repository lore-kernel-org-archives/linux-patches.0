Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618931;
	b=M4t0iHksjVETRUTzCx+aYoEwvVNUiDsjbnoojb1GiFMgVNuMLLwlhZ9SKC8wYTleGzgX
	 u3WKdpVX3ORV9dGfio/ph4s76Rz8H1puZN7qYQoFtiAw9YQssx6genTKWiUGjQfDOo/PA
	 ycp8epWAiI+zS4h21rZwRaLvsKrEc4YYuGTOd50fe6Nm3UbOVGv5ObntiklCNiyukxmh+
	 ZD75l4g0wDd+hXh0eiPUQEcTmuUpk0yaCYi4s3qtEB43aHylnDbyU5WxO4/e2etnDTz8P
	 bSyRHUntKFsQKItnkwz5G6ns+NQG8wnA7Xf43xG61jtfvGQJJFCXW50OQ+BGgSeIjgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eUjHaWRsB6q5knTlZSpWL3IiDi+VuPOHAZMvj+wV5GU=;
	b=N97PaaLgKrQ1Vxh4vdr34y2p28YTxL67t/ZPorqQc0Vqp/LDsPWgy+ck1OVLkIH0Vaya
	 jlj96MhtfKLqlStXoEVjHOAs/B5OCfWfdusvdap8vQ3BXiMTM5dYXMqwJSc+x8XFWS9Nj
	 B+BqYceBPSBYOuU0SkOShy87dbf9Wt2ZRR1kib23ith0RtlfDi016RwQ48PxVmBwMZklG
	 SOCIea0gdqySbcZ85stKIIkbNAZKn3v0IZSKE2qN+djSKLIhnz3Mew3hMJssaACOJQ/Ek
	 gdWLCWlh6NlXGGCT0WjHZj3pi1PBHz7t7i3ltfJWQPJfofcbgScK+/CErobvAnEpMGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjClABbv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E88606A321;
	Wed, 25 Nov 2026 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjClABbv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBA91F000CA;
	Wed, 25 Nov 2026 15:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618930;
	bh=eUjHaWRsB6q5knTlZSpWL3IiDi+VuPOHAZMvj+wV5GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjClABbvqndFSqPsGR+U6WtegJKg6FzUgB4x+vURpSQrdClMZf6rVEsEgg38piau+
	 EZpcawfJFKLgOEyEAFrXa0giQGPS8GTL0Yu95MLDuegbrZS9g2Iz+I6s2JeIYkh4PN
	 H2VojVlduKc360vCUKFOQwOAxRPnFqn8jOi3kpTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0434/1005] SUNRPC: preserve fatal network errors during RPC binding
Date: Wed, 25 Nov 2026 15:29:32 +0100
Message-ID: <20261125143831.917834899@linuxfoundation.org>
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

[ Upstream commit 30150b94c70eff4bf916d7d367ecf75de25d5337 ]

call_bind_status() initializes status to -EIO. When an unbound
transport's port lookup fails with -ENETDOWN or -ENETUNREACH
and RPC_TASK_NETUNREACH_FATAL is set, the function exits the
switch without updating status. The RPC task then reports -EIO
instead of the network error.

This can occur during NFSv3 port discovery with nconnect,
when an additional transport has not yet bound.

Preserve task->tk_status in the fatal branch. Leave the nonfatal
retry handling unchanged.

Fixes: 9827144bfb2b ("NFS: Treat ENETUNREACH errors as fatal in containers")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 6cedc824cf826..73f8469767d32 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2125,8 +2125,10 @@ call_bind_status(struct rpc_task *task)
 		goto retry_timeout;
 	case -ENETDOWN:
 	case -ENETUNREACH:
-		if (task->tk_flags & RPC_TASK_NETUNREACH_FATAL)
+		if (task->tk_flags & RPC_TASK_NETUNREACH_FATAL) {
+			status = task->tk_status;
 			break;
+		}
 		fallthrough;
 	case -ECONNREFUSED:		/* connection problems */
 	case -ECONNRESET:
-- 
2.53.0



