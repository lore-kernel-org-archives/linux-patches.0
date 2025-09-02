Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745332DC33B;
	Tue,  2 Sep 2025 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820619; cv=none; b=k8ale+kQBXHfJPzXLqu5hxTOTmDJhIoC60sTWzOAUGDdD63PmO9QCLiEqHR5DEYoCnuraDVRoaq8QwzzwK1oSL4VmypbKSdvbYe12+TU+8F4B0AR/PQU5aZbkebG7qqXRSMowo8ExLI9o3Mg8EICAxHIMu2mPmLKlrOhTxutAEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820619; c=relaxed/simple;
	bh=Nx5lrfRFTUOElT8SgY53eSHNNrE9j7gO8Eq80PtvIzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1D4l5DttmtjbGxGvYCEH0tAUSFBQxEkdKvRG/EbxVmBZwOz+BSpCXK8tgIeXg3LX63P1ZwlK9vpMzTEyPmonJ3s1cd11x8q7jF7v2npmnibLvCbiG7SXbet1DSW/ZREcXT45MVF/0+iA4ShZAGoHrQPPpPrwAk6bbQuKkg+0kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVhp2kYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVhp2kYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E41DC4CEED;
	Tue,  2 Sep 2025 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820618;
	bh=Nx5lrfRFTUOElT8SgY53eSHNNrE9j7gO8Eq80PtvIzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVhp2kYbCN9d8r+DBGITCPs8XUlhnW9EsA79NvL7uV1WOhZM03wp1CXoIP/drEz60
	 x5FPkwkCPzDXlR+PLQuhSXswL/O8W8UD6DGRZbWTiMMtDBztf7GxnkuwcjxxagUK1c
	 1AAuevEV+ytwJRQy5nbPzBaSM+X5UeqwaeUc3IGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/33] powerpc/kvm: Fix ifdef to remove build warning
Date: Tue,  2 Sep 2025 15:21:28 +0200
Message-ID: <20250902131927.454145079@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit 88688a2c8ac6c8036d983ad8b34ce191c46a10aa ]

When compiling for pseries or powernv defconfig with "make C=1",
these warning were reported bu sparse tool in powerpc/kernel/kvm.c

arch/powerpc/kernel/kvm.c:635:9: warning: switch with no cases
arch/powerpc/kernel/kvm.c:646:9: warning: switch with no cases

Currently #ifdef were added after the switch case which are specific
for BOOKE and PPC_BOOK3S_32. These are not enabled in pseries/powernv
defconfig. Fix it by moving the #ifdef before switch(){}

Fixes: cbe487fac7fc0 ("KVM: PPC: Add mtsrin PV code")
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250518044107.39928-1-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
index 6568823cf3063..5d9d38834507d 100644
--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -632,19 +632,19 @@ static void __init kvm_check_ins(u32 *inst, u32 features)
 #endif
 	}
 
-	switch (inst_no_rt & ~KVM_MASK_RB) {
 #ifdef CONFIG_PPC_BOOK3S_32
+	switch (inst_no_rt & ~KVM_MASK_RB) {
 	case KVM_INST_MTSRIN:
 		if (features & KVM_MAGIC_FEAT_SR) {
 			u32 inst_rb = _inst & KVM_MASK_RB;
 			kvm_patch_ins_mtsrin(inst, inst_rt, inst_rb);
 		}
 		break;
-#endif
 	}
+#endif
 
-	switch (_inst) {
 #ifdef CONFIG_BOOKE
+	switch (_inst) {
 	case KVM_INST_WRTEEI_0:
 		kvm_patch_ins_wrteei_0(inst);
 		break;
@@ -652,8 +652,8 @@ static void __init kvm_check_ins(u32 *inst, u32 features)
 	case KVM_INST_WRTEEI_1:
 		kvm_patch_ins_wrtee(inst, 0, 1);
 		break;
-#endif
 	}
+#endif
 }
 
 extern u32 kvm_template_start[];
-- 
2.50.1



