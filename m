Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043818;
	b=SrKjRygqAqDUCHWKMYhNKeT2AHgTRU3REzvZC1VhNS/A73aA1J7bfuAicDaqwKyS581l
	 4tdk8RTvK7QwaGs8IXndTJsi1zB6r5X0uNQ+A/yUeVrglHw00fzgupyu7fFKDCbM4ogZs
	 I/aF9gWbQzBL2PukjZblkh1F0HlFeeD2/M98CqygUO4XEBstn2fv14V06rutRhD94rvpb
	 WNWFcS0gmQc1WrEkuRdk6/BhX8XKDHQu1yc/2p6SVgHMZA1Wbyu+fib12omtFYvnK+avv
	 pAGnoDGZ7ox2yp/+gZ0AvGEHtCHk4BgKU8LREXN/rT671W1IQj2kWG5Hnc3Xnb4pGLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mYuvwwdHjAYjlvSbVLMxPJRBMuZt2GyE2Kcc3edYenc=;
	b=V6BI5HZIBgTp9ceKPKuIV8scScK5HmV7Ac15EtST9D6ftNiT/m54stN7gsZm85BO8aMu
	 DOCChFfrt/xRvZ8EG7efTMNEdIYKR9S/HnYJnp+1Pc3L7Xy89UTwnweY0IL/fRxqykiOW
	 EpVaxwE7DHV+tGng4I3aEc5M7k7zJ5f+xHj4D94h7aHml62cANDsn6/IqURTJKdnqQjvL
	 Lpb/rxxacx1qXNlkdDjTkxgloJ4Mui+v0iR+keju+UqQarfEmYCT/3VaquPyY5urcdbqD
	 /cqFXzJ/16BPgWHgaIsaL3eHcuVvptqc864mwsAUG82qfqtkj69YeG8EtEJblvJKohg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dINOidRY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59038606A320;
	Wed, 18 Nov 2026 23:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dINOidRY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999121F000C4;
	Wed, 18 Nov 2026 23:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043818;
	bh=mYuvwwdHjAYjlvSbVLMxPJRBMuZt2GyE2Kcc3edYenc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dINOidRYgKNjguYQrks35ZUSW8aC/tueRY+UJw115bQYPQjH/IpVMMWNa0h/APZ23
	 qEN6pZECT7uX5lPf6isN+Vy9w6HoBvggeFKKzWpYnUkHiJVCIxfDULhNFkRRzwSFSs
	 orSas4sUC2Pbe8A14/jN9DdcknyF0QD+at9/wtfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0346/2857] x86/locking: Use sfence for wmb() if SSE is available
Date: Wed, 18 Nov 2026 15:23:00 +0100
Message-ID: <20261118150213.902975004@linuxfoundation.org>
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
index 0216f63a366b5..b744fee19797d 100644
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



