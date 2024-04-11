Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3BC13DDDD;
	Thu, 11 Apr 2024 09:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829566; cv=none; b=IXCPdOsAtB6CRy4QV1f6uRWyxULpx5YCYYJ1FYSKAGE7+QsTXFnALRHP6NSMyIPte5CVDNCfa8SeoedOnzN/xYk+Q25Itsc7hcqTpf5EZroEUVxyN14h/sbM+HPurnZ9Vx0Ky4MdDNy+nM54/qhjnsmV7zDwVnZi/GLWNeT2/Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829566; c=relaxed/simple;
	bh=asvnJddpC5jFrjDsV3qMgq90h2uoC/vycIiBy00QAa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxbE8ELeROPvlZmKWOGhza2paqj89FDEpRgd/2jkYKTb5dGnaH58lC5vWElD6VLaEm5Jfm0blxW0+qL5VlH85YgI//ixzhMcFm2zeCTHA0EYgtAUgaL2p0AOhIUdZ+n+zwpV1DYwQ3OyBf3w3tPquNYKezeDHO+31dCAKeIRDKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rre67j2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rre67j2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CE0C433F1;
	Thu, 11 Apr 2024 09:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829566;
	bh=asvnJddpC5jFrjDsV3qMgq90h2uoC/vycIiBy00QAa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rre67j2D2qtLxMKi3fSG3VTzjMVvnsPSZ+emtP48qXeh2XBQgnII+ejPOTqvv2jgq
	 +LsoUFOzUwmBqLvpn1wgobcDkEOjgmJgQWHk98jlX9UbVs8BGuhsQjBxwRofM38x3T
	 j2t0VrTdtBEVuYjisX0u7+8ffwenNeLPFqebjGUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.19 003/175] x86/bugs: Use sysfs_emit()
Date: Thu, 11 Apr 2024 11:53:46 +0200
Message-ID: <20240411095419.640981625@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 1d30800c0c0ae1d086ffad2bdf0ba4403370f132 upstream.

Those mitigations are very talkative; use the printing helper which pays
attention to the buffer size.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220809153419.10182-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   82 ++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2137,69 +2137,69 @@ static const char * const l1tf_vmx_state
 static ssize_t l1tf_show_state(char *buf)
 {
 	if (l1tf_vmx_mitigation == VMENTER_L1D_FLUSH_AUTO)
-		return sprintf(buf, "%s\n", L1TF_DEFAULT_MSG);
+		return sysfs_emit(buf, "%s\n", L1TF_DEFAULT_MSG);
 
 	if (l1tf_vmx_mitigation == VMENTER_L1D_FLUSH_EPT_DISABLED ||
 	    (l1tf_vmx_mitigation == VMENTER_L1D_FLUSH_NEVER &&
 	     sched_smt_active())) {
-		return sprintf(buf, "%s; VMX: %s\n", L1TF_DEFAULT_MSG,
-			       l1tf_vmx_states[l1tf_vmx_mitigation]);
+		return sysfs_emit(buf, "%s; VMX: %s\n", L1TF_DEFAULT_MSG,
+				  l1tf_vmx_states[l1tf_vmx_mitigation]);
 	}
 
-	return sprintf(buf, "%s; VMX: %s, SMT %s\n", L1TF_DEFAULT_MSG,
-		       l1tf_vmx_states[l1tf_vmx_mitigation],
-		       sched_smt_active() ? "vulnerable" : "disabled");
+	return sysfs_emit(buf, "%s; VMX: %s, SMT %s\n", L1TF_DEFAULT_MSG,
+			  l1tf_vmx_states[l1tf_vmx_mitigation],
+			  sched_smt_active() ? "vulnerable" : "disabled");
 }
 
 static ssize_t itlb_multihit_show_state(char *buf)
 {
 	if (itlb_multihit_kvm_mitigation)
-		return sprintf(buf, "KVM: Mitigation: Split huge pages\n");
+		return sysfs_emit(buf, "KVM: Mitigation: Split huge pages\n");
 	else
-		return sprintf(buf, "KVM: Vulnerable\n");
+		return sysfs_emit(buf, "KVM: Vulnerable\n");
 }
 #else
 static ssize_t l1tf_show_state(char *buf)
 {
-	return sprintf(buf, "%s\n", L1TF_DEFAULT_MSG);
+	return sysfs_emit(buf, "%s\n", L1TF_DEFAULT_MSG);
 }
 
 static ssize_t itlb_multihit_show_state(char *buf)
 {
-	return sprintf(buf, "Processor vulnerable\n");
+	return sysfs_emit(buf, "Processor vulnerable\n");
 }
 #endif
 
 static ssize_t mds_show_state(char *buf)
 {
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
-		return sprintf(buf, "%s; SMT Host state unknown\n",
-			       mds_strings[mds_mitigation]);
+		return sysfs_emit(buf, "%s; SMT Host state unknown\n",
+				  mds_strings[mds_mitigation]);
 	}
 
 	if (boot_cpu_has(X86_BUG_MSBDS_ONLY)) {
-		return sprintf(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
-			       (mds_mitigation == MDS_MITIGATION_OFF ? "vulnerable" :
-			        sched_smt_active() ? "mitigated" : "disabled"));
+		return sysfs_emit(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
+				  (mds_mitigation == MDS_MITIGATION_OFF ? "vulnerable" :
+				   sched_smt_active() ? "mitigated" : "disabled"));
 	}
 
-	return sprintf(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
-		       sched_smt_active() ? "vulnerable" : "disabled");
+	return sysfs_emit(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
+			  sched_smt_active() ? "vulnerable" : "disabled");
 }
 
 static ssize_t tsx_async_abort_show_state(char *buf)
 {
 	if ((taa_mitigation == TAA_MITIGATION_TSX_DISABLED) ||
 	    (taa_mitigation == TAA_MITIGATION_OFF))
-		return sprintf(buf, "%s\n", taa_strings[taa_mitigation]);
+		return sysfs_emit(buf, "%s\n", taa_strings[taa_mitigation]);
 
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
-		return sprintf(buf, "%s; SMT Host state unknown\n",
-			       taa_strings[taa_mitigation]);
+		return sysfs_emit(buf, "%s; SMT Host state unknown\n",
+				  taa_strings[taa_mitigation]);
 	}
 
-	return sprintf(buf, "%s; SMT %s\n", taa_strings[taa_mitigation],
-		       sched_smt_active() ? "vulnerable" : "disabled");
+	return sysfs_emit(buf, "%s; SMT %s\n", taa_strings[taa_mitigation],
+			  sched_smt_active() ? "vulnerable" : "disabled");
 }
 
 static ssize_t mmio_stale_data_show_state(char *buf)
@@ -2267,33 +2267,33 @@ static char *pbrsb_eibrs_state(void)
 static ssize_t spectre_v2_show_state(char *buf)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
-		return sprintf(buf, "Vulnerable: LFENCE\n");
+		return sysfs_emit(buf, "Vulnerable: LFENCE\n");
 
 	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
-		return sprintf(buf, "Vulnerable: eIBRS with unprivileged eBPF\n");
+		return sysfs_emit(buf, "Vulnerable: eIBRS with unprivileged eBPF\n");
 
 	if (sched_smt_active() && unprivileged_ebpf_enabled() &&
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
-		return sprintf(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
+		return sysfs_emit(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sprintf(buf, "%s%s%s%s%s%s%s\n",
-		       spectre_v2_strings[spectre_v2_enabled],
-		       ibpb_state(),
-		       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
-		       stibp_state(),
-		       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
-		       pbrsb_eibrs_state(),
-		       spectre_v2_module_string());
+	return sysfs_emit(buf, "%s%s%s%s%s%s%s\n",
+			  spectre_v2_strings[spectre_v2_enabled],
+			  ibpb_state(),
+			  boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
+			  stibp_state(),
+			  boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
+			  pbrsb_eibrs_state(),
+			  spectre_v2_module_string());
 }
 
 static ssize_t srbds_show_state(char *buf)
 {
-	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
+	return sysfs_emit(buf, "%s\n", srbds_strings[srbds_mitigation]);
 }
 
 static ssize_t retbleed_show_state(char *buf)
 {
-	return sprintf(buf, "%s\n", retbleed_strings[retbleed_mitigation]);
+	return sysfs_emit(buf, "%s\n", retbleed_strings[retbleed_mitigation]);
 }
 
 static ssize_t gds_show_state(char *buf)
@@ -2305,26 +2305,26 @@ static ssize_t cpu_show_common(struct de
 			       char *buf, unsigned int bug)
 {
 	if (!boot_cpu_has_bug(bug))
-		return sprintf(buf, "Not affected\n");
+		return sysfs_emit(buf, "Not affected\n");
 
 	switch (bug) {
 	case X86_BUG_CPU_MELTDOWN:
 		if (boot_cpu_has(X86_FEATURE_PTI))
-			return sprintf(buf, "Mitigation: PTI\n");
+			return sysfs_emit(buf, "Mitigation: PTI\n");
 
 		if (hypervisor_is_type(X86_HYPER_XEN_PV))
-			return sprintf(buf, "Unknown (XEN PV detected, hypervisor mitigation required)\n");
+			return sysfs_emit(buf, "Unknown (XEN PV detected, hypervisor mitigation required)\n");
 
 		break;
 
 	case X86_BUG_SPECTRE_V1:
-		return sprintf(buf, "%s\n", spectre_v1_strings[spectre_v1_mitigation]);
+		return sysfs_emit(buf, "%s\n", spectre_v1_strings[spectre_v1_mitigation]);
 
 	case X86_BUG_SPECTRE_V2:
 		return spectre_v2_show_state(buf);
 
 	case X86_BUG_SPEC_STORE_BYPASS:
-		return sprintf(buf, "%s\n", ssb_strings[ssb_mode]);
+		return sysfs_emit(buf, "%s\n", ssb_strings[ssb_mode]);
 
 	case X86_BUG_L1TF:
 		if (boot_cpu_has(X86_FEATURE_L1TF_PTEINV))
@@ -2357,7 +2357,7 @@ static ssize_t cpu_show_common(struct de
 		break;
 	}
 
-	return sprintf(buf, "Vulnerable\n");
+	return sysfs_emit(buf, "Vulnerable\n");
 }
 
 ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, char *buf)


