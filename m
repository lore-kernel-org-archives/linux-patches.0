Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457823DC4DD;
	Wed, 20 May 2026 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276069; cv=none; b=oaBhciMosZBwbXYXsg9d8ApwCOVasUjtm4x9/NX+lbfhoPUBxu5F2yVEVhcYHChmo774ZGVAWw5tpWqsBwBrwCe1sm0TFHd+7Uc0FeoyoTH1w+O+MzDkOsFklx8dUdemXX1z12hZnZJXABcQA5dkAcFx3p3VyiESazR452StFMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276069; c=relaxed/simple;
	bh=r1YWvLWyYV0WAPXAPOMWkutG4FXf8I57i6Uy9t1sMjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gTO1Av+m99LVjYcAx5Tv56aVeB+MeD5svjRhgaYg/v/pUtq2GrHRaBMfjbjMyiEBbJSu5m8elgDnwbm03H2OrP+lz6P8HfjG3rGnrICT5axvZctLN9ck8GzG7x3Kh8OqjqCTfwc7f4xWLRF0PWCfe3uZRS48oHwlgqTy7KjqRmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsK7gs8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsK7gs8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C458C1F00897;
	Wed, 20 May 2026 11:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276067;
	bh=MvxNdjhxqINUsa1WAFZXIETlsupbkmyZrXhhzNx4Cn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsK7gs8coSBeRupJ5QKk2KOiO4Tja3vfRKO5aXvraIAeRbF69mYbzkb/qmfRDfuaG
	 Wta7qs4UX1sQRKGgwITTpXw0tWHDIn1xO2D0IGQm0YVXhCZWpAKfloCnA008ouyIpO
	 F5px3XByoICNL89XbbcsyVzg9WvN1eEjPDM0B3TW4db7Z6LylxY08llPdx86irJTAn
	 iRQdsYSwFIfoNSwB7DNxOKOvCH9NyDPBgk8ptaIllt+4Kvl3p8qD6cRrChTF2tapWy
	 jrxRgCTPsqAAKt1NfC5yiD6NQ9Uo0zm0kDwpz8adphePgnkdxaWdbZ7RSG437eBYzy
	 +I3HYAlcwD1Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Riley <d.riley@proxmox.com>,
	Sasha Levin <sashal@kernel.org>,
	seanjc@google.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] KVM: VMX: introduce module parameter to disable CET
Date: Wed, 20 May 2026 07:19:30 -0400
Message-ID: <20260520111944.3424570-58-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 2d5d3fc593c9b7e41bee86175d7b9e11f470072e ]

There have been reports of host hangs caused by CET virtualization.
Until these are analyzed further, introduce a module parameter that
makes it possible to easily disable it.

Link: https://lore.kernel.org/all/85548beb-1486-40f9-beb4-632c78e3360b@proxmox.com/
Cc: David Riley <d.riley@proxmox.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: subsystem `KVM: VMX`; action verb `introduce`; summary:
add a VMX module parameter to disable CET virtualization.

Step 1.2 Record: tags present:
- `Link:` `https://lore.kernel.org/all/85548beb-1486-40f9-beb4-
  632c78e3360b@proxmox.com/`
- `Cc:` `David Riley <d.riley@proxmox.com>`
- `Signed-off-by:` `Paolo Bonzini <pbonzini@redhat.com>`
- No `Fixes:` tag.
- No `Reported-by:` or `Tested-by:` tag in the commit itself.

Step 1.3 Record: the commit says CET virtualization has caused host
hangs, and the parameter is a mitigation while the reports are analyzed.
The linked report describes Windows Server 2026 with VBS/HVCI on an
Intel Xeon Gold 6426Y hanging in early boot with watchdog hard/soft
lockups on the host. The root cause is not identified in the commit or
linked report.

Step 1.4 Record: this is a real bug workaround, not a hidden
resource/lifetime fix. It does not fix the underlying CET bug by
default; it gives affected administrators a supported way to disable the
problematic VMX CET virtualization path.

## Phase 2: Diff Analysis

Step 2.1 Record: files changed:
- `arch/x86/kvm/vmx/capabilities.h`: +1 extern declaration.
- `arch/x86/kvm/vmx/vmx.c`: +15/-2.
- Total: 2 files, 16 insertions, 2 deletions.
- Functions modified: `vmx_set_constant_host_state()`,
  `vmx_get_initial_vmentry_ctrl()`, `vmx_get_initial_vmexit_ctrl()`,
  `vmx_set_cpu_caps()`, `vmx_hardware_setup()`.
- Scope: small, VMX-only, surgical change.

Step 2.2 Record:
- New global `enable_cet` defaults to true and is exposed via
  `module_param_named(cet, enable_cet, bool, 0444)`.
- `vmx_set_constant_host_state()` used raw hardware support via
  `cpu_has_load_cet_ctrl()`; after the patch it uses `enable_cet`, so
  disabling CET also avoids programming host CET VMCS fields.
- `vmx_get_initial_vmentry_ctrl()` and `vmx_get_initial_vmexit_ctrl()`
  now clear CET load controls when disabled.
- `vmx_set_cpu_caps()` now hides guest `SHSTK`/`IBT` when `enable_cet`
  is false.
- `vmx_hardware_setup()` clears `enable_cet` if hardware lacks CET VM-
  entry support, preserving the old hardware-gating behavior.

Step 2.3 Record: bug category is operational workaround for severe KVM
host hang. Mechanism: disable advertising and using VMX CET
virtualization state through one read-mostly knob; no locking,
refcounting, memory safety, or endian change.

Step 2.4 Record: fix quality is good for a mitigation. It is small and
internally consistent. Regression risk is low because default behavior
remains enabled, and disabled behavior only applies when the
administrator opts out. Main concern: it adds a new module parameter,
which is normally disfavored for stable, but here it is an opt-out for a
verified host lockup regression.

## Phase 3: Git History Investigation

Step 3.1 Record: blame shows the CET-specific host VMCS state came from
`584ba3ffb984` (`KVM: VMX: Set host constant supervisor states to VMCS
fields`), and guest CET advertising came from `e140467bbdaf` (`KVM: x86:
Enable CET virtualization for VMX and advertise to userspace`). `git
describe --contains` places both in the v6.18 development window.

Step 3.2 Record: no `Fixes:` tag is present, so there was no tagged
introducing commit to follow. The relevant introducing commits were
identified by blame and subject search instead.

Step 3.3 Record: recent file history shows CET virtualization and later
KVM VMX changes in the same area, but this candidate is standalone. No
prerequisite beyond existing VMX CET virtualization support was found.

Step 3.4 Record: Paolo Bonzini authored and committed this patch.
`MAINTAINERS` lists Paolo as maintainer for both `KERNEL VIRTUAL MACHINE
(KVM)` and `KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)`.

Step 3.5 Record: dependencies are the CET virtualization infrastructure,
especially `VM_ENTRY_LOAD_CET_STATE`, `VM_EXIT_LOAD_CET_STATE`, and
`cpu_has_load_cet_ctrl()`. Those exist in local `pending-6.18`,
`pending-6.19`, and `pending-7.0`. The patch applies cleanly to all
three tested branches.

## Phase 4: Mailing List And External Research

Step 4.1 Record: `b4 dig -c 2d5d3fc593c9...` found the submission at
`https://patch.msgid.link/20260512150016.2979228-1-pbonzini@redhat.com`.
`b4 dig -a` showed a standalone v1 patch and also associated it with the
MBEC/GMET series thread referenced by the bug report. No formal v2 was
found.

Step 4.2 Record: `b4 dig -w` showed the original recipients: Paolo
Bonzini, `linux-kernel@vger.kernel.org`, `kvm@vger.kernel.org`, and
David Riley. Sean Christopherson replied in review; `MAINTAINERS`
confirms Sean is a KVM/x86 maintainer.

Step 4.3 Record: the linked report from David Riley documents Intel host
hard/soft lockups and guest boot hangs with Windows Server 2026,
VBS/HVCI, and `-cpu host,level=30,+vmx-mbec`. The same report says
disabling `cet-ss` and `cet-ibt` in QEMU let the Intel guest boot.

Step 4.4 Record: review feedback from Sean objected to an initial
`vmcs12.c` hunk because `cpu_has_vmcs12_field()` checks raw CPU support,
not enabled KVM policy. Paolo agreed to remove that hunk, and the
committed diff no longer modifies `vmcs12.c`.

Step 4.5 Record: web search did not find stable-list discussion for this
specific patch or bug. Lore WebFetch was blocked by Anubis, but `b4`
successfully retrieved the relevant patch and bug-report messages.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: modified functions: `vmx_set_constant_host_state()`,
`vmx_get_initial_vmentry_ctrl()`, `vmx_get_initial_vmexit_ctrl()`,
`vmx_set_cpu_caps()`, `vmx_hardware_setup()`.

Step 5.2 Record: callers:
- `vmx_set_constant_host_state()` is called from VMCS initialization in
  `vmx.c` and from nested VMCS02 constant-state setup in `nested.c`.
- `vmx_get_initial_vmentry_ctrl()` and `vmx_get_initial_vmexit_ctrl()`
  are used during VMCS initialization.
- `vmx_set_cpu_caps()` is called from `vmx_hardware_setup()`.
- `vmx_hardware_setup()` is called from `vt_hardware_setup()` in
  `arch/x86/kvm/vmx/main.c`.

Step 5.3 Record: key callees include `vmcs_writel()`,
`vm_exit_controls_set()`, `vm_entry_controls_set()`,
`kvm_cpu_cap_clear()`, and `cpu_has_load_cet_ctrl()`. These show the
patch affects VMCS setup and guest CPUID exposure.

Step 5.4 Record: the affected path is reachable through KVM module setup
and VM/vCPU creation, then guest execution. The linked report confirms
practical reachability via QEMU launching a Windows guest.

Step 5.5 Record: similar patterns exist for other VMX feature toggles
such as `enable_ept`, `enable_vpid`, `enable_pml`, and
`enable_unrestricted_guest`, so the implementation follows existing VMX
module-parameter style.

## Phase 6: Stable Tree Analysis

Step 6.1 Record: CET virtualization support was introduced for v6.18-era
kernels. Local `pending-6.18`, `pending-6.19`, and `pending-7.0` all
contain the relevant CET code and lack `enable_cet`.

Step 6.2 Record: exact upstream diff applies cleanly to temporary
worktrees for `pending-6.18`, `pending-6.19`, and `pending-7.0`.
Backport difficulty is clean apply for those tested trees.

Step 6.3 Record: local history search found no separate fix for “host
hangs caused by CET virtualization” or the Windows Server 2026 report.
No replacement fix was identified.

## Phase 7: Subsystem And Maintainer Context

Step 7.1 Record: subsystem is KVM/x86 VMX, criticality IMPORTANT to CORE
for hosts running Intel KVM virtualization. Failure affects host
stability, not only guest functionality.

Step 7.2 Record: KVM/x86 VMX is highly active in this tree. CET
virtualization was a recent large feature, introduced around v6.18, so
this is a mitigation for a recent virtualization regression surface.

## Phase 8: Impact And Risk Assessment

Step 8.1 Record: affected users are Intel KVM hosts exposing CET
virtualization to guests. The verified report involves Windows Server
2026 with VBS/HVCI and QEMU CPU settings exposing CET/MBEC.

Step 8.2 Record: trigger conditions verified from the report: booting
the Windows guest with CET and MBEC exposed. Unprivileged local
triggerability was not verified; this appears to require VM
launch/configuration control.

Step 8.3 Record: failure mode is severe: guest hang plus host watchdog
hard lockup and soft lockup. Severity: CRITICAL.

Step 8.4 Record: benefit is high for affected stable users because it
gives a practical mitigation for host lockups. Risk is low-medium: small
VMX-only patch and default behavior unchanged, but it does add a new
module parameter.

## Phase 9: Final Synthesis

Step 9.1 Record:
- Evidence for backporting: verified host hard/soft lockups; small
  contained VMX-only patch; authored by KVM maintainer; reviewed on KVM
  list with maintainer feedback incorporated; applies cleanly to
  affected local stable branches; default behavior unchanged.
- Evidence against backporting: it is a workaround, not a root-cause
  fix; it adds a new module parameter, which stable normally treats
  cautiously; users must opt in to the mitigation by disabling CET.
- Unresolved: exact root cause of the CET hang is not identified; no
  stable-list discussion was found.

Step 9.2 Stable rules:
1. Obviously correct and tested? Mostly yes: simple gating of existing
   CET controls; mailing-list review fixed an inconsistency. No explicit
   `Tested-by` on this patch.
2. Fixes a real bug affecting users? Yes: linked report shows host
   lockups and guest hangs.
3. Important issue? Yes: host hard/soft lockups are critical.
4. Small and contained? Yes: 2 files, 16 insertions, 2 deletions.
5. No new features or APIs? Concern: it adds a module parameter.
   Mitigating factor: default behavior is unchanged and the parameter is
   an opt-out for a serious regression.
6. Can apply to stable trees? Yes for tested `pending-6.18`,
   `pending-6.19`, and `pending-7.0`.

Step 9.3 Record: no automatic exception category like device ID or
hardware quirk. The closest category is a conservative operational
workaround for broken hardware/feature behavior.

Step 9.4 Decision: backport to stable trees that already contain VMX CET
virtualization, especially v6.18 and newer. Despite the module parameter
concern, the benefit of giving stable users a low-risk escape hatch from
verified host lockups outweighs the risk, and the default behavior is
unchanged.

## Verification

- [Phase 1] Parsed `git show --format=fuller --stat --patch
  2d5d3fc593c9...`: confirmed subject, body, tags, author, and exact
  diff.
- [Phase 2] Diff analysis: confirmed 2 files, 16 insertions, 2
  deletions, VMX-only gating of CET controls and CPUID exposure.
- [Phase 3] `git blame` around changed areas: identified CET code from
  `584ba3ffb984` and `e140467bbdaf`.
- [Phase 3] `git describe --contains`: confirmed CET support is
  v6.18-era and candidate is v7.1-rc4-era.
- [Phase 3] `MAINTAINERS` search: confirmed Paolo Bonzini and Sean
  Christopherson are KVM/x86 maintainers.
- [Phase 4] `b4 dig -c`: found patch submission at
  `20260512150016.2979228-1-pbonzini@redhat.com`.
- [Phase 4] `b4 dig -a`: found standalone v1 and related MBEC/GMET
  series context.
- [Phase 4] `b4 dig -w`: confirmed KVM and LKML recipients plus David
  Riley.
- [Phase 4] `b4 mbox`: confirmed Sean’s review concern and Paolo’s
  agreement to remove the `vmcs12.c` hunk; committed patch matches that
  resolution.
- [Phase 4] `b4 mbox --single-message`: retrieved David Riley’s bug
  report with Intel host lockups and guest hangs.
- [Phase 5] `rg` caller search: traced modified functions to VMX
  hardware setup, VMCS initialization, and nested VMCS02 setup.
- [Phase 6] `git grep` on `pending-6.18`, `pending-6.19`, and
  `pending-7.0`: confirmed CET code exists and `enable_cet` does not.
- [Phase 6] Temporary worktree `git apply --check`: exact patch applies
  cleanly to `pending-6.18`, `pending-6.19`, and `pending-7.0`.
- [Phase 8] Failure mode verified from bug report: watchdog hard lockup
  and soft lockup on host, plus guest early boot hang.
- UNVERIFIED: underlying root cause of the CET virtualization hang
  remains unknown.
- UNVERIFIED: no exhaustive stable-list archive proof beyond web search;
  no stable-specific discussion was found.

**YES**

 arch/x86/kvm/vmx/capabilities.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4e371c93ae168..46fb4d2e81c42 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -14,6 +14,7 @@ extern bool __read_mostly flexpriority_enabled;
 extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
+extern bool __read_mostly enable_cet;
 extern bool __read_mostly enable_pml;
 extern int __read_mostly pt_mode;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8b24e682535bf..084c30cf689b9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -107,6 +107,9 @@ module_param_named(unrestricted_guest,
 bool __read_mostly enable_ept_ad_bits = 1;
 module_param_named(eptad, enable_ept_ad_bits, bool, 0444);
 
+bool __read_mostly enable_cet = 1;
+module_param_named(cet, enable_cet, bool, 0444);
+
 static bool __read_mostly emulate_invalid_guest_state = true;
 module_param(emulate_invalid_guest_state, bool, 0444);
 
@@ -4585,7 +4588,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	 * SSP is reloaded from IA32_PL3_SSP. Check SDM Vol.2A/B Chapter
 	 * 3 and 4 for details.
 	 */
-	if (cpu_has_load_cet_ctrl()) {
+	if (enable_cet) {
 		vmcs_writel(HOST_S_CET, kvm_host.s_cet);
 		vmcs_writel(HOST_SSP, 0);
 		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
@@ -4641,6 +4644,10 @@ static u32 vmx_get_initial_vmentry_ctrl(void)
 	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
+
+	if (!enable_cet)
+		vmentry_ctrl &= ~VM_ENTRY_LOAD_CET_STATE;
+
 	/*
 	 * IA32e mode, and loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically.
 	 */
@@ -4655,6 +4662,9 @@ static u32 vmx_get_initial_vmexit_ctrl(void)
 {
 	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
 
+	if (!enable_cet)
+		vmexit_ctrl &= ~VM_EXIT_LOAD_CET_STATE;
+
 	/*
 	 * Not used by KVM and never set in vmcs01 or vmcs02, but emulated for
 	 * nested virtualization and thus allowed to be set in vmcs12.
@@ -8240,7 +8250,7 @@ static __init void vmx_set_cpu_caps(void)
 	 * VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error code
 	 * fails, so disable CET in this case too.
 	 */
-	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
+	if (!enable_cet || !enable_unrestricted_guest ||
 	    !cpu_has_vmx_basic_no_hw_errcode_cc()) {
 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 		kvm_cpu_cap_clear(X86_FEATURE_IBT);
@@ -8721,6 +8731,9 @@ __init int vmx_hardware_setup(void)
 	    !cpu_has_vmx_invept_global())
 		enable_ept = 0;
 
+	if (!cpu_has_load_cet_ctrl())
+		enable_cet = 0;
+
 	/* NX support is required for shadow paging. */
 	if (!enable_ept && !boot_cpu_has(X86_FEATURE_NX)) {
 		pr_err_ratelimited("NX (Execute Disable) not supported\n");
-- 
2.53.0

