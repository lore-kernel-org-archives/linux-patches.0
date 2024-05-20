Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1E213A265
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245203; cv=none; b=kr7KlAWjQmDLfELc9RC97t1Hvs/sdGZHpaaRkgMt6VmVVFSY3Y8kZ+IqY7qDenNC3slBUQoX9ZCXjT+x8g47PnR84aQDXOUYVxv4QIoEyvcKY26Zl3Fa5ROcGrPnNBEVm26BRlUV9nnleE7ars8f2awLf8KgoNlRpT6IEiNsgsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245203; c=relaxed/simple;
	bh=SrCUXI/oM/RyfJid2zkIs4n9nvj5uW7YKEMoo1adejA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzVKhbX9Jr/LQaEtBd46RAlIw3EanbyFYhY4K/R53JWa946qnhrrUR0neo5hokLf/RUjmXUn+gkoVB4IpzOntg4C8qPdte9UlcIh8JmAz592E83DyvdHmyEjqz1JCmpQ/aTIrwOD+kBw5BWCUmdZJ+Noj0b6oApwdGfNDORWEyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B5qjDzrA; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B5qjDzrA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245201; x=1747781201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SrCUXI/oM/RyfJid2zkIs4n9nvj5uW7YKEMoo1adejA=;
  b=B5qjDzrAHfcgnWGUKHf3mFXs82WZ8/U3NhADcmEmWx46FBdncdvzmt2o
   y0KRknvMjNbYNlxCHLsCRbzBd1twLnJF7K/ISAIb5tjJ6RRX7OaPdp/mM
   UWjL5QQoQUo9JRxQ2KvFXrAzP3b8f1eRokJtJNNLTwqQGPcLL9ncpAJRr
   irpzil3d+uaCVm1Il3C3U9tuEjDklIBWdoAANytmhFnyEFOH6VUJrKVa3
   0XCYs1cebFAgyyE/4SVTjvMb1MJ6o+YB76Ld5e/XlKwjeu5NU0Hyfqx8z
   xA4Go46oqV5A0eLLIrw91dVIf3YzrCgLiFk07v6nPgJh9S95nM63W4uCG
   w==;
X-CSE-ConnectionGUID: FTlzJFbbT6C8ymoXay1Eyg==
X-CSE-MsgGUID: qDxYvyNUQj+Rxt1/GIbTEQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199601"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199601"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:36 -0700
X-CSE-ConnectionGUID: hUI/PFvgSy+kdlt5jv+Wtw==
X-CSE-MsgGUID: rEtX2mjpRy677qKZA6Yolg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593409"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:36 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v6 09/49] KVM: VMX: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:40 -0700
Message-ID: <20240520224620.9480-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6051fad5945f..ceb0c1e6275a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2525,17 +2525,15 @@ static bool cpu_has_sgx(void)
  */
 static bool cpu_has_perf_global_ctrl_bug(void)
 {
-	if (boot_cpu_data.x86 == 0x6) {
-		switch (boot_cpu_data.x86_model) {
-		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
-		case INTEL_FAM6_NEHALEM:	/* AAP115 */
-		case INTEL_FAM6_WESTMERE:	/* AAT100 */
-		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
-		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
-			return true;
-		default:
-			break;
-		}
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_NEHALEM_EP:	/* AAK155 */
+	case INTEL_NEHALEM:	/* AAP115 */
+	case INTEL_WESTMERE:	/* AAT100 */
+	case INTEL_WESTMERE_EP:	/* BC86,AAY89,BD102 */
+	case INTEL_NEHALEM_EX:	/* BA97 */
+		return true;
+	default:
+		break;
 	}
 
 	return false;
-- 
2.45.0

