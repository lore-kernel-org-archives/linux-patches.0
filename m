Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618673;
	b=DnemN0/lNRUKCBglKphx+60CAw2f0fngLm49/j3wTobs84omdDbJGiFdbD8l31y9dn81
	 HdZXlHsp9SnEkKOJMD9aeYdaKYnmL4Tiz2VujEUF8VpGOTcde8Hgz2yCqrEP8PKiLo+iz
	 9Q+XpNQwCMAvU2SBtGJRjkJpKbz3869bKtUnwIT5VrNjVhcINebnHa9824Y/UYCPu6usE
	 ib3JDIB+d9g1kklIKaTEwAJk+Rr+eJ+37ojlxmMeNHYZeXAaMNs2nj9768BCw/qjqT/5f
	 wV39/pf1HL3HnKjCRKLEI6D0oofo5Di2JZq+ndMq1j+DUKhqhh3E8IS0qSfdcOi3kPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wrMpJx/6zygWLsEing4O/dDUcPXAaJ86EG06ua+MMkU=;
	b=ylG5lKL47MMFrbvPbdKyX6pKWHsJg7d10AW8F1RoGD9sqVzLsmSEZO25gGaEoQRCU1Sx
	 JS166/FWP09EiTQExBuzcj8+jtY5/v32Azor0WVyZXCrnp/h7NkXw3r83YnvEWmj9JPYt
	 lzqP32NKgBwg06tp/KcKUnpD41lxM/QOqrOSnVCZkzQu8Wn/iUbExLUKcCw4kFmjMPvy5
	 qzXmW9/WHx9M+v3JEQH+6KHXn1S1rQNwCtvSxzgQvwX2YwnPA67h3qAHrNSIM1CxDH0ma
	 bUUt+ZhK6X99AjiCc2vM531VgzaKK2GME4AnRe4Sd0cNSlw3Dr/Rwopt57vVRC2x8UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBmF74Hm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A9B606A323;
	Wed, 25 Nov 2026 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBmF74Hm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C40D1F000C4;
	Wed, 25 Nov 2026 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618672;
	bh=wrMpJx/6zygWLsEing4O/dDUcPXAaJ86EG06ua+MMkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBmF74Hm/dpjGY16P2DSYfD7rgDfJHCkMswHKX6Rhy2HyJ8MX6z+FSoSCMI05B3+7
	 zEZNL+QrPaqaa7UpCrGvgUHN2vz2rSNbN+ykIqxvBADFDLuydkj8DBSpu2vVGrSHzJ
	 BQfib4iKG22e20SGGA5U8qgBUPf7cHo1GzypGGQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridge Lomont <cyridge@proton.me>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0351/1005] x86/kcfi: Dont emit KCFI_REFERENCE() in modules
Date: Wed, 25 Nov 2026 15:28:09 +0100
Message-ID: <20261125143829.955163072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Ridge Lomont <cyridge@proton.me>

[ Upstream commit fb685de78e6bf79e49854e7d149f69b125583de5 ]

KCFI_REFERENCE() takes the address of a symbol so that the compiler
emits its __kcfi_typeid_ symbol, which the SYM_TYPED_FUNC_START()
assembly implementing it needs. It is used from arch/x86 headers for
__clear_pages_unrolled(), copy_page(), __memset() and __memmove(), and
all of that assembly is built into vmlinux.

Modules include the same headers, so with CONFIG_CFI=y every module
also gets an __ADDRESSABLE() reference to each of these symbols in
.discard.addressable. This serves no purpose there, and since
__clear_pages_unrolled() is EXPORT_SYMBOL_GPL, modpost now rejects any
GPL-incompatible module that includes <linux/mm.h>:

  ERROR: modpost: GPL-incompatible module repro.ko uses GPL-only
  symbol '__clear_pages_unrolled'

even though the module never uses the symbol. This makes OpenZFS
impossible to build against CFI kernels; its configure checks fail
in the same way and are misreported as CONFIG_DEBUG_LOCK_ALLOC.

scripts/module.lds.S does not help here: modpost checks <module>.o
before the final link, and even after it the discarded section only
loses its relocations, the undefined symbols stay in .symtab, where
the module loader resolves them with the same license check.

Only emit the reference when building vmlinux.

Tested on x86_64 with clang 23.1.3 and CONFIG_CFI=y, with both
CONFIG_LTO_CLANG_FULL=y (the configuration from the Fixes: commit) and
CONFIG_LTO_CLANG_THIN=y: vmlinux links without warnings and still contains
__kcfi_typeid___clear_pages_unrolled, __kcfi_typeid_copy_page,
__kcfi_typeid___memset and __kcfi_typeid___memmove. It boots in QEMU
with no CFI failures. A minimal module with MODULE_LICENSE("Proprietary")
including <linux/mm.h> fails modpost before this change and builds and
loads after it. OpenZFS builds against a CFI kernel with this change,
and its pool, encryption, checksum and send/recv operations run
without CFI failures, in QEMU and on a desktop with CFI enforcing.

Fixes: 9b041a4b66b3 ("x86/mm: Ensure clear_page() variants always have __kcfi_typeid_ symbols")
Assisted-by: LLM
Signed-off-by: Ridge Lomont <cyridge@proton.me>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Link: https://github.com/openzfs/zfs/issues/18092
Link: https://patch.msgid.link/20261027-kcfi-reference-modules-v2-1-3a3247f15806@proton.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index cb2f6050bdf7d..a7e57ffb6126d 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -241,10 +241,13 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 
 #endif /* __KERNEL__ */
 
-#if defined(CONFIG_CFI) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#if defined(CONFIG_CFI) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO) && \
+	!defined(MODULE)
 /*
  * Force a reference to the external symbol so the compiler generates
- * __kcfi_typid.
+ * __kcfi_typid. Only vmlinux needs it, as that is where the assembly
+ * using the typeid lives; in a module it would only add a reference to
+ * the symbol, which fails modpost if the symbol is GPL-only.
  */
 #define KCFI_REFERENCE(sym) __ADDRESSABLE(sym)
 #else
-- 
2.53.0



