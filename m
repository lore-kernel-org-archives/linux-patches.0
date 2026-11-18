Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059356;
	b=xEdd2Eb8l65ldX7EfKPbB9vSpGBHtqP535bUL54hYdyszfvGKbl53sOxzEzLTdRGkKRE
	 /a3yaw12RL/g4VJQQz0AT0eYnrBOnNtD/85UQfQ6mBXKcnXfhpPTWb3jEvWpy31TvOnlI
	 XedWNve61SArNJLKC+chz4ieEGP3EVNysSUuii2eLoNDX5UGhcUpjZVLBL8apEcD7DGKy
	 d5zknCHp409MqliROWUy3Qx0299qrnhNLrBeQYys7zZAErI4xm+2XhJ80lJ0M1mZnNNYn
	 /vzfxEMKouMvnxjBWZdPZarAaC9W0tLHcEGTF3Lq+kpQo3CkDdKvd53rjF7VpAc/BCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jrc/5ZjPBX/lN+WCPZVOT8gz/WUI2HSdGdkGR87PgEU=;
	b=co8dUcz0ysoNKsxWh37Y/QhejmVtf+fBLzYM2m9/Qz+8sgsfmQ+50DyCEVJs0nRBDyuJ
	 h1ksf/aT82SZ28LdDbDGpuhJNkAtpF5WnRqja8KlxzSY+8gVUaYgbmWXGxxO1xn03rzGv
	 l+ishr3u/dIZ4OkNku3gHVXVjJ20MdYzs5q0ZvNlWFtVSRYt+PzzdyZq3eu2MYPyFB5oW
	 camM2OdX7+QysdLlMN8gqyZJ7O5GEdbQ4EuHDhP+oCcgt9kKskZNpVJ5+NYb1dIpKcrlK
	 Hvf6xRoLKQvZYcBWTlCkK0ELuLveCFujdgRMqaESl+hPh0WSKILWq9eQCvayqnW/1Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G61xdAbc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7758606A320;
	Thu, 19 Nov 2026 03:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G61xdAbc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D301F000C4;
	Thu, 19 Nov 2026 03:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059356;
	bh=Jrc/5ZjPBX/lN+WCPZVOT8gz/WUI2HSdGdkGR87PgEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G61xdAbcnKbR7dIb6RuyjzxwCpmzGSt+DiXZBcUBYEvyqDV2IMDdH3Dd5nRQzEWMQ
	 akcykWKgi3membojRGHon2koljcyuLQwWQDRh3rvTFzssi0LWay6z8dFtyWh2WK93F
	 19RHHzEXYSwOUgw4VbtGM2wYbWNEeXtSoTjl5QMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0813/1848] KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state
Date: Wed, 18 Nov 2026 15:47:31 +0100
Message-ID: <20261118145950.386351021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 1c4c84a643b704e473cb171f7b61359ff29b12a4 ]

Force EFER.LMA=0 if EFER.LME=0 when preparing L2 state for VMRUN, i.e.
mimic real hardware's behavior of ignoring EFER.LMA if EFER.LME=0.  VMRUN
unfortunately allows the nonsensical combination, i.e. doesn't fail, but
KVM itself has an invariant EFER.LMA can be set et if and only if EFER.LME
is set.   Breaking that invariant can lead to a variety of issue,
particularly in MMU code that keys off EFER.LMA when determining whether to
emulate/virtualization 4/5-level paging versus PAE paging.

Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260902232028.2767071-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: adapted cached EFER access to a local READ_ONCE() snapshot of the guest VMCB in nested_prepare_vmcb_save() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a87df5804a766..854c0d2e665ec 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -403,6 +403,8 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
+	u64 efer = READ_ONCE(vmcb12->save.efer);
+
 	/* Load the nested guest state */
 	svm->vmcb->save.es = vmcb12->save.es;
 	svm->vmcb->save.cs = vmcb12->save.cs;
@@ -412,12 +414,16 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 	svm->vmcb->save.idtr = vmcb12->save.idtr;
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags);
 
+	/* SVM ignores EFER.LMA if EFER.LME=0 (instead of failing VMRUN). */
+	if (!(efer & EFER_LME))
+		efer &= ~EFER_LMA;
+
 	/*
 	 * Force-set EFER_SVME even though it is checked earlier on the
 	 * VMCB12, because the guest can flip the bit between the check
 	 * and now.  Clearing EFER_SVME would call svm_free_nested.
 	 */
-	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
+	svm_set_efer(&svm->vcpu, efer | EFER_SVME);
 
 	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
 	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
-- 
2.53.0



