Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065388;
	b=ZB/uJQdEBoccUCbeL7VPc6bn4pzpd1r5FT/PVzFL/1IdJZ+WU54Jyzgw5YhcwMex0t4K
	 Q0VQXPQi41WuVmGY5OKmvfSMqgCLWIW/H0sWrhe0W0w8Uo9GnG4w9GjUDPAjiQTKDbYwP
	 a2tVu5R+kPKULLRRWHZWpP2jqumFIQuQ7H5eNlvs02eifDFx1Tfx6Aj33zDaK+fPxf894
	 gbKVC67ZDtctoGk6YsyHTG0hUJxKuCJmrwwKIuhnbhCzC8S4V0y/ZA35/jUK+MkBqnxLB
	 AaN6wTOvj4+SsIK8yqO8dT2Dj1ZiPs29givVGAr9IrpdOrlQLsRL6fN6EFxZm7ZpFgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZiDkEdb4c77byVRX+GNrYGu32/O+mPv9IZaPt7Q3whI=;
	b=t/k7rQldjYFjnvfrotWiqw7Xcwx3/7k5X4VZdAYZZpPt+3Mn3OlpujXu7O+OLRJVYajF
	 RQn0JkJ68HoAb+3zvmC5LOWBkfeSHHpmsQovRtNyTNkcWUhEuEvvLVW0vVGEHyRv5IqEJ
	 PBXtFf543zWg+XUussK0bQcl5dMvd83xPzlVGYOcG2+adX+Z7vxlF6NdYJvUusMcZPtTJ
	 QO3rnP1K1e8B5n31FPTiYqxuDahT0B99i7EJp9Vt7byGi2Nipd5VY7tfcTMbt8vvdBj/z
	 IteoBjQtfyTg6POe0hmsXT8ltIrcl/98JDs6f57G5TNR4NuLoAj41SxWDBLVfyXBm8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YU/eSkKf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04DF606A32C;
	Sat,  7 Nov 2026 15:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YU/eSkKf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2B61F0089F;
	Sat,  7 Nov 2026 15:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065387;
	bh=ZiDkEdb4c77byVRX+GNrYGu32/O+mPv9IZaPt7Q3whI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YU/eSkKfMotRldA9fVKbW4k5poYK3RucAARmBVt+oZZ5Ki/R18nk/Bkr3Su1SabWK
	 HxhKEXIeUiyjhVMOxv0cH7toNIYQUNd92D3iiyCy3SYtFAI1jBH3CubIL+wUEFIDaj
	 O7GhCXPeZUXa4U1440DTIaeEeoKZ9C9zSwuo3gPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1111/1257] KVM: arm64: Set HCR_EL2.BSU to Inner Shareable for guests
Date: Sat,  7 Nov 2026 08:56:47 -0500
Message-ID: <20261107135009.931873941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 00e73757518020273ccf6308a51f214e58c21ad5 ]

KVM sets HCR_EL2.BSU to Inner Shareable for guests, so that a guest's
barriers cover the TLB and I-cache invalidations that HCR_EL2.FB
broadcasts. However, since HCR_BSU_IS became an alias of the generated
HCR_EL2_BSU_IS, it is the unshifted field value 0b01, which sets bit
0 (VM, already set) and leaves BSU at 0b00. A guest's DSB NSH is then
not required to wait for a broadcast TLBI to complete on other CPUs.

Build the field with SYS_FIELD_PREP_ENUM().

Fixes: d0f39259eff4 ("arm64: sysreg: Add layout for HCR_EL2")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261016081558.805411-1-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4bfbd827c5aa7..b3e9dd302730e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -98,7 +98,7 @@
  * TID1:	Trap REVIDR_EL1, AIDR_EL1, and SMIDR_EL1
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
-			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
+			 SYS_FIELD_PREP_ENUM(HCR_EL2, BSU, IS) | HCR_EL2_FB | HCR_EL2_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK)
-- 
2.53.0



