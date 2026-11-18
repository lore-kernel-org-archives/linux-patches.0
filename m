Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050356;
	b=PLmMskcE9aktvqsAPCKBSbAPeLMXzF8lz7Nx1KBDTQN2MXXHE9fa5QRWz4s6M90lhCpD
	 +WHUNsyCjYk9jYppiv9uv+xZ7F+QKtEO2yi96mNNLe4VBOZpgGrcSJ1Sw4YXKfoeJULri
	 TtiHbuLDScLjm985sEtaHz9Mpekc7bjHV4WmTiF3wPFWklLk0aVwrSWNvh421w60pmtM5
	 ofGF7gcRBhGpAlvZOjMmb5zapGz2GL6cGRb1yOq3fJf0yAJcUgc0jPnkBW77PA0HP6pe7
	 X0fhIDYffC7iBmIUbkYbLYoOc4xZkUtltACg93wvLyMGMk8Vm3FAhU9iHti3XWjE7ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3t63E9YjCHi+iaYwrImCyCws6X0RAOblzSmeaPd88yw=;
	b=nzshx8GIpfjF9HHVwn1yTYNgn1+HlexVXr12kxxbUW5iHmsTqSsKPgZ5AgpS33FbiH+G
	 YOXwxRUSO9CfdskHVy8xM7KyYoV+b3J0NKwAjFpP7sfXgn2lxhHIBtZPplk/xbqNIvN7F
	 9/UikwVsDqCwc+UOt0oozX14J/Vb4QcEIabPv0XWOKV1j++KvRdO/TRfbZhAS068juYSB
	 l1pAWjyQO5Eh6Zx8ylo6MlnGSbjsleguAlQhQB6VNqhXaS68S48xT7Jm1Tm3WI9lInKXb
	 yh4suPK5P1AxRp2QG7lCZF/1xdJJ0APgmeDkRS/CeewrEKIBxYyElAiFaVBEwd/thKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0jguTByM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CCA606A33E;
	Thu, 19 Nov 2026 01:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0jguTByM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0AD1F000C4;
	Thu, 19 Nov 2026 01:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050356;
	bh=3t63E9YjCHi+iaYwrImCyCws6X0RAOblzSmeaPd88yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jguTByMMarEyLQq2asgSx293GMs2RFTbSfLbI6OgJoUbc08Ui+RHXjsArDLv1VrA
	 QcKP4jOkq8SgSu+zZPSlqA+I+z7G54Kc073CNxsGBA1O06nU8Zn7fldquCwtQeilTv
	 8eTHoc3z376R7u0TjrB+cE9pwSn6VMS8+rOPjAoE=
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
Subject: [PATCH 6.1 2680/2857] sh: Emulate one-byte cmpxchg
Date: Wed, 18 Nov 2026 16:01:54 +0100
Message-ID: <20261118150338.072926119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a0593f6ce0e0f..dbbfc9ffbb955 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select ARCH_NEED_CMPXCHG_1_EMU
 	select CPU_NO_EFFICIENT_FFS
 	select DMA_DECLARE_COHERENT
 	select GENERIC_ATOMIC64
diff --git a/arch/sh/include/asm/cmpxchg.h b/arch/sh/include/asm/cmpxchg.h
index 0ed9b3f4a5779..3d5ca061ffba3 100644
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



