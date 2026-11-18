Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017505;
	b=Id29VIViO/gqLtxAHvn754tYQW2/86CNiaXABJhtzP4qVDoP+r54Hzwi0+pRgSo6+kSk
	 GGu7n1lj+BGktDDO9zVtKJWK/V8QNhl+rHFJ6xpSPsWUdMKojbk5Eif3BfhmzUWreOpqa
	 rA3PBt/4yFQkqSDxgwSfIpakI8n8vYWwVUyxyyiaBBznTDRAMcdEPSnjvTJVi3DFicInA
	 SbRQSf8S/PSClnAV26zQrZwMuCRWgzIwX3a2qU/thCmh12DfoQPM8ZgrOsXCzbuWf2YLZ
	 GMcW/EY4qu6nUUm7RIqu8W2SGSSc6bCHThjOijG1VQvu/tzJC8+RDtAqTDGww3Iigjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=93nLpnt/PrfmUwss7MCQt+1IM+p+umFdeVKmu9WpWpE=;
	b=0p8uJeouoaRf6SAGd0Ev8aWwdBv+Xn6bs80jc2zYb6udljth2NFnPbw2zvvck5C99yOk
	 3ANvc1mUQoK8Pxx2RMXHllxjRIlAvpqdLQlQ5QstWaeNZMP9Vf/oKU5HRrc4v5W2FPsy5
	 Jm+SE9XhT9hkxddIpkcFHSkVJ00JYCWSikAI9PwkkoUVjivzVfKPAA3H7HICx6tWhaJBl
	 u/mvU/I0V+SyrOAFxJ7BrbszbUzsFBtzNuqOtUUdCT/oMV/nQX4FO40q9NN9tu1Q9vm4V
	 I9mHSx33quD52f8VkjAnjzHx8/3yHE7uCwgNW8rJEJoj2LPBVvFVJmEKpium3ZJ+eJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mLttHr/G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3F8606A32A;
	Wed, 18 Nov 2026 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLttHr/G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9021F000CA;
	Wed, 18 Nov 2026 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017505;
	bh=93nLpnt/PrfmUwss7MCQt+1IM+p+umFdeVKmu9WpWpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLttHr/GgtVrKcruGOcdklF3VoTzr50n+neqdT+44IJIy07pF+wZIKW8WO0uvSTak
	 8rNnMWCXvodX1b3HF1P1n9YEixt6qnyHprovjjCpGYDKvl+Sqrac6mUhQiRxQl2m9L
	 Ll5LOeV2hsE/ZDjC/0zoB9QFgQcc3rjbfD9QAQJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0906/2651] m68k: apollo: Fix interrupt setup
Date: Wed, 18 Nov 2026 15:35:46 +0100
Message-ID: <20261118150320.495354430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index ba96a92f8f18f..89bfb5aaad9df 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -2,6 +2,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 
+#include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/apollohw.h>
 
@@ -11,10 +12,13 @@ static unsigned int apollo_irq_startup(struct irq_data *data)
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
 
@@ -26,6 +30,8 @@ static void apollo_irq_shutdown(struct irq_data *data)
 		*(volatile unsigned char *)(pica+1) |= (1 << irq);
 	else
 		*(volatile unsigned char *)(picb+1) |= (1 << (irq - 8));
+
+	m68k_irq_shutdown(data);
 }
 
 static void apollo_irq_eoi(struct irq_data *data)
-- 
2.53.0



