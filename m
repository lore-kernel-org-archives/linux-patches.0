Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DEC1078F;
	Mon, 27 May 2024 19:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836672; cv=none; b=Rkg1ZHukVm33MmKzrcjicPpsDf6lCAR9xWb1uOMSicfnqk+Cazrdyt7sHCLubHrL8ioHB7Gm+a5iOqyxw6A2Rzh5yBlIQGOSMYhYhsECHB9O6UAs7YXipRALjFqOAeNFIQMhP+mrNsvHXeJcfyvZicGTeUfoOqkOl3nMBm5PK8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836672; c=relaxed/simple;
	bh=4OXvpqCmgwKTAKpI5nONYDTHdtMAUbrp0qZE+mHrgxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNIV/Ql+ULdCa4ZdEnHANZovKYa8p/5krINWDQ3tM2LAtP9CA2VZcl4TqUQnDUGBMZRCGc/tmjNZrTVP40LDJ9gy7EEp1bcFdcTubEvjfSiSjNvkyba3o/AV1Vc0oGgHlRCMGsM+fMaThvhma2bCsPfXNWS2j20XSXCYt6Ol2sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sO0QbOKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sO0QbOKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82765C2BBFC;
	Mon, 27 May 2024 19:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836671;
	bh=4OXvpqCmgwKTAKpI5nONYDTHdtMAUbrp0qZE+mHrgxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sO0QbOKJK1+cjVy4DRmPEdEZ7qFaf/tEYSfs/q9BxLd6OizUzoWY5n2RvGZkO+dJp
	 BVxk338sYTIWMUIBmFkUothfuWQMfJDbPg4hWrLoIlxOh349PtOerIZfz7VtpZoFZo
	 4EG6/Y1Vt5ew8A4LSsOQjePY+l58Ri/GP0qbGyTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 136/427] locking/atomic/x86: Correct the definition of __arch_try_cmpxchg128()
Date: Mon, 27 May 2024 20:53:03 +0200
Message-ID: <20240527185614.581288595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 929ad065ba2967be238dfdc0895b79fda62c7f16 ]

Correct the definition of __arch_try_cmpxchg128(), introduced by:

  b23e139d0b66 ("arch: Introduce arch_{,try_}_cmpxchg128{,_local}()")

Fixes: b23e139d0b66 ("arch: Introduce arch_{,try_}_cmpxchg128{,_local}()")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20240408091547.90111-2-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cmpxchg_64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 44b08b53ab32f..c1d6cd58f8094 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -62,7 +62,7 @@ static __always_inline u128 arch_cmpxchg128_local(volatile u128 *ptr, u128 old,
 	asm volatile(_lock "cmpxchg16b %[ptr]"				\
 		     CC_SET(e)						\
 		     : CC_OUT(e) (ret),					\
-		       [ptr] "+m" (*ptr),				\
+		       [ptr] "+m" (*(_ptr)),				\
 		       "+a" (o.low), "+d" (o.high)			\
 		     : "b" (n.low), "c" (n.high)			\
 		     : "memory");					\
-- 
2.43.0



