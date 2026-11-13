Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585583;
	b=zwzu9h/YCpaQ9bbk3vxtF0Wrzo8oh0Dnn2TBwQyKNMwB4ZCgreVy2+CDKU6i2Nouu1q9
	 CGtq9WA6LtUeNh/KoCsM5e/lCgursFrkho3JiF669FrSUWDtKZ2I4b6PF3d5kPSGvE4CO
	 ZrlWYHHfTByVZIGBRJaXQJ24nVdjHf3ogYUnTw64xbAgOvUnvfo7XDiGUQ2Tl3f0mg4kJ
	 Ewh6Ce2ddEWTBgh9nLvjgIO+sutESkIhJMpWWxSNhVa3PKSJZkScoCaJd7eb6mv174Zj0
	 PYHDsFHG0pTjcLAYdlSEUHcQow166twroKdXhBUC0/1X7zLUcnEmst9uZxCyCW/TmCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oykexeul6dWqrZoxk4phS6J0ftiIWR9bv9B+3z7CYQU=;
	b=HypYWiil4z9J1iFOKhKmExe2AmHbRPfhi84TFNQus2P1KjstG23VOm5WFW8XeHJjWZij
	 SCDzghEbR1v3YEvAXMc06FHAtY6LlDqtHRdDBf9P4t9UobZhHfKgD5HGgHD9+UAc7FfR8
	 oJq3omrrKiXHgKSW/NOttZFfY30JEk1jWl2RS1jIjH3VCmayOejl60wy7vXVK8Ih1AzN8
	 VdT3wUwAj9SIRJIIWwa8m2ZF9CkxTGZyNMUp5dRzO8EGWpAjqau3KrBzhZrtiQYCdFZHG
	 nzbZtnFwxcvy4eb0QFatdUIZGbruuv4BhUeyKvuNXMayeQG8yGpLrWbR8/9kvZMUWxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5Zcx975;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B6F606A893;
	Fri, 13 Nov 2026 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5Zcx975
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB151F000C6;
	Fri, 13 Nov 2026 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585582;
	bh=oykexeul6dWqrZoxk4phS6J0ftiIWR9bv9B+3z7CYQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5Zcx975DrP7oLAAqmRoAgsAshp5u+f0oSF5NbiiR/i9ZGAdpr9hRvlDHD5owtIbu
	 QIB0xgm2v5Sym2AIxHLAl6w5u+JHJg1Hn5QF5QVSK7OIn5wTaa0JBXjnpFTAgN1R5v
	 +FfKdTt9e2UAiVy9x8IWfYSgqS/qcrOuP+Ecxj0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 214/507] x86/vmware: Fix i386 high-bandwidth hypercall arguments
Date: Fri, 13 Nov 2026 10:48:38 -0500
Message-ID: <20261113153801.743410425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



