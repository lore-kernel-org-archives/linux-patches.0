Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029720;
	b=x6Ya8Ouc0ZrwN6cYkXFv5/Zy5gqItgEkphSn3/1fuyEpFIU200F4nhXQzTIoUrErltBg
	 OIDxmLNYT/y+Mrnil95kGI+7XvFDqsWFZQLxWGQTuIsabX0EzEf4uwMotq5SCmSaulrWx
	 rYFxHxoPeRF0sKvkPcHrNlbPgheHc2a/ZpFYKfjATqxLf7w+Y3Dd7lB0/IaA5vapcqvV+
	 fsYCzw47uB/erpNvGxZKI9FnukKZiNuT/KKIz7HcEGfaLNGl4nxM31QG/uRi13qZkgF5T
	 DnvhbAB79B2QlOTZT1q5A0BWc80BWFQQR2a12zQjPKaNbyqaYj1Gdi6ACdhjZPFItKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H2wbO4KKpmLAtsnpDU/MSamyrn1qbxPCpB5IoBejPvI=;
	b=X+rAAtEq4zP+W8NTXOsBPp906YVwIosM3IbpdZcg5N+NoNvRIXGStIFRhAUhrC5MTgT5
	 RCsC2x66rFgfbBCeP6TRHKhkU8hp2X4ZZ488pVyFYudELFYgpJkcaX+UmQsGH+ZIrw3zB
	 j9f5fjL5BcysjUZUr4rE4eg5kY+m16Y3LBLMpyiVHxQHKOb1ioOPUKrSeMoxQPLydUQcu
	 HBlmOoJ5jPCGV0CbQwTD7ObpN8toYlLNFLk9Yn03RZ49pLGgt03eFYxVXrsr5wFI/mZ12
	 OauCaVpmif7/Zx3uiAuWy+jpLd3XAyt92Y4coi2E1TS/XaNS5bg2FJG2BFFC1G07hOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=orTQzZXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9107B606A33A;
	Wed, 18 Nov 2026 19:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=orTQzZXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B2C1F000CC;
	Wed, 18 Nov 2026 19:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029720;
	bh=H2wbO4KKpmLAtsnpDU/MSamyrn1qbxPCpB5IoBejPvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orTQzZXMih7MzxThVTkZhr7eGalilCzBQpXCJR27beCvAHQR7n6e4lCQ9Z80SbpeB
	 2Ua+Yu0GDxI1bSWIrADswtt8hj+3t/TD+GZZ2j9BFlWGca+w6meycj+TkWo9GkpBn4
	 CpgIj/CaQgcQjprXbTbVIi7AOVrJO1lGslC6cCXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usamaarif642@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0450/1756] Revert "rcu/nocb: Fix rcuog wake-up from offline softirq"
Date: Wed, 18 Nov 2026 15:42:57 +0100
Message-ID: <20261118150026.718525267@linuxfoundation.org>
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
index a1a5942d70170..9db8a88e9e6dc 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -554,19 +554,13 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
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



