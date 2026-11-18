Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030182;
	b=oSSLCR+S6uRVJ3OeTdDHDLg5kwrWoCk2hXQhA/hBQheSm4lRkUPrgDiZJY/AKrkRs9lM
	 lTp9jwuus5xBBbUMrJNB5NpmHDYE/9vB0gPIAUsasrwnR5AbUl4IaVetDTq+Q8xYBQFWo
	 afKA4uZDpAidAAp3yjQFnVm6a/fITwZdJKOayp4lq+97bK1LOFk/2G1koXokk6I+AWfU5
	 dpWWm/GSx2HWhen54miC9vbuxzOZgYbiW3pM18TrBrgAvBbpRuXVHuZVDa9zadNhFdl51
	 J2pXyT/65iDw37boqncJw65bE4CPX0BQPqMZOc+2QVOfYokOkXYXEYxWr85pHdujdqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8kOK92kn8xwhYLjyS4y+Gos3/OOij+oZwxCbeC0yJ0g=;
	b=lK+KOl960y5v87scMLsIS6Y6mfTluEhlK/rFjF28a4VqTnXCUl1i+p6saSECWwrJf4gw
	 kpLVZ6WvsoF6CFHa3mLVs2Mw7hHX80XGkiHcjLSECKavYgDlT/5LJPRwQrmB3TRoGcBSs
	 pFMdwUjhatKY7WZBOPqQNPgK5NBOh+uy9OAtBiuF+dAceaxfixDG3oQiaSuKqJABI2ToX
	 v6VG1sN0fAXMzLqRy73PLkqoLicnegoQZmm3XaOT/CJOwBJtQ5qWjX5XHML8AcLQMJVQg
	 RXT7i+d9+055SRoSvihbiD/fEgbmWU4fSp+7C3ae134lkn2Js2m29eg1kFL2CDjicyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=noeTmtf7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E23E606A32C;
	Wed, 18 Nov 2026 19:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=noeTmtf7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73431F000C4;
	Wed, 18 Nov 2026 19:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030182;
	bh=8kOK92kn8xwhYLjyS4y+Gos3/OOij+oZwxCbeC0yJ0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noeTmtf7ww8DqtQgBfdJoWxY1lya+7ZqMKXM5Nb935IOyO50NQFaw9Lmo66sQFNg0
	 VwrYOyGS8QYJVjyRtsCubzaQ8x0CY9xgKEvxWl73NHvi0AT5nGPuQEKDCz1Tuv0iau
	 dhwhV/t0tDl6+ePejqVCC52792NdEe9gxxVeDRDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0615/1756] m68k: apollo: Fix interrupt setup
Date: Wed, 18 Nov 2026 15:45:42 +0100
Message-ID: <20261118150033.410981290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



