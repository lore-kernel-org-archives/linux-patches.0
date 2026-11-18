Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036542;
	b=29s2do+KvCVoiQfWM6Yrp4GZUajWBK7qOp17xw1NzOOq0bl2wQcnPs2M4b9HCGePKiQ1
	 nK3k/ppU+Xx92/1mr89paagkg+UiLBcDSTlNTqFzjeNKk6NRv2qHPS0dS1n8D2VJyD2Ty
	 xbTYyjZ5MnnjMbaoRpdbHLorD9KPC+7XECnD8IxaWyBfF1NGfmk6rJAyfynznngeI+Zsm
	 Ia+15Du/uxDSoHOi4pk9eE0OgDBB2Q2jd+pWrH2cm3pCiMTVU//cGkd8oeUtWUkPIFKyi
	 MzmDfmJvm8N1ZlmnCvAO1mrzVTkdjbaRDdE9yIbFvDuoJsJGD9/P6qnJYZCBb68vuig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cgRqe6YtWPg4nG0qjyWXdFpdZBmPsv4XYT3lO3tPLQ8=;
	b=T0nK20kaCiPZ6NSFbMKTPqSwRaTTUgU1xEcp/irvzaAYnkJ9gzeJX/CiNsiOXFbR2XMB
	 YaQK8CEWETKCVnq9v9nSnaSqH9WwGOyyczuoBOEe+71//D6FWKcixKMv3dVbC9TCwheeC
	 6IF1FKvywGHCBxz1I7MRC59cRA5lYTj+xyBPN9bLM2EWo1lKcl15dRwWwgx+yVXcdGu6t
	 J9g/MBhkmh2wFp1GDHup0E1uk9FUdNCt7pEWSHPyrqF2Subxa2Z366W1a8RlCBL4L85SB
	 u4GeKgvKjEABXRADzVIHvVfMQTOejVPDo8NroSclPvhcnUM40pd3IAZun5vzw9qAZWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjGseI62;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DF460A2629;
	Wed, 18 Nov 2026 21:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjGseI62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A580E1F000C4;
	Wed, 18 Nov 2026 21:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036542;
	bh=cgRqe6YtWPg4nG0qjyWXdFpdZBmPsv4XYT3lO3tPLQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjGseI624Gv66JpxVHqlJ4IyjrM5aTIGAU4Oim49a81n6mImSEjd0FFAyD9gjZ5M8
	 xQLfdhrjf9v+MYSjuy81DObHMBypmihVOBJ16v4mgavnn1UnNKsz6AXP1LgGhTOx3m
	 8hUGPX8Jcsbzbdh5Jct6ZFuN5ryEHWw5vmJ2XE/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1096/3318] sh: intc: Sort the prio and sense lists after filling them
Date: Wed, 18 Nov 2026 15:28:38 +0100
Message-ID: <20261118150352.859651970@linuxfoundation.org>
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
index b19388b349be3..590a532e75a7e 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -277,9 +277,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 			k += save_reg(d, k, hw->prio_regs[i].set_reg, smp);
 			k += save_reg(d, k, hw->prio_regs[i].clr_reg, smp);
 		}
-
-		sort(d->prio, hw->nr_prio_regs, sizeof(*d->prio),
-		     intc_handle_int_cmp, NULL);
 	}
 
 	if (hw->sense_regs) {
@@ -290,9 +287,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 
 		for (i = 0; i < hw->nr_sense_regs; i++)
 			k += save_reg(d, k, hw->sense_regs[i].reg, 0);
-
-		sort(d->sense, hw->nr_sense_regs, sizeof(*d->sense),
-		     intc_handle_int_cmp, NULL);
 	}
 
 	if (hw->subgroups)
@@ -360,6 +354,11 @@ int __init register_intc_controller(struct intc_desc *desc)
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



