Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829675;
	b=M/VD2J8PhyQ4Ea2XgQlGdty3vVyGmysF+0zCp6XSj3egsoA5juwFkANgOaDcGBEUsJSG
	 P650P/5ARCt9C9FZTL9sZLaXdYwuJIaWdJfvdTyU1COzSfRdnKs4NtpDwshUGinkct1QT
	 isVA9pEYgiqjSkmv/yq5hoL6x5chUXC2/Qcef+4LiyBpbkGYV5SPBx27MjFlQxa+KwyQD
	 I/4D64/3aS5lro8hr8Wg12zW13AnLyoSm3+U/e72XTSDL4aKudL6pxMi4hC5lWscBDuyJ
	 jXR5iTmqBZpnzcgWBSHPJoO4O8fprbnK2gQCy7Lx5B+plp7xMJi71HJuI10O4U8C1Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qzDGXWuH3S6f9JmoWVH6wwFuYcfgpaRnKuZVvZ52hiw=;
	b=T6QvyXAXfhiBoRzuXBmN66I1l81CaMiPFu8s78Tw1XamPQzeVDsE+hkB1N3VFGYS6nWO
	 5ZWfE1T8XQyWaJLBCn9EnpK6hFitQ3usZjb2ShR7OwtufCDlLfuzVQjMrKCKN+edFytPh
	 h4TzmvPmicnkVfDdpcl+FFxky22iaOrZD6ut3gHRMUosi/l76viueWn5/Bf37sdPm1g7j
	 lO0Lf0y4BbYmPxy0hDXNHSJMZBnlgRP87B6EH77Grir4k2YZwtL5BiZqzZCLnoCFIhHw7
	 +oPeaFfnkQPSe1bu0JhyUOJxv9ugw2HucwfqZ075eXxfMhKSAFQ1ipAuCrjtjB3+paQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpJACqKP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC77C606BA3B;
	Wed,  4 Nov 2026 22:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpJACqKP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A3D1F000C1;
	Wed,  4 Nov 2026 22:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829674;
	bh=qzDGXWuH3S6f9JmoWVH6wwFuYcfgpaRnKuZVvZ52hiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpJACqKPJpVsI6WH3S5Aq53k6SPHb0oOPgB3rdwnhknQ6D/u3TGJw8F52YszVwcrM
	 QyVfKH1vCEZB0eqkYNE4r8bqPb8hxuga0PSoBSUXoL5dib6r+9IGff6U52RhkmNJzJ
	 JW52x1StjE7dQOAYtVMz+bYzOOGrVkxdulS6lTAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0273/1005] arm64/runtime-const: Use aarch64_insn_patch_text_nosync() for patching
Date: Wed,  4 Nov 2026 16:00:06 -0500
Message-ID: <20261104211051.530649324@linuxfoundation.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit a6690350a4ae7558b39d15fcc776c4d1ab5bbf39 ]

The current scheme to directly patch the kernel text for runtime
constants runs into the following issue with futex adapted to using
runtime constants on arm64:

  Unable to handle kernel write to read-only memory at virtual address ...

The pc points to the *p assignment in the following call chain:

  futex_init()
    runtime_const_init(shift, __futex_shift)
      __runtime_fixup_shift()
        *p = cpu_to_le32(insn);

which suggests that core_initcall() is too late to patch the kernel text
directly unlike the "d_hash_shift" which is initialized during
vfs_caches_init_early() before the protections are in place.

Use aarch64_insn_patch_text_nosync() to patch the runtime constants
instead of doing it directly to allow runtime_const_init() slightly
later into the boot.

Since aarch64_insn_patch_text_nosync() calls caches_clean_inval_pou()
internally, __runtime_fixup_caches() ends up being redundant.
runtime_const_init() are rare and the overheads of multiple calls to
caches_clean_inval_pou() instead of batching them together should be
negligible in practice.

The cpu_to_le32() conversion of instruction isn't necessary since it is
handled later in the aarch64_insn_patch_text_nosync() call-chain:

  aarch64_insn_patch_text_nosync(addr, insn)
    aarch64_insn_write(addr, insn)
      __aarch64_insn_write(addr, cpu_to_le32(insn))

Sashiko noted that aarch64_insn_patch_text_nosync() does not expect a
lm_alias() address and Catalin suggested it is safe to drop the
lm_alias() for runtime patching since the kernel text is readable. The
address passed to fixup function is interpreted as a __le32 and
dereferenced as is to read the opcode at the patch site.

No functional changes are intended.

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Link: https://patch.msgid.link/20260728052540.4728-3-kprateek.nayak@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/runtime-const.h | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/runtime-const.h b/arch/arm64/include/asm/runtime-const.h
index be5915669d239..31a6f94e57955 100644
--- a/arch/arm64/include/asm/runtime-const.h
+++ b/arch/arm64/include/asm/runtime-const.h
@@ -3,6 +3,7 @@
 #define _ASM_RUNTIME_CONST_H
 
 #include <asm/cacheflush.h>
+#include <asm/text-patching.h>
 
 /* Sigh. You can still run arm64 in BE mode */
 #include <asm/byteorder.h>
@@ -46,34 +47,26 @@ static inline void __runtime_fixup_16(__le32 *p, unsigned int val)
 	u32 insn = le32_to_cpu(*p);
 	insn &= 0xffe0001f;
 	insn |= (val & 0xffff) << 5;
-	*p = cpu_to_le32(insn);
-}
-
-static inline void __runtime_fixup_caches(void *where, unsigned int insns)
-{
-	unsigned long va = (unsigned long)where;
-	caches_clean_inval_pou(va, va + 4*insns);
+	aarch64_insn_patch_text_nosync(p, insn);
 }
 
 static inline void __runtime_fixup_ptr(void *where, unsigned long val)
 {
-	__le32 *p = lm_alias(where);
+	__le32 *p = where;
 	__runtime_fixup_16(p, val);
 	__runtime_fixup_16(p+1, val >> 16);
 	__runtime_fixup_16(p+2, val >> 32);
 	__runtime_fixup_16(p+3, val >> 48);
-	__runtime_fixup_caches(where, 4);
 }
 
 /* Immediate value is 6 bits starting at bit #16 */
 static inline void __runtime_fixup_shift(void *where, unsigned long val)
 {
-	__le32 *p = lm_alias(where);
+	__le32 *p = where;
 	u32 insn = le32_to_cpu(*p);
 	insn &= 0xffc0ffff;
 	insn |= (val & 63) << 16;
-	*p = cpu_to_le32(insn);
-	__runtime_fixup_caches(where, 1);
+	aarch64_insn_patch_text_nosync(p, insn);
 }
 
 static inline void runtime_const_fixup(void (*fn)(void *, unsigned long),
-- 
2.53.0



