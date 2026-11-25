Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621719;
	b=ui59w31PcUS9hgh6mKJOCV3Vb495/wCH7XGwMZ4Ur6IlVmdIHP1FBq28rHfShtquIITK
	 /cWj2cHC1uin84WApEWtKYUsahvpSlB5fUOliQVYSx4E0EXpn1S1eVwZhL5j2IDephlvP
	 YJKY2dZbvQlXPaM00mGemMofoyCYYBptna94PMGVzR1UllILBKfWmM0C9hvJCEy5Li7//
	 ZBvXFCaxAZyr+gGYTBQeVOV+4dTLbyaWbVeYeXZA7FJICk/vx3qeSok8h+JwBbJIIJRq1
	 bq0QDFQl1hDtiIlHsCR3do0Wl3wI8+LmGSCw7sRX++Lv2+3D+EkhggvGv/bxY61BVGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GLfo6Y8B6mJlsnQwfPVT6MDhrpSBqknviga8Z/SluNI=;
	b=gWc8hpo+lnXc76GQbO1xBuB7nqkalWmj+TJIF/DyV1xw9fg7U3qlWFNKnw5UtUljOE7y
	 qgz/kiZEyLoKssVRI4b4tObI1xpwy0xlVk18vRwDFUi4ancOUtP0Mqkk6b3UPWKK3iqrX
	 M8oHXNWLgr87moiPMy950p9lzYzxFHI8PBp0H343CCMEYsxuVTEf1VJVwJN3jFKu3hH/O
	 V9EoDltdSLlK1ht9w0SBHPuj/aHzWIMnBjrWJsFGbxYFudKCxONNkCMHtIBrKEdL3oyr9
	 1dhmYNHhFeWaBAIeSm7BiVYVvZZ//7XU8/uOWo20ovjfKLVvZz//886lnC4F7vFlrJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uyd3r7+Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F98606A32A;
	Wed, 25 Nov 2026 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uyd3r7+Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011931F000C4;
	Wed, 25 Nov 2026 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621719;
	bh=GLfo6Y8B6mJlsnQwfPVT6MDhrpSBqknviga8Z/SluNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uyd3r7+YtE/0UJVov7oa+mu52fMFBfTgMGVe82HUKSU6fkqX8t5CXu51uMxrEI/a1
	 0PBjTlEKUvS3zhKgPo2eNwu3bXBbx5TdjSt+z+oIux73zqaDvp0whosnEtCn9vU5xD
	 ECTHSYA+E3nesSEVbI/BrTqWfhrgWAjaBLBi0YyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridge Lomont <cyridge@proton.me>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 316/990] x86/kcfi: Dont emit KCFI_REFERENCE() in modules
Date: Wed, 25 Nov 2026 15:28:03 +0100
Message-ID: <20261125143829.493198717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 5b45ea7dff3e5..2911b9e622929 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -248,10 +248,13 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 
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



