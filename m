Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025788;
	b=HMBY03C32SEHFFa2HWQKau77ezhEh+i9l0nCceYcWVSBqbh7dZrns+X1Vwdl6nwTU4ok
	 T8iCM5QLv9FH8wTe+dBEcP1ifyfPfTL31J8ZGWTZ08/moxcKVoSI8yPUY1JsFHLEyUj6K
	 e81PKu94PERUzABI+QfCGB+Suy0A1rRG/kcweRX5QkuxwefpACmTTJjHI7fAZ7l1dRzlu
	 4t1OwZGtLoqOiwBs5QbLARPqyznpX6tKyaEhj/DpWcMUOPI3L7LdtYxdscqaqQ+fXsTVt
	 eWhkhQ3PPQ1mNcDl8Syzf1vG9WS/Jry/b88d03BUwYn0n6UBZEvSEVJ4o9yMEMuSyaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SPoxIvi7jzEv2eRfypoBv3VctZsaXprY4gMyNj5OnjE=;
	b=PTMF0bAMFVGclci75Rj7pzSKJKUfa5l0A4+bBdGtWQbDdYrjLw/yPftp1GuKl+fN+Asy
	 azjosB8rgQ1unvH1WtRoQVXhuKGGrv2/oaJuTTZV1aGchlb6PNVGJd70oH7zUNSBOl99E
	 nShjCQabxjA72asQeyIjT61M1WGNnOsAimznNrca9Ri8s7tVLhUSf+VGlfBlq0mbSiEfI
	 CcQh5I9AQQaM4d1EsFLknFlGZ4JXYXw0DnW3QsNWVRSyQNk/k4yiazGhTDr+N9dqZnwmb
	 txOg9hNYPLUT2KBb1VY0iiYVEd7wL2xtIF6oXV72/hAIg2lQDYpCOzjN50fANj3bykQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZMTshgq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A5760A260E;
	Wed, 18 Nov 2026 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZMTshgq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4451F000C9;
	Wed, 18 Nov 2026 18:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025787;
	bh=SPoxIvi7jzEv2eRfypoBv3VctZsaXprY4gMyNj5OnjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZMTshgql4VxwCkqNr1bB6d2ZWZ4kBOignQi0YX0WXk91pZuE04pkfVkMU3payABN
	 CgSSnYZV37Ccg2ftzVQxdypXp1153v0Ry78gP513Dmeyi+QFMwEa6B53jeBjP77wHJ
	 U/bOOgP1zODFpu90ao3tz8bWjnK8xMDE/D/m2dBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1151/2151] sh: uaccess: Require offsettable operands for 64-bit user access
Date: Wed, 18 Nov 2026 15:48:06 +0100
Message-ID: <20261118150204.111541933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

[ Upstream commit 8b5dba9ea4a3f5ed994f03d6ca7686c49491b426 ]

The 64-bit __get_user_u64()/__put_user_u64() paths address the memory
operand as %T2 (base+4). This base+4 requires an offsettable address,
but "m" also allows the indexed mode @(R0,Rn) (e.g. for a variable-
indexed array element), which has no displacement field for the +4.
Depending on optimization this build fails with "invalid 'asm'" or an
ICE in GCC's change_address_1.

Require an offsettable memory operand, allowing GCC to reload an
unsuitable indexed address into an appropriate form.

Fixes: 2d2b308a8b7d ("sh: Implement __get_user_u64() required for 64-bit get_user()")
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/asm/uaccess_32.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sh/include/asm/uaccess_32.h b/arch/sh/include/asm/uaccess_32.h
index 5d7ddc092afd7..cef40414bfb13 100644
--- a/arch/sh/include/asm/uaccess_32.h
+++ b/arch/sh/include/asm/uaccess_32.h
@@ -92,7 +92,7 @@ __asm__ __volatile__( \
 	".long	1b + 2, 3b\n\t" \
 	".previous" \
 	:"=&r" (err), "=&r" (x) \
-	:"m" (__m(addr)), "i" (-EFAULT), "0" (err)); })
+	:"o" (__m(addr)), "i" (-EFAULT), "0" (err)); })
 #else
 #define __get_user_u64(x, addr, err) \
 ({ \
@@ -116,7 +116,7 @@ __asm__ __volatile__( \
 	".long	1b + 2, 3b\n\t" \
 	".previous" \
 	:"=&r" (err), "=&r" (x) \
-	:"m" (__m(addr)), "i" (-EFAULT), "0" (err)); })
+	:"o" (__m(addr)), "i" (-EFAULT), "0" (err)); })
 #endif
 
 #define __put_user_size(x,ptr,size,retval)		\
@@ -196,7 +196,7 @@ __asm__ __volatile__( \
 	".long	1b, 3b\n\t" \
 	".previous" \
 	: "=r" (retval) \
-	: "r" (val), "m" (__m(addr)), "i" (-EFAULT), "0" (retval) \
+	: "r" (val), "o" (__m(addr)), "i" (-EFAULT), "0" (retval) \
         : "memory"); })
 #else
 #define __put_user_u64(val,addr,retval) \
@@ -218,7 +218,7 @@ __asm__ __volatile__( \
 	".long	1b, 3b\n\t" \
 	".previous" \
 	: "=r" (retval) \
-	: "r" (val), "m" (__m(addr)), "i" (-EFAULT), "0" (retval) \
+	: "r" (val), "o" (__m(addr)), "i" (-EFAULT), "0" (retval) \
         : "memory"); })
 #endif
 
-- 
2.53.0



