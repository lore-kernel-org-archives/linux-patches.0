Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034515;
	b=3nI0341wn/84Ej5zUXWpXXKX8M4OoG2Sig6cdehljDh/7w2yy3IRvfdWZ7I5DPbRs7Pq
	 IZfJdJiBzDl1Z9UAtpPzEMhfodITrZGqAjKA3NcMGnarq7bcDZVgIoUTR3zCuC8G7rkMJ
	 ZTOJk6f/0PscvURmVUWPJGdJOhYZMdfywVSnO78LqVyzTiuwHjg+Xg/k21zWyRS6Mnm9g
	 DqRycOW6bBjThKxVzKNsptjqwgECUzdbAIomjNxeNC7YS9qSQL+feLo36efbwYddfxwBh
	 mDSMaIABJMDo26iKwdRj9Xfnr0GDiLBamynyY3FAJwpvALOFmM3YVn0S3Efgo0Pa+fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8jG42LDOA3zsEd8WDA5vEGF0K0777pfDhS2P7rdQ2kY=;
	b=BJBly6MGIAHVZv53o91au6Cljx3RVRwJ5bQIPmM+/Qb1d7n0X+As41+2VJUUEvxtKuA/
	 J0ljoo1293XyEWt8Dg+lO6p/QerP7yd/gGbKkHkNIUlNCfRUrUjjL5Hf5YA/n32XY1zq+
	 eLohnA4Cfdqsjn0vKCbEyS0olByRd2UX8lRxnLDxZhJL58mTYr1oJMjt0PDCc8X9tE3BL
	 n8ksbp7tnr0hY7dqO/nDMdfcBgn6dF0n1hrn78ApwP2y2lta5WOxb7cgUh6RD8h2PUkGz
	 TyCvsH5hCeXc/TiWI0Td1Kg1bsEKBEr8S1v7/zbWTfYPEk83y7CGX8e91TtiBbepyTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VcKU/bX7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D9606A31C;
	Wed, 18 Nov 2026 20:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VcKU/bX7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264471F000C4;
	Wed, 18 Nov 2026 20:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034515;
	bh=8jG42LDOA3zsEd8WDA5vEGF0K0777pfDhS2P7rdQ2kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcKU/bX7Fk6gs+T6OOivfL6gpBM5PiHB8MwXnMSYiC8Tj16wvhsEkehl6fWzNsSio
	 drzA6TGvDlZ5FNutxMOtaq/SG6HBUGWyRQyG5W57uYT/x/XxhO9PzP/nRUj0ifTATV
	 XYedqFwAAAl9BwZ9PByMiTNeDPTxVq2bC/rbu8fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0380/3318] KVM: x86: Always initialize EFER reserved bits on vendor initialization
Date: Wed, 18 Nov 2026 15:16:42 +0100
Message-ID: <20261118150327.657678541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit a4b8acd428ba3f03952ef309d7f438dbc357557b ]

EFER reserved bits are statically initialized, and do not reset if a
vendor module is re-loaded. For example, loading kvm_amd with nested=1
removes EFER.SVME (and potentially EFER.LMSLE) from the reserved bits.
Reloading kvm_amd with nested=0 does not add them back, allowing
userspace to set EFER.SVME with nested=0.

Re-initializing EFER reserved bits before configuring them on vendor
initialization.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713181020.2735367-4-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Inlined the EFER reserved-bits reset in __kvm_x86_vendor_init() before hardware_setup(), using IS_ENABLED(CONFIG_X86_64) for LME/LMA, since msrs.c and kvm_setup_efer_caps() don't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb659d04d07ee..24a19d5d68219 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -102,16 +102,7 @@ EXPORT_SYMBOL_GPL(kvm_caps);
 #define emul_to_vcpu(ctxt) \
 	((struct kvm_vcpu *)(ctxt)->vcpu)
 
-/* EFER defaults:
- * - enable syscall per default because its emulated by KVM
- * - enable LME and LMA per default on 64 bit KVM
- */
-#ifdef CONFIG_X86_64
-static
-u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
-#else
-static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
-#endif
+static u64 __read_mostly efer_reserved_bits;
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
@@ -9606,6 +9597,15 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, host_arch_capabilities);
 
+	/*
+	 * EFER defaults, re-initialized on every vendor load:
+	 * - enable syscall per default because its emulated by KVM
+	 * - enable LME and LMA per default on 64 bit KVM
+	 */
+	efer_reserved_bits = ~((u64)EFER_SCE);
+	if (IS_ENABLED(CONFIG_X86_64))
+		efer_reserved_bits &= ~((u64)(EFER_LME | EFER_LMA));
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		goto out_mmu_exit;
-- 
2.53.0



