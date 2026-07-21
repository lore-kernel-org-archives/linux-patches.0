Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25F046D2B9;
	Tue, 21 Jul 2026 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654072; cv=none; b=gdOfUymsDv6Y67KzD4/DqAv0fxdwnA44thBZLSwoGpWPlSfb4XfIuKORe1x/JCNU4ugRFaI6vTRrEgwRQ0GJIB5XfxY75bVL2BVQ/aA3WX+/wC6eBfuQxjlJDli2tQrhCTQZR1DhW6dvy9SfUola/XpYTTV/+ukqOdh3lfJkhYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654072; c=relaxed/simple;
	bh=eiHE9wsn4Lb7Brt36g9y3tTUbqY98m1IuU5l+62djIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLK7ALI2lwIr2Fyjy1iFPNP+Exg+uSbXcBcYxAHrzzHs8mf1xPGLBtLs60ASX4bOQBGEoYaKRylXi0dN2zjkLz8N7AJNfzuUDEIUV98QeZXlPY3VRA9IXMEeu9aa+3XiWWJEKDGBE8tcy1Hv2hEDdAU83M+ALjFvnc9ZrZQCYPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3MQb2yL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3MQb2yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B8A1F000E9;
	Tue, 21 Jul 2026 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654070;
	bh=jZtH3PKvsZ+Obm7xOHeYAn9ZTBc0dXufUDGizRup0DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3MQb2yLiUnaVwXqV1DiNNRtA3z7zPQIYnYYjYgTyAtq9KrVI+ksd9HD34me5spRD
	 nLPvpcdWBOUy2/OVdT3QJffxVFstQGxnVbIOWnc1uECKADo1mujRYr0T4zKeewwFDH
	 R5tbRPWWHYZz4dD6nAhdd+5g85cIgc8vn8oiFqQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Atish Patra <atishp@meta.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 1564/2077] KVM: SEV: Do not allow intra-host migration/mirroring of SNP VMs
Date: Tue, 21 Jul 2026 17:20:37 +0200
Message-ID: <20260721152629.670471889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@meta.com>

commit 6ee4140788234a6fabf59e6a50e38cdb936008cd upstream.

The intra-host migration/mirroring feature is not fully implemented for
SEV-SNP VMs. The proper migration requires additional SNP-specific
state such as guest_req_mutex, guest_req_buf, and guest_resp_buf to be
transferred or initialized on the destination.

The SNP VM mirroring requires vmsa features to be copied as well otherwise
ASID would be bound to SNP range while VM is detected as a SEV VM.

Reject SNP source VMs in migration/mirroring until proper SNP state
transfer is implemented.

Fixes: 1dfe571c12cf ("KVM: SEV: Add initial SEV-SNP support")

Reported-by: Chris Mason <clm@meta.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Atish Patra <atishp@meta.com>
Link: https://patch.msgid.link/20260602-sev_snp_fixes-v3-1-24bfd3ae047c@meta.com
Cc: stable@vger.kernel.org
[sean: let lines poke past 80 chars, tag for stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2142,8 +2142,9 @@ int sev_vm_move_enc_context_from(struct
 	if (ret)
 		return ret;
 
+	/* Do not allow SNP VM migration until additional state transfer is implemented  */
 	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
-	    sev_guest(kvm) || !sev_guest(source_kvm)) {
+	    sev_guest(kvm) || !sev_guest(source_kvm) || sev_snp_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -2865,8 +2866,9 @@ int sev_vm_copy_enc_context_from(struct
 	 * disallow out-of-band SEV/SEV-ES init if the target is already an
 	 * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
 	 * created after SEV/SEV-ES initialization, e.g. to init intercepts.
+	 * Also do not allow SNP VM mirroring until additional state transfer is implemented.
 	 */
-	if (sev_guest(kvm) || !sev_guest(source_kvm) ||
+	if (sev_guest(kvm) || !sev_guest(source_kvm) || sev_snp_guest(source_kvm) ||
 	    is_mirroring_enc_context(source_kvm) || kvm->created_vcpus) {
 		ret = -EINVAL;
 		goto e_unlock;


