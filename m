Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056719;
	b=0W8a4yXo00yrUV26FBqYTyDvmBY9+T+XDUuCZgxvKT9FqTtIsFGsVfShCa4WnNibf19n
	 NtHJXpVNt0RYfEeYXpIVw0J2kXYmQrGKNMy/S+QAw/ZzLRW693LacYVhtUZAuH/l9a2pF
	 naoSUBZwbWbmQFbyyN8wJxr/6kQGmNppx6UCpYzCd0NlOGedR/NAXXwWJiN2+N/7xk4Pc
	 HF8Tiukz6oTpNOu6RqIlitDobafNatA/gRmplT/mM3iQikJ7td28XSL7qekxvW3jIL3H6
	 Rq0BF16rluegzmE6kqV2arDxZEZKRAKiyKZobAoXAiTIn1owCfEXNqaB8KZd/7OUSDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4JOAhmtL5b+DiMN5bn1R4rTFPGaMRZEaLxeGFdEKzGc=;
	b=MOUD4pQhKUtV5Lh+5X0iCV9g52rQ2+HSrwEMo8jmuCcuSZceOxx1KYzuKF2HYFrseSQ+
	 fd+8HnLeXDPsecniKNvYtYw2OLvND311rMkOZSN00WFOA5JHqLYh2Fzb+Lpz7V7vTvzrL
	 Kcqyb+HY58kUCk/l540xnaokeQzIrSvXXKm0QLbm4YZ1fDbRzJZHk4xmix6yJ7fD35yEM
	 BLK/9ZOFR+Zoq20XC03MJt+UcFKUvY544MV1VO7dTZ16RYG1WZ7/cfKZhrPpjK+atgX92
	 9kyiN1HGXjQKzieSXwYpOJAZytG9toWTQSvNrYYMlFVzHDodZtHBy/VD6IjdKhMItGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FlT7JIBY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAA1606A333;
	Thu, 19 Nov 2026 02:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FlT7JIBY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7D11F000C6;
	Thu, 19 Nov 2026 02:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056719;
	bh=4JOAhmtL5b+DiMN5bn1R4rTFPGaMRZEaLxeGFdEKzGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlT7JIBY0hT2cCwpkH+KONBEQtTyEJaJMJpuKHoP9P0wJre7r3ZNZbm3y/q+Sw89W
	 7yDmZpD8UAIBp1FbY4PfjhGwG45vSUa3EaN/kP8fJB+ltHPfq/BVi2oDoDo2x1lIbl
	 lIUX7PLc5PS9k1FlcV/TrNsyYf6d5qnQ8k705+Es=
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
Subject: [PATCH 5.15 2089/2214] sh: Emulate one-byte cmpxchg
Date: Wed, 18 Nov 2026 16:02:45 +0100
Message-ID: <20261118150134.188657707@linuxfoundation.org>
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
index 101b95f26a91c..04c41890fb79d 100644
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



