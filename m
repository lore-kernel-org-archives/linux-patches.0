Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618579;
	b=vNzwqOeuEkBtBi9bX7Wprl89deCs2E/btbpVX4Qc9ee5lqokNoav2STo8WXPiZn5lZem
	 dq9zfZ+EF1eEF6VuU6AtiVpl41bOoqmUmcOcDmk5492SLtsBzp77qfe5eF3JCZmhfsA4q
	 Ucjv7zvZw8v1kZzOObSdotYcJJaI897HvZLC82pRSSuUg2IBEpAY9NlECL9K4FlvY9CDq
	 CWvkOFWZOwvLuuNy5OdPcoZv+kNkTcUSqwYNvY7UOAudmPhDx1/IJSSerbhqzTCVDokGA
	 2J53syC4iL4ntcRcXEyw1BGZdq/8rv6fhci9vexG0uVbSrDf1yW3TThVdv9OAoFKOiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pHi4qJqawl7MDhnRczwYrx2/jM2RtyBMbjQfNi7CGy8=;
	b=Z55WWBIHJzH1TZupV01XkTdWCMla0GS2jvfGTUh5sx+g/lFst+rO4rnha0i9t17aLxNj
	 7kmGJUryzWzqOidaQuZhDnwSEy1FbGDhAqlYlD+OQOM2QiAN67Z74KiwZCjmBbDAVmFp+
	 YgXG1q0hbLnn7mgHJa2WmDKBTvEeAvKsD3ljteRDl3MI7U1qtUuzIzK2ebe2Rfkr+oU2+
	 R+awS61FaMV/b0EcqjbCIzt5nx1g75VCtmaX7SZ+EapGlO9aj/5I+eIMwvss1Ry+7RjZj
	 lK7GGZfQLw63gskx+NPOdGB/OnfRSqPPjGSmleHQWOxGyhEB1IC6KXUwzCmi411hoIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tpNmm0S7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38F1606A323;
	Wed, 25 Nov 2026 14:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tpNmm0S7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F9A1F000E1;
	Wed, 25 Nov 2026 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618579;
	bh=pHi4qJqawl7MDhnRczwYrx2/jM2RtyBMbjQfNi7CGy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpNmm0S7/uKmNWQkdEnDfLHzl7HwQxg4/d7WD4eJWf/IsvS+tD/ecHn+skCUgPPTu
	 H355a3Ae5I/0Lz45GV1+ikO8X+bjjzkcIPmqzBzLA4dzmDRkf5QemfejhWZbdNW+Cr
	 jE+LOvBnPY6+8FrGdlDriT2i/gZwMY5h01pwSy7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0325/1005] MIPS: Alchemy: Register interrupt chips with the IRQ core
Date: Wed, 25 Nov 2026 15:27:43 +0100
Message-ID: <20261125143829.345820183@linuxfoundation.org>
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

[ Upstream commit dd722e605bd6b5ac593475ad2ed76cd9d27cb2ef ]

Alchemy initializes its interrupt chips through the set-type callbacks,
which use irq_set_chip_handler_name_locked() to assign the chip and flow
handler. This bypasses irq_set_chip() and its descriptor registration.

Since /proc/interrupts switched to iterating the IRQ descriptor maple tree,
the statically allocated Alchemy descriptors are no longer found. On an
MTX-1, the file contains only the CPU header and ERR counter even though
the timer, serial, Ethernet and PCI wireless interrupts work.

Register each IC0/IC1 interrupt chip through irq_set_chip() before setting
the initial trigger type. Do the same for the Au1300 GPIC. Keep the locked
set-type callbacks for later trigger changes.

Fixes: 171cc0d9eed1 ("genirq/proc: Speed up /proc/interrupts iteration")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/alchemy/common/irq.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/mips/alchemy/common/irq.c b/arch/mips/alchemy/common/irq.c
index 2403afcd2fb95..d2fa8731fb3c0 100644
--- a/arch/mips/alchemy/common/irq.c
+++ b/arch/mips/alchemy/common/irq.c
@@ -892,15 +892,21 @@ static void __init au1000_init_irq(struct alchemy_irqmap *map)
 	mips_cpu_irq_init();
 
 	/* register all 64 possible IC0+IC1 irq sources as type "none".
+	 * Register each chip with the IRQ core before setting its type so
+	 * the descriptors are included in interrupt enumeration.
 	 * Use set_irq_type() to set edge/level behaviour at runtime.
 	 */
 	for (irq_nr = AU1000_INTC0_INT_BASE;
-	     (irq_nr < AU1000_INTC0_INT_BASE + 32); irq_nr++)
+	     (irq_nr < AU1000_INTC0_INT_BASE + 32); irq_nr++) {
+		irq_set_chip(irq_nr, &au1x_ic0_chip);
 		au1x_ic_settype(irq_get_irq_data(irq_nr), IRQ_TYPE_NONE);
+	}
 
 	for (irq_nr = AU1000_INTC1_INT_BASE;
-	     (irq_nr < AU1000_INTC1_INT_BASE + 32); irq_nr++)
+	     (irq_nr < AU1000_INTC1_INT_BASE + 32); irq_nr++) {
+		irq_set_chip(irq_nr, &au1x_ic1_chip);
 		au1x_ic_settype(irq_get_irq_data(irq_nr), IRQ_TYPE_NONE);
+	}
 
 	/*
 	 * Initialize IC0, which is fixed per processor.
@@ -947,6 +953,7 @@ static void __init alchemy_gpic_init_irq(const struct alchemy_irqmap *dints)
 
 	/* register an irq_chip for them, with 2nd highest priority */
 	for (i = ALCHEMY_GPIC_INT_BASE; i <= ALCHEMY_GPIC_INT_LAST; i++) {
+		irq_set_chip(i, &au1300_gpic);
 		au1300_set_irq_priority(i, 1);
 		au1300_gpic_settype(irq_get_irq_data(i), IRQ_TYPE_NONE);
 	}
-- 
2.53.0



