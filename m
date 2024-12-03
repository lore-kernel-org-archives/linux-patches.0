Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D69820B7EC;
	Tue,  3 Dec 2024 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240097; cv=none; b=J/SVQjm6MbsIutYFe+X44BCqnFrX1vn6pB26npGNxh/kIL38IxfR2Wab/3IFnvIQApnHp5mXcOqPU+++QkZvruVBtmOVJpFdFg+FHxnewj8lmGCxTq9+ZKhTLqxChMYNFNtfpfXuo13C2IHJx+bzNCJYAwNP10HNBGW35/ItzJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240097; c=relaxed/simple;
	bh=5+W4gjrn98xvKEVEhhop0IHnjAr6scFb9D2CEncwEKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sD7zSep5Q/e0ZBNFd0q42lEu/jKE3Pk4dq+7C2V8ZtDdKet7z6LvlxCZPOA91W2dFNZLL3mQjfreQXyEx2/QEwhoh3WgBkAUkcMgtOBoMw30rn84rLxw1fcMUoF0u4+r6QdHX0+G420NdvokkfK9jfHc7JgmVKaXRbxcDQ9NPJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMeJCi3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMeJCi3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5865AC4CECF;
	Tue,  3 Dec 2024 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240096;
	bh=5+W4gjrn98xvKEVEhhop0IHnjAr6scFb9D2CEncwEKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMeJCi3LdTN0z4yJl1QHlJIw9VUgnfs7VK5BwdFvgWz8OP6AywkT6DMC80h7Fqg8X
	 L6P8j3eRIOSO3t/2ffe4grZBaZ4yXjsaXPueOHwnVIkAJ7CLbTqiR1gpqLNFa8CXqC
	 UXk0UGN9mPg410dMXleFGmgoZOSFMS8b5hgSC9cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/826] arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature consumers
Date: Tue,  3 Dec 2024 15:35:48 +0100
Message-ID: <20241203144744.286242708@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 2287a4c1e11822d05a70d22f28b26bd810dd204e ]

Despite KVM now being able to deal with XS-tagged TLBIs, we still don't
expose these feature bits to KVM.

Plumb in the feature in ID_AA64ISAR1_EL1.

Fixes: 0feec7769a63 ("KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20241031083519.364313-1-maz@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 718728a85430f..db994d1fd97e7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -228,6 +228,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_XS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_I8MM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_DGH_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_BF16_SHIFT, 4, 0),
-- 
2.43.0



