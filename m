Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831815;
	b=5pcYBK28qFjU/6Zb3q+qJH5d9UFsc5YtJmSKG81xxoMR8oel/qxwvARK4wTYx7oTtjkL
	 YAZVmElY7yD6C4Bfk/sKteEoHisdvhCdVKRdCb3WmZ/8BFfFAB4KAWZkCowhZTj2p/eUD
	 RmnoHwZK0xwpUJvj4kfG/F08esNlF+HK8ZgVKiWyOJEwRF8/GkBvrrCXOcjY9cw7ixWtq
	 VQX1cePcuF2tY/F6seJpBM3FbO4O+bCefSD/pKb5/pBab2Q78TVBNh0eec8XIEKc3gM1U
	 9ZOQYqfxWWaqmhoSR+IytY4b7uBgcjY/lY0F0oXcsKhBKdsM+Su/WJLCmVaMKbRn7aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gm13YmvMaHXyDMXdHzOGtnjVIUwzGC7qKl9ntbSUV6M=;
	b=35I7kuhD/cbvXhF5udkUK+PJvNnFzk29JRYKud31hf/Jjph+2WQ5+2NtlZG9LJFNj42d
	 /SmTflTT3/mOhebZ2gZJoSTMiPIhiFyT4QNgBSVKtEUDMb5lJ97Oxmmm4T7+5KDLdLJ1d
	 rG8P2WEzYvvDGes4AwONRhdQa/e1HpIAewMhsotOp56RBVt4Jetc92i8lbtbbNCmbTB24
	 abWuXc1Z7+0iXOjIf1o+VeeDNmop3zse2oFHT3qClMIpm4NWVeZblVCssWsQvcphsuF//
	 mqLRlgH5UknTfZaVo6dlCaNotg47CSWxS2wrnWvsDjP+tpH57JGACf8nhwvC+LrQItg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcWuPjVd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE815606A86B;
	Wed,  4 Nov 2026 22:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcWuPjVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783BD1F000C1;
	Wed,  4 Nov 2026 22:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831814;
	bh=Gm13YmvMaHXyDMXdHzOGtnjVIUwzGC7qKl9ntbSUV6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcWuPjVdS/BQeHvRkhpEUjjNh8x5G6MYojTXdEorZ2frB6i0ttvE6f+jpuSfxNt2L
	 7fzSj9+o2dpfkr85eHpNh7oebsIFHk0Y8/aWTjpxqxHaCpgn8UxfeZb4JKKkxaNrIB
	 LxDDg5AWNaxiGZ1tuYPu63sdQhcabOJFtr4AzJWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0928/1005] KVM: VMX: Disallow using to_vmx() in common VT code
Date: Wed,  4 Nov 2026 16:11:01 -0500
Message-ID: <20261104211109.132748233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit f305fd31f52a8d3ce4d2bf0c88c45bb7a373809c upstream.

Poison to_vmx() in main.c and posted_intr.c so that attempting to interpret
the vCPU as a VMX vCPU will fail at compile time, as opposed to failing at
runtime, or worse corrupting state without outright failing.

Note, to_tdx() is buried in tdx.c, i.e. isn't broadly reachable, and so
doesn't need the same treatment as to_vmx().

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260904010353.3175819-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/main.c        |    2 ++
 arch/x86/kvm/vmx/posted_intr.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,6 +10,8 @@
 #include "tdx.h"
 #include "tdx_arch.h"
 
+#pragma GCC poison to_vmx
+
 #ifdef CONFIG_KVM_INTEL_TDX
 static_assert(offsetof(struct vcpu_vmx, vt) == offsetof(struct vcpu_tdx, vt));
 
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -14,6 +14,8 @@
 #include "vmx.h"
 #include "tdx.h"
 
+#pragma GCC poison to_vmx
+
 /*
  * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
  * when a WAKEUP_VECTOR interrupted is posted.  vCPUs are added to the list when


