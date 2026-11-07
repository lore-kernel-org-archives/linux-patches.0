Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061351;
	b=E7Z3d2sJAizHcr6nWqkcu87LfzQ6+oebpBC7KaXq3prV8pRMfLfFdfyZRuMlepuFLmfD
	 cBb+Pn/mpSFaxie71hfe3VxZxFLnxe+xqc+xUmTkrotLjWnzTdJ29i0s1NRdqJL20U6ud
	 vaJd/zy8Bus3pcnx7krqHvL3JpxE97iCxnMNju5lnC1BK6ZROcqmksFaeKFRcVRtA2t1M
	 4LIua/AzpNnXzXu3qGMBae5XOBZFiYgsPnqq55QgftJyVNEHilPYPKx0kYw6oBtzAIVKs
	 QayPo2G9HR6MrlDHgIYbv0iqezsRsSwJHqROgM8oYsJj0D3+0uMOGSznYV24+N2H7XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VoVbQ8mNpox28OIX7pUH/cm9bIy+BHRqI6yl3WsThkc=;
	b=ulgKWXAkAoGb7/6Xh7n+cAAQ7FHRbUVFlkXY90AGD3l6nfaYet0sE/6xQ4D5rS9x3XXG
	 BskjvqtOIPy/kJ94zvpjyypfynoydq8qDwXvOGnSFJX4LsoM/x/700OtyFaNb9zbb3JNL
	 xaWxxna/5VZ5/3oPAd6IykZAqom0kqqKLBOvasr6JBWHw9gLXXyBiqapFJpRp2nSOId7f
	 AHFXgR2ou4xKlj2yGFrhwj6xfDFibsHI9tGsEhSdhYHJCIpONoRCK+Ou1kiBAIvp6H9Et
	 SG8Y12M+YUIXlwwvBIJNI0+rvisYGgSTdNDAc1/CohFQjRlx8Uf9GMM/pfn+yBouMCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cc3/V79I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EA5606A326;
	Sat,  7 Nov 2026 14:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cc3/V79I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815321F0089F;
	Sat,  7 Nov 2026 14:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061350;
	bh=VoVbQ8mNpox28OIX7pUH/cm9bIy+BHRqI6yl3WsThkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cc3/V79IdE3qM2RcjcuXUnqQ1hlmWXBDkafz7rwJEQQOA0qzd+kgepHAma20QI/7r
	 akZsT7R9HNBofyWxxeXIXJkQdXF2BJPt+dQcZrwrESqt7gR02bqFO61sQn5TtF9hTo
	 zRaLdhfdN1fJPePeAd5V7fOeBwrNGBvDjqMNh5hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0478/1536] LoongArch: KVM: Check kvm_request_pending() in kvm_late_check_requests()
Date: Sat,  7 Nov 2026 08:41:34 -0500
Message-ID: <20261107135010.919909569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 14d2714d6537a9df5bea2515185034dbb9d30f03 ]

Add kvm_request_pending() checking firstly in kvm_late_check_requests(),
at most time there is no pending request, then the following pending bit
checking can be skipped.

Also embed function kvm_check_pmu() in to kvm_late_check_requests(), and
put it after the kvm_request_pending() checking.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 32d05564a612 ("LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/vcpu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 92c0c38b1bad1..92a1fff0829c3 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -143,14 +143,6 @@ static void kvm_lose_pmu(struct kvm_vcpu *vcpu)
 	kvm_restore_host_pmu(vcpu);
 }
 
-static void kvm_check_pmu(struct kvm_vcpu *vcpu)
-{
-	if (kvm_check_request(KVM_REQ_PMU, vcpu)) {
-		kvm_own_pmu(vcpu);
-		vcpu->arch.aux_inuse |= KVM_LARCH_PMU;
-	}
-}
-
 static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	u32 version;
@@ -221,6 +213,15 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
 static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
 {
 	lockdep_assert_irqs_disabled();
+
+	if (!kvm_request_pending(vcpu))
+		return;
+
+	if (kvm_check_request(KVM_REQ_PMU, vcpu)) {
+		kvm_own_pmu(vcpu);
+		vcpu->arch.aux_inuse |= KVM_LARCH_PMU;
+	}
+
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GPA, vcpu))
 		if (vcpu->arch.flush_gpa != INVALID_GPA) {
 			kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
@@ -280,7 +281,6 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		/* Make sure the vcpu mode has been written */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 		kvm_check_vpid(vcpu);
-		kvm_check_pmu(vcpu);
 
 		/*
 		 * Called after function kvm_check_vpid()
-- 
2.53.0



