Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060922;
	b=qUkhzNZLo0iElgIBu0eH/+RnGfhZCsoNUb6aUYka1z+M84u5mKgNoWMYcwt4Hn/wineA
	 8DXaOFtTr8cXrQ0xUsuIBZ/IpiKDcxslyx8iMRmyPm5xowJfRzOHO4Dy9ISOQ73KzElQj
	 02TAqL9jVypUsQggLRDJbbQUhKnPW4NdcFI5DpYlaCI+g6DvxQwbZLgehed7Lw1y+rLmV
	 yjOy9y7n8bArXpFTZslw248WTtSqjoqy7IrfnyGc028AJNedoe7CdgNoz1ofxWJaVQNqs
	 FEJjq6A9jTEPNjMf8Wo8FtWi96fHMXWqS8/4sXPwxIDZ5w+NMq36Vg6L+9nOcHDlLbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OAbBdSWmt+SvDEaAVmLzSmlLS/92/XH737VHi7DwtiQ=;
	b=BkzFD5K1yA8bpLI0bQDgQBVDoBRDU2ZM0WcjTLFUI9Jlvx872SZGhGys9Jzo0iF4Z+8/
	 T3JU9OCRiVLetH59HmxvacdxegEN+dP/D85icXMVSubB75m7jeB4/OAMI4nFe6ceyPKCW
	 cxxlC3KmYBKklSNTdBZKjsbo9OiP6iAR98XEou2MTtat058TR6U92dehmP6+PkNLtXqdd
	 5aM3Vft+/2c8mGpPSz57xcd01y5CipNV8Zyr/Mc8yr9xnhyUebr4ZS00BLXcKjAhWyRKA
	 DW0vr83THiPFBeZgcMti/VGSa6APYu5kZzpyTYfcWEXovHpSvTpubsRLNKhPNKI0pLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMaicVxO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17702606A331;
	Thu, 19 Nov 2026 04:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMaicVxO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696701F000C4;
	Thu, 19 Nov 2026 04:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060922;
	bh=OAbBdSWmt+SvDEaAVmLzSmlLS/92/XH737VHi7DwtiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMaicVxOLVRTczVUx2g3XZpqIbHLYvA6Zg6hBpbH+oNHHo8Yit1F6ok4v8WFGQtvA
	 qVpER8sP7YLCZl7hngrJdnejzzw9Ty0i2yCnucTUmKZOSwaCfYx8Oy6Ou2PvdsNjyp
	 nj/AxgRtLtyzRG3q4/dlcNWZEIfOGULtpqcBzQmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1370/1848] m68k: apollo: Fix interrupt setup
Date: Wed, 18 Nov 2026 15:56:48 +0100
Message-ID: <20261118150016.908133268@linuxfoundation.org>
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



