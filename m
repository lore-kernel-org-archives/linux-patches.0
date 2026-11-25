Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621673;
	b=i//lzjecUHHg2Ep9HrgftQ9mbw4u66E49zBBvLTH2o35XOLQyC2dHwKZu35IM+aApDOQ
	 GSBp2z67gDHzHzzH5pMgjzW4V5YFgzLTm3zKJdyVNgDhsY8koDTBsOpnmnWsV2ZN86A+t
	 pdD2n+s18uggqfl1HU3mZaq+81JpkHsr4XxoBDtvd7b3qkkrVA0fuF/nA4cqOTm9yiQk2
	 MuSgaRjsKDGZhJkU8T1tvbLWoeQ5j/7j4Ve8unYpjW4YnQQyEd+tee8pH3Kr2/gJC2D1T
	 DY3ZtlUkgZ9dBT6w5Gjt3wqTzB5Gfjq6ryg9PMbBY8JBFMXHqXT6ZPjDwikhCxnkY+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kd+CAJRrmXu7FKmt55NG18VaHiGfGc79p+WQQrpz3Lw=;
	b=HDPkS/750puz73Wl0W0FD39qNkXzBy5FReoPtt29eRZXktE3ltDfnNXoGlM3Hfal5eJj
	 vzuSIapAwKewsEBvymFpJyhVb1FQubPZ5DQMVQJidpw/8QybfB8GIR6EV7n8zOZFjRYbN
	 rFg41GbpfeTfFVzWIDMlzuqkZdjBUVz9vuPAikAHe7Lmz48PCboEG8QwR/aXmSon8Z7ja
	 G3KAvouKGfkSPGlHFJv2kjX8WSTgM6H3N39LPUc0WcUA0/LQNdnaUS9wq0G07fswB8gxb
	 h6dLRc3cavnGarecpvGcFsDMgQPkAN/YTIgh7M/3U2Bo4x06TfspBhhZf7L7RPCENMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BipcSdGp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC611606A338;
	Wed, 25 Nov 2026 15:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BipcSdGp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5921F000D8;
	Wed, 25 Nov 2026 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621673;
	bh=kd+CAJRrmXu7FKmt55NG18VaHiGfGc79p+WQQrpz3Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BipcSdGpW/f+gEc03GyF/3cN+qhepAdTsqYzaMzEFFLLf52G7IRYvV960wklv1CkK
	 mhUGFdl3QcMHye8N+1vq8wyOWQrJlSlisnjgpBw+AoQETxhPSgmSUwD1lEKFtMOZdL
	 abRyHiZvmMLVx/LoaV+ggFRHwhBvKUWKUoDDWr8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 298/990] MIPS: SB1250: Validate and update IRQ affinity
Date: Wed, 25 Nov 2026 15:27:45 +0100
Message-ID: <20261125143829.072681071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 456c965ca46c59a4a241c755e6565fd883a522f4 ]

sb1250_set_affinity() selects the first online CPU in the requested
affinity mask without checking whether such a CPU exists. If the
intersection is empty, the resulting CPU index is invalid and must
not be passed to cpu_logical_map().

Reject affinity masks containing no online CPU with -EINVAL before
accessing the CPU mapping or interrupt mapper registers.

Also update the effective affinity mask to reflect the single logical
CPU selected as the interrupt target.

Fixes: 421d1563c662 ("mips: Validate online cpus in irq_set_affinity() callbacks")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sibyte/sb1250/irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index 2f08ad267a11e..d7a656cd7ec0c 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -76,6 +76,8 @@ static int sb1250_set_affinity(struct irq_data *d, const struct cpumask *mask,
 	unsigned long flags;
 
 	i = cpumask_first_and(mask, cpu_online_mask);
+	if (i >= nr_cpu_ids)
+		return -EINVAL;
 
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
@@ -103,6 +105,7 @@ static int sb1250_set_affinity(struct irq_data *d, const struct cpumask *mask,
 		____raw_writeq(cur_ints, IOADDR(A_IMR_MAPPER(cpu) +
 					R_IMR_INTERRUPT_MASK));
 	}
+	irq_data_update_effective_affinity(d, cpumask_of(i));
 	raw_spin_unlock_irqrestore(&sb1250_imr_lock, flags);
 
 	return 0;
-- 
2.53.0



