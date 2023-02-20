Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABD163B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54831C433EF;
	Mon, 20 Feb 2023 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900505;
	bh=GJx0ju4aigeLfhnWgB36GzGcm2YwC+sYdp3EGLsWlxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiyPdAEPvj2SKDmtyUTZuaeEDqgBcOaOLS/rJfELTmpKeRLgQJ7AGoY1nrIj9ukvL
	 F9sOVeavTotxkTRgVG3rdQ4nZvnNVTYQTDkom7o1m+qgWP4B0JEQ26Z51VQdr/zhLL
	 3lfwSOQvLR5OlZaaj3oAKO7EgznqkDjAtmyVDqHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/89] KVM: VMX: Move VMX specific files to a "vmx" subdirectory
Date: Mon, 20 Feb 2023 14:35:21 +0100
Message-Id: <20230220133553.950224885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit a821bab2d1ee869e04b218b198837bf07f2d27c1 ]

...to prepare for shattering vmx.c into multiple files without having
to prepend "vmx_" to all new files.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: a44b331614e6 ("KVM: x86/vmx: Do not skip segment attributes if unusable bit is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/Makefile                      | 2 +-
 arch/x86/kvm/{ => vmx}/pmu_intel.c         | 0
 arch/x86/kvm/{ => vmx}/vmx.c               | 0
 arch/x86/kvm/{ => vmx}/vmx_evmcs.h         | 0
 arch/x86/kvm/{ => vmx}/vmx_shadow_fields.h | 0
 5 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/x86/kvm/{ => vmx}/pmu_intel.c (100%)
 rename arch/x86/kvm/{ => vmx}/vmx.c (100%)
 rename arch/x86/kvm/{ => vmx}/vmx_evmcs.h (100%)
 rename arch/x86/kvm/{ => vmx}/vmx_shadow_fields.h (100%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index dc4f2fdf5e57..13fd54de5449 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o page_track.o debugfs.o
 
-kvm-intel-y		+= vmx.o pmu_intel.o
+kvm-intel-y		+= vmx/vmx.o vmx/pmu_intel.o
 kvm-amd-y		+= svm.o pmu_amd.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/x86/kvm/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
similarity index 100%
rename from arch/x86/kvm/pmu_intel.c
rename to arch/x86/kvm/vmx/pmu_intel.c
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx/vmx.c
similarity index 100%
rename from arch/x86/kvm/vmx.c
rename to arch/x86/kvm/vmx/vmx.c
diff --git a/arch/x86/kvm/vmx_evmcs.h b/arch/x86/kvm/vmx/vmx_evmcs.h
similarity index 100%
rename from arch/x86/kvm/vmx_evmcs.h
rename to arch/x86/kvm/vmx/vmx_evmcs.h
diff --git a/arch/x86/kvm/vmx_shadow_fields.h b/arch/x86/kvm/vmx/vmx_shadow_fields.h
similarity index 100%
rename from arch/x86/kvm/vmx_shadow_fields.h
rename to arch/x86/kvm/vmx/vmx_shadow_fields.h
-- 
2.39.0



