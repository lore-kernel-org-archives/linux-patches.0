Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704502;
	b=bmffqseI+/D1WQXXD1uXUY59VfCOtUEO6an1OOq1RwFCLyegOxQYR7MmRAZy2PSXWxVQ
	 rYmQLo4/I29pnSgoQ75YvWOlthRFFAAyFNsk1bvg4Sn7QDS2cCWVvN1m3xF0voWaKLV1Z
	 WSW6AWmWzztLS+G1rjTJEEUXfBoCySc0MDEHAfcNNooK0p8qN1pxis4QkZN+NLLJBJ9dA
	 3zkBc/zXMWad2mqyaSNoShoZXcyEqP6CiMUiWyAMz9yXhOZ+AEfTJi7mktgUcE4iiaOVZ
	 FAo2TnAof1ZP23+0zbNKz6nOYFH4IBis/sXSJKVu9P6JUmg8YCFYumZRbEvm7//ATug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CVR5cJBWAwvh8qb+8OagCPEzQJwgxT01uQ3+04fIGj0=;
	b=0CEyT0y8RUJ6uRsd/834YhoVX7P4FFz+Rw2iWyd8TX2Es2S9dWD7p3XZGX22hKkxZ5qc
	 mIlxoQznsDqi+KBCr+2eFLacPS/ZGb9Lew9US+ratxLbCIRnVWoC27tJQp7IDRmMIe7oj
	 tFJrydUDm5f4VYPa7ry+k8Kf9YBcGWaLGfs3lOPfqflvXxDdVfHGutBdlP8hMjwPO6c1+
	 JNG1RSVXyjq1v8nV5GDjk1/ladu7ttXhpCbfjWAnG3Z9kBEoPMQSxYHDhLRLHGe6hixJt
	 f8USvlYR4zr98xd/LT+e5yciERB9uILuojpt7iUVITogz2Tt5HzlHsQqX6S9dkNr23A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPLuKuvA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5CC606A336;
	Thu, 26 Nov 2026 14:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rPLuKuvA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09091F000C6;
	Thu, 26 Nov 2026 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704502;
	bh=CVR5cJBWAwvh8qb+8OagCPEzQJwgxT01uQ3+04fIGj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPLuKuvARkiYTVGwo0rx1bOxpCioVQKa8Ajj63ymgcDDjcUGMd0HvVKNssgLrEaSf
	 ChZPMylnQmoSd78eYBX3s7kCx7Jd7GjnIQa+KHQC1JMyVIUFlj7JD9vnvguLS8/lWX
	 MPLErdzM1tCu/rlFHN2bLtoZJpAp09WmL1cexkjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/265] MIPS: SB1250: Validate and update IRQ affinity
Date: Thu, 26 Nov 2026 15:37:02 +0100
Message-ID: <20261126143611.432452441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



