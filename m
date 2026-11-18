Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055420;
	b=f2nQYkyzl3dCBdcFZxOT+kmHVc2mUMfFltw20VmHcE0HA6WHsSU45TFw4JMBDUYIkXyJ
	 L6RVhMocMVbtKR+JMKhIYBZAHCYqvkZTtprs14pS8HyF7oaoIJY40Ay9siaCx6w5Xgnps
	 Udk1zk9ZsEAYTAS9nIoxWBS4dPK2FEa8X26g2OJm0LrVgS2zVDxFVCkRm2Falg5A0YLeL
	 UTQVLOP2OOqWQIlnSKc0/pbgjctZZqJKuxhJAikNMSSK5yrGbFjwuSAymuVL0zvNf0y7R
	 T2vs+jFJEEgMRa5GywjhKy1BSUY9sTJwHdEcYicV/8AJRlE48ELy2HcfH5ZepVpHjdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jD72eDQ6fvc9SPHudNxTD3QC8vPEuyUkB4bkpbBsM3U=;
	b=J5bCvXv0HI775mFTcn4Isyuq1UyEX5HdmkaRkqIrto8CEwqboOzMQ8DPd8HkUxR3JImd
	 z+v2hRFMWcXAOtN8r6vob+KDwpBZrDzlPFC3gU4JeWmHBccTiQ3NY4JLVorQOONKzTZTc
	 3HMYL+p1FvkkWkXgIEMETphPE2t9IPSJWLSNOVP8EBh1MeQyoL1YGkG/u1I/pP4F8m3QJ
	 hQmvX1E5ELye2UgAq/A/ZT/awqgXb7PlyywWPEkAVfZRSwUr9hoduJVJINdZ2UDbkftvg
	 IvKSCgxk3TgWVwnpI4iIdYSKzC9+inZc/x0A7XC7JgWOUBheu1YHBXa6BOCJxyVuXpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ia3k3nTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1C2606A325;
	Thu, 19 Nov 2026 02:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ia3k3nTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9461F000C4;
	Thu, 19 Nov 2026 02:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055420;
	bh=jD72eDQ6fvc9SPHudNxTD3QC8vPEuyUkB4bkpbBsM3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ia3k3nTNEA0sXV7ZmB7ltTBnIL43X9qjy2GMxMeTBGH2Ive1C5niXp48MMSjtfKk1
	 y3RyuvwxVZ+86TLhDyS7YyqluDe5iZKLRLbz9J7I8HBou2lK2xKBliSnNAzw0lS8ZQ
	 2+7yjLuK7aopHhJH1WplmFUlMxqryH7QpGXcp6zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1624/2214] m68k: apollo: Fix interrupt setup
Date: Wed, 18 Nov 2026 15:55:00 +0100
Message-ID: <20261118150116.936727826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



