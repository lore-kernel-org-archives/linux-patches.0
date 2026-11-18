Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019901;
	b=LtX/9rpWE0r9/c3dH1efzDxe/EBtgyX4isBLZqgNSAOsr0v6dH4eCK9e/HLuqvVv0wj5
	 37skAs6Ba/x6yaoJN+pdxxTG41RW7sXVzADia/aei7pgCjpfpEOaSGw7hEz6tIr1jBI5u
	 JvGjuVQ5K92PqSYb0egxvm13/5NQ7t7XkepewYQeEyyf772yll4kfHCBFO5Qcn6waQPdx
	 x2ZXdn+TenNKp/qiyUcYD3Kb6PYxAwjXydGiII66oCURtHBwNIhjhJXp4dhUt3B+ZruMN
	 iI95mjkTdLivAKDp+HxQimfIL46r/YqV+4qKFc9JHyLWS54fLdJlkQy3q7CzaJ24Y0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dJhjfY4cAiLgAXwM73xwm2HNeMTNVmtN7ub4syhf4l8=;
	b=thnDFtEmJvyU09jruNvSmJ7s6xGYtQcLJfqWte1G2hHNPCuaJc0r4vVoYxpv/dwEwVYO
	 e5ZBMw5GPSWxrBSQ8dba055QAhH4GlBtt+++RS0lDKyObhxKbjr6qYv6AsQmPqxWbesig
	 BW7LqdGuox2z2chDzKUMsrxSK4fiN9R8TA/zqaZXAH8tD1/iWD+eyrwXbhfpijhDvdPbT
	 ZwycBdRfOGfDI2dZZkkZ2PDUPqWh/BJJ/pncLjahQgSbUBU/i8R8RnGP+0apwY+LGWb2X
	 GCQfwb+j8wM8/YpgjK9AzNMuQT8yT4HHYIjUjXSvxBAUAqH5NAcBnneYzqXz7HqKutA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w534zJu6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AA7606A32C;
	Wed, 18 Nov 2026 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w534zJu6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7811F1F000C4;
	Wed, 18 Nov 2026 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019901;
	bh=dJhjfY4cAiLgAXwM73xwm2HNeMTNVmtN7ub4syhf4l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w534zJu6gCNYcfwIBLmLs5rxEbTfnVk5DGP+5exQmJoJ28Rjz2CThKPMZdV/zM3c7
	 cvMmU8CroCzgQ6v3Qdx0MZ3eQqMrzbhrpEL16b3xqQ/E+kO25UdyBK3zm3/kIdjhWo
	 jsbchar2ZiMJY1F+uycD9itkIbxO6yASAyXE2xB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1761/2651] s390/percpu: Rename inline assembly symbolic names
Date: Wed, 18 Nov 2026 15:50:01 +0100
Message-ID: <20261118150350.847844948@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 02a8ff0f894f6960d5d5fb47169140a1ae5c024d ]

Rename percpu inline assembly symbolic names so they match (more) what is
specified with input operands. A trivial change which is supposed to make
the code a bit more readable.

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 60 +++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index ff32c56b4d79e..ac34847cd7fc0 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -151,29 +151,29 @@ do {										\
 	if (__builtin_constant_p(val__) &&					\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {			\
 		asm volatile(							\
-			MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
-			AG_ALT("%[disppcpo]", "%[ptr__]")			\
+			MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
+			AG_ALT("%[lcoff]", "%[ptr__]")				\
 			op2 "   0(%[ptr__]),%[val__]\n"				\
-			MVIY_ALT("%[disppcpr]")					\
+			MVIY_ALT("%[lcreg]")					\
 			: [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
 			: [val__] "i" ((szcast)val__),				\
-			  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
-			  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
+			  [lcreg] "i" (LC_PERCPU_REGISTER),			\
+			  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
 			: "cc");						\
 	} else {								\
 		asm volatile(							\
-			MVIY_PERCPU("%[disppcpr]", "%[ptr__]")			\
-			AG_ALT("%[disppcpo]", "%[ptr__]")			\
+			MVIY_PERCPU("%[lcreg]", "%[ptr__]")			\
+			AG_ALT("%[lcoff]", "%[ptr__]")				\
 			op1 "   %[old__],%[val__],0(%[ptr__])\n"		\
-			MVIY_ALT("%[disppcpr]")					\
+			MVIY_ALT("%[lcreg]")					\
 			: [old__] "=&d" (old__),				\
 			  [ptr__] "+&a" (ptr__),  "+m" (*ptr__),		\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
 			: [val__] "d" (val__),					\
-			  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
-			  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
+			  [lcreg] "i" (LC_PERCPU_REGISTER),			\
+			  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
 			: "cc");						\
 	}									\
@@ -190,16 +190,16 @@ do {										\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
-		AG_ALT("%[disppcpo]","%[ptr__]")			\
+		MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
+		AG_ALT("%[lcoff]","%[ptr__]")				\
 		op "	%[old__],%[val__],0(%[ptr__])\n"		\
-		MVIY_ALT("%[disppcpr]")					\
+		MVIY_ALT("%[lcreg]")					\
 		: [old__] "=&d" (old__),				\
 		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
-		  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
-		  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
+		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
+		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 	old__ + val__;							\
@@ -216,16 +216,16 @@ do {									\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
-		AG_ALT("%[disppcpo]","%[ptr__]")			\
+		MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
+		AG_ALT("%[lcoff]","%[ptr__]")				\
 		op "    %[old__],%[val__],0(%[ptr__])\n"		\
-		MVIY_ALT("%[disppcpr]")					\
+		MVIY_ALT("%[lcreg]")					\
 		: [old__] "=&d" (old__),				\
 		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
-		  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
-		  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
+		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
+		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 } while (0)
@@ -245,14 +245,14 @@ do {									\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
-		AG_ALT("%[disppcpo]","%[ptr__]")			\
+		MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
+		AG_ALT("%[lcoff]","%[ptr__]")				\
 		op "	%[res__],0(%[ptr__])\n"				\
-		MVIY_ALT("%[disppcpr]")					\
+		MVIY_ALT("%[lcreg]")					\
 		: [res__] "=&d" (res__), [ptr__] "+&a" (ptr__),		\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [disppcpr] "i" (LC_PERCPU_REGISTER),			\
-		  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
+		: [lcreg] "i" (LC_PERCPU_REGISTER),			\
+		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (*ptr__),						\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
@@ -271,15 +271,15 @@ do {									\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
-		AG_ALT("%[disppcpo]","%[ptr__]")			\
+		MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
+		AG_ALT("%[lcoff]","%[ptr__]")				\
 		op "    %[val__],0(%[ptr__])\n"				\
-		MVIY_ALT("%[disppcpr]")					\
+		MVIY_ALT("%[lcreg]")					\
 		: [ptr__] "+&a" (ptr__), "=m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
-		  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
-		  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
+		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
+		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 } while (0)
-- 
2.53.0



