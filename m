Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049328;
	b=QVKhddTvyXK1gTkbHqTr5E0wFJCJ5srF3QPlK6FV5/18+q8BfnfZMips4GfyaA+RcHFv
	 Ug+7tsDWqqNPUU1DcFwJWXiMwpVoHAOlE6/Ce+6KQht0K2XF5XTzAVZDAXOvgOIMX7VlY
	 dUWn1y7670UjacFwkXiKnqj1C41xD+3+Wal8Iqz82y/HMkR7RB91+JqU6wAyhpZaR8uqH
	 Ck2RCOPzmed+MaF0HElMywz5IuoZx5wsArydyldlXw0ozgc0Yuhdn4W7pxcgG0g5wd5J7
	 2J/rcOieb6+Yho/pRc3RsTlhu2eQ+uWsYe213MKwr52JQ7DTSNtJURq4OKaucchmRww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cM1tc48G0Vjsk/cNlapgsL/IEYdW7mgmrs5dBu6qsE=;
	b=IMORIsX3t7+15t8IsA5DlRq2I8H6SIDegdSDKLx8qij8wI3PnHg2t7vBfEJ/YxuTg3BV
	 IZloxHYlR7OtAv8GjkDcXoh1/lpJK6Zt/f++C++KAhgOFvgXrwluxjol+uUcRRH3JvG/z
	 0zLTcvRZT2rqtIH0SF740+uN400+V5kQP5rtiH1Vs2mjP1nDAefZ3+1Ego5OTEukmAoSs
	 5qui/RgLm3fcU3ROnxxNXpdLxhiuHKqGWmuRQAfbW08Unjy5YramLUuVM2B5ngiFKMIMn
	 hsM35CvwoPWv/ORt3nu7iyA17PFkTRTvnE74xFV0U6tLS5uGFkfm4tPe1g0fuK8e+1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6IRsc9Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2522606A33E;
	Thu, 19 Nov 2026 00:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6IRsc9Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0203A1F000C4;
	Thu, 19 Nov 2026 00:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049327;
	bh=4cM1tc48G0Vjsk/cNlapgsL/IEYdW7mgmrs5dBu6qsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6IRsc9YL4kgCiG26ui1P/Oo3F3/7KhPozkriV4ugMEGPzpYt8DsFEeSdkc2LSEIQ
	 T93C8XCU7+sEk9LaYdEFxNaOc4JxMUwUCjv8Ckj3Ukcs1H6EUHknh3eX6OKzeXCBcC
	 yI23XbM0dXYRtuv8INtLFss3KrPQISiJ0wKxTEIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2275/2857] sh: uaccess: Require offsettable operands for 64-bit user access
Date: Wed, 18 Nov 2026 15:55:09 +0100
Message-ID: <20261118150323.367286046@linuxfoundation.org>
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



