Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064742;
	b=JrGyVhjNcETACVdmWa1F2DD9KAvOPHHC8RuhlnzM5RiGpHAaNZcSiO9Ha0/ayM/j8bcz
	 9chFfJa+TokAZwFNy25UYXTcOWStuHTxIBijvqQbO/AkCjGrKyn6uPxQsxzKOYPmhMp/7
	 Q/Uhl7W46JWOyDa7F0vpN2FAeUYMxDlhkO7Dgm+A36n/MOPU7rW2NxS+dEunfqzxaeqQN
	 WXnfeK6Qv2ao/k5HRuFksnUQ/nugv1smVW+7fbkwseZ4EFQvPcupj9Z8aiTeMeWUQ9QQK
	 XvBsxrMUmf0kHmlaVOCK1cHBGxkePjL+wW+iHrEF2ZyGCFEiY6kQyZY2ENjLM2BnQ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eNte88nego8p6jeYZUFESIL0iF/jGB+JJIXzRJ2t90Q=;
	b=hJaYs/y81claOefYnXX7DCasMm6pP+AOa4UMVL7Vmyi3HZfnzlyK64jkzzapHB3eLCSa
	 o2Ei+doF3UxduyD5LbLS75ZOdoTyaP00PBJNNh2A0oQ1Pwc6601gtUBz7eujJeQoXLIsc
	 orcb85J5wY2uUC5IPJ2k/ZFC7OExN8jvscYTYlHZrzbMa2Q1DeVbnarEHCSnBvZaEkqxG
	 ALbQ5t1LW59G3FLF1gJWjecGMZ8yCtRTA/sCcNMyXDheIQKNrk46ICWigleODT4294S9R
	 kyJS/EeuccjB+8emFHaC1QGEB/5SgUkpSHR7jz+w3SMTByo00ymCk46OFvGQK2q89LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqPND7cw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70865606D834;
	Sat,  7 Nov 2026 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqPND7cw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216F21F008A3;
	Sat,  7 Nov 2026 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064742;
	bh=eNte88nego8p6jeYZUFESIL0iF/jGB+JJIXzRJ2t90Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqPND7cwTmBjiV9Oqbt8n0VyLjB5P/d563WRLHzG0otrjHnpQld1gEhmMHC99IvgH
	 9Q8oyxcJvpKCo/F8moX6J9mlQuaL+7KseBvVtlHjlcQuqpti2oMHqedeKFxq42Fw7d
	 YtgCCZCmIvvsAfAxSIvd7kI/r6+8zsbTfwPD3yag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0718/1257] sh: intc: Sort the prio and sense lists after filling them
Date: Sat,  7 Nov 2026 08:50:14 -0500
Message-ID: <20261107134959.092178552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 94a219eda3b5fb1d1753a5ecf28b171c8f308a27 ]

register_intc_controller() sorts d->prio and d->sense right after
allocating them, with hw->nr_prio_regs and hw->nr_sense_regs as the
element count. The lists hold hw->nr_vectors entries and are only
filled later, by intc_register_irq().

On SH7785, sh7785-irq0123 and sh7785-irq4567 have four vectors but the
SoC's eleven priority registers, so sort() swaps 88 bytes in a 32 byte
kmalloc object at boot. slub_debug=FZPU reports "Right Redzone
overwritten" in kmalloc-32, and v6.5 and v6.6 panic in
__kmem_cache_alloc_node() while registering sh7785-irq0123.

Found with a custom QEMU model of the SH7785LCR. On it, v6.4
sh7785lcr_defconfig boots with SLAB, the defconfig default before v6.5,
and hangs before the console is up when built with SLUB.

Sort the lists once all vectors are registered, with the number of
entries that were added.

Fixes: b59f9f9775e6 ("sh: intc: optimize intc IRQ lookup")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/sh/intc/core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index aa68fe190865d..ffbe60234eefc 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -275,9 +275,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 			k += save_reg(d, k, hw->prio_regs[i].set_reg, smp);
 			k += save_reg(d, k, hw->prio_regs[i].clr_reg, smp);
 		}
-
-		sort(d->prio, hw->nr_prio_regs, sizeof(*d->prio),
-		     intc_handle_int_cmp, NULL);
 	}
 
 	if (hw->sense_regs) {
@@ -287,9 +284,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 
 		for (i = 0; i < hw->nr_sense_regs; i++)
 			k += save_reg(d, k, hw->sense_regs[i].reg, 0);
-
-		sort(d->sense, hw->nr_sense_regs, sizeof(*d->sense),
-		     intc_handle_int_cmp, NULL);
 	}
 
 	if (hw->subgroups)
@@ -357,6 +351,11 @@ int __init register_intc_controller(struct intc_desc *desc)
 		}
 	}
 
+	sort(d->prio, d->nr_prio, sizeof(*d->prio),
+	     intc_handle_int_cmp, NULL);
+	sort(d->sense, d->nr_sense, sizeof(*d->sense),
+	     intc_handle_int_cmp, NULL);
+
 	intc_subgroup_init(desc, d);
 
 	/* enable bits matching force_enable after registering irqs */
-- 
2.53.0



