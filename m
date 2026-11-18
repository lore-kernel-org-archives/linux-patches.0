Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034727;
	b=PdtcCuP6R5xKYaZUKJKgGLj9sYNlt468As528A52prVfrPpcYx9PLJohfD2Kop8MQAIy
	 bri7J82mHfKWMI6jarovsqC4+v6yRFZr+7J01fqnlOCf1ffXRIOG29f0oVgJx60jecuwX
	 QTAUnp2cZW6JOyZZIH93gmndr+LuMtzvEPBB/8azhbEtMxeQ6Rube7xiJQiie6MeivuQ6
	 c8iOXyJt3/HODNhF64BoBKZJkTmQSqpT1MvDPvRbtkEn+XWJKKkLtryko7aOHZ9X8zXzq
	 dpD91TfgeZtW+ygBT4TlEPi0KFcgrQBLVLSX5dDi7K8d5ejQdjzk4QD9vGhe/Q3dKKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ogK/S9JY92HfHdNqVUzbT2LIaphaz1m2kXisxrroobc=;
	b=jp8h1F4zgL9IMrAS4pVIZ4vKO4C1lKnOekx30Dj52JxhpxA6L0jBaLRwknQrms32WLKV
	 4KYIj35/gLTms5fvJCZKw49DtbmYbcpngXWj/sfJ6E5Mvk7gjd/LWDI7kmHJJxAMF5PtP
	 JP45CItsgiSOQwtiBZUn6YXOOzd6NF7U6ZhoqXSIpviYo0Vtm6hlxGYDBshS9Gmk5h2dA
	 0LdduCY7p4BNQRrxilNT3cZRRoaGrMIwF1bNXwQr5fSguGR1X5tGhbTNuDeV3uWLyN1TJ
	 +EtYCmUydoflA/RYhWswpl+VjRVJlBiZ62t1V8jKOZPonxrfk6mBFnWvFsuRnl6tCsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jj/CJ+hM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7F5606A31C;
	Wed, 18 Nov 2026 20:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jj/CJ+hM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C8F1F000C4;
	Wed, 18 Nov 2026 20:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034727;
	bh=ogK/S9JY92HfHdNqVUzbT2LIaphaz1m2kXisxrroobc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jj/CJ+hMjWv9I70Lwm3yExVVXRW/5guo745c8OmSexKlQNinxEhMoUHTxINqXJjSf
	 gFOccjbicrUwWvKOiUuIYwq3d1My4RQYY+lFmKkM6OZSWIISn3YgXHVsskO9pmVn3d
	 bsBk3/AW0+lXKe7rF4MDmzm2mB8mqdcrgdc8rOA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0470/3318] arm64: percpu: Fix LSE operations on {8,16}-bit types
Date: Wed, 18 Nov 2026 15:18:12 +0100
Message-ID: <20261118150330.983722388@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8cf2093f5372952a9ebc805c418d45df7112cd14 ]

The assembly for __percpu_##name##_case_##sz() and
__percpu_##name##_return_case_##sz() doesn't use the 'sfx' macro
argument to form the LSE instruction. Without 'sfx', a W register
argument will imply a 32-bit memory location, and consequently
{8,16}-bit ops will erroneously read and write 32 bits of memory when
the LSE instruction is used.

Fix this by appending 'sfx' to 'op_lse' to LSE instruction. It is not
necessary (and not valid) to append 'sfx' to 'op_llsc', as 'op_llsc' is
a register-register operation which does not access memory (and does not
take a size suffix).

Fixes: 959bf2fd03b5 ("arm64: percpu: Rewrite per-cpu ops to allow use of LSE atomics")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: stable@vger.kernel.org
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/percpu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 31193bcf89a2b..8cf4068ce1b56 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -77,7 +77,7 @@ __percpu_##name##_case_##sz(void *ptr, unsigned long val)		\
 	"	stxr" #sfx "\t%w[loop], %" #w "[tmp], %[ptr]\n"		\
 	"	cbnz	%w[loop], 1b",					\
 	/* LSE atomics */						\
-		#op_lse "\t%" #w "[val], %" #w "[tmp], %[ptr]\n"	\
+		#op_lse #sfx "\t%" #w "[val], %" #w "[tmp], %[ptr]\n"	\
 		__nops(3))						\
 	: [loop] "=&r" (loop), [tmp] "=&r" (tmp),			\
 	  [ptr] "+Q"(*(u##sz *)ptr)					\
@@ -98,7 +98,7 @@ __percpu_##name##_return_case_##sz(void *ptr, unsigned long val)	\
 	"	stxr" #sfx "\t%w[loop], %" #w "[ret], %[ptr]\n"		\
 	"	cbnz	%w[loop], 1b",					\
 	/* LSE atomics */						\
-		#op_lse "\t%" #w "[val], %" #w "[ret], %[ptr]\n"	\
+		#op_lse #sfx "\t%" #w "[val], %" #w "[ret], %[ptr]\n"	\
 		#op_llsc "\t%" #w "[ret], %" #w "[ret], %" #w "[val]\n"	\
 		__nops(2))						\
 	: [loop] "=&r" (loop), [ret] "=&r" (ret),			\
-- 
2.53.0



