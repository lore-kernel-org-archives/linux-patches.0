Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019904;
	b=XPAXH0SlMuZqK4X+BbvwzXZ3oXT8zIYrFTIwJRqJ38A9q7DKWjmxdJRfn8ruLYds8614
	 TT5JJkDABvYh6T7Vh8MRTyxPBbVrmPJy46SDhc7oYXJdsUtAyqAEOEjjR2M8BlbVVTEtt
	 eNnIRdxDXGWajA19rJszoCGNd7Ln2j5xGB8DTJnmgmHiD4zqte7f8wU6EYSejcq7AYnye
	 /jMPHTJMC7yk5bNuZvjk4RpERlLRsvRCkV9OBbap/9mSh9QQ9CGhueDOgt6NLtOw1PA9k
	 8KQSMpfsM4mdEMy46MLmR2Zi2NyDbqilZJYzN/MHRuYBXyM+M6v9JE3Z8yCQd+V1/wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=phwY1Kp5UfpNsR+fTJW7BAgdQVoD7NRSP0SfLZSNRzU=;
	b=zZfwq8HSKymr5KSQD9isDOVK917Vpq14++eCZQNZxZOpehypKiiN7SW+fT+Kho1OMbJz
	 KsWkOn/cPT4f4pHzLajK1NP70/aNC+eZqBbrsbIxzTRtwPhYVDBNBjF4ZwIwmoMcQtJIv
	 KVrj4L3t1JjnUNtU0NCKYB9QH1wYHw6BI2iG4LJa35KbI4CiM4j/kP7aTt6WNxjGd4NGE
	 V98znfU7s2LHbxCFAD7PObzZAVTCVoPFSA7jULRY8SYXf12ry7EOJVbPaQh/vuRxTXNwB
	 moBS/T6eQaS/nBsUKNv9/h7syPbIMUqmrTTckJbYEqfQrJqgrZOXc5JtHpy9O7lTNxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHmTSavm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B75606A33E;
	Wed, 18 Nov 2026 16:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHmTSavm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498F11F000C5;
	Wed, 18 Nov 2026 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019903;
	bh=phwY1Kp5UfpNsR+fTJW7BAgdQVoD7NRSP0SfLZSNRzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHmTSavmMxFV7JUCqHCLLlr9CYQzPPTn7S2ODXkD5Z0lMUZWc87KN/+nbx1WJUcK2
	 mQ165/huSLtQ8zAv7sXRfOyJV6/TAeZWLyKaRGodsmwctT6bpO37+1raN9pwz4RCnV
	 arlbTMNtEz8SlShqecBKdPiviaX0lZhWzO2DleEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1762/2651] s390/percpu: Use __PCPU_BEGIN() and __PCPU_END() for inline assemblies
Date: Wed, 18 Nov 2026 15:50:02 +0100
Message-ID: <20261118150350.879515047@linuxfoundation.org>
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

[ Upstream commit da9af84e66c3ace4f1a95421c1152f9df4e6abc5 ]

Replace the use of MVIY_PERCPU(), AG_ALT(), and MVIY_ALT() within all
percpu inline assemblies with __PCPU_BEGIN() and __PCPU_END(), since
the begin and end of each inline assembly is the same.

Also use consistent names: e.g. __PCPU_MVIY() and __PCPU_AG() instead of
the previous MVIY_PERCPU() and AG_ALT().

Furthermore extract DEFINE_GR_NUM and UNDEF_GR_NUM which are used to
convert register strings to register numbers.

All of this should make the code more readable. No functional change.

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 85 +++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 42 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index ac34847cd7fc0..4c274e5dcb605 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -92,42 +92,49 @@
  *
  * Inline assemblies making use of this typically have a code sequence like:
  *
- *   MVIY_PERCPU(...) <- start of percpu code section
- *   AG_ALT(...)      <- add percpu offset; must be the second instruction
- *   atomic_op	      <- atomic op
- *   MVIY_ALT(...)    <- end of percpu code section
+ *   __PCPU_BEGIN(...) <- start of percpu code section
+ *   atomic_op	       <- atomic op
+ *   __PCPU_END(...)   <- end of percpu code section
  */
 
 #define LC_ALT_ADDR	__stringify(LOWCORE_ALT_ADDRESS)
 
-#define MVIY_PERCPU(disp, reg)							\
-	".macro GEN_MVIY disp, reg\n"						\
-	".set	.Lreg,255\n"							\
-	".irp	rs,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15\n"			\
-	"	.ifc \\reg,%%r\\rs\n"						\
-	"		.set	.Lreg,\\rs\n"					\
+#define DEFINE_GR_NUM								\
+	".macro _GR_NUM opd, gr\n"						\
+	".set	\\opd,255\n"							\
+	".irp rs,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15\n"			\
+	"	.ifc \\gr,%%r\\rs\n"						\
+	"		\\opd = \\rs\n"						\
 	"	.endif\n"							\
 	".endr\n"								\
-	".if .Lreg == 255\n"							\
+	".if \\opd == 255\n"							\
 	"	.error \"Illegal register number\"\n"				\
 	".endif\n"								\
-	"mviy	\\disp(%%r0),.Lreg\n"						\
-	".endm\n"								\
-	ALTERNATIVE("GEN_MVIY " disp		     " , " reg "\n",		\
-		    "GEN_MVIY " disp "+" LC_ALT_ADDR " , " reg "\n",		\
-		    ALT_FEATURE(MFEATURE_LOWCORE))				\
-	".purgem GEN_MVIY\n"
-
-#define MVIY_ALT(disp)								\
-	ALTERNATIVE("	mviy	" disp		       "(%%r0),0\n",		\
-		    "	mviy	" disp "+" LC_ALT_ADDR "(%%r0),0\n",		\
+	".endm\n"
+
+#define UNDEF_GR_NUM								\
+	".purgem _GR_NUM\n"
+
+#define __PCPU_MVIY(lcreg, imm)							\
+	ALTERNATIVE("	mviy	" lcreg			"(%%r0)," imm "\n",	\
+		    "	mviy	" lcreg "+" LC_ALT_ADDR "(%%r0)," imm "\n",	\
 		    ALT_FEATURE(MFEATURE_LOWCORE))
 
-#define AG_ALT(disp, reg)							\
-	ALTERNATIVE("	ag	" reg ", " disp			"(%%r0)\n",	\
-		    "	ag	" reg ", " disp "+" LC_ALT_ADDR "(%%r0)\n",	\
+#define __PCPU_AG(reg, lcoff)							\
+	ALTERNATIVE("	ag	" reg ", " lcoff		 "(%%r0)\n",	\
+		    "	ag	" reg ", " lcoff "+" LC_ALT_ADDR "(%%r0)\n",	\
 		    ALT_FEATURE(MFEATURE_LOWCORE))
 
+#define __PCPU_BEGIN(lcreg, lcoff, reg)						\
+	DEFINE_GR_NUM								\
+	"_GR_NUM .Lreg, " reg "\n"						\
+	UNDEF_GR_NUM								\
+	__PCPU_MVIY(lcreg, ".Lreg")						\
+	__PCPU_AG(reg, lcoff)
+
+#define __PCPU_END(lcreg)							\
+	__PCPU_MVIY(lcreg, "0")
+
 #ifndef MARCH_HAS_Z196_FEATURES
 
 #define this_cpu_add_4(pcp, val)	arch_this_cpu_to_op_simple(pcp, val, +)
@@ -151,10 +158,9 @@ do {										\
 	if (__builtin_constant_p(val__) &&					\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {			\
 		asm volatile(							\
-			MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
-			AG_ALT("%[lcoff]", "%[ptr__]")				\
+			__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
 			op2 "   0(%[ptr__]),%[val__]\n"				\
-			MVIY_ALT("%[lcreg]")					\
+			__PCPU_END("%[lcreg]")					\
 			: [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
 			: [val__] "i" ((szcast)val__),				\
@@ -164,10 +170,9 @@ do {										\
 			: "cc");						\
 	} else {								\
 		asm volatile(							\
-			MVIY_PERCPU("%[lcreg]", "%[ptr__]")			\
-			AG_ALT("%[lcoff]", "%[ptr__]")				\
+			__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
 			op1 "   %[old__],%[val__],0(%[ptr__])\n"		\
-			MVIY_ALT("%[lcreg]")					\
+			__PCPU_END("%[lcreg]")					\
 			: [old__] "=&d" (old__),				\
 			  [ptr__] "+&a" (ptr__),  "+m" (*ptr__),		\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
@@ -190,10 +195,9 @@ do {										\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
-		AG_ALT("%[lcoff]","%[ptr__]")				\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
 		op "	%[old__],%[val__],0(%[ptr__])\n"		\
-		MVIY_ALT("%[lcreg]")					\
+		__PCPU_END("%[lcreg]")					\
 		: [old__] "=&d" (old__),				\
 		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
@@ -216,10 +220,9 @@ do {									\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
-		AG_ALT("%[lcoff]","%[ptr__]")				\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
 		op "    %[old__],%[val__],0(%[ptr__])\n"		\
-		MVIY_ALT("%[lcreg]")					\
+		__PCPU_END("%[lcreg]")					\
 		: [old__] "=&d" (old__),				\
 		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
@@ -245,10 +248,9 @@ do {									\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
-		AG_ALT("%[lcoff]","%[ptr__]")				\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
 		op "	%[res__],0(%[ptr__])\n"				\
-		MVIY_ALT("%[lcreg]")					\
+		__PCPU_END("%[lcreg]")					\
 		: [res__] "=&d" (res__), [ptr__] "+&a" (ptr__),		\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [lcreg] "i" (LC_PERCPU_REGISTER),			\
@@ -271,10 +273,9 @@ do {									\
 									\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[lcreg]","%[ptr__]")			\
-		AG_ALT("%[lcoff]","%[ptr__]")				\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
 		op "    %[val__],0(%[ptr__])\n"				\
-		MVIY_ALT("%[lcreg]")					\
+		__PCPU_END("%[lcreg]")					\
 		: [ptr__] "+&a" (ptr__), "=m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
-- 
2.53.0



