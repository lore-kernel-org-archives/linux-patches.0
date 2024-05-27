Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2776C168C4;
	Mon, 27 May 2024 19:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837945; cv=none; b=QuoVaIkj0KWSoxcQ22xuASNmqHPG46qPYqqbK5vBMXmcNACTP6+O+qzuG+jZRjwz8sjlu36J/b0NB8e+BAmbi1ZSADJAIvF7Smvniu5kCCmxh2yN4ERcyTDuF5EUaqAhgOLTqVC9kHz+iS/niq5uqzfOQA3BYy96k1GB0mzsaME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837945; c=relaxed/simple;
	bh=iq//nYSpQpiRqpfYotlDpzt5Jxsg908NcZ08vEw4Qkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYIXg8D/Y3iLfojXQdIuEfmLHN6wPZMUujB0jGn4VZSBeLaKMoSUZ9oTaDq04oOoo5Wvgnk9dFtNXtkiBBXmRH2F3GJUw50KMqxJ091xdzmtA9kEEsaicvjeAe12iWe0byYe0z2HkkY8T/jpiZ+j8ssSm3q+eTiZGJQGdorbKc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/RZUrL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/RZUrL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2D7C2BBFC;
	Mon, 27 May 2024 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837945;
	bh=iq//nYSpQpiRqpfYotlDpzt5Jxsg908NcZ08vEw4Qkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/RZUrL9TN2OBz95TEuMloWl4VhI4TOTOnlkP46H7Y8L3i6XFVbl1kCImpyti25Ou
	 z5hSNQB5AHOby94Qvf9h9chcrba091G/GojkpYSeMOli4QIeCac0aqztTDYx3Ie9+Q
	 0MxEZLyDcoeso3RpRSOwK4k+3NcrWIRComabUD0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 205/493] locking/atomic/x86: Correct the definition of __arch_try_cmpxchg128()
Date: Mon, 27 May 2024 20:53:27 +0200
Message-ID: <20240527185637.029330719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



