Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041039;
	b=nwe6XjpWIbLzbIC++WWxAArh7t2uHwsZDlmFoVzSEua2SIxdrMWivvoaWgM3ZP6zWtuU
	 iWXl4/xS0GHnhx27vQZwzTjs0bOcNCsQu1AI99lKIViKDuI1EAkmRk6M+KHW9ndgVEM9v
	 t3Lz+YKra/Qqj8RWLq0XS3anxQP+fMBsOLckkLAS3fcmJGkjdAPewOZcPCRd26x8rPnW4
	 ZZO0fxg2n6bxcLOhlwmUJmzXPpT/lcDOVh6j9xzmKWjyNZDMXFMO21q4UNZDStpsrUImd
	 0MhK9tVNirF5/X0xmbPnEEl0W4+2Z637jwTDg0U8VDSTNSp3IDgGj4SlvKrA5m+gBwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=phf4Ae/vhnCNhnlp9Yv3rumymJU+isrSFMW5FTF1zUo=;
	b=kkqvJYa51MDEFjffNTTl5aff3veDgVxE5rSI63F6jYQeZXDXF1Q92jfxM7w1U6nlmLFM
	 vY/RES9GFXF3paHm65Ud41+CTXYeo5R6d8dY39zu3SIvdxGPwkHBxn2K+3nHTr36Xdxjl
	 gj3Rhx2+MlJ89CYJCZ/+qPbuY2i0rMcEk6jzNaHKFtuTUmxyPLCThlq7as9iwVdB7ERC5
	 QQAujq2tAET8ZKqkSwpQsG9loaSDrKe02cGMFAbJMNPWVwS6teTSkkR7IMtvnGJ0GHsMK
	 1XmFS0Be3g+VQ/imHJBywdRpWjEkGwewqO0fsihwJwXKF1mcd04062aN7zijzolvc/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ei5xazSq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F172606A32A;
	Wed, 18 Nov 2026 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ei5xazSq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAA71F000C4;
	Wed, 18 Nov 2026 22:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041039;
	bh=phf4Ae/vhnCNhnlp9Yv3rumymJU+isrSFMW5FTF1zUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ei5xazSqLxfVksGJlBD9/nfNnmFfx/5T//zbHL5N1dab+gjwSftqFElVQ8VhNC9HM
	 uyMK/7cXWjVkKK+P83DETcRqsnjrN8a+RNDoY2k6h1GOPfw0AFDG71shtPtDEoB1jI
	 MMlDi8+xoKXKTdEiF38f4I0wklB5sTPKwRCOLf6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2631/3318] sh: uaccess: Require offsettable operands for 64-bit user access
Date: Wed, 18 Nov 2026 15:54:13 +0100
Message-ID: <20261118150440.021712643@linuxfoundation.org>
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



