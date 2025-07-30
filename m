Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA43226D17;
	Wed, 30 Jul 2025 09:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868985; cv=none; b=YhddICQa5ne4kCLj0FAsaxMvamwFry/IyiXDb7ar41kh9NJAmRWwzU9DG1LuyrIM+tCjD4lDaGA700PyWNYY4eyXWvEK4HjTiApkEuvx97XGbxSWwD7Uh2wyNZA9xJ5Nru8XjnAt/NThJ/i+jHJTBoWJGrojUExU8Q+wGexx0nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868985; c=relaxed/simple;
	bh=oroqXZ6uROR2Jya0VxzILAmhv/IOekyb80t25HckNGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdMLPg2G8/dLRqjzQLExEYnU+W9xi5UY2Y7VPMv+m80LDvxZmGxu3bLD26EDcOufV9k9tQI8Cl97fspae2ZuIM5wJpoZZYhScHhDneHwqtR+RrkHInqaqv0fMhk/S1OmqunbD4w+tNAojIvYl/KrtAAAexh/sRkTZqIf8UPe1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+B445mM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+B445mM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2445C4CEF6;
	Wed, 30 Jul 2025 09:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868985;
	bh=oroqXZ6uROR2Jya0VxzILAmhv/IOekyb80t25HckNGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+B445mM2Q65bYbbp2E8sJ9w8nmzrOsOTKaTxL7MmRPTIg3JMc+52z7DtTKRe/NOE
	 q/4ccBlrvfZN3RaU4NGM0u78FdtdyhHtXhRSEL9h4kx6J38FvTGEvdr0WWg9TbnTck
	 mWgCELLaaYOWgExYowj81AUck0hiBXCc3RgW7Vsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/117] KVM: x86: drop x86.h include from cpuid.h
Date: Wed, 30 Jul 2025 11:36:05 +0200
Message-ID: <20250730093237.530052999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit e52ad1ddd0a3b07777141ec9406d5dc2c9a0de17 ]

Drop x86.h include from cpuid.h to allow the x86.h to include the cpuid.h
instead.

Also fix various places where x86.h was implicitly included via cpuid.h

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240906221824.491834-2-mlevitsk@redhat.com
[sean: fixup a missed include in mtrr.c]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: fa787ac07b3c ("KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.h      |    1 -
 arch/x86/kvm/mmu.h        |    1 +
 arch/x86/kvm/mtrr.c       |    1 +
 arch/x86/kvm/vmx/hyperv.c |    1 +
 arch/x86/kvm/vmx/nested.c |    2 +-
 arch/x86/kvm/vmx/sgx.c    |    3 +--
 6 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -2,7 +2,6 @@
 #ifndef ARCH_X86_KVM_CPUID_H
 #define ARCH_X86_KVM_CPUID_H
 
-#include "x86.h"
 #include "reverse_cpuid.h"
 #include <asm/cpu.h>
 #include <asm/processor.h>
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
+#include "x86.h"
 #include "cpuid.h"
 
 extern bool __read_mostly enable_mmio_caching;
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -19,6 +19,7 @@
 #include <asm/mtrr.h>
 
 #include "cpuid.h"
+#include "x86.h"
 
 static u64 *find_mtrr(struct kvm_vcpu *vcpu, unsigned int msr)
 {
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 
+#include "x86.h"
 #include "../cpuid.h"
 #include "hyperv.h"
 #include "nested.h"
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7,6 +7,7 @@
 #include <asm/debugreg.h>
 #include <asm/mmu_context.h>
 
+#include "x86.h"
 #include "cpuid.h"
 #include "hyperv.h"
 #include "mmu.h"
@@ -16,7 +17,6 @@
 #include "sgx.h"
 #include "trace.h"
 #include "vmx.h"
-#include "x86.h"
 #include "smm.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -4,12 +4,11 @@
 
 #include <asm/sgx.h>
 
-#include "cpuid.h"
+#include "x86.h"
 #include "kvm_cache_regs.h"
 #include "nested.h"
 #include "sgx.h"
 #include "vmx.h"
-#include "x86.h"
 
 bool __read_mostly enable_sgx = 1;
 module_param_named(sgx, enable_sgx, bool, 0444);


