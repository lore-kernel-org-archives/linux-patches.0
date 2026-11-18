Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039854;
	b=uKhWItZ9WRV/SO38kxaAclSkHIrrHji5fH6v5pysrS+XrQHFwfc6PoHhl1pob1cIUEOt
	 L7XZiaC0S3YiQn7V+36XY0x0l81A6vSpEJMp4FeC00FPr7WmVs6S2TOyWfuHJvtsTkr7f
	 U01yYSvbsNusTrY3L1U6zzAnD/vs6veLsU6D+a2n6h2rqpMwDYUVp2J6oK+ABjcnQuz0l
	 u5yc7ytZr3A3L+vYhDIdxU2R/Ea4PDwCt+GC3nVnnWVGerMom9EnEM3Dos1WxULWIhCqi
	 RHLyVyg2JpCEU+eJvcoa20tGuXmrgMR60/k81vtrTdw6BVtocRXiibVK5lGoWVRyl2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=abxvoIIc0EOU1ihLVekSKKuqW3rO4VIjcPPdjWDHOVE=;
	b=VDaDAWHxiELb0rVWGuEv+4DB6TWL49sQ4swAxvxYLp9MLwVej1rn1gRn18us+utLv1Rd
	 +7Hvhwdq9OZiv3BRdogtpuxCpSRahTktitb6HqPQFYlv1JukaKuOkceZQd7YMmElef1Gy
	 f/VKwRtu4vRHYsrvhe902C5VxOfpYqNp6jBtNML7hOoFIA6fQTweqLes5A/hpd2NLjmrP
	 DNpaGrM2bpmq4hj9TEAFYidDS5CO+g0DJT4LJfiY6nGn/vY/z3tyRvWiXtmSMB5XvQYMB
	 Gf0IYFuVa0wqAn+NrjNnlvUjM33V+T8tufA4BQ39P3vk70n0iQaSc6ItrqnzUWHdrWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAbEyZqa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73963606A31C;
	Wed, 18 Nov 2026 22:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAbEyZqa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D63E1F000C4;
	Wed, 18 Nov 2026 22:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039854;
	bh=abxvoIIc0EOU1ihLVekSKKuqW3rO4VIjcPPdjWDHOVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAbEyZqaGrDqBDAXo6kLYMjuDUdxuvD5VMcBnztxKN2oqO9s7IeVa5eluA4SLlLm4
	 k2VnwtO+i5Zab1pDdgzIDflfusdLNwvUEyo6cn3FYlnq8kKpkrRBqMmJ0MfhoP06rU
	 OxB5tAAdWzVQuXZwlVcISsnpBhfJhAwU1nxHU4Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2249/3318] rcu/nocb: Check rdp_gp->nocb_timer in __call_rcu_nocb_wake()
Date: Wed, 18 Nov 2026 15:47:51 +0100
Message-ID: <20261118150429.305289317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit f3c4c00784b5f7499d9cb6d31b661370c9a1ce7f ]

Currently, only rdp_gp->nocb_timer is used, for nocb_timer of
no-rdp_gp structure, the timer_pending() is always return false,
this commit therefore need to check rdp_gp->nocb_timer in
__call_rcu_nocb_wake().

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: 4c714f015d9e ("rcu: fix shrink budget underflow in lazy_rcu_shrink_scan")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 42b7f0d4d4d8d..b266a64a7e1e2 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -548,6 +548,7 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 	long lazy_len;
 	long len;
 	struct task_struct *t;
+	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 
 	// If we are being polled or there is no kthread, just leave.
 	t = READ_ONCE(rdp->nocb_gp_kthread);
@@ -598,7 +599,7 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 		smp_mb(); /* Enqueue before timer_pending(). */
 		if ((rdp->nocb_cb_sleep ||
 		     !rcu_segcblist_ready_cbs(&rdp->cblist)) &&
-		    !timer_pending(&rdp->nocb_timer)) {
+		    !timer_pending(&rdp_gp->nocb_timer)) {
 			rcu_nocb_unlock(rdp);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE_FORCE,
 					   TPS("WakeOvfIsDeferred"));
-- 
2.53.0



