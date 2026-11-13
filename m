Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590318;
	b=zSzdT7Jw4/dvitNGDJgY1eMwoV1CcX7BLuYyUnlLK6KvWK4okcR5eoXXmCP5/nI+mmGX
	 t702R68FGw7bY0E/QLOKhsWMD94cIvqEpPrJN5Fdb3FZJN5UVzObWBQ/LNqo4tk7hE40u
	 AQnIyV10MJ4vaxNQ6LVn0YBVuOmjPZfP+j4hPY8QKqFHt/VwWKFCaNrSV48BHzc60pSn6
	 k+dmNbERp9F3uqvM8yrF3GgWymIOomoE8F5/DJAtubLbCvbo04fEnM7VcA1lB0YfoQ2DV
	 Ay0AKcrAqnuzndQbdmXVUlaiOMFj2VUWE/8SehiXR83hBYrwjMs3GQvjU3DXTNEkhGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AXXUJxoeaaD8pDp+uCXrbsF/tDuTJawEMDj7DbkSAOQ=;
	b=FluLtQrcpEKb59yCOXPzd4L1eCje4PxA5SyyGfVrOhArtjSfpXEEg8XmOKEviBN8dpyk
	 WEfefTsYZwbEPgGvGKFAZZ/spcyaKmhf1W7dFhUwcsWtIBNCRY7fQV8xzJblT2BQR2LI8
	 uQ5flfcQMQmq9LaGL8GZDHy1QmqXYty3jg7S6lqovAe4ynYWAGuXPHKTr7jEBF3W6mG1Y
	 S/+mZLPKidjnlDdkvtrvxMjnxvSHZOpMwJATEdua3LEUa0iaQ9KGc9lJUYcfRQFv7Gdux
	 y9xJzM0H42zjib2pM5mk0EaNRkod/hGccLqlzxamFY1LuOuqzeMLktu2qB8txkcGRVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaNBu3l8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A43607E053;
	Fri, 13 Nov 2026 17:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaNBu3l8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2283A1F000C7;
	Fri, 13 Nov 2026 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590318;
	bh=AXXUJxoeaaD8pDp+uCXrbsF/tDuTJawEMDj7DbkSAOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaNBu3l8+Mt/C37dVhcoPoYBPn+UoAdskCfycEhee0EoeAiKs29EVN6Acd72LheKR
	 hsCY0Vznj1JQBvS2euRvsHGQcT5fT0xJUgSLtP860sonwlR9GdMfY/dXlFxqozoncY
	 1krazACJV/4+00yCRKqJT7JoW7doSvSRFthDSZ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/686] x86/vmware: Fix i386 high-bandwidth hypercall arguments
Date: Fri, 13 Nov 2026 10:47:14 -0500
Message-ID: <20261113153831.154239617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit e0e022004bbedc7caf1c18770980eb5372019189 ]

The high-bandwidth hypercall helpers push %ebp before loading the in6
operand into it. On i386 without frame pointers, both GCC and Clang can
address the memory-constrained operand relative to %esp. The push then
moves the stack and the helpers load the wrong value.

Typical i386 configurations use the frame-pointer unwinder and happen to
address the operand through %ebp. However, UNWINDER_GUESS is available
with EXPERT and permits the affected frame-pointer-disabled configuration.
vmwgfx is also available on i386 and calls both helpers.

Stage in6 through %eax before changing either stack register, then save
%ebp and copy the staged value into it. Load the VMware magic immediately
before the string I/O instruction. Mark %eax early-clobber so it cannot
also provide in6 or an address register for it. Use the same sequence on
x86-64, where the full-width register preserves in6.

Fixes: 34bf25e820ae ("x86/vmware: Introduce VMware hypercall API")
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Cc: stable@vger.kernel.org # 6.11+
Link: https://patch.msgid.link/4ab10678a8f50053934b62b56af81f881c1d3798.1788414669.git.zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/vmware.h | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmware.h b/arch/x86/include/asm/vmware.h
index 4220dae14a2d9..fb011cef01e76 100644
--- a/arch/x86/include/asm/vmware.h
+++ b/arch/x86/include/asm/vmware.h
@@ -276,20 +276,22 @@ unsigned long vmware_hypercall_hb_out(unsigned long cmd, unsigned long in2,
 
 	asm_inline volatile (
 		UNWIND_HINT_SAVE
+		"mov %[in6], %%" _ASM_AX "\n\t"
 		"push %%" _ASM_BP "\n\t"
 		UNWIND_HINT_UNDEFINED
-		"mov %[in6], %%" _ASM_BP "\n\t"
+		"mov %%" _ASM_AX ", %%" _ASM_BP "\n\t"
+		"mov %[magic], %%eax\n\t"
 		"rep outsb\n\t"
 		"pop %%" _ASM_BP "\n\t"
 		UNWIND_HINT_RESTORE
-		: "=a" (out0), "=b" (*out1)
-		: "a" (VMWARE_HYPERVISOR_MAGIC),
-		  "b" (cmd),
+		: "=&a" (out0), "=b" (*out1)
+		: "b" (cmd),
 		  "c" (in2),
 		  "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
 		  "S" (in4),
 		  "D" (in5),
-		  [in6] VMW_BP_CONSTRAINT (in6)
+		  [in6] VMW_BP_CONSTRAINT(in6),
+		  [magic] "i" (VMWARE_HYPERVISOR_MAGIC)
 		: "cc", "memory");
 	return out0;
 }
@@ -304,20 +306,22 @@ unsigned long vmware_hypercall_hb_in(unsigned long cmd, unsigned long in2,
 
 	asm_inline volatile (
 		UNWIND_HINT_SAVE
+		"mov %[in6], %%" _ASM_AX "\n\t"
 		"push %%" _ASM_BP "\n\t"
 		UNWIND_HINT_UNDEFINED
-		"mov %[in6], %%" _ASM_BP "\n\t"
+		"mov %%" _ASM_AX ", %%" _ASM_BP "\n\t"
+		"mov %[magic], %%eax\n\t"
 		"rep insb\n\t"
 		"pop %%" _ASM_BP "\n\t"
 		UNWIND_HINT_RESTORE
-		: "=a" (out0), "=b" (*out1)
-		: "a" (VMWARE_HYPERVISOR_MAGIC),
-		  "b" (cmd),
+		: "=&a" (out0), "=b" (*out1)
+		: "b" (cmd),
 		  "c" (in2),
 		  "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
 		  "S" (in4),
 		  "D" (in5),
-		  [in6] VMW_BP_CONSTRAINT (in6)
+		  [in6] VMW_BP_CONSTRAINT(in6),
+		  [magic] "i" (VMWARE_HYPERVISOR_MAGIC)
 		: "cc", "memory");
 	return out0;
 }
-- 
2.53.0



