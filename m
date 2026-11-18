Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040259;
	b=k9A8QVrk1S2kJPbnOY8n36MyWc4zu0c+MqpVxUpHwbOx9P1HV1ClKLTwlR6Em4APGKOl
	 EWrrPBfhboligUjymuTXBrM1Pocq9aw4T8r9+afqmxWReinYNWih6wiJUnyOauwbSl+hZ
	 Z6ypkrLPOkUyelia81EmlUH2NW5g5PUXy70BMhmMR4S0Lr7kAz84fUFRPOs42WSEgjRqv
	 F3ESJ7PLzRtaa/iRS1blC0mRd3ThpiYQ5JTTs5SKGKR6VnzS8ciei9ELb8aNcA3Uh3NXp
	 tGMj2eAtYDZYWCQviWZz5i7gn7pqGDud0xeCWoVoMVqGV9xEMSUJo/XXT6ekpeQkdPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hefa3kAdLkyTKl63bIGD+dsng9jU4R4McZbz3fHjoa8=;
	b=PU6CKDTQPgvyxMnuzK5SRGX17Ztpbx5WvOA0Gtrc/u8AFsp1HhMKn0uB1zW/LKsrUb7R
	 1CtjSA6j/T0G5umV8f5cX3xrAvcUOHwrz6i5u9ov6O4rOxjH9Vpf+pNExsX48hgHVWe1W
	 wL+HIq2/OOHvMBjHqbcLIBuSmb5EgidFJUVpo71Ydv/S1x84WOmpkuGliAdyO1DR7w093
	 OM6EMLwj/kFbehi9kAfSaqZKegCXA2Z8h8HjqJUAuJpXNNgOMLlmBjK6H/DJTjzcUp3nq
	 FFguUJBmkSb9S7uUzgmdICJkqN+jJIPPqJoSdgE9RR9qjVZnb9zf5bVQVgZlG6i/2mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Edm557EG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F71F606A31C;
	Wed, 18 Nov 2026 22:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Edm557EG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8DF1F000C4;
	Wed, 18 Nov 2026 22:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040259;
	bh=hefa3kAdLkyTKl63bIGD+dsng9jU4R4McZbz3fHjoa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Edm557EG2gZNZ9e+gQcOzzJsSNnhx9NVqvY53rPsGzJHQW8tZFBD/DRQCEKX3R9kR
	 cWm9YkRuXU4qb34smx8rq69gLXJZPm+joj8VlaWcLCmAqM8LD+J5plOhR48mOHrZzI
	 HQKIewxWfPS5ak5slpPHFq3QxLkRH1zawUQ5NLGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2392/3318] m68k: apollo: Fix interrupt setup
Date: Wed, 18 Nov 2026 15:50:14 +0100
Message-ID: <20261118150433.276839611@linuxfoundation.org>
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

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 6cdbe63badcb524c88f2c8b3cee08f2ffc099a1b ]

The user interrupt vector needs to be installed before the interrupts
are unmasked otherwise the timer tick isn't handled and boot up gets
stuck in calibrate_delay().

Assisted-by: Claude:claude-fable-5 # Wrote Apollo DN3000 emulator using QEMU
Fixes: 0aa78106c661cf6c ("[PATCH] m68k: convert apollo irq code")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://patch.msgid.link/20260828094940.3882602-1-daniel@0x0f.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/apollo/dn_ints.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index 02cff7efc8342..e62c96c5b0dd6 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -2,6 +2,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 
+#include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/apollohw.h>
 
@@ -9,10 +10,13 @@ unsigned int apollo_irq_startup(struct irq_data *data)
 {
 	unsigned int irq = data->irq;
 
+	m68k_irq_startup(data);
+
 	if (irq < 8)
 		*(volatile unsigned char *)(pica+1) &= ~(1 << irq);
 	else
 		*(volatile unsigned char *)(picb+1) &= ~(1 << (irq - 8));
+
 	return 0;
 }
 
@@ -24,6 +28,8 @@ void apollo_irq_shutdown(struct irq_data *data)
 		*(volatile unsigned char *)(pica+1) |= (1 << irq);
 	else
 		*(volatile unsigned char *)(picb+1) |= (1 << (irq - 8));
+
+	m68k_irq_shutdown(data);
 }
 
 void apollo_irq_eoi(struct irq_data *data)
-- 
2.53.0



