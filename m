Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019895;
	b=PMkIs/KIt4piIUorBQ2Zj+k8tJfBoHWttQXejYHG7qW2/dwDkMwtPYI7Edwswm57OXMq
	 DemwSgo8priBsEJmdGRG3nV4ULTZZMzo4gccHL6WqHL6P2rbv4V7WnETT3fS2vhXrsm3M
	 Rmh7Tbw87f+BDET/tQSZ1xvuE/oEMN+w/qIRxnNFY+sJkrLcTUHr7Wu9nVo+O1VuXiIp2
	 eEDnppanEtdOl3cexJ7sCWK1X2eR7Sa5r4E+eb3I17KBB2ifMjuZRa/UVMfH3vjRGxwL7
	 lL0Lp+plpuPzIT7MnueZJ63EfCuTSiuovBl7onVU8jcxp8q4j5anM9XE0Q8Vjuxd0PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z+yXHEvHXImriZNF8k3ejOFyhPCEAu5oIJ5ZRXYEOvU=;
	b=HkzdqJIu8yfIrTXt7W9r3guZaZqtfnYynFm2R/31RwJ4MTNCMNVcCYYzvuRw9hiH2fXC
	 nWrv9hQzqg3Rc3DN6VKDm6ymHjR3Stt5c7DZ+M0efrSLdvZyRG4XcS2fG63tTGEIELwII
	 ltdePjfE3vWa420WqY8oIdqgr9s89vQGpIuS23Fg01dozNmvdOdX+RtX3XuAJaj0X0aqn
	 sP8EnMgtBFyEkxoJ8EbWO88hQkKadOrf15EEjamCwU8Vfp8Tv15G0sTc0KooVvF3ncpZ2
	 krh0CwzfkAb9DdgWdYap7DhUeAbUB9UcH4te6d78BZpLh7uLRVpJglaqbtXZCNA1xFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kayKcCnd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA099606A330;
	Wed, 18 Nov 2026 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kayKcCnd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19EA1F000C9;
	Wed, 18 Nov 2026 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019895;
	bh=z+yXHEvHXImriZNF8k3ejOFyhPCEAu5oIJ5ZRXYEOvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kayKcCndd9KZI9cwA/J3RuWVjnuEzGwFmpQ4l0JDXl8lPRmXq/+EqYriJKqdoOM2P
	 iMZ6Vpq5NDnPWUnf71MVuBDplmJje3xESK2Ghybaf9jM70ji093kqIgS4lMxjkGh6/
	 bJ7sZy1lDw0u7jZDH76IJljAg0Ur/4qwCHIowwiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1759/2651] s390/percpu: Let MVIY_PERCPU() calculate alternative displacement
Date: Wed, 18 Nov 2026 15:49:59 +0100
Message-ID: <20261118150350.786474505@linuxfoundation.org>
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

[ Upstream commit d6fe39764bd690949ae640c49164cca07b99d7c9 ]

Let MVIY_PERCPU() calculate the alternative lowcore displacement instead
of passing the same value(s) again and again in all percpu inline
assemblies.

This shortens the inline assemblies and makes them a bit more readable.

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 68 +++++++++++++++-------------------
 1 file changed, 29 insertions(+), 39 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 1bd3f3c4c5847..a2715ac72957d 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -99,7 +99,9 @@
  *   MVIY_ALT(...)    <- end of percpu code section
  */
 
-#define MVIY_PERCPU(disp, dispalt, reg)						\
+#define LC_ALT_ADDR	__stringify(LOWCORE_ALT_ADDRESS)
+
+#define MVIY_PERCPU(disp, reg)							\
 	".macro GEN_MVIY disp, reg\n"						\
 	".set	.Lreg,255\n"							\
 	".irp	rs,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15\n"			\
@@ -112,19 +114,19 @@
 	".endif\n"								\
 	"mviy	\\disp(%%r0),.Lreg\n"						\
 	".endm\n"								\
-	ALTERNATIVE("GEN_MVIY " disp    ", " reg "\n",				\
-		    "GEN_MVIY " dispalt ", " reg "\n",				\
+	ALTERNATIVE("GEN_MVIY " disp		     " , " reg "\n",		\
+		    "GEN_MVIY " disp "+" LC_ALT_ADDR " , " reg "\n",		\
 		    ALT_FEATURE(MFEATURE_LOWCORE))				\
 	".purgem GEN_MVIY\n"
 
-#define MVIY_ALT(disp, dispalt)							\
-	ALTERNATIVE("	mviy	" disp	  "(%%r0),0\n",				\
-		    "	mviy	" dispalt "(%%r0),0\n",				\
+#define MVIY_ALT(disp)								\
+	ALTERNATIVE("	mviy	" disp		       "(%%r0),0\n",		\
+		    "	mviy	" disp "+" LC_ALT_ADDR "(%%r0),0\n",		\
 		    ALT_FEATURE(MFEATURE_LOWCORE))
 
-#define AG_ALT(disp, dispalt, reg)						\
-	ALTERNATIVE("	ag	" reg ", " disp	   "(%%r0)\n",			\
-		    "	ag	" reg ", " dispalt "(%%r0)\n",			\
+#define AG_ALT(disp, reg)							\
+	ALTERNATIVE("	ag	" reg ", " disp			"(%%r0)\n",	\
+		    "	ag	" reg ", " disp "+" LC_ALT_ADDR "(%%r0)\n",	\
 		    ALT_FEATURE(MFEATURE_LOWCORE))
 
 #ifndef MARCH_HAS_Z196_FEATURES
@@ -153,33 +155,29 @@ do {										\
 	if (__builtin_constant_p(val__) &&					\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {			\
 		asm volatile(							\
-			MVIY_PERCPU("%[disppcpr]", "%[dispaltpcpr]", "%[ptr__]")\
-			AG_ALT("%[disppcpo]", "%[dispaltpcpo]", "%[ptr__]")	\
+			MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
+			AG_ALT("%[disppcpo]", "%[ptr__]")			\
 			op2 "   0(%[ptr__]),%[val__]\n"				\
-			MVIY_ALT("%[disppcpr]", "%[dispaltpcpr]")		\
+			MVIY_ALT("%[disppcpr]")					\
 			: [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
 			: [val__] "i" ((szcast)val__),				\
 			  [disppcpr] "i" (lc_pcpr),				\
 			  [disppcpo] "i" (lc_pcpo),				\
-			  [dispaltpcpr] "i" (lc_pcpr + LOWCORE_ALT_ADDRESS),	\
-			  [dispaltpcpo] "i" (lc_pcpo + LOWCORE_ALT_ADDRESS),	\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
 			: "cc");						\
 	} else {								\
 		asm volatile(							\
-			MVIY_PERCPU("%[disppcpr]", "%[dispaltpcpr]", "%[ptr__]")\
-			AG_ALT("%[disppcpo]", "%[dispaltpcpo]", "%[ptr__]")	\
+			MVIY_PERCPU("%[disppcpr]", "%[ptr__]")			\
+			AG_ALT("%[disppcpo]", "%[ptr__]")			\
 			op1 "   %[old__],%[val__],0(%[ptr__])\n"		\
-			MVIY_ALT("%[disppcpr]", "%[dispaltpcpr]")		\
+			MVIY_ALT("%[disppcpr]")					\
 			: [old__] "=&d" (old__),				\
 			  [ptr__] "+&a" (ptr__),  "+m" (*ptr__),		\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
 			: [val__] "d" (val__),					\
 			  [disppcpr] "i" (lc_pcpr),				\
 			  [disppcpo] "i" (lc_pcpo),				\
-			  [dispaltpcpr] "i" (lc_pcpr + LOWCORE_ALT_ADDRESS),	\
-			  [dispaltpcpo] "i" (lc_pcpo + LOWCORE_ALT_ADDRESS),	\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
 			: "cc");						\
 	}									\
@@ -199,18 +197,16 @@ do {										\
 	lc_pcpo = offsetof(struct lowcore, percpu_offset);		\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[disppcpr]", "%[dispaltpcpr]", "%[ptr__]")\
-		AG_ALT("%[disppcpo]", "%[dispaltpcpo]", "%[ptr__]")	\
+		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
+		AG_ALT("%[disppcpo]","%[ptr__]")			\
 		op "	%[old__],%[val__],0(%[ptr__])\n"		\
-		MVIY_ALT("%[disppcpr]", "%[dispaltpcpr]")		\
+		MVIY_ALT("%[disppcpr]")					\
 		: [old__] "=&d" (old__),				\
 		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
 		  [disppcpr] "i" (lc_pcpr),				\
 		  [disppcpo] "i" (lc_pcpo),				\
-		  [dispaltpcpr] "i" (lc_pcpr + LOWCORE_ALT_ADDRESS),	\
-		  [dispaltpcpo] "i" (lc_pcpo + LOWCORE_ALT_ADDRESS),	\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 	old__ + val__;							\
@@ -230,18 +226,16 @@ do {									\
 	lc_pcpo = offsetof(struct lowcore, percpu_offset);		\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[disppcpr]", "%[dispaltpcpr]", "%[ptr__]")\
-		AG_ALT("%[disppcpo]", "%[dispaltpcpo]", "%[ptr__]")	\
+		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
+		AG_ALT("%[disppcpo]","%[ptr__]")			\
 		op "    %[old__],%[val__],0(%[ptr__])\n"		\
-		MVIY_ALT("%[disppcpr]", "%[dispaltpcpr]")		\
+		MVIY_ALT("%[disppcpr]")					\
 		: [old__] "=&d" (old__),				\
 		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
 		  [disppcpr] "i" (lc_pcpr),				\
 		  [disppcpo] "i" (lc_pcpo),				\
-		  [dispaltpcpr] "i" (lc_pcpr + LOWCORE_ALT_ADDRESS),	\
-		  [dispaltpcpo] "i" (lc_pcpo + LOWCORE_ALT_ADDRESS),	\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 } while (0)
@@ -263,16 +257,14 @@ do {									\
 	lc_pcpo = offsetof(struct lowcore, percpu_offset);		\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[disppcpr]", "%[dispaltpcpr]", "%[ptr__]")\
-		AG_ALT("%[disppcpo]", "%[dispaltpcpo]", "%[ptr__]")	\
+		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
+		AG_ALT("%[disppcpo]","%[ptr__]")			\
 		op "	%[res__],0(%[ptr__])\n"				\
-		MVIY_ALT("%[disppcpr]", "%[dispaltpcpr]")		\
+		MVIY_ALT("%[disppcpr]")					\
 		: [res__] "=&d" (res__), [ptr__] "+&a" (ptr__),		\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [disppcpr] "i" (lc_pcpr),				\
 		  [disppcpo] "i" (lc_pcpo),				\
-		  [dispaltpcpr] "i" (lc_pcpr + LOWCORE_ALT_ADDRESS),	\
-		  [dispaltpcpo] "i" (lc_pcpo + LOWCORE_ALT_ADDRESS),	\
 		  "m" (*ptr__),						\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
@@ -294,17 +286,15 @@ do {									\
 	lc_pcpo = offsetof(struct lowcore, percpu_offset);		\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
-		MVIY_PERCPU("%[disppcpr]", "%[dispaltpcpr]", "%[ptr__]")\
-		AG_ALT("%[disppcpo]", "%[dispaltpcpo]", "%[ptr__]")	\
+		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
+		AG_ALT("%[disppcpo]","%[ptr__]")			\
 		op "    %[val__],0(%[ptr__])\n"				\
-		MVIY_ALT("%[disppcpr]", "%[dispaltpcpr]")		\
+		MVIY_ALT("%[disppcpr]")					\
 		: [ptr__] "+&a" (ptr__), "=m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
 		  [disppcpr] "i" (lc_pcpr),				\
 		  [disppcpo] "i" (lc_pcpo),				\
-		  [dispaltpcpr] "i" (lc_pcpr + LOWCORE_ALT_ADDRESS),	\
-		  [dispaltpcpo] "i" (lc_pcpo + LOWCORE_ALT_ADDRESS),	\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 } while (0)
-- 
2.53.0



