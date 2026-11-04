Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829121;
	b=MllzFT8+bAfxasHNWRO+dg0D0i7G658U8JfstaJlHCcwmxZFqkq18lCiPQgD8N2fWBxN
	 Ym/fJyDa5jOb+Y9Qq8CmVwzJVxVNYXMd/WbFOkS7TaKXZQy1NzBfgXsuewWcRuBOaL4He
	 vOabea0jJgaVwvjtAKsxgCN9lvk/iW7sasOytDFNkpWHVLGtW2W3aEm/qxgTvsEA1EwUE
	 AS6b9y7pyt6yUCfVkpriHbbI8rDceOMwXWdLiODNSxcF8O8w2A3j0hWMykttcUvV7qNAR
	 OfLggUgk9UgLwNzN1pRORQhedKNClAVd0VW7BdcP12KWyDAvk//loP+j57vl4S3d3Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZt4YvA37hxo5wSY4BZjxC7mXPKKmZFbx8vyZb0QHDE=;
	b=VhFUkS9SU9Glg1w0wa/diQNuE5LHXWXp2d4B7h3z3QXJ9LQRyV/57D8AW5XsTljSXqPj
	 1q59orydGzN2A3FBsfdB6lo9+IZEh3SVPErCf0A1s7udrzqX+79fPIlXXIfxOkdNPGpjm
	 ZqgqFRvcJ++pKNuehQYTIQM92FjQQdAuEva1J6EETntI1JNb4amsntj47/e4BOZnxzjv9
	 ZZ9GqOCngvpa/dKHRni7FDLNp954C7fkblyO4qpgszE6wIIatd5I6dc/PdSj07EwxPbkr
	 ZadV3vTTIYVFjMH4dslcMGXNsjqokpkevFKIP1Y00BJigNq1YLujwO41psX/BoBI7Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2TTaHEQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CBB6083634;
	Wed,  4 Nov 2026 21:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2TTaHEQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738031F000C1;
	Wed,  4 Nov 2026 21:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829120;
	bh=PZt4YvA37hxo5wSY4BZjxC7mXPKKmZFbx8vyZb0QHDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2TTaHEQOG65Es+bZDeMDd/1nHHCMjSyaR3NoF6BtdLfzvvQd01TgyP9rcAuYzPXj
	 lf2sWTg3ansZ7yuD/Vr++V9CE7esDmx4EZ8HETvjRAcKJY1WO6MQR7nYinJaCh7sLB
	 S06yX4G/74uUCi5Z2jcLBaQoRQqhiRyudt2Kll2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 459/547] KVM: VMX: Disallow using to_vmx() in common VT code
Date: Wed,  4 Nov 2026 16:10:43 -0500
Message-ID: <20261104211051.390179537@linuxfoundation.org>
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


