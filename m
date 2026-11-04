Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829124;
	b=1nB/migQU0EeXBy9dHTG5YK1yQDv9TlJP8PvokqKka4mooNxEqMCbfrOkxcURdpB5BtJ
	 BpGORHPXSVK74Dj8mgvPakjCWRJuQ1Jcpj38HlnV1V2aX235S2ELEIXBVbj3UIT01UORB
	 3NRx6r7rrF5tYRBhyvt6MpxeC/4dwNX403QTdc8L8jM//8v63IyWrKy2ixmzNiQqpRiYP
	 Xxd8a44sFqbIVYO2y+6fBGfdtXZgrKnokiELfnNMMjxGCqHKnuKCmjudUiKHxQT7nj+FL
	 RP+shhLsUuSTNCQD87MWLUkbZRiqe8dJmWzkFj9LK+UzozN3DTYF9WBRtr8LISZ3XkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LKA8iPeLZ8gZ/IXcCG7ahDIJTmtJHg+SVkbzTl0D+0k=;
	b=PUZHjGM4w7G+F8hgNleFk3RbPSBTEALMB51OzAXu96l3IkWKHa46ke/e7f4HSLa3lhQ1
	 wAEhxpuaRnUbcOVIPmBqGlWhwpFEjmy+3E9kzneqj5N2MpdWLNG8A7Jors1EdFhzz39R1
	 TMHmos8xn+0PFq/ucfGkUrhhxcnWray9xCMeaIGCw7tXKdFUMXQSmKdJD8wYjsccN1edE
	 6uA/CkCNEyCPvLewgTt7VsdMGzMMCqxB6w4FLss5vQSiwhkvtbE8g63flzHUiwtXAL6Xm
	 e47GE8VsraNHKh4Xli7H/rv4DN6rObMy+lUNNpVaDrUrS1NUjX7I9LkPoeDt5q1t9dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2330Hb0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EF0607350D;
	Wed,  4 Nov 2026 21:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2330Hb0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727B81F000C1;
	Wed,  4 Nov 2026 21:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829123;
	bh=LKA8iPeLZ8gZ/IXcCG7ahDIJTmtJHg+SVkbzTl0D+0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2330Hb0a2S0Su86HRdDgD3KkOItayMNRq0mlAfUpfn4iE5UIpAxvk76EfJs5POck
	 6WGYwaeeNl/Bzs6AUJJnr0G/t1tZ8IIW0xOS4xmBsN+CwmMKplwK51RL4i2Ao0N782
	 CAO5N6N9pnT0Qvm4vRXe2K8XnqHWKdsTMvnfAEYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 460/547] KVM: VMX: Formally define KVMs "0xdead" exit reason used for failed VM-Enter
Date: Wed,  4 Nov 2026 16:10:44 -0500
Message-ID: <20261104211051.419059137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit d85f7dc8cf3c91a131946dae4c3aa8d9c97322d7 upstream.

Add EXIT_REASON_UNDEFINED to track KVM's magic "0xdead" value that's used
to stuff the exit reason on a failed VM-Enter so that the magic can be
reused by TDX, and to make it more obvious that it's an arbitrary, KVM-
defined value (though the whole "dead" thing makes it pretty darn obvious).

Opportunistically add a compile-time assert to ensure the KVM-defined exit
reason never collides with a "real" exit reason.

No functional change intended.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260921235656.1107929-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/vmx.h |    8 ++++++++
 arch/x86/kvm/vmx/vmx.c     |    4 +++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -20,6 +20,14 @@
 #include <asm/trapnr.h>
 #include <asm/vmxfeatures.h>
 
+/*
+ * UNDEFINED is a KVM-defined value used to indicate that the basic exit reason
+ * is undefined/invalid, e.g. on VM-Fail or if TDX never attempted VM-Enter.
+ * The value itself is arbitrary, it just needs to not collide with a real exit
+ * reason.
+ */
+#define EXIT_REASON_UNDEFINED			0xdead
+
 struct vmcs_hdr {
 	u32 revision_id:31;
 	u32 shadow_vmcs:1;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6388,6 +6388,8 @@ static int (*kvm_vmx_exit_handlers[])(st
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
+static_assert(EXIT_REASON_UNDEFINED >= ARRAY_SIZE(kvm_vmx_exit_handlers));
+
 void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		       u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
@@ -7474,7 +7476,7 @@ static noinstr void vmx_vcpu_enter_exit(
 	vmx_enable_fb_clear(vmx);
 
 	if (unlikely(vmx->fail)) {
-		vmx->vt.exit_reason.full = 0xdead;
+		vmx->vt.exit_reason.full = EXIT_REASON_UNDEFINED;
 		goto out;
 	}
 


