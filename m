Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061371;
	b=rsVIaz7KidHcsdN1hdd63mG0pwwQIewNxgaepUM3tzM2G4kwc71MP2ZeKGn1oe8UQ1yr
	 5Zq3ZBhg5Gp8e0r8cluEDtyYmap3ssbUIOdNYTiZBaFftOj+O41uq8Fev4Atk6h454ikI
	 mkODWFOI5UJ1t/pWMbju0Y+hBGsrZlua+ZLYiDqAA22tIpeckDypfLvE6THy4gmRpCsX7
	 kd4ScBn0JQ/l6bROLgF/8EYxsn7hAVIlsxpZRNobgR/mdZlKss4qTI25DZlPePtGlwR4C
	 3iISGrIVdKN9rG5JEaBa6qPAhbHlCwE7KVf2eO494HWPRhh7n+TeHn+kfphJeWnxLCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sF2mJqM2ZjWjS41Tqd2zIIkSj1MXj07tCygsnjdB7xI=;
	b=OrtalBV0j9SverKrvPMabc6yyZ0enIRqpEGHVREzRLbt/vokwmtu8qj65wiEUTQq1DgA
	 73veFnB6QDG1HCjqf09LNV6iQnm5zxJhUved2kaI+xjWz/h789jcakthbGfaKCXa8orrd
	 JjhJBFjjdvMBhYnDVIq/syY67LphEbrYgQYqE9HJ5fYGH6U8iimsc8PbKXi4MHZG1OZOZ
	 FQ0RMWj1WRD808k+oEorJX28srHBg59LbYFHQ7sag6nVktvW/1vt0D/QkkshX9CjDxdrA
	 FQJrCMuU9ryT9p4PUoUIoDWAVVgj379LTY66HNPBdyUmTpgf13yl7MJ3Bn9KsBhtd4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AfxwOJvE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C086D606A332;
	Sat,  7 Nov 2026 14:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AfxwOJvE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442431F008A1;
	Sat,  7 Nov 2026 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061370;
	bh=sF2mJqM2ZjWjS41Tqd2zIIkSj1MXj07tCygsnjdB7xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfxwOJvEWQGJCcGfMb2bFvA6fV0oKSEdVWF0DIKE2vPDrSH219RkZvMiMmlq2csz5
	 KtQsWNk/omgMNLRpGgKz9vBZcdiIlCR7z4emp+MHFJeZghx5QuXrjEVPyiXEGpYbqJ
	 g/pBIVQ2zx7FVt0hr87P7kiR+S9JAHNxzow4mifA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0457/1536] KVM: x86: Always initialize EFER reserved bits on vendor initialization
Date: Sat,  7 Nov 2026 08:41:13 -0500
Message-ID: <20261107135010.364241340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Applied the EFER reserved-bits reset inline in kvm_x86_vendor_init() in x86.c, just before hardware_setup(), instead of in a new kvm_init_efer_bits() helper called from kvm_setup_efer_caps() in msrs.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23696631599ac..6c358aab53287 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -108,8 +108,7 @@ EXPORT_SYMBOL_GPL(kvm_host);
 #define emul_to_vcpu(ctxt) \
 	((struct kvm_vcpu *)(ctxt)->vcpu)
 
-/* Enable syscall by default because its emulated by KVM */
-static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
+static u64 __read_mostly efer_reserved_bits;
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
@@ -9335,6 +9334,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, kvm_host.arch_capabilities);
 
+	/* Enable syscall by default because its emulated by KVM */
+	efer_reserved_bits = ~((u64)EFER_SCE);
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		goto out_mmu_exit;
-- 
2.53.0



