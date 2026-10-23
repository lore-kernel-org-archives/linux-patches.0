Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774276;
	b=3ORnCkEPnZBDvzqCDfmpV52sLoQl6wzmIrbDByVZ436deoSJqzdgDd50f6PBDwn41GOo
	 QMAPQZTJSD5xkLek48vNdsPcmpaeCmxo2gmFq0iur31ZM/tmKb6FSCAlzRyIHyBCTT9iY
	 cvRfhcTtcLV2fXpzpWFAghbrDCVZM0c1zYaCxQzFJk/wPsGl4F5vTyi6BHo/BYXHHKj2j
	 CnP/zH0Kyolps1kH5xNtxe+8zJp1UupLa4WX0MnyjvXziek1oHYOyslagr2lsIU9qgQBO
	 FXHOXWoQF8Ikkst7VydrCRTWEYGn1vIVBOkcyEJTpIDnkduEgu5Mpph75hPj1WD2rrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cX4zfGdNeWlfvC89p+zYW6DtCJTj7+zu8iooVYKvzTE=;
	b=1z27T4eugBxuph8xe1MjaCB4l+SZhMeHLptQZRCLZ3caXvkT5jWCFGfA4k6bLkx9XBqU
	 A1PwD9VQaUYmiSmpwDmaBIrbH31qHY/d4ls6XcR7gpbN7F15lRw4RSNhjqm5dI8lYJK1U
	 pR5YN3oeh2ePl85PjBsSKxcDd4KKrgmcnrYyO9dwzZiKBmxki/yq/P+4nPa84/S/4LAD5
	 C9bxRQYAwbNpehMS36sgX9ElW1WUP4zzBSzoaPmFPnMtnlaDv+uQsQnOtmZg8zG6eue7c
	 7RvcRq5Jrn7v0+CN0TbtFCY+an3ZppO2qJm7GJPccBjcCHlvdJjtsOQIfCh9hBqgsNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2G5nEJd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8957E606A31A;
	Fri, 23 Oct 2026 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2G5nEJd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90F41F01825;
	Fri, 23 Oct 2026 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774276;
	bh=cX4zfGdNeWlfvC89p+zYW6DtCJTj7+zu8iooVYKvzTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2G5nEJduXbZ009AYQbe2L+Z3SaEfgf6jNP7QW2ZAq7j0K7DvS79r1J3VAYTWIBuh
	 P0R4kqoh/Fqh+eOHnsQMIT85+s20IslmKHPkaisU+LVYDDZhNAz7ypCw8J+xvlYH4N
	 fbzJ+zx314tMEVRYshTex2rgMdCQ/PB/fvkp/ONs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	Yosry Ahmed <yosry@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/193] KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc
Date: Fri, 23 Oct 2026 18:36:59 +0200
Message-ID: <20261023163717.567255527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

[ Upstream commit 55780d8a1dcc93d2c4b33c565ada88df12c9f206 ]

Virtual VMSAVE/VMLOAD enablement (i.e.
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK) is set/cleared by
svm_recalc_instruction_intercepts() when the intercepts are cleared/set.
This is unnecessary because the bit is meaningless when intercepts are
set and KVM emulates the instructions. Initialize the bit in vmcb01 base
on vls, and keep it unchanged.

This is similar-ish to how vGIF is handled. It is enabled in init_vmcb()
if vgif=1 and remains unchanged when the STGI intercept is enabled (e.g.
for NMI windows).

This fixes a bug in svm_recalc_instruction_intercepts(). The intercepts
for VMSAVE/VMLOAD are always toggled in vmcb01, but
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK is toggled in the current VMCB, which
could be vmcb02 instead of vmcb01 if L2 is active.

Virtual VMSAVE/VMLOAD enablement in vmcb02 is separately controlled by
nested_vmcb02_prepare_control() based on the vCPU features and VMCB12,
and if intercepts are needed they are set by recalc_intercepts().

The bug is benign though. Not toggling the bit for vmcb01 is harmless
because it's useless anyway. For vmcb02:

- The bit could be incorrectly cleared when intercepts are set in
  vmcb01. This is harmless because VMSAVE/VMLOAD will be emulated by KVM
  anyway.

- The bit could be incorrectly set when the intercepts are cleared in
  vmcb01. However, if the bit was originally clear in vmcb02, then
  recalc_intercepts() will enable in the intercepts in vmcb02 anyway and
  VMSAVE/VMLOAD will be emulated by KVM.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260110004821.3411245-3-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
Fixes: 5a1a726e68ff ("KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates")
Reported-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Closes: https://lore.kernel.org/linux-mm/arY1Wq6R9OY20ans@pcnci.linuxbox.cz/
Tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
[ yosry: The bug is not benign. Since 5a1a726e68ff, a vCPU restored into
  L2 (e.g. on live migration) recalculates intercepts with vmcb02
  loaded, leaving vmcb01 with neither VMLOAD/VMSAVE intercepts nor
  virtual VMLOAD/VMSAVE, so L1's VMLOAD/VMSAVE corrupt host memory. ]
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 335b214aa3711..5f3c6d7974fb9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -981,10 +981,14 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_set_intercept(svm, INTERCEPT_RDTSCP);
 	}
 
+	/*
+	 * No need to toggle VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK here, it is
+	 * always set if vls is enabled. If the intercepts are set, the bit is
+	 * meaningless anyway.
+	 */
 	if (guest_cpuid_is_intel_compatible(vcpu)) {
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
-		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -993,7 +997,6 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 		if (vls) {
 			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
-			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 	}
 }
@@ -1137,6 +1140,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
+	if (vls)
+		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
 
-- 
2.53.0



