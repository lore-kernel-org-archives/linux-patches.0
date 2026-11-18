Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039857;
	b=bWvV3gAdBl0wSWAS94AZBC9Cu9lMbdv1I/hsJ3YoCD1L+VRFiMM2SScVRN/Q2LquPgIn
	 W6CuXeTuGtzhlTNjdQy1dDKCV8/CYmbmiVPXd0aW0keJ40qKb3dmynkghBs8pv26tL7v/
	 XFb07nOaxAW5wd3/6TVyP4yMnBI6X7SW/6LZ36Db4c/10EGqqjCkGnIOlee55cc3b9Mmz
	 C1Oktx2/sQ1iUgpRzVus3e4y6obPBVutoM862ufNkhHd6t6SXyQtUwYrbU/Vr8eccWgtC
	 3KNIIT0TqdPM0GyD1ENsMsIo+9R1+TuDGuwJkIDjmOSFtRo+T7JRnqcYS3R4rrLGkIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u0aNlBXV+zrryAVMIf2S6mgqJRzw7o0d9XxdMNEpuwY=;
	b=I7wPUQIbSjG0fje8/BmKUjFXGvO1KYnWQ7KX98dABGibp9z1no6d5HwYh/usy/9tsk+t
	 z01mUzj3cLl8XwAQtbeyrEXTLQiIorNS1iZo9+6X4UUbqrMNt+OpNOnyniG5i6SSIp0R+
	 QZCyBXB5TZuQs/evua+qD485ejiYT2GiqmBYhAjC8DId5P/Q+gKseYv0KwknKn3xsle7W
	 YVH+Sb8vuN/jwGT3Bvp9MdVbKxD6rPNm7oD4Va0w5PqAatokJXjYLNVN2GdPrkYoBLAjp
	 L8Ua72WmHLFt6KGCNZ1pKsP3xGHFqGHo7RZnEMoD+vWXjf/YiajSRxJ4f/LFzAMfpBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f2H45ztK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345A6606A31C;
	Wed, 18 Nov 2026 22:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f2H45ztK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820821F000C4;
	Wed, 18 Nov 2026 22:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039857;
	bh=u0aNlBXV+zrryAVMIf2S6mgqJRzw7o0d9XxdMNEpuwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2H45ztKgqGjhT/iw3xsb85ltMzOpVEjbPwDMpLth/QeuUhwsbCmrZMS3B/7w42ta
	 XErN1rYh/UI+/vRGa2TxIfagOD90a6NatDyUiCnLm9Zcc5gcSsC6gk6L8bakNEaQHO
	 ZpVBsRg74YcUbiy783/KIRU0UCGNpNQu7d47T8hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usamaarif642@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2250/3318] Revert "rcu/nocb: Fix rcuog wake-up from offline softirq"
Date: Wed, 18 Nov 2026 15:47:52 +0100
Message-ID: <20261118150429.333044984@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit b95d15980a0f2727a421392ebb50fc6338e43b02 ]

This reverts commit f7345ccc62a4b880cf76458db5f320725f28e400.

swake_up_one_online() has been removed because hrtimers can now assign
a proper online target to hrtimers queued from offline CPUs. Therefore
remove the related hackery.

Link: https://lore.kernel.org/all/20241231170712.149394-4-frederic@kernel.org/
Reviewed-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Stable-dep-of: 4c714f015d9e ("rcu: fix shrink budget underflow in lazy_rcu_shrink_scan")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index b266a64a7e1e2..42891f6897e86 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -569,19 +569,13 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 			rcu_nocb_unlock(rdp);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE_LAZY,
 					   TPS("WakeLazy"));
-		} else if (!irqs_disabled_flags(flags) && cpu_online(rdp->cpu)) {
+		} else if (!irqs_disabled_flags(flags)) {
 			/* ... if queue was empty ... */
 			rcu_nocb_unlock(rdp);
 			wake_nocb_gp(rdp, false);
 			trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 					    TPS("WakeEmpty"));
 		} else {
-			/*
-			 * Don't do the wake-up upfront on fragile paths.
-			 * Also offline CPUs can't call swake_up_one_online() from
-			 * (soft-)IRQs. Rely on the final deferred wake-up from
-			 * rcutree_report_cpu_dead()
-			 */
 			rcu_nocb_unlock(rdp);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE,
 					   TPS("WakeEmptyIsDeferred"));
-- 
2.53.0



