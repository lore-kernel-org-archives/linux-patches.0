Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038292;
	b=jlFMF4kaW0v/nmaMKZIQfzXmdoakfDDuVUBNtCoJsOYeqeimWLOBp2sZqH0lt33DBfrv
	 BfiEtv6Wgqhzukq9mM39aF1wJCpBWLrdPbYlFxJbhdG0aka7LACaBVCq+3UaJBGurOZar
	 vA5GQ0I8m+3vwGFp5ebU5G2nTGuoMGw9cKLmh7yzFI7p2JrDAYae4k95C1FlOXK20zPKJ
	 4HGEsOLlh3EzCKah0iFR2KF2k0pm3bF/R9h/lMJ6gOWxqTUZacfHPQek9TD8w/Ib5kZEq
	 rWcmeRYTAygoQcjNPLtvlzowNJ2mjUI3Hw7WXuQAnDQKCBbIyqZE4EehmSxXWXUcZvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OEsyW9hVQl+rHnYN1yxRtPRw8Kr6xxlcqdleexQV0Nw=;
	b=dFf608O6ITavbmXc0c2GJcCP1SJyD4NZm3mhvp9k9n7BGbhyj9C+nzl26IVoxX59iEy4
	 gnBfK7Wx97CZfYfvgxYD5ugwRlOLfy2026dSg5yMkItsb1eQpNl04JwgrZsYcLcPzoBk/
	 As3DH/fDwSb5cpi+d0MG3BVhWL1+GioeZeM3KWSFvVTrQmtNvsQbRCy+Zue/8nzh2YUMj
	 f5FfA30c5+CALH6/K6Rvr8KiVBaaJZ/DWQBFrd2ZQ7E6KC2HfIkq4g+/lXaoCJbFGl1rV
	 JXg46Dz/t9y1f3sWCT3miiYjsEiCMyJBIZTNQ2lUIVaLAm8FA4g8xCPPIkDYsZU97uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAeUoHye;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E198606A320;
	Wed, 18 Nov 2026 21:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAeUoHye
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19BC1F000C4;
	Wed, 18 Nov 2026 21:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038292;
	bh=OEsyW9hVQl+rHnYN1yxRtPRw8Kr6xxlcqdleexQV0Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAeUoHye0MqoYKBmVCjJet+j6itQVSg8B5Ftam+5PM/wuqAlo/v1UjpfAmwVB9WmV
	 73Ulocrk6ZaTS4goc4VtN1Wtslqlqw4O4SY2DUIkNCwXEb8AubVe9MNW5iO7vV1dYk
	 AMyUrfW6YS6fdPKNvYIDpz1fSO6agxEifTcVVYHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1691/3318] KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
Date: Wed, 18 Nov 2026 15:38:33 +0100
Message-ID: <20261118150412.560172917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 6c29285e78b5e4811145ebda382ac0ba732ce56a ]

Protected VM ID register emulation leaves unlisted fields at 0. This
creates two issues for TGRAN:

  * TGRAN16: 0 means non-implemented. It prevents 16KB protected VMs
    from booting even when the hardware supports it.

  * TGRAN4|TGRAN64: 0 means implemented. This may falsely advertise the
    feature even when the hardware does not support it.

Advertise all the TGRAN fields in pvmid_aa64mmfr0 so that the hardware
support is properly propagated.

Cc: stable@vger.kernel.org
Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260928095454.3255918-2-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: adapted MAX_FEAT table entries to mask-based restrictions with explicit signed clamping for TGRAN4 and TGRAN64 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 3 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c             | 9 +++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 37440e1dda930..fc765894f3f31 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -90,7 +90,8 @@
  */
 #define PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED (\
 	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_PARANGE), ID_AA64MMFR0_EL1_PARANGE_40) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_ASIDBITS), ID_AA64MMFR0_EL1_ASIDBITS_16) \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_ASIDBITS), ID_AA64MMFR0_EL1_ASIDBITS_16) | \
+	SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16, IMP) \
 	)
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index edd969a1f36b5..7614978a548d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -191,6 +191,15 @@ static u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
 	set_mask = get_restricted_features_unsigned(id_aa64mmfr0_el1_sys_val,
 		PVM_ID_AA64MMFR0_RESTRICT_UNSIGNED);
 
+	set_mask |= SYS_FIELD_PREP(ID_AA64MMFR0_EL1, TGRAN4,
+		min_t(int, cpuid_feature_extract_signed_field(id_aa64mmfr0_el1_sys_val,
+							 ID_AA64MMFR0_EL1_TGRAN4_SHIFT),
+		      ID_AA64MMFR0_EL1_TGRAN4_IMP));
+	set_mask |= SYS_FIELD_PREP(ID_AA64MMFR0_EL1, TGRAN64,
+		min_t(int, cpuid_feature_extract_signed_field(id_aa64mmfr0_el1_sys_val,
+							 ID_AA64MMFR0_EL1_TGRAN64_SHIFT),
+		      ID_AA64MMFR0_EL1_TGRAN64_IMP));
+
 	return (id_aa64mmfr0_el1_sys_val & PVM_ID_AA64MMFR0_ALLOW) | set_mask;
 }
 
-- 
2.53.0



