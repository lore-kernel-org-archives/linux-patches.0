Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF7A1A619E;
	Tue, 30 Jul 2024 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357470; cv=none; b=F05Pvq8lR5laiIxCTovurJccHsWTdXq6VSK6HYu673tpSOS2YTEkPRfkLBsf7tGvf/2W5HtY5sWLgt9PLEgB5JInSQdI+Eq4G65NaBhryqeAUs39pZIsUKJ02n0jidSTWUX9MKIy2xtRMPEPFl7MnvBltg8XHQQ+bw6qvttqjMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357470; c=relaxed/simple;
	bh=mnh2fBvmE+Y/+kJh5P7gBnGOppYaH2ECI28tvQkJbNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckBgVpg5qeW8hH1quIk07kqss6Jdac2D5KrICPHq6BTwzmNp/TbqduF3r/J+sRuiMpSA0CMDtZy5qf+A8rMCDelX7aA5MpPSLBvYbW6hsyBOpk+q1x9S/X4J0IIgSSdl7XRcHlOW1Z9Zbnu4rynfDu9lBNp/WYpH7K8qVA/RhQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOUahgOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOUahgOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1D4C32782;
	Tue, 30 Jul 2024 16:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357469;
	bh=mnh2fBvmE+Y/+kJh5P7gBnGOppYaH2ECI28tvQkJbNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOUahgOAgpWBhhjqT5ypRnImjd+mZSsRfqZbjc1rajlvZuXHwLIsEHEMufxJ9fS6a
	 NMqLHbfQbw0mFf5QIodzT5ujp2asid65Ew0Pu+bUXojmw97wISgtubsY55oVYps7s8
	 KGTMVNTgNi6n8fzKbArZ7WaOM5vvH9T/At6ECN8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/568] KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
Date: Tue, 30 Jul 2024 17:46:05 +0200
Message-ID: <20240730151649.961821709@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

[ Upstream commit 009f6f42c67e9de737d6d3d199f92b21a8cb9622 ]

The kvmppc_get_one_reg_hv() for SDAR is wrongly getting the SIAR
instead of SDAR, possibly a paste error emanating from the previous
refactoring.

Patch fixes the wrong get_one_reg() for the same.

Fixes: ebc88ea7a6ad ("KVM: PPC: Book3S HV: Use accessors for VCPU registers")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/171759278410.1480.16404209606556979576.stgit@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1e668e238a288..1bb00c7215440 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2249,7 +2249,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, kvmppc_get_siar_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SDAR:
-		*val = get_reg_val(id, kvmppc_get_siar_hv(vcpu));
+		*val = get_reg_val(id, kvmppc_get_sdar_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SIER:
 		*val = get_reg_val(id, kvmppc_get_sier_hv(vcpu, 0));
-- 
2.43.0



