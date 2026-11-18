Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019898;
	b=g6Hxg29T6nEh+a1HXPjGn1ksbeMU1m7fusQmBj0yfp5YTTrbN0m82Rm+T+pVQERTXIoT
	 2ROMDJBPv6c7ZW4DA24PTv+R5MbXMKbk87njG7syKLWRqYIcTCgtOmSZy1vYbNi0gvMLG
	 7SWb+kfR07ecajCSi88cJ9SWq8oGBv1mW5fk7Ms7I7kLr8Ep5QfbLxpyF+zvYUX/Zlnz9
	 OeTggson72mPOgwj/5R3o6I320ClIUcdAgDgNIxNg1zjdwE6TmAIZoTqqgmD17p0IY3Vy
	 /BJ+jh5mid5U5HtmZkfIXyhfNlmbPmP/5XGdTygzQBhbXLTZESCv4By++ast/3j7deA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gnp9zUm0yDYW3SwtZuxf5LxjcKCqmQsKja/qGoitwcQ=;
	b=cT3hCwkOsO8c/IgXl1c6jQEElb4ivpcWARQfQYXJ6il8LHVv52mwdBri20tcpUxyjJ4b
	 u5fJLRaZ0l3M5laMr/L5Ism4ipr9ZcKzNLCDr/Jpd8qXCyfM9nsyVB8yGk95X22YvIR0k
	 lT/gNL6SFexUihGkxi3mdmP+Mhr7GTzggqKmX27BPxL+SRDOk0JA0Llpjg+NXwoE4c2y4
	 8m+NZY8KtHs/haQ8yEvsTDl12WpKb9JJIwok/pDWa71E7sOKCT9KdSr+QcJZ0rlDi37xu
	 cz/CaX2ht0t6dnFuR1PRQyzAycmhTGWuDcT6dvccsDrXZP1lsRaa69KEfeqI3AxzBhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hk1VvdSo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF59606A32C;
	Wed, 18 Nov 2026 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hk1VvdSo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A226B1F000C5;
	Wed, 18 Nov 2026 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019898;
	bh=Gnp9zUm0yDYW3SwtZuxf5LxjcKCqmQsKja/qGoitwcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hk1VvdSoabMh9UXvR8j5EA+Mh0VcyWaCL32nOQoOfUVFsEhvZZ5HpqHRD+zcxi2JF
	 0gwHzIsOk9H4+TCcyz3aPUKKzkensH2z7ebFNvcv+DuYV3/PN29VPJkfIj1gAIlYQh
	 VJ43tO9bCiwaTjIMZW5ifulUBpIypR76EiZvkzh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1760/2651] s390/percpu/lowcore: Add and use LC_PERCPU lowcore offset defines
Date: Wed, 18 Nov 2026 15:50:00 +0100
Message-ID: <20261118150350.816332035@linuxfoundation.org>
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

[ Upstream commit 301e3a0776511ed60cca1f7d4b14b6b44827c6f4 ]

Define LC_PERCPU_OFFSET and LC_PERCPU_REGISTER offset defines and use
them in percpu code. This shortens the percpu inline assemblies and makes
them a bit more readable.

Note that because of header dependencies it is not possible to use
asm-offsets. However to avoid adding more dependencies to asm-offsets
it seems to be preferable to use the current approach in any way.

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/entry-percpu.h |  2 +-
 arch/s390/include/asm/lowcore.h      |  3 ++
 arch/s390/include/asm/percpu.h       | 47 ++++++++++------------------
 3 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/arch/s390/include/asm/entry-percpu.h b/arch/s390/include/asm/entry-percpu.h
index 4ef47265cfce8..89c9e44f6f833 100644
--- a/arch/s390/include/asm/entry-percpu.h
+++ b/arch/s390/include/asm/entry-percpu.h
@@ -49,7 +49,7 @@ static __always_inline bool percpu_code_check(struct pt_regs *regs)
 	}
 	if ((insn & 0xff0f) != 0xe300)
 		return true;
-	disp = offsetof(struct lowcore, percpu_offset);
+	disp = LC_PERCPU_OFFSET;
 	if (machine_has_relocated_lowcore())
 		disp += LOWCORE_ALT_ADDRESS;
 	insn = (disp & 0xff000) >> 4 | (disp & 0x00fff) << 16 | 0x8;
diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index 5cef215d30e7d..0e2d3af01ecbb 100644
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -222,6 +222,9 @@ struct lowcore {
 	__u8	pad_0x1900[0x2000-0x1900];	/* 0x1900 */
 } __packed __aligned(8192);
 
+#define LC_PERCPU_OFFSET	offsetof(struct lowcore, percpu_offset)
+#define LC_PERCPU_REGISTER	offsetof(struct lowcore, percpu_register)
+
 static __always_inline struct lowcore *get_lowcore(void)
 {
 	struct lowcore *lc;
diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index a2715ac72957d..ff32c56b4d79e 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -14,17 +14,16 @@
 
 #define arch_raw_cpu_ptr(_ptr)						\
 ({									\
-	unsigned long lc_percpu, tcp_ptr__;				\
+	unsigned long tcp_ptr__;					\
 									\
 	tcp_ptr__ = (__force unsigned long)(_ptr);			\
-	lc_percpu = offsetof(struct lowcore, percpu_offset);		\
 	asm_inline volatile(						\
 	ALTERNATIVE("ag		%[__ptr__],%[offzero](%%r0)\n",		\
 		    "ag		%[__ptr__],%[offalt](%%r0)\n",		\
 		    ALT_FEATURE(MFEATURE_LOWCORE))			\
 	: [__ptr__] "+d" (tcp_ptr__)					\
-	: [offzero] "i" (lc_percpu),					\
-	  [offalt] "i" (lc_percpu + LOWCORE_ALT_ADDRESS),		\
+	: [offzero] "i" (LC_PERCPU_OFFSET),				\
+	  [offalt] "i" (LC_PERCPU_OFFSET + LOWCORE_ALT_ADDRESS),	\
 	  "m" (((struct lowcore *)0)->percpu_offset)			\
 	: "cc");							\
 	(TYPEOF_UNQUAL(*(_ptr)) __force __kernel *)tcp_ptr__;		\
@@ -144,13 +143,10 @@
 
 #define arch_this_cpu_add(pcp, val, op1, op2, szcast)				\
 do {										\
-	unsigned long lc_pcpr, lc_pcpo;						\
 	typedef typeof(pcp) pcp_op_T__;						\
 	pcp_op_T__ val__ = (val);						\
 	pcp_op_T__ old__, *ptr__;						\
 										\
-	lc_pcpr = offsetof(struct lowcore, percpu_register);			\
-	lc_pcpo = offsetof(struct lowcore, percpu_offset);			\
 	ptr__ = PERCPU_PTR(&(pcp));						\
 	if (__builtin_constant_p(val__) &&					\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {			\
@@ -162,8 +158,8 @@ do {										\
 			: [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
 			: [val__] "i" ((szcast)val__),				\
-			  [disppcpr] "i" (lc_pcpr),				\
-			  [disppcpo] "i" (lc_pcpo),				\
+			  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
+			  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
 			: "cc");						\
 	} else {								\
@@ -176,8 +172,8 @@ do {										\
 			  [ptr__] "+&a" (ptr__),  "+m" (*ptr__),		\
 			  "=m" (((struct lowcore *)0)->percpu_register)		\
 			: [val__] "d" (val__),					\
-			  [disppcpr] "i" (lc_pcpr),				\
-			  [disppcpo] "i" (lc_pcpo),				\
+			  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
+			  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
 			: "cc");						\
 	}									\
@@ -188,13 +184,10 @@ do {										\
 
 #define arch_this_cpu_add_return(pcp, val, op)				\
 ({									\
-	unsigned long lc_pcpr, lc_pcpo;					\
 	typedef typeof(pcp) pcp_op_T__; 				\
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 									\
-	lc_pcpr = offsetof(struct lowcore, percpu_register);		\
-	lc_pcpo = offsetof(struct lowcore, percpu_offset);		\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
 		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
@@ -205,8 +198,8 @@ do {										\
 		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
-		  [disppcpr] "i" (lc_pcpr),				\
-		  [disppcpo] "i" (lc_pcpo),				\
+		  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
+		  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 	old__ + val__;							\
@@ -217,13 +210,10 @@ do {										\
 
 #define arch_this_cpu_to_op(pcp, val, op)				\
 do {									\
-	unsigned long lc_pcpr, lc_pcpo;					\
 	typedef typeof(pcp) pcp_op_T__; 				\
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 									\
-	lc_pcpr = offsetof(struct lowcore, percpu_register);		\
-	lc_pcpo = offsetof(struct lowcore, percpu_offset);		\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
 		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
@@ -234,8 +224,8 @@ do {									\
 		  [ptr__] "+&a" (ptr__), "+m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
-		  [disppcpr] "i" (lc_pcpr),				\
-		  [disppcpo] "i" (lc_pcpo),				\
+		  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
+		  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 } while (0)
@@ -249,12 +239,10 @@ do {									\
 
 #define arch_this_cpu_read(pcp, op)					\
 ({									\
-	unsigned long lc_pcpr, lc_pcpo, res__;				\
 	typedef typeof(pcp) pcp_op_T__;					\
+	unsigned long res__;						\
 	pcp_op_T__ *ptr__;						\
 									\
-	lc_pcpr = offsetof(struct lowcore, percpu_register);		\
-	lc_pcpo = offsetof(struct lowcore, percpu_offset);		\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
 		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
@@ -263,8 +251,8 @@ do {									\
 		MVIY_ALT("%[disppcpr]")					\
 		: [res__] "=&d" (res__), [ptr__] "+&a" (ptr__),		\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
-		: [disppcpr] "i" (lc_pcpr),				\
-		  [disppcpo] "i" (lc_pcpo),				\
+		: [disppcpr] "i" (LC_PERCPU_REGISTER),			\
+		  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (*ptr__),						\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
@@ -278,12 +266,9 @@ do {									\
 
 #define arch_this_cpu_write(pcp, val, op)				\
 do {									\
-	unsigned long lc_pcpr, lc_pcpo;					\
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ *ptr__, val__ = (val);				\
 									\
-	lc_pcpr = offsetof(struct lowcore, percpu_register);		\
-	lc_pcpo = offsetof(struct lowcore, percpu_offset);		\
 	ptr__ = PERCPU_PTR(&(pcp));					\
 	asm_inline volatile(						\
 		MVIY_PERCPU("%[disppcpr]","%[ptr__]")			\
@@ -293,8 +278,8 @@ do {									\
 		: [ptr__] "+&a" (ptr__), "=m" (*ptr__),			\
 		  "=m" (((struct lowcore *)0)->percpu_register)		\
 		: [val__] "d" (val__),					\
-		  [disppcpr] "i" (lc_pcpr),				\
-		  [disppcpo] "i" (lc_pcpo),				\
+		  [disppcpr] "i" (LC_PERCPU_REGISTER),			\
+		  [disppcpo] "i" (LC_PERCPU_OFFSET),			\
 		  "m" (((struct lowcore *)0)->percpu_offset)		\
 		: "cc");						\
 } while (0)
-- 
2.53.0



