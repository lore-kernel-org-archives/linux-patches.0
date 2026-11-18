Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046860;
	b=w+54YveNSWB3Dj3ToP+yS6ORTIkBH0h205djtMt8migZIYR2HWDWxN0EapaHRJZ/F5ya
	 Z3YMMXtwGU8Twl2N/DuVRetA0hUVLg3JrgzfXA+JGeoy3o6xtNWmfQEN3P0gHo4wanBgA
	 uzEyvPf63EESWAx1MMk5C4JfU9ZradUT+w1w+qOB6267WTqPae+pjzk9/QcWD0lM+OVxO
	 c+RzPyMygsw2mblKJ/T46AnFVk/lm0I6wid8sJgwfD3HwIJirokSTFTrK+9Eei03QgjgA
	 NoS87wti+AdY071/ENbKA/Eom3hfzCeuAhUNI7q5qK9Fw4rO4q3H+uZFVK4+yQC6LXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f5PIqER3Ho+Bkly1Y2FRoFcEwBMlRDjyv+F3toQ6E/I=;
	b=hclT9J8bfTUKeAjmwY9izjnPgvZ053/PxnkhztF38vBy15cG88b/ggZZoFISsbbN4sTh
	 LqslmEXeMHm5cc4AS0mEjomYwnIKdAv5RcFel9uQHWRr9Q/C8LBbax0TwGvLruXzG417p
	 FrhBVr3bqXJZDp5lFPfHLHqT2rZg9mlV1LFCrqXBSXjVCL5Hq12YfuhGx2yUx3E1Fnnb9
	 rQSg3G+G/WUWK9Ac69ghiQwhcQTDIEvm/2E5/JT735ZRNALju7RAhFpF01KaE9pgsCwBw
	 575aWehPsQHIiBr9j7Hl3+YUWfcx63JcevGPddZXHTi8M95I+7P4Vh4K6ZFT+9goW6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yi5FEsmw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE098606A320;
	Thu, 19 Nov 2026 00:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yi5FEsmw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDFC1F000C4;
	Thu, 19 Nov 2026 00:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046860;
	bh=f5PIqER3Ho+Bkly1Y2FRoFcEwBMlRDjyv+F3toQ6E/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yi5FEsmwbq1WY/Kbof3vnDMipOpaXUjeYEeEd9YTFpqmx7dSOWLsDfPqdfRb3u14K
	 GFpb3Z1bPS5VMSlT9v6hAda/CXJCAmh6cYZMgHW6RmBVCrRbukdRMeM+X69zi0/AzN
	 UQ05t4eniTHae49sCk5YBtJdE+nvGVzHvT0qTBig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1433/2857] KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
Date: Wed, 18 Nov 2026 15:41:07 +0100
Message-ID: <20261118150252.911617837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted MAX_FEAT table entries to mask-based feature restrictions with explicit signed-field clamping ]
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
index 3d5121ee39777..20ba05ff34209 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -190,6 +190,15 @@ static u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
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



