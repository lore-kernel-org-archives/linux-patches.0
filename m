Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061424;
	b=U3P6bngy6XrhjiNos6HWtbco/2zWGnye2gpI5DJHyFQW7KZJ/x9lFGDJA+yYQ0Zp0I/n
	 k23w/5T5qD4ZNQoEIUjXPhqVvynWCregj4F6Pa7Yi+zkfce9VP2O7IkZ+p8Jvt5P/i0eY
	 HAq5KWZ9wFpnYSxfLZU+Mr5qrTPHyuJ1g7sJlJbHUFYmtQ/0KqzaGi1o+VYKuo1neJOW8
	 9OM9Yc3DLdY2gSH7jgs+SsljXKPr06J6Tn88xYiD6aeWYZysqzLiCzFoE6IbZpb3LliBd
	 rg/NgHRkgSjTR9IjpvhyDV8VWFfJUQ8NUAMr4UK5wsJT2paBKkLiJ5tAd9JP+b2F2bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ppt/On6bAU00VlHvU4TcCCf5N3zALCQYT/YTCatxjJI=;
	b=Ads5wIRKuYYljEpfO+3cMbhWLnFpIHS/+CXOnT++uVXrmjLDAnSlovfL5pkDq91Bz+0f
	 DM6V7sBWiykfxoQKBgMqlK5Ls13Cwsj1via8Pm9H1Ojj/sQnxSirMcEs/Z5d1p1yLOdUi
	 7PU/PYDyrR6Qd+0Zzhak6YpXQ7Svlq6d/ZWy9OSOIK6IaLaivkZwdd7AnZVCmVihjl9Mv
	 6NlW7tSDxgqLL8woRLh1lzsEzK3cF8n+iI8L42+ffXFNMlCg4H2qfiEm5j7uepia7LK2B
	 d+3Ew8MMyeYU49YBYVI0eq/gmPhzVV+GlZl9b1wQqPSECAMJ97oLiS+lXb4XrSJ1ZLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuKlCqk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02483606A320;
	Thu, 19 Nov 2026 04:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuKlCqk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BE71F000C4;
	Thu, 19 Nov 2026 04:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061423;
	bh=Ppt/On6bAU00VlHvU4TcCCf5N3zALCQYT/YTCatxjJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuKlCqk0WyjPpFoC8v64ryc+g4JnBcCfWSV6lx4pPjzirHBQKpbXn7ZOBwisq53NT
	 sC3n6V4zATR3vNghxfhmG11o76dgvILQx0Z3c4+GODBPGmyFzexjWJ+BCU39KuSTdY
	 GU7AssERb01y6QPGEjOmyPgfbdSuyY9HzEzsuE48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1510/1848] sh: uaccess: Require offsettable operands for 64-bit user access
Date: Wed, 18 Nov 2026 15:59:08 +0100
Message-ID: <20261118150022.526735095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



