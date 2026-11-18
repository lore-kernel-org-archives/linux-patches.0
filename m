Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019907;
	b=gBMP3PUSMnsvuP3BmgXFNeBkdrcQRaO+3TjEtuNWRguxtuTqxaKfOfp99I3qpIU0YIKj
	 CJTwacC8Lc8/rpLmMGcSkctwSoOXgnPRx+l/uHkH4+CCaGh0viuQf2KHCNcGmDbaOXfhg
	 XgvjcdPaqqsPCHpkre6am5Q05DRzkgKZztJ4oQPtJ8U7q9IN0si6y+OzpJxz7PmKgKUFd
	 jx4MsKWL+Ya/M+MQ94GHbe5vbyc2npdTzG6KA7JeLNc5mjQvHyyd7DYnuEfnTJcwbTLTy
	 WaWqkyOgvGJKZpeObf0JDGaBi613vO1bThYnEYrBfUjAz6TgFuLxCWmh/wlsS8qOb5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YxJgY5JzYOSn57ZrjefyxkSNnrAOQdXE+Y8m34EO3OY=;
	b=PO76VRop4lFfuMXLfbyTTUHa9NXH2LV9ZgVo/kmY2VMhkNrnLLTr0PaGDj327ipWo3Vt
	 S4BMpwXbkB6JbNh52WXjrI0Km7+hwlEg/ElakjnWwUrKFm0AjY4Vf91ceGxLbgX1R6VZ4
	 lV2/QNqnQzAU4kN1pt4Eou48TVHzVIBmzTrfCCaDUey0Zel2K5p72w2HrEAfnrqb/9VAi
	 lpgRHi/0yr5vs4+DtkF4fvAC5RCSaE3AiISZohPO8zlDu3VzRVL0fSrvhBcFJsXGrVKYO
	 H2DEBs9Kh2dtt0QrU/DfRqezePq8/gwW+5txpveOT6LJIwameuc3oS99zR2jfTzXaAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZdZEhpx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98C2606A320;
	Wed, 18 Nov 2026 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZdZEhpx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033821F000C9;
	Wed, 18 Nov 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019906;
	bh=YxJgY5JzYOSn57ZrjefyxkSNnrAOQdXE+Y8m34EO3OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZdZEhpxzf+foJMS4AqCwDNAdtH5H85UTvDJ0h73MKLmPaMqY+LPL1V3rJK9pE5+7
	 h4ccu8w4x/t7JHOSi5XvAAJcpoqxWtZe5Pw3p5Ul3eub/vGM18VCO01rcVLgO+j8ma
	 BxjqOMcn00s8F21UOaBqQOaAcW1W4YA4+SqCJB2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1763/2651] s390/percpu: Use percpu code section for this_cpu_cmpxchg128()
Date: Wed, 18 Nov 2026 15:50:03 +0100
Message-ID: <20261118150350.915395104@linuxfoundation.org>
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

[ Upstream commit e8b55c9982df6dc5f28c427e4debabb4da3a5e64 ]

Convert this_cpu_cmpxchg128() to make use of percpu code section
functionality. This is just for the sake of completeness, since
currently there is no in-kernel user of this_cpu_cmpxchg128().

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 4c274e5dcb605..37e7ca08c4afe 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -312,15 +312,23 @@ do {									\
 #define this_cpu_cmpxchg128(pcp, oval, nval)				\
 ({									\
 	typedef typeof(pcp) pcp_op_T__;					\
-	u128 old__, new__, ret__;					\
+	u128 old__ = (oval), new__ = (nval);				\
 	pcp_op_T__ *ptr__;						\
-	old__ = oval;							\
-	new__ = nval;							\
-	preempt_disable_notrace();					\
-	ptr__ = raw_cpu_ptr(&(pcp));					\
-	ret__ = cmpxchg128((void *)ptr__, old__, new__);		\
-	preempt_enable_notrace();					\
-	ret__;								\
+									\
+	ptr__ = PERCPU_PTR(&(pcp));					\
+	asm_inline volatile(						\
+		__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]")		\
+		"	cdsg	%[old__],%[new__],0(%[ptr__])\n"	\
+		__PCPU_END("%[lcreg]")					\
+		: [old__] "+&d" (old__), [ptr__] "+&a" (ptr__),		\
+		  "+m" (*ptr__),					\
+		  "=m" (((struct lowcore *)0)->percpu_register)		\
+		: [new__] "d" (new__),					\
+		  [lcreg] "i" (LC_PERCPU_REGISTER),			\
+		  [lcoff] "i" (LC_PERCPU_OFFSET),			\
+		  "m" (((struct lowcore *)0)->percpu_offset)		\
+		: "memory", "cc");					\
+	old__;								\
 })
 
 #define arch_this_cpu_xchg(pcp, nval)					\
-- 
2.53.0



