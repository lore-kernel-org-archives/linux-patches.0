Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016862;
	b=ph+rzwt4e+x2ap0kCNB/LIxxYtcUJiOnDxPJtF/ECPyhLP3Nq3Z3FFqiMDCjcosCrMeB
	 jU53yOHlgG3y66S+nVc20yVHTtppf2l90kM4h15VUOmPyKnWar9LJtKIXDPgB9ed7EUms
	 Uaj2XQlRQUjt/FmE9sAYzKGe103Mn6WXiY8rUdGceVUhbJgPsNvpzgq9hGq3Afgwl+uVm
	 6JbHXmDbb7gLM4wAmmLswpwCbwa/lZxg6jUsED4/k4Tudys+oGRF18fHusGjORY7mRT8r
	 lfhnBwx1Yecvoumn7JhizGLs/MuPsOA+bIz6ovg2RVTrDBqxasxH2RavI+doY0xHFcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/LSRx2v9N76BJjWOYQrPYWzPGcSnHvx/IS+3bv18RjE=;
	b=NAZDwOyNTtFrXac3jIqlrrrahRNiG7GWPe6T+uC+k8OvJCCe3mRQN9fc9kFTJr6bwBLq
	 /TIajFyx+QNc0BF0X51yRpFK0eYWzeafBSFg0mB58+19an6RdZG2P1O1hOfGD36tm0AmO
	 zHr51Shd53UyEd84ond5AOlpnL2kG5Y0ECmbBRjF2ia/47nsGRWFdRq2PC80fsDcTCEYw
	 fZEdHFG8DxiGBHgRLFhJRJfKnkLkyNZnW8INC8yliqbr4hr1rA/UD22maLHcA0pT/ovLO
	 MG+2PRRYG4gw7Q6dmzgHwSH0KrO9dEZG9m2KD7mXwM8XbXcUSCJQgy6Q3mjFZbQsksA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2UbE8bd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD68606A337;
	Wed, 18 Nov 2026 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2UbE8bd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518641F000C4;
	Wed, 18 Nov 2026 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016861;
	bh=/LSRx2v9N76BJjWOYQrPYWzPGcSnHvx/IS+3bv18RjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2UbE8bdm+aL8dt1REjFMZn3n+J+IBoc2Ag/z5vOU8OEv0zInHgupvAMet0QAQVH3
	 ESFfGKDyUx0R7MQDFdHwH53EGOiZbygkVBFBPSI/JLCo5iBD8Rj6DGnN5YNBjAU3yj
	 /llYSRlE/0JKmQuxOJ+96Qa8fwQw7ga6ByJg0ha4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0678/2651] x86/pvh: Really inline memcmp() and memset() to fix unbootable VMs
Date: Wed, 18 Nov 2026 15:31:58 +0100
Message-ID: <20261118150312.277935641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit b24bc9dec9c89d01ccb675a55cda6831dc048ce9 ]

Even with __builtin the compiler may decide to use the out of line function
instead of the inline implementation.

The existing code is broken with gcc-14/15 but not gcc-12/13 (Ubuntu 25.10)
and vmlinux no longer boots with CONFIG_PVH if CONFIG_KASAN_GENERIC is set.
The instrumented out of line function performs a memory access to a region not
yet initialized by KASAN, as it is still in the PVH kernel entry point.

For testing purposes, if the size argument in cpuid_base_hypervisor() is
reduced from 12 to 8 the compiler decides to use the inline implementation.
In xen_prepare_pvh(), it (still) decides to use the inline implementation
(at least in these compiler versions), but it is not guaranteed to remain.

Switch the builtin to the inline implementation to address this.

  [ bp: Massage commit message. ]

Fixes: 416a33c9afce ("x86/cpu: fix unbootable VMs by inlining memcmp() in hypervisor_cpuid_base()")
Fixes: fbe5a6dfe492 ("xen, pvh: fix unbootable VMs by inlining memset() in xen_prepare_pvh()")
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260921-pvh-kasan-inline-v10-4-08da47943d8e@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpuid/api.h  | 2 +-
 arch/x86/platform/pvh/enlighten.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpuid/api.h b/arch/x86/include/asm/cpuid/api.h
index 25b22b173f2a7..759b12d94bbfe 100644
--- a/arch/x86/include/asm/cpuid/api.h
+++ b/arch/x86/include/asm/cpuid/api.h
@@ -205,7 +205,7 @@ static inline u32 cpuid_base_hypervisor(const char *sig, u32 leaves)
 		 * from PVH early boot code before instrumentation is set up
 		 * and memcmp() itself may be instrumented.
 		 */
-		if (!__builtin_memcmp(sig, signature, 12) &&
+		if (!__inline_memcmp(sig, signature, 12) &&
 		    (leaves == 0 || ((eax - base) >= leaves)))
 			return base;
 	}
diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index f2053cbe9b0ce..cb442cbd9d828 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -8,6 +8,7 @@
 #include <asm/hypervisor.h>
 #include <asm/e820/api.h>
 #include <asm/x86_init.h>
+#include <asm/string.h>
 
 #include <asm/xen/interface.h>
 
@@ -129,7 +130,7 @@ void __init xen_prepare_pvh(void)
 	 * This must not compile to "call memset" because memset() may be
 	 * instrumented.
 	 */
-	__builtin_memset(&pvh_bootparams, 0, sizeof(pvh_bootparams));
+	__inline_memset(&pvh_bootparams, 0, sizeof(pvh_bootparams));
 
 	hypervisor_specific_init(xen_guest);
 
-- 
2.53.0



