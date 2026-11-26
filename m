Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705187;
	b=eVM/oBavDSEbdzRC1i8ybb89pL9u4AvbnI4GE1hjDrrQbFk/YTZjyiyE4Uxh5/u32Niz
	 5aAFP613RfsToiY8BltRamVhP5y9JIMt5ueL08rsooofTY9TzuLQZjNDQ6xId/WXU6eB6
	 fwAHJJS2nwO7mh0Gib0nP5c2t42oTUV/t+qv0YM5UaI+0H555RBChj589SH+5N29Q6S6Y
	 eRrddBjcw2/mpleftCYdNUmkGP/C5ZvZnoZypvrKSRMIT6cj6fTRAs8qveEHjJSC4waYF
	 TzGthfVVLcuwWYcY88gs3uFeAB6H2+3b7IpOZyvVol6wIniOUtAd/Jlw4TsSoFxmh3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ciU+eX9Mi7ZvXqyz9Dl+aDM8oZaDPXhlWQ5paRrw3I=;
	b=LC3EzBBMLiyAs3yM/DLHy5fv4EyIu1KMowQJclMVOhP67Tv8BxhVzkAHuiwhh4eX3P2K
	 /xDrIH7av0ltsniWIX/WLF01gakuIwdzKosF/Pz00zBQq/t/G5vh+TohbSALuGAf7lp+6
	 XZaQjD8iMjsjXdlvH9tnSGSLJRK6Z7wxGlG7G+j8uyUu4CsLksfuqdq2iTmHmY8NyJ8vS
	 cP1MCUF0DU7V0UyqdKWLAuhOXeHiBn7XUdvXYV+hr3C7IiBpX9WMp4Cy+ccwLbZ9dtn1M
	 3pWLOOLBeYGuXD05ApO0vePvOUXRlSS5gVu8+bik2ERtrLjxgJadlDh8Ioe+SwzPY8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gFGyF4ty;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3217606A321;
	Thu, 26 Nov 2026 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gFGyF4ty
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276001F000C4;
	Thu, 26 Nov 2026 14:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705186;
	bh=5ciU+eX9Mi7ZvXqyz9Dl+aDM8oZaDPXhlWQ5paRrw3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFGyF4tyeom7ziZ5eXeYhhKWnE9dylz+Sy+Zj5Y9APWSGRbo+LR5JU0mbDyX20Ha1
	 7BdikDQ7vhFW78MShzKYHtH/eISvy2fxa1YpCMGauglamyhc8hx8pE/TQTCxey0VBT
	 SDDo63Qlz2kNpKkYwxYNxyMjxH8EHBAoUUFVFfaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/319] MIPS: SB1250: Validate and update IRQ affinity
Date: Thu, 26 Nov 2026 15:38:00 +0100
Message-ID: <20261126144009.271403438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86f49c48fc34d..6859a0c4ca558 100644
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



