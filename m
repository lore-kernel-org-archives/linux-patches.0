Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217199;
	b=4xcNN/xOpmXARNd3ABh4iOf+EQ5HDTe1tzJWGQiepxdMOif11L4r9MxPIUbHM6yMWEIs
	 6X9l2dFLZtqH1NLXgGj1ke9/pZTCTum4QGCin8KAMZg74iY+q8RDS65XswvD+/jfBLTVl
	 b33zBtLbnDQ67c+Nqx835pb2Ytkk9kZ5nvvVNQVYvJtMcwXhPFSzD4rgtian+GUktwdlh
	 PcB15H6UgDbSerP3a4wQJE1Fn4I2uqgj+IFnT64DwJOK5XfwbMtuoIHbFyze03AUneLon
	 0BYgxsGljfXpyruaUcLHR6xJOEG0GV7D1V3aoFMloaGxblMiDi5rTlhRfda+mJ09hlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1oge8cMYnFF8+hesAjzDQHdG3HW9UjCXsaApmYOQJdM=;
	b=gnSI7+DSqpggRHNibDnChx72Wa0pfXklKFC8nutI4GEPTinLORpB5+//ZStwJeGadek7
	 qA0PZUbbpGHtZA3Y3DY2EQqpE/uNtmXYBM47FSuQ8bIJeVIZ9iDoScG97qePLfbrolMoy
	 kpCPGlke5BMw/KIUzBJIiu5VR2GcYvHZzN7+Pby0gca1SPneveV3uMJDUSi7rchnmdX66
	 OAVAIh1oYypWEEVUTL+VUyREgaU3d8i2XmeijcKqD6FQLN/hGvLZYrLG1b61NMQve+rBr
	 +lqmDv+MPeujpJFT180dI7k3kipFMA7HnahAD1wDkvQOawedy5vnf9eKT+35sIioP0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y4wXhBs9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52E3606A31A;
	Wed, 28 Oct 2026 19:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y4wXhBs9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033861F01825;
	Wed, 28 Oct 2026 19:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217198;
	bh=1oge8cMYnFF8+hesAjzDQHdG3HW9UjCXsaApmYOQJdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4wXhBs9hzF/mT01hhpho9F8hybtfmVejk9IlRXTa+UHvr1SLRsdDCtQpojrueU+u
	 DydvfKxOZBKKpFT2R0jqJyND3Vh43c43kMg9ZNrP2AJuBluA/rm4SzyOn/Vd2R4FYt
	 pT3Ialn/AqkmnqcdUq9F2BjIcF7XwzVYn61QQRe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <songshuaishuai@tinylab.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1821/1887] riscv: Remove SHADOW_OVERFLOW_STACK_SIZE macro
Date: Wed, 28 Oct 2026 18:05:17 +0100
Message-ID: <20261028170540.880578620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Song Shuai <songshuaishuai@tinylab.org>

[ Upstream commit a7565f4d068b2e60f95c3223c3167c40b8fe83ae ]

The commit be97d0db5f44 ("riscv: VMAP_STACK overflow
detection thread-safe") got rid of `shadow_stack`,
so SHADOW_OVERFLOW_STACK_SIZE should be removed too.

Fixes: be97d0db5f44 ("riscv: VMAP_STACK overflow detection thread-safe")
Signed-off-by: Song Shuai <songshuaishuai@tinylab.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lore.kernel.org/r/20231211110331.359534-1-songshuaishuai@tinylab.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/thread_info.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 78933ac04995b..e7572d0ea29a9 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -38,7 +38,6 @@
 
 #define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
 #define OVERFLOW_STACK_SIZE     SZ_4K
-#define SHADOW_OVERFLOW_STACK_SIZE (1024)
 
 #ifndef __ASSEMBLY__
 
-- 
2.53.0



