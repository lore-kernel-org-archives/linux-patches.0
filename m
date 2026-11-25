Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624586;
	b=2nQYUaRsIgjEIUXtauqrXpOCUOVnsLqPCLGLad+/IRb8Z5FaaoXxQIGenDAXrpOdxvwo
	 qz7pmHjQHQ7c+WbMg4syScHHGxoyKJnggOzEfcr37sjXMX1sSdTToaOuzz2zjku91rY6N
	 5Qd8Eam1Cz985xavjEC99AN7greNFI04Siqc0guFjnJcGDRkibIlLqqi9oCMNMtTIBSvH
	 uqarVDJyqpes17yQH/IFkrjUaGxIyptnG61tSoG6kDKRkOczqVJJJ0WEHXTUA2TwXdiwt
	 1BK8jgBHdH507Arf1qsqy8L8ZglpuZJYh0736arsIsxvR8MAkS7sqpvEeiwAnsjmNsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IokNZ8VTF+ovOA36ir8TDpKDBqVVNJcqh8oyWl3NVRU=;
	b=3w5gugqMeeZutKnPhE0SmqB60BHtXtKdWa9myA2qCCdBrab4X4SN+Aozt74/Chv6rg73
	 c2MYo2yJ0xAWSxh+R5ChEnvsTcOgAOGjPxUlIxsA8AftNK88shEI9D3lpbeqnLSwSrVcO
	 s6dAqMcrZLhdC20mFuBytETOFwm/gs4IHXKgr5bfeGwUdfzggtEcLSdrhcEA5EyyVxGuA
	 cXXfM+uxUeH+3at1x2iCYZlSuI4yPtpu0XkNYnG3ObfKQWy4peeRP3AqoKPtdeAw3l73i
	 K1YHtKaM7idxxqcJElnXOXCpvikwj1Amvm5KhMnhQ00HMIFemC+xGf/JAAuv5fZ+tIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=we+99KFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D773606A33C;
	Wed, 25 Nov 2026 16:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=we+99KFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA1D1F000C4;
	Wed, 25 Nov 2026 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624586;
	bh=IokNZ8VTF+ovOA36ir8TDpKDBqVVNJcqh8oyWl3NVRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=we+99KFF6gTQ9r9DbYRqTZ1B/EOrs5o24OHf4hoM74YE7EM+HBqPFX3T0OTcc1JZ9
	 XQIpcnf+EMw3fZ9EgQSXoYED9CnSzo0/oznmJi6t7I80Dz+O1o/is7wSuL/spV6NV8
	 p80wvhCDBsoaUH8PzZcf84pqBzm31VX3h1itmit8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/816] MIPS: SB1250: Validate and update IRQ affinity
Date: Wed, 25 Nov 2026 15:29:50 +0100
Message-ID: <20261125143854.812284490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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



