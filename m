Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024567;
	b=4u5e/O4MjB5JrloBrjh09HSNrT6Fw6DLSHk05GaplogMRI1aFuMjsU17pjfdjePlKm8Z
	 dmG9kTTrFcep+VojugYjviQy3noaZuCmMejGQW/YGJw7S5q3SW8rbpYAYze/nVhUBso9/
	 yULf9/wviqnyRUQBpO+jikDer+JtlrAbRoN/Vai/0eZqpjf0kn4XXHnVYXgOT22o3MVId
	 CFF3oHE03KgaEfYo9OlfMeZFP3mGZQ1eKVPvsv6GPjZ1re8Y3IfcZy1zeZ/pwRBe7hVof
	 9Qwby+bSCVSB7vXOXo731WWwNh7Z5F1VSNuCLqOhVkxWpA42YrqFRK+hA3iXf5Ezzbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tgnVM+fZLgZZZwuhYp2RnatWGWHmAybjeqfzn6LyyJY=;
	b=ajLpL/kVNuDwk1wjeuUK4HnK6l8FuqD6e3LezL5UBSkQAGojSN6hsM6lyB7q61EpwheQ
	 oXMKlpHCfpy/nws2OuS7FodYcZLD4zWHOlUsY3sxIm7PlU2XyaA2spjHbRQ77z/ZFXkyX
	 hu+Wa2wLmwxJemHMge8olRs85nj6bgI2CLDPUrM9ZvWzUV1OcQ0tcxSAV0pFWg1I/G8w3
	 ub2MlKogcjPMf7JwZrKYQWmYbaMZ1YK1hGwXFcSSPR9xMBIKGhpLH++wiLZ1hc15WUNlP
	 bVZpFPOi8vw5o43a82BFaYI13ZChLqwnevSxi0AKTR7ziXvp51yOJQWu2wPy32ZAr+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTCdy5xK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A186606A320;
	Wed, 18 Nov 2026 17:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTCdy5xK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED021F000C4;
	Wed, 18 Nov 2026 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024567;
	bh=tgnVM+fZLgZZZwuhYp2RnatWGWHmAybjeqfzn6LyyJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTCdy5xKWKsLOh+uBJYTmutrzwRrCzYtHwxdA1qrWf0w3j/zFc4wfaJObfcvMc5wN
	 Iz7doudCxRQnqO/wFSlJakH4m0B1+Fl2VgHOIyZAwZ1cD3+PWt2qAWW7jvZwNM/ddB
	 3yvxmyxhj0q5vp+qiYO99ZH54Hvn8Eo0phNpcr6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0770/2151] m68k: apollo: Fix interrupt setup
Date: Wed, 18 Nov 2026 15:41:45 +0100
Message-ID: <20261118150150.150318366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



