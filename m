Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022956;
	b=TPLxHqCvd0jpap3mTf6P2FvkHyJFpzWZe8ZppCafXqa2jxCHhzDUVeDPH1phLT1d4e9V
	 8I374ICnhnCraBrTPT7WC4fvGAtH2YSyyfSYgO/SvXJCrdpmkMxLXvUBRslTQkRahoG/C
	 s5ks5rr6+yeAxXPX5CH25vkajYy5KP5clmkRLAS/yVxLxLLBDNZsgXd2w4dJ62/y+emw1
	 XsjntjPdCegP1emGgOj4iRYE8UtfdoPs3h+BftCk9smcz7NH8OtCNPJQASDLDj4lV84kZ
	 GfInd6i2RT+7/S6pk0KmtguEiB85dzLOciaqk9l5Wtm8eb1mwBkRepVeH9ioj/lrMPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T3VLoKkp4VLl7Di+Beux93VttZ+ZyddUnIHB3Rb6aYw=;
	b=p8nkVOuH8k5iIHzHRBImu+9DBCcVGggj0NhRXuj7rGnW+ZVN/GnOp3qwAgKnEE55Aqg6
	 oqBU7WvEYhW2FK0Fh+dZcXa4Tzi1mMtinNoQc6G1n4OxWawdAvPsnYGAtQ0OWPeb0M9ty
	 z0HJ7qh26eOqh9o0EP7g3okj3pb+6KnOlSoBcAwj6R/go7mXW9UjdV8K0vKFDDK8gAhhM
	 8Q4hvBX3lF63KXS8S1XE5T9aHke4mCtUO53DcnKSAgFSk0QuvOU2y4WRvrhUTAlvbz/fu
	 2GnsUXgDVZGrth7BuprgQf7qCL0SX6jbABxvxRu/bUU9J1OEAhmiBP9qD6t/2kLSXkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WyOugrr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B63606A32C;
	Wed, 18 Nov 2026 17:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WyOugrr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596AD1F000C5;
	Wed, 18 Nov 2026 17:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022955;
	bh=T3VLoKkp4VLl7Di+Beux93VttZ+ZyddUnIHB3Rb6aYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WyOugrrTE28Zkbyh2QKIidWJJV4xra8LZoP84b2IVRtnS/tUUXssXALH7B3IdYdl
	 ynp6eiESugUo4JRBqqBQMVFxaWNQQpsHOhN0dOMzo69V8VwssczJk/mR9t7O+HenVT
	 dbnOHhJvgKFldT2cnxs3Fao1mCCfKGvyVZx3cuGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0198/2151] sched/core: Dont steal a proxy-exec donor
Date: Wed, 18 Nov 2026 15:32:13 +0100
Message-ID: <20261118150128.996542796@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 3dd95f077371f5def65a91c4bb13bd574a62bc3a ]

try_steal_cookie() avoids stealing src->core_pick and src->curr before
moving a task with the same cookie via move_queued_task_locked().

With proxy-exec, src->donor is the current scheduling context and may
differ from src->curr. Stealing it migrates a task that the source rq
still treats as current, leaving src's scheduler state for that task
stale. For CFS this means cfs_rq->curr points at the stolen entity,
and the next pick on the source rq hits the WARN_ON_ONCE in
put_prev_entity().

Commit 7de9d4f94638 ("sched: Start blocked_on chain processing in
find_proxy_task()") tweaked the fair class logic so that the donor task
isn't migrated away while we're running the proxy. Do it similarly for
try_steal_cookie() and skip src->donor as well.

Fixes: 7de9d4f94638 ("sched: Start blocked_on chain processing in find_proxy_task()")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260807035232.1881495-3-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 57ba5fcff1339..824888693c414 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6292,7 +6292,7 @@ static bool try_steal_cookie(int this, int that)
 		return false;
 
 	do {
-		if (p == src->core_pick || p == src->curr)
+		if (p == src->core_pick || p == src->curr || p == src->donor)
 			goto next;
 
 		if (!is_cpu_allowed(p, this))
-- 
2.53.0



