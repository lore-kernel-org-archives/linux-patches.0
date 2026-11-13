Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586014;
	b=Mf8iDV/AecSKAEXu88DAsfd5K7l8ba5t8c1iSJYl/n2TfBbFHTbQQtW9YjkhWPy21zzN
	 0jRKyx8/BlKwGX+YizMDnd3xULiDMcf0hrnu6FUCXmh42CulERp+EFfTclOZdBqFYJGaq
	 JtaA8+/8LoNnpS2ZhMwa5XI6CCF8Havwe2Y49zQ3ociqjzKHnOdGuo+XtUGmOfO7rX7my
	 ozM0WlE84r+k9gR4iMPNroKi5COAiEWPQDaq1mhPxDWiqCyOIOGAj1Z8uYXfBXi8YHOod
	 IbJXx8NLrH1Pm2CmuhVE8Zc8JC+4VjVYuTGDxTBILe7phGviezAryyg20d4aY04dEYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yh2KO75Sh8AsnuvRevhxcgRCEAtWlvRgw5lYXFRRkyE=;
	b=jPztWet73S6wJkMtFEby+87GX2vnokDe/OwJpwbPUuVho1qUqaxLm5a/ul7CN7MI+aYj
	 FsLNqVC0FAfMdX5wKRqX4Psce9a/qlf9eCOVLAmcSyGQvA1rkL567H3Hvzziv/z3PpcAw
	 zxMzdb5ZMzrLU7T9//u9nBmHiB6Kn0mkGjJsB5kaGXdhpujvdeoecEX5HSjyTXwoEMEnF
	 mE0qGhx6tjMCeuGm6yzLIbn1OMIq7wjCLw4yie6S2dyhnd2IzKCjlMJPEllFNmr+EWSs+
	 b/XwVWFDnlkz0ePdkK6POXKzt4acODa1sxdN5yiR/1Ad18pubC44fwc6oJkFG+ccKuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkCn1Z9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B33606B2C0;
	Fri, 13 Nov 2026 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkCn1Z9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712BF1F000C4;
	Fri, 13 Nov 2026 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586014;
	bh=Yh2KO75Sh8AsnuvRevhxcgRCEAtWlvRgw5lYXFRRkyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkCn1Z9UOHuKlxYzDu2ZKfalmosNSmxUgACIqsvdTgiWIwdYjOUH2z7H0Rkjt9INo
	 a3wwXwlsoUrDDtkdihAxDygUjhuClTEjLkQs6a4ti1T63fbXOU9tQ0FdGsILqCyQvG
	 yCrFIn3nSVUgVDJ76iOMKtXWRDra+VlcACq4eUYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/686] KVM: TDX: Stuff exit_reason with UNDEFINED on wait_for_sept_zap return
Date: Fri, 13 Nov 2026 10:43:07 -0500
Message-ID: <20261113153822.792088749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit e5f1d62c59aea4f270773de1bf6e8867f5b1124c ]

Forcefully update the exit_reason to KVM's "standard" EXIT_REASON_UNDEFINED
if tdx_vcpu_run() bails without trying to run the vCPU because KVM needs to
wait for an in-progress S-EPT zap to complete.  This avoids handling the
previous exit multiple times due to a stale exit_reason.

Fixes: 4b2abc49712b ("KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-6-xiaoyao.li@intel.com
[sean: use EXIT_REASON_UNDEFINED, drop comment about bits 31:16]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/tdx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dcbfcd79791c8..02a15ad90c586 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1041,8 +1041,16 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	 * allowing vCPU entry to avoid contention with tdh_vp_enter() and
 	 * TDCALLs.
 	 */
-	if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
+	if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap))) {
+		/*
+		 * The vCPU never entered the guest, but this looks like a
+		 * handled exit to the caller.  Synthesize an invalid exit
+		 * reason so the previous exit's stale value isn't consumed
+		 * a second time.
+		 */
+		vt->exit_reason.full = EXIT_REASON_UNDEFINED;
 		return EXIT_FASTPATH_EXIT_HANDLED;
+	}
 
 	trace_kvm_entry(vcpu, run_flags & KVM_RUN_FORCE_IMMEDIATE_EXIT);
 
-- 
2.53.0



