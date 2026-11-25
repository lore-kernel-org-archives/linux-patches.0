Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618592;
	b=nlXB3oiOl8dLCjAxd+AYJCXs1a2Iyp5kH/MXgUgJE4gu1FQ3nC1Rk9jJKn+aUkJvc8C6
	 74HRv/udeJhXvZbOpCkYZ9R/WW0EC/iu/COmcTj4w+h+5NzQJEBliKbxu10lvApdCCZ12
	 yULjCZnYSR8bfdguLH9dCHUqn2RN5gw8BQX7FWDSBUigM54u12GM0mVZwydi10GmW7qAy
	 epEsVgwZbHHcfuyRmibrKDrtyvZxk0vGB6oduFXMymmwNQVltUGfwfqmzBrp8UL0Am1P7
	 80gs25sG5DKoqzZtP2czm7CN8a7d5zrUHx4rZKIMkPJuK6gSEZ4N0s+ATzL2QrCxnVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EmL0veID+fhdMKWRuS1K4BGiTca6hvwlV/UjWDRwtDY=;
	b=PL4k+g6S86SosewvfURD9Poxc9uN1aKCsgAWit8qADRt20+JlR9+lVwgnKLZFFDdKlo2
	 D3iPxX2kFqIilRLRm1xDya1Pf7yCWXJEMuY4ukTAU5fSe8fjAaYHZ+r4xg47orFZ0Z/xk
	 AwgYKrwLK55fvxKZw98nDadw/3P5PpGLWSU/mwbUKBphr2+iF6hwjUdn/6PrIsazAj2g6
	 xANOvWpv0VqJSCjmH7XFJJsf12LdimI7XZpfJCcJu0S8fY2DSQX1qnrbXwf1JAUJKbNAk
	 5Lr2HVKaLpNAIyqjM8ActoknPuk+8+RQ/jTRoRnbIITgqU5B3wUg0PQK76LLfkJegNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzgXMDK3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989D7606A321;
	Wed, 25 Nov 2026 14:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzgXMDK3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51321F000D3;
	Wed, 25 Nov 2026 14:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618592;
	bh=EmL0veID+fhdMKWRuS1K4BGiTca6hvwlV/UjWDRwtDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzgXMDK3CCOHOVk1gT9d0e3WECZ4CZm6GV24jyD8FQ3pO+jjpHiSd+ZHrdHOm8qct
	 9O3L8OFjtm9QD/PWmTmJqqtI+OwQpyJMBP33OQqd39hcZAXHcQebfEleWuSyRfhanB
	 bIT3qW1rsvHHZAeF4JMb361GGeZOdXh82OU+Wue0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0328/1005] MIPS: SB1250: Validate and update IRQ affinity
Date: Wed, 25 Nov 2026 15:27:46 +0100
Message-ID: <20261125143829.417746981@linuxfoundation.org>
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



