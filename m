Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061418;
	b=MPNe+sZ5bD66NIsCTqd5/kqnOeBHIVrxXAIP05ycBxoxF3kzB4QQOOHBpQ7O7/UITbg2
	 nNEeSezx6Lj8T/UoAtbn7/v+f12qs0zyOxyICmW50EZ1A1Bc297tu5lCHVfN3Wq/px9le
	 TuL3NCc+LrvvkdJZvmJyhFSlZY/DVqMJ+Epd5e/Ev4p7aKO8sGyWsL5nSD6lcDmIwNK5X
	 5tPYmzaG9jUt5e3w8QYuhxXaDn2N4Q8UF0AyFtfmqnMThtj0Tr+LVaod/uh063mQZDwjG
	 /zCgELIfXINQ6PT7WlO1InriCFcxesIrHxuvWK/WoK3dFvOQY186020wMVaLDcBfcHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GKGeXhp8lnVXEuZLbT8sFiYVp5BvFWNIhU38C87sGvg=;
	b=FXCAlOIONxB2kZODE0XcFYLZL7MNywlLJ2a8fgAt1Idt5En5dnacUMT0A0AVTz8t/z+A
	 9laLLuglF/SGyFnM312B+sV+8VfClkYAbNyl1050+q7NgngW0xd8cm4ZrEbpkJWB2DLkV
	 dtpB4Hbg/q80w+YYAdEucvUrVBoEYf0ysHGPb6zK9J2xjGCULqmLJbs5VlDeRRbGIQHYa
	 KubIPlk9u5WnIJjb1PNX+ydCh1W+LJd0Car0RKp9t8BhOZHdZ2vTeip+pVEQ1rA790lq2
	 3phTcNXHd7Q1JU0eaN2ky9RAK0XmHbfDcMebksXrx/wMB6ewXyEHs96mz6Vf/wtJbcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tp8OL9Us;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD99606A326;
	Sat,  7 Nov 2026 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tp8OL9Us
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1441A1F0089F;
	Sat,  7 Nov 2026 14:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061418;
	bh=GKGeXhp8lnVXEuZLbT8sFiYVp5BvFWNIhU38C87sGvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tp8OL9UsL2273t9U/7abJTM6YF9xk5ilJY62XkBuQx6WsaEnGej0gpWQTdvt0i294
	 gY/lBPf/AoMK/mNpD+fR7Om9Qge6ftj9jFdK4i5aQ94Age0I0azUbIRgI0Qw3c8q/M
	 U9brAfEBzVPlfVR2Ls59OVe+hyUMqp42qmfWNBAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwoo Lee <rkskek9254@gmail.com>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0530/1536] KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails
Date: Sat,  7 Nov 2026 08:42:26 -0500
Message-ID: <20261107135012.502425120@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 10180a277549339020b08000206092c07e0bff5a ]

Re-pend GET_NESTED_STATE_PAGES before exiting to userspace if getting the
nested pages fails in the KVM_RUN path.  If userspace re-runs the vCPU, and
vmcs02 holds valid PFNs from the *previous* run of L2, then KVM could
re-enter L2 with stale, unpinned PFNs mapped into e.g. the vAPIC page.

Note, both SVM and VMX (as of commit 11722439fb20 ("KVM: nVMX: Ensure
KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit") ensure the request
is cleared on VM-Exit (including the "forced" case), i.e. there is no risk
of double-mapping due to emulated VMLAUNCH/VMRESUME/VMRUN *and* the request
trying to map the nested pages.

Fixes: 671ddc700fd0 ("KVM: nVMX: Don't leak L1 MMIO regions to L2")
Cc: stable@vger.kernel.org
Reported-by: Jinwoo Lee <rkskek9254@gmail.com>
Closes: https://lore.kernel.org/all/20260813043932.3214460-1-rkskek9254@gmail.com
Reported-by: Stefan Teodorescu <fane@google.com>
Link: https://patch.msgid.link/20260921211608.1030158-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Replaced the kvm_nested_call(get_nested_state_pages)(vcpu) context line with a direct kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu) call, since the wrapper doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c358aab53287..0e7fac0012605 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10300,6 +10300,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+				kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 				r = 0;
 				goto out;
 			}
-- 
2.53.0



