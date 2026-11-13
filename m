Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586016;
	b=twl3A7fLto/+l+srzY6/ynHYHg2XCF+HNgNYUHnqXv85+Xrl6+xVW0odmIzsvRRK0y59
	 891ZGrQzqG8XTGTIVzDlnxgY+WXZODgjw+w8w08ioI3Z9YSFFRcQjKVHlK9huF6yewzfJ
	 gam+Bq8gr8hfdVqq07pQnJI7qUkVnXInnWmcHRVhuwQ7IxCbYTaI19oBp/FxuTIz1FTdy
	 ySIj1FCjWuaKzoF4bU3fZzsJSBW9It1Drsgu+utD+MM/dz0/6EucLHv/6k6bG9gAHcj05
	 6TPkN0KLyWRiBsbXBOTxmTf0Bo756ThwxcLdGMKqFEFTxIjZNc36aLZwXIx7a5U4kow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D0QstuQHuu0YPeEE9u5+8DDRi1o3Ds74h1iFKEB0cwA=;
	b=gDELcxMeRYTiz5EeYe5lt05ME8XldrFeCYhrU6lK8VM2fssYufjN1HNV3VYm7ajtusoZ
	 OP0uL8H9iBl7R0e4tjmbA40NSTIFAlCgKSS1NZmMnoRWelujYoDkbB2+yrLCxT4pytJre
	 v8xK/TX7tnchXZ6JZrF1kL6E9MKWSlm4jfuBSpl0+XtGmzLqphp+M3QArMJxkPP2IFLh2
	 ptFHqIHSpT+r9Dm/WzzcFe1xUEg39WNhaqokvqhrw+gYChaj8n6q9vnIZ9g+5QYt6vZNV
	 1PrkjHl7m6BF/azRuM0bZIJWG0d4B7jbW3cWFG5z8tn0zIQgUJOfyKDjXqtEs7FScFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vq0oG8qF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0738C606B2D3;
	Fri, 13 Nov 2026 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vq0oG8qF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FA31F000C4;
	Fri, 13 Nov 2026 16:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586015;
	bh=D0QstuQHuu0YPeEE9u5+8DDRi1o3Ds74h1iFKEB0cwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vq0oG8qFK8wpA1ZL1utOOgrcR/r3r22c8ortLZlVzrNgWnq1okOJ3R3jF4UPK53zz
	 TA4FVitH8TJ6uyLGSKlljEYK2xwzrRt5ZQtLhT4f3YqJ7TU2xe6/CjuEFBhdSED8In
	 7aQQmLxu/mycWsalHoNj/07Sc3SiWY6LwoKACYao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/686] KVM: TDX: Set bits 31:16 to 0 and use UNDEFINED when synthesizing exit reason
Date: Fri, 13 Nov 2026 10:43:08 -0500
Message-ID: <20261113153822.820115879@linuxfoundation.org>
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

[ Upstream commit b43c520b198ab70868307a489ef2117ed6d6c4cc ]

Set bits 31:16 to 0 instead of all-1s when synthesizing an exit reason,
e.g. if the TDX Module never attempted VM-Enter, or when stuffing the exit
reason due to an unexpected "real" EPT Misconfig.  Opportunistically use
VMX's KVM-defined EXIT_REASON_UNDEFINED (0xdead) instead of -1u.

KVM is going to support Bus Lock VM exit for TDX, after which bit 26 of
the Exit Reason becomes meaningful and indicates that a bus lock happened.
The existing synthesized Exit Reason, -1u, will cause a false positive in
that case.  Change the synthesized Exit Reason from -1u to U16_MAX, so that
bits 31:16 are set to 0.  This also avoids the potential issues when other
bits in 31:16 become valid in the future.

As a bonus, the check for synthesized Exit Reason in tdx_failed_vmentry()
becomes unnecessary.  Just drop it.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-4-xiaoyao.li@intel.com
[sean: use EXIT_REASON_UNDEFINED instead of another magic value]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/tdx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 02a15ad90c586..411291603681f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -904,8 +904,13 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u32 exit_reason;
 
+	/*
+	 * Return the synthesized invalid Exit Reason, as the TDX module
+	 * never attempted to run the vCPU, i.e. the Exit Reason is undefined,
+	 * but this is NOT a failed VM-Enter.
+	 */
 	if (!tdx_is_exit_reason_valid(tdx->vp_enter_ret))
-		return -1u;
+		return EXIT_REASON_UNDEFINED;
 
 	exit_reason = tdx->vp_enter_ret;
 
@@ -920,7 +925,7 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 		 * Defer KVM_BUG_ON() until tdx_handle_exit() because this is in
 		 * non-instrumentable code with interrupts disabled.
 		 */
-		return -1u;
+		return EXIT_REASON_UNDEFINED;
 	default:
 		break;
 	}
@@ -951,8 +956,7 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 
 static bool tdx_failed_vmentry(struct kvm_vcpu *vcpu)
 {
-	return vmx_get_exit_reason(vcpu).failed_vmentry &&
-	       vmx_get_exit_reason(vcpu).full != -1u;
+	return vmx_get_exit_reason(vcpu).failed_vmentry;
 }
 
 static fastpath_t tdx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
-- 
2.53.0



