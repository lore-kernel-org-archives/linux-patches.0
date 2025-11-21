Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBFD3F9D2;
	Fri, 21 Nov 2025 13:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731898; cv=none; b=SfCbvDvzwuvUt4w4hbU4cy1dxQLLgBV61LSlFn6Px/L/1zZ1uHzx7mmWGrWRmG7gQhrCMmjkDrlDpMQcucrz2GCdX37rX5YvFExx87Y55VGLvW6lhRXZJzOKp4Q+nMEqS1IXuHnXWUaaQ4PZzKcfre6zGrdgT1Y/r93eruEzJ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731898; c=relaxed/simple;
	bh=kLo1VHsxUvGlv2nZCr7rWleAGg5KD/2DE8FxsKjnXts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmMbfQiQuogFO/PAqDJO+TAHhp6AVraY9vuyPR/bOuLpU3b52vPJxbdOIrd6MTxPESiVIMTPoIyHi3WHpjJyaaUQ/KQ7/4GGPTtjGr5jZdMIuGNeoumItRMW39avuma/+xEqr2xP3lMIRXfOCiKSXMpwTBX7E4JCA4RUUM/2xkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgB6OfcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgB6OfcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E1AC4CEF1;
	Fri, 21 Nov 2025 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731897;
	bh=kLo1VHsxUvGlv2nZCr7rWleAGg5KD/2DE8FxsKjnXts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgB6OfcNEb6da0fRZ9R6GOp7aN2Acs6IVSvGhqfq3Xk1dphbskSJ5zDhF5olNEOzy
	 Cmvo8l2qfdebYZ01XGmlrCJ3JZ73/GYRspWrl9ez/WHTUbw8thtJfKFElOa4ZAvRJD
	 rxzEDdmUmVtkx26JpNLro5JWkr2E2Qc3mDGKc0kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 118/185] LoongArch: Use correct accessor to read FWPC/MWPC
Date: Fri, 21 Nov 2025 14:12:25 +0100
Message-ID: <20251121130148.133560849@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit eeeeaafa62ea0cd4b86390f657dc0aea73bff4f5 upstream.

CSR.FWPC and CSR.MWPC are 32bit registers, so use csr_read32() rather
than csr_read64() to read the values of FWPC/MWPC.

Cc: stable@vger.kernel.org
Fixes: edffa33c7bb5a73 ("LoongArch: Add hardware breakpoints/watchpoints support")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -134,13 +134,13 @@ static inline void hw_breakpoint_thread_
 /* Determine number of BRP registers available. */
 static inline int get_num_brps(void)
 {
-	return csr_read64(LOONGARCH_CSR_FWPC) & CSR_FWPC_NUM;
+	return csr_read32(LOONGARCH_CSR_FWPC) & CSR_FWPC_NUM;
 }
 
 /* Determine number of WRP registers available. */
 static inline int get_num_wrps(void)
 {
-	return csr_read64(LOONGARCH_CSR_MWPC) & CSR_MWPC_NUM;
+	return csr_read32(LOONGARCH_CSR_MWPC) & CSR_MWPC_NUM;
 }
 
 #endif	/* __KERNEL__ */


