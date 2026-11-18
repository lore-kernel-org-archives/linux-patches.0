Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060128;
	b=xI6oV4Fvjy3zmPpeSMPv5Mxqy9TktOk95daItnTdTmlAzOfgXbCQSUGXjlOZcPoZXSBO
	 Qr/ogtxS5n9kZ3A+UVwSBbgGYnS+nS2uGERTr8f+oFlzpIChJCj/z86xqR3ywuFQddyYo
	 WIqp/Drpm/BgN7C9RzfBkUlhsNgAwqEwDnorkzFhifwwrX22iKHMHayco6KveKOYcbIsZ
	 bHZ7dEyUff0h7gWbTgHg+zpDZW/Yk+vKN9cEzjXQHwbCM9Fk8F4Gx58KEUqvPQHKJKQA0
	 rCX2hZ5T4t3xa5ddxq0R1IThRdvfioZ8DSfyCdqzOyXSIVexqnk5msvbloIC8mb9rbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n+KHS9yrZdS030k+TrovCC6ZBZFBT29vCKGOUK7RGro=;
	b=KvrCN3beWlk+OwzIz+LsMb3japYMcLuvKwtRuNzgwCQ9Xw55mVEbHN8tT/2zgwItpCIh
	 z6UuAb0NXWWQ2DGpkygbLgih3qpSRyMgApgSXlP/Z1jsKp6ViFN2jSeI0QZeo6xfFeUqt
	 +aPLSjcniYvfx5pCm1QzQtVJ6vOny5mf//xJzpbC6ZY2NLTSem2lLmhSO0R3WVo/6VS/I
	 mSuKVy6xA+yrfCo9cwDi0ylSR+xU6SIYb5r/5dV2nptJ9VMn4l4DJAhV7uECNOo8DL09E
	 eJeSddNKidjOcR6RUXdC2B2afCEBhUvtLIdGEwvHZ+cNEMC+dyBLlYePSg4azTaLAGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ipv/dEey";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21283606A326;
	Thu, 19 Nov 2026 03:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ipv/dEey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D6E1F000C4;
	Thu, 19 Nov 2026 03:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060128;
	bh=n+KHS9yrZdS030k+TrovCC6ZBZFBT29vCKGOUK7RGro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ipv/dEeycxJf3EeaLhubx2PoG40XJlc8KRsBvOw0BXkmTPrjPFGbgzYC3Mwkpvvqe
	 TjCKkXsGd3czzlvKwo9FUz2hn3iSkqw96DRjz+WzRWpzL3+npcN+tGHFfmcDEjRttZ
	 vdJzdLyNSthOF2Ep9T7j9kbYTFpf/1RgpqZeV2MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Wenlong <houwenlong93@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1088/1848] KVM: x86: Exit to userspace if emulation prepared a completion callback
Date: Wed, 18 Nov 2026 15:52:06 +0100
Message-ID: <20261118150004.235235871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Wenlong <houwenlong93@linux.alibaba.com>

[ Upstream commit adbfb12d4c4517a8adde23a7fc46538953d56eea ]

em_rdmsr() and em_wrmsr() return X86EMUL_IO_NEEDED if MSR accesses
required an exit to userspace. However, x86_emulate_insn() doesn't return
X86EMUL_*, so x86_emulate_instruction() doesn't directly act on
X86EMUL_IO_NEEDED; instead, it looks for other signals to differentiate
between PIO, MMIO, etc. causing RDMSR/WRMSR emulation not to
exit to userspace now.

Nevertheless, if the userspace_msr_exit_test testcase in selftests
is changed to test RDMSR/WRMSR with a forced emulation prefix,
the test passes.  What happens is that first userspace exit
information is filled but the userspace exit does not happen.
Because x86_emulate_instruction() returns 1, the guest retries
the instruction---but this time RIP has already been adjusted
past the forced emulation prefix, so the guest executes RDMSR/WRMSR
and the userspace exit finally happens.

Since the X86EMUL_IO_NEEDED path has provided a complete_userspace_io
callback, x86_emulate_instruction() can just return 0 if the
callback is not NULL. Then RDMSR/WRMSR instruction emulation will
exit to userspace directly, without the RDMSR/WRMSR vmexit.

Fixes: 1ae099540e8c7 ("KVM: x86: Allow deflecting unknown MSR accesses to user space")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <56f9df2ee5c05a81155e2be366c9dc1f7adc8817.1635842679.git.houwenlong93@linux.alibaba.com>
Stable-dep-of: ae85ac25eb67 ("KVM: x86: Conditionally resched when restarting REP string emulation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f5a6fe42d874..d7236e8467316 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7717,6 +7717,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			writeback = false;
 		r = 0;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
+	} else if (vcpu->arch.complete_userspace_io) {
+		writeback = false;
+		r = 0;
 	} else if (r == EMULATION_RESTART)
 		goto restart;
 	else
-- 
2.53.0



