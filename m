Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019920;
	b=HY1LExiMimFQllglsmpm7LyRiwPIAp+8eWQc3uk5EHtCjjJSNsniRPLdIPXDLHcw0kxG
	 6ui5hNejbrgHT93MNqahs4eBNeYPo8MBz9Z0g5uhTexXqN6yXsF5W40kRkR9eiUdIHjl8
	 rK/idqOGhFwyxKN2KiDRs90bGi88D24XWS2bhA2Y8WBdCrh/HX8OOYrvkN8FwjuICW3UD
	 470XVDCMAIl0tgwVgNV50VpMZvoAGSXu1a7w3Ed7FuXeLVWyViGrPUs1xRejIrdAcC9Su
	 MtZpGQ7ELg8xJN1Ft//p7tVHq8k55l/CMF655YRDYpmcN6yoNSK6CzusB0ymlRKGoSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDUR6gaCpvsrej9ergF1TIMzzqL2oYJhiPmP2yh1fHs=;
	b=clJ1Eh5wTlPvlQOWGhwrggDZVFOvc5py4nHT9z4qlBbnK0KfK85gphmJse3ZphYcqgZR
	 J80t9BFeGBnLYZTdIby58PkRu/cNRgd31lVQjJmLfauC4cMVxeLOyOcwXJ7Yj31kjG471
	 IbmwbdG8FFQadJHymm8pbBM0zgTDHQ5rD5LBZ5zZKCFEwcaBG5WLbwGZ0EwmXSd8w0Xg/
	 N/CXMui8DgcCxqhfa/4QxBI04pKafLUHzJde3IDiRjjkv0BSRfFVranv4ntF4fehBlipk
	 sIOJlI9p5PGwBSRgdDkBF6tAz5zSy1N3k98qri4OP5Mg3Z+nRj5VBuELChPyn/4W3tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W/Tu8AhA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816C6606A31C;
	Wed, 18 Nov 2026 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W/Tu8AhA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF671F000C4;
	Wed, 18 Nov 2026 16:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019920;
	bh=DDUR6gaCpvsrej9ergF1TIMzzqL2oYJhiPmP2yh1fHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/Tu8AhAVeqLP48XOqT0gwLLTVY+k8D9cIKuXpLQbaNjeIVvF70OjOkJHFB01IZf6
	 Kc/VyueNMGRq2aq5WVBH/o4KFZe969cd4Wu6HvTYzAVczh4Cm/HlTVoK9mrr9X/hhb
	 p/EsxWwwTqcm+twZwBE/QjBYqGmfTJ6mJk6MLbgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1767/2651] s390/percpu: Use asm_inline for arch_this_cpu_add()
Date: Wed, 18 Nov 2026 15:50:07 +0100
Message-ID: <20261118150351.041558837@linuxfoundation.org>
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

[ Upstream commit 10f9cf286ec3e6f99569e5ce3e99afbeb77b962f ]

When converting to preemptible percpu operations the arch_this_cpu_add()
inline assemblies were not converted to use asm_inline instead of a plain
asm statement.

With all the macro usage the inline assemblies grow significantly, and
the compiler may decide to not inline even small functions. This can be
observed with gcc16 and a defconfig build where many calls to
__srcu_read_lock_fast() are not inlined anymore, even though it is
basically only a this_cpu_inc().

Use asm_inline to address this.

Fixes: 18ec6c5d7ec6 ("s390/percpu: Use new percpu code section for arch_this_cpu_add()")
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index b5417e34cc976..3f983285f944e 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -193,7 +193,7 @@ do {										\
 	ptr__ = PERCPU_PTR(&(pcp));						\
 	if (__builtin_constant_p(val__) &&					\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {			\
-		asm volatile(							\
+		asm_inline volatile(						\
 			__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
 				      "%[pair__]","%N[pair__]")			\
 			op2 "   0(%N[pair__]),%[val__]\n"			\
@@ -206,7 +206,7 @@ do {										\
 			  "m" (((struct lowcore *)0)->percpu_offset)		\
 			: "cc");						\
 	} else {								\
-		asm volatile(							\
+		asm_inline volatile(						\
 			__PCPU_BEGIN("%[lcreg]","%[lcoff]","%[ptr__]",		\
 				     "%[pair__]","%N[pair__]")			\
 			op1 "   %[old__],%[val__],0(%N[pair__])\n"		\
-- 
2.53.0



