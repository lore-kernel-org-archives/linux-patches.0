Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618569;
	b=UPZ7vaGjSgx4uzapy+IOzMZn111n1JjKkwcihbUTH1tVvigtVtYeqZ3BovYWibetFxPp
	 +MO3evKXI+8y8YabFuYAVvgnd9BbZVFQx8+HLfsS+7ephxGidG976lkECp5VesdWBxh7r
	 ah2igvS4RQ0+BN8qovWCvk9phdH6vZdKIx1t0gaJjN4EirBt1Fjf//DpNyBcoITsz5/7h
	 EFvoC2jdJZDtJ+qq+MPC4kxXIa34QVzX8KW+d9ddW6sKxcQKSVLuKLLq1+W1VWAH7pVOR
	 NyK6zo8fLg7XfUOHFIZTHFn4hVeAKIR25gWeQZMxoiUFcT8ie97jhLPPoziYyyHT0XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NZFQo3u/5J66uHXuVmxNbH1njOYO4PWBZYcwS5W9tI4=;
	b=rw4Ou2GGMfhxIX+cc/FZSdYPBMUezpyO1EzoWO8PxEfaJxK1wqlk7gjshJ5Rcd3bjpNh
	 fS47tNKAblFo/C3YuD7xpO9eDNq1lFbFvxZq8D3Xzx23/1Ps9qbZ3l12tLanW/UCLNxUh
	 057ifmKZYehLlQJujI5e82X7km4YU2AHyrmKs0ayriUIcUycfxA7UJ1dAt/9iZJMxFsHz
	 Z0pVZ0pD4j7E/mKV8UmRl3gF8WHdKUH4nPooTq5uxJ9Nr0rgy9hkAYrfLMLmpDWkWoaIK
	 wepFzsny/h+u8Yx0l0p2rCx3uGIthmOJNSSFkoevfutT1J77Xc5PBnDyoGEha4hZK5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e/6fYcFG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F238606A68F;
	Wed, 25 Nov 2026 14:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e/6fYcFG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E4E1F0156B;
	Wed, 25 Nov 2026 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618569;
	bh=NZFQo3u/5J66uHXuVmxNbH1njOYO4PWBZYcwS5W9tI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/6fYcFGTnVSBdvTWld4cruZR76OiPFaYp5JTzCOp4MknZqaFGOYZSBMEEypzeUwP
	 evDDw3t1JUcbkwLJwtINHEgXl+mGTLf5sFrmc6TvZBYh9LG2TLpgPIJ2nKOk19JkUO
	 /S0qS7P60yz+kLCRGjcqWIfICVRqJVAbBZ3JM5Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0322/1005] MIPS: SGI-IP27: print the NMI dump on an nbcon console
Date: Wed, 25 Nov 2026 15:27:40 +0100
Message-ID: <20261125143829.278141397@linuxfoundation.org>
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

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit b79147fb33c3b5713c005e763b00239ea14b552a ]

Since the 8250 console became nbcon, printk() in nmi_dump() only queues
records for a printer thread that never runs, as no CPU leaves the NMI
handler. Print from an emergency section and flush pending records
before the hub reset.

Fixes: d3539347022a ("serial: 8250: Switch to nbcon console, take 2")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sgi-ip27/ip27-nmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/mips/sgi-ip27/ip27-nmi.c b/arch/mips/sgi-ip27/ip27-nmi.c
index fc2816398d0cf..c502982621e6b 100644
--- a/arch/mips/sgi-ip27/ip27-nmi.c
+++ b/arch/mips/sgi-ip27/ip27-nmi.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/console.h>
 #include <linux/kernel.h>
 #include <linux/mmzone.h>
 #include <linux/nodemask.h>
@@ -183,6 +184,12 @@ static void nmi_dump(void)
 	 */
 	arch_spin_lock(&nmi_lock);
 
+	/*
+	 * No CPU leaves the NMI handler before the hub reset below, so an
+	 * nbcon console's printer thread would never print the dump.
+	 */
+	nbcon_cpu_emergency_enter();
+
 #ifdef REAL_NMI_SIGNAL
 	/*
 	 * Wait up to 15 seconds for the other cpus to respond to the NMI.
@@ -227,5 +234,6 @@ static void nmi_dump(void)
 	 * Save the nmi cpu registers for all cpu in the eframe format.
 	 */
 	nmi_eframes_save();
+	printk_trigger_flush();
 	LOCAL_HUB_S(NI_PORT_RESET, NPR_PORTRESET | NPR_LOCALRESET);
 }
-- 
2.53.0



