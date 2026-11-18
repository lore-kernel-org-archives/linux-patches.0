Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055040;
	b=Hw5lyi9uLV3AnR07ZrVmDIf2BLvkmdYNUzqPArdrK7/7b2X20LO9Mf+Y9h0pHptZMACr
	 GKNc89FzKqeUb1SBFB3qLPyugt6toJdXdDFahHcWkf2uLJkiQDhVkKhzOx1+I9tDgjbbC
	 xoV50dsMkgUjN7plmLJmFV7fhnU27nLcrQNaYBAYweKaH7cZQ/kdhkNG3ooKzuWetE3JU
	 bHfIGHKpPJHc/Le0EtFcgWa53wCCkhLmfovUOhiWc6oCxz0vojhc/gqzMSyix7yXm4jkt
	 timGwSgP9QcYIHAlBDvUt8VOQlFUzQuOMLT8E1DPY2/CTzSqzsErRBAp9UgXjobk4cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XIPbcJk2KXWSezbc7ihVoZfWkUZpqu/Hha6d180rZNs=;
	b=A9f+mV7kXfw9WHOxLdB++Smy9xShKLNfwG7nbC2k3EOjq6fKoiBUTWktFrrSH4PXOsuQ
	 yx92GLabydHJ8zJe1LRQecjI40yD75pTFT3b5+9mrpNm4st6dvl9nFruriTY6+9kb444M
	 A0iB55c+CIqtbKbQ3KVgOpMLhC7P+MFuTQpgO7LnWO17cGnqHvkxlPmZQwwGwvgEJerXX
	 +X7fBnOewxtJPwCFyeNqJmniGcgDVC1phrS0CJ5RxCd2VQy/8ekXV+5783AlwzzKHbhIh
	 dkyPxC/hzDoDmkNpKVrnOguWK5n5ByATdzNDJyWZoo5Kdw4KeIt7eR9csmtEp/rFZMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjrtDcmf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AA2606A337;
	Thu, 19 Nov 2026 02:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjrtDcmf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72A31F000C8;
	Thu, 19 Nov 2026 02:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055040;
	bh=XIPbcJk2KXWSezbc7ihVoZfWkUZpqu/Hha6d180rZNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjrtDcmfJD7s0v915ELNAtPwbeA4gv4cXpyN00XH3rqeyAiofbGd64tGip639vhXI
	 R6K6161v+l6NO54+OSyVGS/y7vGk0ynqcdaRvk1pqyK4EIk2BUYJFzhAv9fAhvUctl
	 8pV8GMo8kUB8VSonrM2XYWRcRzvO6V1oFXGzZPAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1489/2214] x86/svm: Avoid sign extension of SVM_EVTINJ_VALID in 64-bit expressions
Date: Wed, 18 Nov 2026 15:52:45 +0100
Message-ID: <20261118150110.870823987@linuxfoundation.org>
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

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit c5991239b148d40d4981901968b3a6a838ff517b ]

SVM_EVTINJ_VALID is defined as (1 << 31), i.e. as an int with the sign
bit set. Whenever it is used in a 64-bit expression the int is sign
extended, so bits 63:32 end up set as well. Two 64-bit users are
affected.

verify_exception_info() uses the macro as a mask against a 64-bit value
when it sanity checks hypervisor supplied exception information:

	u64 info = ghcb->save.sw_exit_info_2;
	...
	if ((info & SVM_EVTINJ_VALID) &&

The mask is 0xffffffff80000000, so the check also passes when any bit of
the error code in 63:32 is set while the valid bit itself is clear.

svm_vmgexit_inject_exception() builds the value that KVM hands to an
SEV-ES guest in GHCB SW_EXITINFO2:

	u64 data = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT | vector;

For vector == X86_TRAP_GP this yields 0xffffffff8000030d instead of
0x000000008000030d. The field uses the EVENTINJ format, which holds the
error code in bits 63:32, so KVM asks the guest to inject #GP with an
error code of 0xffffffff. Linux guests only consume the error code when
SVM_EVTINJ_VALID_ERR is set, which it is not here, so they are not
affected in practice, but the value KVM writes is not the one it intends.

Use BIT() instead, as is already done for most single bit definitions in
this header. Every other user applies the macro to a u32, where the
resulting bits are unchanged.

Opportunistically give SVM_EVTINJ_VALID_ERR the same treatment, there's
zero reason to open code BIT().

Fixes: 597cfe48212a ("x86/boot/compressed/64: Setup a GHCB-based VC Exception handler")
Fixes: c3392d0ab714 ("KVM: SVM: Provide helpers to set the error code")
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Link: https://patch.msgid.link/20260908053722.3917934-1-nagachaithanya9911@gmail.com
[sean: use BIT() for SVM_EVTINJ_VALID_ERR as well]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/svm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index b00dbc5fac2b2..8c0dbd5a8e727 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -372,8 +372,8 @@ struct vmcb {
 #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
 #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
 
-#define SVM_EVTINJ_VALID (1 << 31)
-#define SVM_EVTINJ_VALID_ERR (1 << 11)
+#define SVM_EVTINJ_VALID	BIT(31)
+#define SVM_EVTINJ_VALID_ERR	BIT(11)
 
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
 #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
-- 
2.53.0



