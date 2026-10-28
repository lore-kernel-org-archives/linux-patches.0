Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212718;
	b=wKkBR/wcK4Vfx256YAnKGRHoOKLN4GW4IUZAL8o5nQyEFuKKvU9ARMWSyxPydgC2ZroA
	 DzrI6G3b1B9ud++YlC6tAJ/AylHxxXSBQPaGZdFYya0TJdznUkDzgQb/gRpKasmWvOv+b
	 4a7C/6AaK7rjqtMDYg8WwDf/V9BQbfvjRzmKpSxzAnf5NRXldhJH4Jd/tLbWfagqYqBNl
	 HsbDkkP4CYVjKMumw3aGlL5gDGDvx9GH07xDFl4jbDlB4H0dPnwAmBPkK66/d5QILy/iA
	 HXHDTs2uGSORHgFY3e9mnTIptLKV/1AGl+FaKX7ysD3ZsRQG1xv9BEaFPrUfxIb5r7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFsNsc1fkN3iC73+nfkkCAK4c3KIpluM2YwDiMR9wII=;
	b=NzDmXHhFeRX2lTOJboOWpc9P1H6e3HxCdgWn18e5Zs1Dn3rez9K/I3if9dZzC0MlzU8u
	 3cXPROzFphmaG2kai/I8gMRPFhydUFuQZxx9VQTdCMYjpaEBFnfbMtzcCiY4bIBfw+Ryc
	 0Vr3qnS7fCpUBaLsa/aPSabRXmMEDp116hXTLVviNzUeeBsuRq7B24CBw2IYwqGRgvrrt
	 50QP0XjrSZATBRvMSFsO/8WGGyfoVJc8RgFSIOnDtOEdXj2dofHTWPX4HZA6aWyWe0OVD
	 jZXzOn9gEO6XDl3thikS7b5KXQMZQRUn1NCC2Np/d595cUxUHlTD+Lx3UEOGJDQ5N7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flFkPD4k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AAB60A2605;
	Wed, 28 Oct 2026 18:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flFkPD4k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E12D1F01825;
	Wed, 28 Oct 2026 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212717;
	bh=eFsNsc1fkN3iC73+nfkkCAK4c3KIpluM2YwDiMR9wII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flFkPD4kt6obeBtgJ/8XMYmnNxmjlLBZsvBCB/w3l76hTSwcBoJ8A8ZdZAFZiQ507
	 XUxooB6kz3pmWssU+zjazJvvVT3p2NugEFu5D6liCke/frIFllSA0YMGqqgMFt6yAI
	 Mwl+rLI32g1WgPOdsNqQKCpViDJ6S1B4GR3B9uyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0208/1887] perf/x86/amd/lbr: Fix kernel address leakage
Date: Wed, 28 Oct 2026 17:38:24 +0100
Message-ID: <20261028170503.968349096@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 2a892294b83f541115c94b0bb637f39bef187657 ]

A user-only branch stack can contain branches that originate from
the kernel. As a result, kernel addresses are exposed to user space
even when PERF_SAMPLE_BRANCH_USER is requested. On AMD processors
supporting X86_FEATURE_AMD_LBR_V2, perf can still report SYSRET/ERET
entries for which the branch-from addresses are in the kernel.

E.g.

  $ perf record -e cycles -o - -j any,save_type,u -- \
        perf bench syscall basic --loop 1000 | \
        perf script -i - -F brstack|tr ' ' '\n'| \
        grep -E '0x[89a-f][0-9a-f]{15}'

  ...
  0xffffffff81001268/0x717a90a38f1a/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a39157/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a2c628/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a41b60/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a260db/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a260db/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a8bef1c30/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a8e4d3c90/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  ...

The reason is that the hardware filter only considers the privilege
level applicable to the branch target. Extend software filtering to
also validate the branch-from addresses against br_sel, so that any
branch record whose branch-from address is in the kernel is dropped
when PERF_SAMPLE_BRANCH_USER is requested.

Fixes: f4f925dae741 ("perf/x86/amd/lbr: Add LbrExtV2 hardware branch filter support")
Reported-by: Ian Rogers <irogers@google.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://patch.msgid.link/a898a29725f6b2f30518354cdc2e432db66c43cf.1783680119.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/lbr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/lbr.c b/arch/x86/events/amd/lbr.c
index 48f4095f500d4..6096fb6925f66 100644
--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -124,7 +124,8 @@ static void amd_pmu_lbr_filter(void)
 		}
 
 		/* If type does not correspond, then discard */
-		if (type == X86_BR_NONE || (br_sel & type) != type) {
+		if (type == X86_BR_NONE || (br_sel & type) != type ||
+		    (!(br_sel & X86_BR_KERNEL) && kernel_ip(cpuc->lbr_entries[i].from))) {
 			cpuc->lbr_entries[i].from = 0;	/* mark invalid */
 			compress = true;
 		}
-- 
2.53.0



