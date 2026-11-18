Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042403;
	b=g4jmUc/cobR021sAhYrjkANykIzUvLzNSnEVYUN3Rpp+DPHc9R8Sbagd4GuWTnWS9JoX
	 tMfo5CoJeE/ziCmKVvSrBpMEqKdqaRaD+IlBfXK10tgIMeL7RnWJ2cgaa6NwXy3QT6YjB
	 lc3K5GmMCnEgS0tXwAuZgEZk9GU8mQCvswyDbK8po8fs5S//BgYTxTrcnDLQU3KrkVLrT
	 Zy+yyo5XtfZTR4I84/vVn3ZCMaIzgMOp6N8kfGIKqFRscEe8Z6JLlkFyqcucG2LZCrQ0u
	 HFp4aSzUqqzB3oQRFMw3F/eCJK29ZMjJdfCiM7NrTTx4AzWbDbkfPm9MJ9Wm6Abqrzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hGeu/PhVYDLfvEhxADTzH32OcPTR5NQHZ38HwoKequw=;
	b=D4jReUS57qGmcsNXSmPJKC/anVzUVtwyQ1XBPMcoQLgngSVLWLEH62b+a1ywnDPDFL8H
	 6RFukHXSD83LE3BXRb3+BC/NItUFQIV+6iZtt5I4KpkUD9126R5F2lu8GhNrlzAKYrMmv
	 uRsJCrS0idUOl0jj23nhh6vi9FHRK5H+vWG7+wlMM6J+bv3CRXr5Eb9/EJIdaO/Wd2u6g
	 qrAv9YhKjwkHVbxeersrLLUX1RilxUv4Vk6g9JC6C0HC2IvmzGViSe4HsWoG2mc41zaQ8
	 vxQgL5lk/LGpVItP0noM30+6eC9WAc1vfUkt8Y8iNYRWV1eac8GgcXTp4EWogjLSckw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/h138En";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B404C606A325;
	Wed, 18 Nov 2026 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/h138En
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0251F000C4;
	Wed, 18 Nov 2026 22:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042403;
	bh=hGeu/PhVYDLfvEhxADTzH32OcPTR5NQHZ38HwoKequw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/h138EnfGD6+4wAizeEc8xL4qMCj0Epr5WJaI+uWHUw35kBS/zSaYJ6wX/bCy5NR
	 Y4LwKNZpV3dRkyqzd0xK2LBTVcX3qKHye4PLTQozk7X8+pAwSjxyaPy0N9DjHW2S6d
	 s5Pm37gojnPITBW1F1y7hJOyoDiGBN1vrfy+Ev80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-sh@vger.kernel.org,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3117/3318] sh: Emulate one-byte cmpxchg
Date: Wed, 18 Nov 2026 16:02:19 +0100
Message-ID: <20261118150453.456563295@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit c81a748edefd098ea21dd35d4bba03f69412fc26 ]

Use the new cmpxchg_emu_u8() to emulate one-byte cmpxchg() on sh.

[ paulmck: Drop two-byte support per Arnd Bergmann feedback. ]
[ paulmck: Apply feedback from Naresh Kamboju. ]
[ Apply Geert Uytterhoeven feedback. ]

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: <linux-sh@vger.kernel.org>
Acked-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Stable-dep-of: f45711b39e03 ("sh: Select BINFMT_FLAT_NO_DATA_START_OFFSET for !MMU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/Kconfig               | 1 +
 arch/sh/include/asm/cmpxchg.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 33530b044953c..3a81cef700fce 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -15,6 +15,7 @@ config SUPERH
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select ARCH_NEED_CMPXCHG_1_EMU
 	select CPU_NO_EFFICIENT_FFS
 	select DMA_DECLARE_COHERENT
 	select GENERIC_ATOMIC64
diff --git a/arch/sh/include/asm/cmpxchg.h b/arch/sh/include/asm/cmpxchg.h
index 288f6f38d98fb..0d7926bdb8a72 100644
--- a/arch/sh/include/asm/cmpxchg.h
+++ b/arch/sh/include/asm/cmpxchg.h
@@ -9,6 +9,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/cmpxchg-emu.h>
 
 #if defined(CONFIG_GUSA_RB)
 #include <asm/cmpxchg-grb.h>
@@ -56,6 +57,8 @@ static inline unsigned long __cmpxchg(volatile void * ptr, unsigned long old,
 		unsigned long new, int size)
 {
 	switch (size) {
+	case 1:
+		return cmpxchg_emu_u8(ptr, old, new);
 	case 4:
 		return __cmpxchg_u32(ptr, old, new);
 	}
-- 
2.53.0



