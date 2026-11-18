Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044105;
	b=r48WXsCqA+bNZcC/a5Lrw6QBVDc7wtaD0o4/8c0yZkdu+Sd5rxS5IlDVJwu1o1ofxdvp
	 mX1BpXyHbMlMYSGX3TdfR7GsbCMQ+WlnozlI+w11ZXSdW5H8ivIfWydCmdbj2PTjBpG4A
	 bSGsEBn3WKk7xplKPFXEw1YimpYHK9P7uHuJS/dJs4jN51532Aa0iTIl0Lj/d/lC7YBoQ
	 SUQHP9wiMyIl3KU7HxDd0DC9GDQ7FNvFGrs7qlj9GfkPrHRw03e3pIkpt35MdWxDB3lu9
	 QABV1bc0KPB8cdRKofB5cX+DIaM541GAwzXe/ceU4+MR3g4pUlHkqV5MvteMvPDaw8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ANLGcI6t5gpZPcDlSt9yH3QhhBfgItTZgmpyVRHJLY=;
	b=KBpbDvXd2UH1/BDRcT6JEYIwWIScVH109kwPq0SoN0bZZ8IgAoGFGByXqfkBXb5ee+tb
	 fyhLaYIVb5yyqr2I73TVCM7/tRMmoBr2oN52pJ/sm86FJ/sXX+JKzdd3uILhKJBKvjKXV
	 K0i+OVCNhJnZ9VGfvZE/nbqIm4TEmH7zZ7ndI0u+vy92WgK/2aJ6JNhMRocHjwth9BZkK
	 ai/mwHvZydS3fyAEYy2CFmx/BXaBLhgdWioS26l97auYRRUip9WUHuGPRb51oPbqscegn
	 k7FsEnLqn8HN5Zo6aLj+lz3Cw85I+DVQTuh//LB/3AD+NtKNLHbxeB37+4lmzZeuFdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL3lOb2W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A8B606A325;
	Wed, 18 Nov 2026 23:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL3lOb2W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026E21F000C4;
	Wed, 18 Nov 2026 23:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044105;
	bh=1ANLGcI6t5gpZPcDlSt9yH3QhhBfgItTZgmpyVRHJLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PL3lOb2W/xlGW5r5RfAxIG3ILdis5njxFXIR/2b4uy3j/0OtDL1OSBWfXgQWAqa7f
	 nNhl+cewhanwaWp3+U/mCB3HVb0DxBtRP+9n8SzeBBonpYEc4eTnLZuE4l8cCyXVsu
	 8d0I0iv4V5jUcxKHrprY9jwcdyS2alwQwAVpsgS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwoo Lee <rkskek9254@gmail.com>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0448/2857] KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails
Date: Wed, 18 Nov 2026 15:24:42 +0100
Message-ID: <20261118150217.508435216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
[ sashal: Adjusted context: the call is kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu) instead of the kvm_nested_call() wrapper, with the same added kvm_make_request() line. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db710ae4848d8..1eb49a6b33497 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10655,6 +10655,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+				kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 				r = 0;
 				goto out;
 			}
-- 
2.53.0



