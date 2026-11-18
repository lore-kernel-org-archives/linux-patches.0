Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034945;
	b=u8HwNrtgpwHss0nYoPEIztOBmgosqHgdsXoWf6AbcLQmOk/swTp1V0dLVCKxe8kNMGa/
	 xCvrAorK3mna2u5HeMu5Vo9SuJumxm4oRyFZx4Or+saKL4i8VTM999Xppb0z6zYHCURyB
	 3XLQdloBhSIlwYb3CsWG6B6ee0qzyhDg3VySkok6Yk9/rn39BWgRsB0D9hhqNhLCGO/q3
	 PTmPKhmo4TutylhtF09uRRpk7g0rzyKFhLZBoxNSUxgU/yhZxYVcZErLsHHaQxRBKLwUG
	 nrF1QArZ76FEC1iFAoymNfETj93+3SLhUfXLNTeE8+qTfhscfCbr7gC64MhhO1NyUQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=maPOAQQ+Zh2au3ExeAv8SyKFtPEYBUuI+IU5urzvMKw=;
	b=sZZIWLLhssaxYDuJ1Sl1L1RoTJfIc4J059vVfsO1hVfHuWdGucjup1QnZJT73KklQIdU
	 J5+Adg3T4dwATzD3Pi7IHTUV1D2w5wrfontp5ao8VdoVQYazx2UEo6Cm19hAKFzZmrwx8
	 DLAguEawJo3FEnbNDl7L5O4pF4G+9F9t/iHnO1OI+zgFXXh7vwBhunYQpiMuOSCZdNxHo
	 X6iEwnPSxJ8HxB3VtBE0qak8jUYkBSzoHOWMUMQOAJnpA1BnLHwDwKHeBsS0EsooIaYqJ
	 +Nnluy4r8vN0EdF+Hxh0JDLJJK+39VWhpF5TzxXx0e1bW1NbeO8j2r0Zc9Bdpvb865A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GU0sP/EF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99365606A320;
	Wed, 18 Nov 2026 20:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GU0sP/EF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8951F000C4;
	Wed, 18 Nov 2026 20:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034945;
	bh=maPOAQQ+Zh2au3ExeAv8SyKFtPEYBUuI+IU5urzvMKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GU0sP/EFhf5erxEx9hgSSPel0Sk47e8t4T+pkas+gG9ZMUdNvhYQSZ+Ce0u1D1o6V
	 HI0xNgtef2i1sERwFlaU14Spkz6GQVS9B2PCjoQnSMnDrm4XDl7m38uILcwRkoZgxj
	 37QeQHL6PI23uAwV8Su14NYZqKQAhPQtQ4jxavDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0551/3318] x86/locking: Use sfence for wmb() if SSE is available
Date: Wed, 18 Nov 2026 15:19:33 +0100
Message-ID: <20261118150333.837375843@linuxfoundation.org>
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

From: Yao Zi <me@ziyao.cc>

[ Upstream commit d824ed1307680dd482f607b0e707c575f70668c4 ]

When adding cc clobber to wmb()'s definition, the alternative()
condition to use sfence was incorrectly raised from X86_FEATURE_XMM to
X86_FEATURE_XMM2.

Restore the correct constraint for potential better performance on
machines without SSE2.

Fixes: bd922477d935 ("locking/x86: Add cc clobber for ADDL")
Signed-off-by: Yao Zi <me@ziyao.cc>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260801182953.15069-1-me@ziyao.cc
[ sashal: Changed the X86_FEATURE_XMM2 to X86_FEATURE_XMM flag on the sfence line of wmb() by hand, because the tree's fallback is spelled lock; addl and the upstream patch context expected lock addl. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/barrier.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index d0795b5fab46a..fc85b3df0f0fb 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -17,7 +17,7 @@
 #define rmb() asm volatile(ALTERNATIVE("lock; addl $0,-4(%%esp)", "lfence", \
 				       X86_FEATURE_XMM2) ::: "memory", "cc")
 #define wmb() asm volatile(ALTERNATIVE("lock; addl $0,-4(%%esp)", "sfence", \
-				       X86_FEATURE_XMM2) ::: "memory", "cc")
+				       X86_FEATURE_XMM) ::: "memory", "cc")
 #else
 #define __mb()	asm volatile("mfence":::"memory")
 #define __rmb()	asm volatile("lfence":::"memory")
-- 
2.53.0



