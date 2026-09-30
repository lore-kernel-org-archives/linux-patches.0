Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE553BE642;
	Wed, 30 Sep 2026 18:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792512; cv=none; b=ED23MxOiEgO9niZ/Q2WkcHOyPJPlxoJOKmp50exUBPPuFKM6/9OZaGwYwXZ0eJjMvnSjDv1xnzkldQrfakVHsVPaGCxUT90+tKjTvXVj/dGcAMt4E9yBAbz24UWtbKpqFCagx/wsqNdOOLiy97sj62skv+jqSFi/xxYdKBiTyrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792512; c=relaxed/simple;
	bh=tphjjUBj27OihcfYy6YrqD4n6a64/bp0MGrn5gGNJTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3Ku0Ilf5VN6z5SpgvQWSTujYCIdd5DQjPPVRxh4OTxhbM5JHo1SFUQtjOL1pHHhclCUmGhL+i49drVhmyniLjdL9J55QCBqeHO8VM71ULM1w0f2AmaJMiKnvC4BYgb1+1QZaN3vyuOsNUl9uk6e4zG3mwyZhSKagwnn975e6FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZWM3tDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZWM3tDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8F61F000FF;
	Wed, 30 Sep 2026 18:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792511;
	bh=MwxG+xXK4KgIllwLoY/8GcvEBrMlF1dtQQzs/YKcGug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZWM3tDFZLj7AGdMz1DIxZR5RwqUszAbWNJ7kwcVSV8OYk0+jgO4WohVDNBO0pbNN
	 O+hyYkO8UpLXlK72vE/WkJEJ58rRvHrohrkI0QgCIz40mjYHQonrCNfvgvdObXX7Of
	 yq1J01t3KD/9kNVLygLpPcfChFesDS99GjoUKCFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 681/752] KVM: x86/mmu: Use a bool for direct
Date: Wed, 30 Sep 2026 17:29:11 +0200
Message-ID: <20260930152412.979391290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

commit 27a59d57f073f21f029df1517c2c0a1abea5b0ce upstream.

The parameter "direct" can either be true or false, and all of the
callers pass in a bool variable or true/false literal, so just use the
type bool.

No functional change intended.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220516232138.1783324-3-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c0257bbb25c39..f5cfbf973e859 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1738,7 +1738,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2079,7 +2079,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	bool direct_mmu = vcpu->arch.mmu->direct_map;
-- 
2.53.0



