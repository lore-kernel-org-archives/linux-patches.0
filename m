Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018101;
	b=muo6bzRxJe2bKveh/LbmfuKpp4vaGCtfShv0ilREDS8qj6PYUP8kPANmgEpbWMP5F74x
	 zC/8AKahpfnH2oBhcZ//xv+pMgcpHrhoh+1lqk3WqsV6dcaLcw7S4coC0QsChylUEbK2+
	 JXN+IqdQO1IzR0GZgU+xt5pyEZ1VnI6Rh4HidoZed8qipsT+pVKWqcRHcYNkyaf6ZUyH6
	 DozAcWruZ5Kl2CrPPG6BRzoepju2oe2KkFaGVfKMMTPmyYDSL1F+fNi1x4MQKwo9d9lKz
	 +BeMSBL0HowajzlCo+4LrNi5eyab8Ui9FharHkC8Z/Z3wV9XFkTljYxukUQuY6FAbUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZPHadPzTzCUNEJU98t0fCgUtTIqvwVHykgkWgc3As5w=;
	b=o09XTk54UAlIhhArKklg0MZYS3tn5gsNtSy8oFlsLepU9/vCBbl4FRXNTqSDLovREFYI
	 j1P1al4TcpNjovWDqraEhbg9Ys8ylB3RZgA91EkGpmq1gMvyO6busRAeZZXQdFGUQC4cw
	 QH2NkOF6joXhNKpTVmUTpEIDzrPSE5PWAWpNfY57KG15KoYn0BzclC1qhfIwLiO07RiJj
	 R7gNdG1fSVIodgVTx2Tkp0rSpFSMZLqKSBfPAKe4G5WnjydpvEDfsMLpFFf4iyn0ZE5f+
	 GBj7Z3XW5bSXVzVz/6ab6eGRjCvNJbxAbhtxoY1KD6is+WJdUNRwzTZ+UBJ5dyKZvgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qWbTlu1c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2797C60A2605;
	Wed, 18 Nov 2026 16:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qWbTlu1c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780C41F000C4;
	Wed, 18 Nov 2026 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018101;
	bh=ZPHadPzTzCUNEJU98t0fCgUtTIqvwVHykgkWgc3As5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qWbTlu1csraoTompYibR+F2riSiH7A4sDz/+1dBy1sTwSUgE2uoqvVBTKIHkQkvtj
	 ibBvT0Prai1UKENkUrYmK6X81RH0/ZkcB17HDu4emprPXn6safRTzZJyRWsbHF4MCH
	 SulOsFQ7+Y3ygI+GwvZnxswZarP8tuDd9PwDubrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	Wen Yang <wen.yang@linux.dev>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1113/2651] rv: Use LD_WAIT_SPIN as the reactor lockdep wait type
Date: Wed, 18 Nov 2026 15:39:13 +0100
Message-ID: <20261118150328.069316400@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Yang <wen.yang@linux.dev>

[ Upstream commit 39ccedfd9e55c95e440c26611a1db750b92b83bf ]

rv_react() overrides the lockdep wait type to LD_WAIT_FREE to enforce
that reactor callbacks take no locks. But callbacks run in the context
of the triggering tracepoint, which can be preemptible task context on
any kernel. A timer interrupt firing during the callback makes the
interrupt-exit path schedule and take rq->__lock (LD_WAIT_SPIN) while
the LD_WAIT_FREE override is still held, producing a spurious
"Invalid wait context" warning:

    [ BUG: Invalid wait context ]
    context-{5:5}
    1 lock held by kunit_try_catch/209:
     #0: (rv_react_map-wait-type-override){+.+.}-{1:1}
    kunit_try_catch/209 is trying to lock:
    ffff8a743ed3e8a0 (&rq->__lock){-...}-{2:2}

Use LD_WAIT_SPIN instead of LD_WAIT_FREE, which causes false-positive
warnings in preemptible contexts due to scheduler preemption taking
rq->__lock.

Fixes: 69d8895cb9a9 ("rv: Add explicit lockdep context for reactors")
Reviewed-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/5586dd00789a0f904cc299cd8889744b8c6f8dc9.1789412799.git.wen.yang@linux.dev
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/rv/rv_reactors.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/rv/rv_reactors.c b/kernel/trace/rv/rv_reactors.c
index 2f5fc8d18dea4..ff7d478227c32 100644
--- a/kernel/trace/rv/rv_reactors.c
+++ b/kernel/trace/rv/rv_reactors.c
@@ -465,7 +465,15 @@ int init_rv_reactors(struct dentry *root_dir)
 
 void rv_react(struct rv_monitor *monitor, const char *msg, ...)
 {
-	static DEFINE_WAIT_OVERRIDE_MAP(rv_react_map, LD_WAIT_FREE);
+	/*
+	 * Reactors must not explicitly take locks, so they should be
+	 * LD_WAIT_FREE.  However, reactor callbacks can run with preemption
+	 * enabled, meaning the preempting code (e.g. the scheduler taking
+	 * rq->__lock at LD_WAIT_SPIN) may violate that constraint.  Use
+	 * LD_WAIT_SPIN to avoid false-positive lockdep reports.
+	 * But you should still NOT be using locks in reactors.
+	 */
+	static DEFINE_WAIT_OVERRIDE_MAP(rv_react_map, LD_WAIT_SPIN);
 	va_list args;
 
 	if (!rv_reacting_on() || !monitor->react)
-- 
2.53.0



