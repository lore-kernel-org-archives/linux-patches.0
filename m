Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055959;
	b=fRzxMM+z+CdFuVYGVlYkw41aAC4iVPq3/OX+df+jMjXgNz7lWNkszZgpZJ1z2JKpCUJy
	 uDArWI12152bezGm+j1Uw/LG/RMI7bQyPuj81LOSegPHh5EdGSMV5ZHRRqLbLx9olbMxS
	 Do1DeIU8tmWiFGU+24SQc+O+ngKoEaLI/g+ff/ohj8Pioj+3RfQ38VUNIHULmpuOn0yNt
	 rHxymBkM3pkfSRMgpPC4z0S9mZoQfAvg26sN9lWBi/rP2DmAY/mEjXbiiS98WAPIQWx/G
	 WtNbpggjvJzwunfRBvy/DWt6VS0kDfD9ipCGfemkPx6Ofo5/yL43hqPq7loyaZkguiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJrkgu+TgRwWMcT/SpIyR8si+jiOFaXwIpEVCipgvXU=;
	b=bmY8L4kvmfmgtFJBxOU2CNiZgofeTfczO0BxHf+KuYyvWQpCz7CiXIoxVKFzvXsecP1y
	 6J2DwZVm5dcrxug7qxOBSVRFN56Nig363dTO0Nfugw9IdXttljiso7AioECG61IXLwJ/0
	 r/T2fiKgd9JkOrzDG4yYFhNREde0K4707sWb9yVgwekoQuXreW420levc2j9QfGovkwvL
	 dlNeJARewdHs2MknkJfuF0MOVBOw47zwjmIjleJcDQkFloPzU8/dB/2hc6G1HuAvn4b1L
	 ouWEnhDFMUdpJJIQJEjJHHkF9aO7PiaBSyrRXkAxDu+Ut1PzMFu80N3TbjNc7ewKGCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AoV/M2q4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB1606A31C;
	Thu, 19 Nov 2026 02:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoV/M2q4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027C31F000C4;
	Thu, 19 Nov 2026 02:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055959;
	bh=TJrkgu+TgRwWMcT/SpIyR8si+jiOFaXwIpEVCipgvXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoV/M2q4FS4bGM3Ca5rWJP3nkvdVaHeutgzAiO5D0kGiWz6XUSZskSUKLIkOw2lkh
	 mLXbx/vyQh0drqnWFyr11SHpcgPMMZXYyLyaAl/G8vI7+XhLI2O7L6N0jHmB6zfLdr
	 fSlD3CYLIlE3lBjc6VNxRcfMA16sB0K/QMShHaT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1777/2214] sh: uaccess: Require offsettable operands for 64-bit user access
Date: Wed, 18 Nov 2026 15:57:33 +0100
Message-ID: <20261118150122.587763994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



