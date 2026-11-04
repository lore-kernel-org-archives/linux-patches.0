Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829687;
	b=kWHBJosUK+obLD/GejFVzrud97mkG9Z2mYtHJkMaSxXiLGr2a/3CvJkN1CZJJj0Yk1oO
	 DxBBDYO1kWddeMDWA4BEeNeLI/gNM1oanktHl3SuEmNHEe3LtoSyob/OxtRohlhWZ0jN4
	 1P/tOmSW3ldPXv2OBMGnJMtdPTUBdFtxmJGDpN6vsXloMv0QQQPGWSDTEXzZeO+XUhzdT
	 /F72/TXqmXyZRmLXRgzgkKcAspQC1Hr+aXTv5RNAtDexVHc6BI3hmu78NwY9FOSeQ7R3I
	 n86CmTcL60B0+e3z8YIRL9uls+S8NRzyfx6Rm4cESCdRwIDZWYR73TOpBE5jzRrTSvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JYjqoXGiD3WqpmiifQv7K0IoVt0hL9t7amdJ7GShYOE=;
	b=fzS7qVdXeZzwk4NHCgX0p6IDiMwXXakxsCxsC6b/h6Uyv6u51tT0+2BHFUauxQSoqQr0
	 gU9TrFzieVXiGTYJJWm68j/VZ2LrkMhtTjJrD02CKGzw4pIR/cXQ8Klr+0Oez4Qw+sauD
	 y1bXoE61ORY+/ecLXAw39y9s5aWycm2RZsMcON6rOxDfaBDzdX79yO0s+nGlZnvYbdJnS
	 YegbZv3mdtVLsUEnc41Ww0Zlz7P8Eo3gMKSjjCnChgnHGwBJmnTysLx84jzrSK03NZIVE
	 UCKjwWFq0smNsYAflOrOI2ZjrYxPCnGDJ1MWyZ8oJTSmVbRffsCV19lyA/fsi1EsfWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3OZpVaa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEE2606EE91;
	Wed,  4 Nov 2026 22:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3OZpVaa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF951F0093A;
	Wed,  4 Nov 2026 22:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829687;
	bh=JYjqoXGiD3WqpmiifQv7K0IoVt0hL9t7amdJ7GShYOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3OZpVaamh8C7dtcQ4e+8F3efZYASSilBwup6LO3UtebonOwSHGCFw4AaS/eMOl7m
	 Zo3oGtNzjBj+AvkPpieW7FBOzcGWBCwCJ7mjfgyUkZa8r3Ved1dNJP5ZEQyODu6CNk
	 bWiT5z+fbGAVK2iGlkjS7UiZZBj7jEKxrAGz/mvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0280/1005] s390/mm: Fix handling of vmalloc area in do_secure_storage_access()
Date: Wed,  4 Nov 2026 16:00:13 -0500
Message-ID: <20261104211051.734619161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit a2e5a9d853e015bc876399eb18435aa88101c60a ]

Secure storage access exceptions in vmalloc area need to be handled
separately since virt_to_phys() does not work on such addresses. Given
that there cannot be a valid access let such exceptions fail
immediately. The kernel will either fixup or crash.

Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>> ---
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 46e5748b5b1b3..9d7d3ef99fc16 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -433,6 +433,8 @@ void do_secure_storage_access(struct pt_regs *regs)
 		panic("Unexpected PGM 0x3d with TEID bit 61=0");
 	}
 	if (is_kernel_fault(regs)) {
+		if (is_vmalloc_addr((void *)addr))
+			return handle_fault_error_nolock(regs, 0);
 		folio = virt_to_folio((void *)addr);
 		if (unlikely(!folio_try_get(folio)))
 			return;
-- 
2.53.0



