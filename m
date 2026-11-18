Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058509;
	b=tkDu5CAQ+lwBa+q8c8xNn0QwiEATA3/ZI37D33/xxeqnCgmE/pudANp0j2wRFhh2eVUh
	 0ZYKvHwCHI9syP09HWa1lLWarAzuYO92eExCfF2lhLzsd3tZSqRBZyTG6m2kxLvE9tg2P
	 7h5zD+4Wsvr0mOJ+qETUJ0Dmw5q7kQtYwmJM+6E8A+nxgHYe1AFN+iqza3DHoXeMYKRie
	 s7Dsr7rYDjMsJrWVIf3JcTvBp4Z5caRBHl+NmzWkqP2vtR0CMBW3QVbm1HwiowuKnFvxe
	 a1pD3Mt4PCZ4CTm9NBhPNCdjbbS8UfZN9RNoMz6sP8KKcn5HPRilGRLwJdPeo9Sd2UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3By2BGbKPapYOSpcatKyMqVVdbLEdWRv2k5WXs4hSEY=;
	b=byidLsIlgrLTeEuQYVX3pWeODDhn6L9Bw+QMsDymwJ3FdopE/FlT/OMtmxOCdPRPw3YL
	 K9rxJRhXg76XmImAAvKbad1E0MX35+6i02uRmMge9Sawup82Lm+vf2iwCxgK1XoBxOG45
	 I28AI4ziqFcKy98Xn3iXaFCkySvEotQmXdG1zsUn7hV4ir2g1hdp4pkHD415q80zB7H1E
	 Oq15zqMQIbBzZ90QKCkBF99Rrm70YckE9SpjD35X+kie8oVKka+3CPZh1D4veAKpWin1M
	 rqDN9WRPHKsP9dTzrCKghMhFrUFjgoAesWEabQlOaBRRAN5sWOhD3Ybc5T5ExgqO/AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h1fkbPFD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35D8606A325;
	Thu, 19 Nov 2026 03:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h1fkbPFD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124301F000C4;
	Thu, 19 Nov 2026 03:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058509;
	bh=3By2BGbKPapYOSpcatKyMqVVdbLEdWRv2k5WXs4hSEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1fkbPFDGzPCJK29ZIixWcP4c8w80baLW71D4IwEIfMGWr0w3dfMg1Mg5TC0mBPCz
	 QrUgGuRG3ub9dRgMLyNJ62DGWfYpWQTStUeN1ULrJDh6CrSTDfTbQktShfeIsm3H7a
	 10zl1zuXM5hjyimPwzwSw3Xuz5wCtbOr05XPv6Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0511/1848] sh: intc: Sort the prio and sense lists after filling them
Date: Wed, 18 Nov 2026 15:42:29 +0100
Message-ID: <20261118145936.123887878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 51586c5e993bb..14e3ccc30b02a 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -262,9 +262,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 			k += save_reg(d, k, hw->prio_regs[i].set_reg, smp);
 			k += save_reg(d, k, hw->prio_regs[i].clr_reg, smp);
 		}
-
-		sort(d->prio, hw->nr_prio_regs, sizeof(*d->prio),
-		     intc_handle_int_cmp, NULL);
 	}
 
 	if (hw->sense_regs) {
@@ -275,9 +272,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 
 		for (i = 0; i < hw->nr_sense_regs; i++)
 			k += save_reg(d, k, hw->sense_regs[i].reg, 0);
-
-		sort(d->sense, hw->nr_sense_regs, sizeof(*d->sense),
-		     intc_handle_int_cmp, NULL);
 	}
 
 	if (hw->subgroups)
@@ -371,6 +365,11 @@ int __init register_intc_controller(struct intc_desc *desc)
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



