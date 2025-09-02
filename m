Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C5D299AB5;
	Tue,  2 Sep 2025 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820394; cv=none; b=lpx0kUAZHkzN2AfUyH10ekOvHLYxLCoOXZ89+6xHa+K7e+O6S5PVqpqfb0A5G5+E5IBFj3yMUy8ekTY0qAe9Voyjy0vhnLre5vJdsWBaNozJjZMk42tWvl7ThiD/4nHwWSpwOQoIl9BrJ0e+R25o/0OgPoOPRmsiSze/8lJpfhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820394; c=relaxed/simple;
	bh=wl+KpYpHxK0NxzKQdzURtvxLHqf+ld45kIShL/6X75U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u139Bx5jpxDA/udrGGsBtIzUMHTWb7pXWTNizAmie/SKd8otGzYC6dppSAwFXw0aJUnzwFB019TKpdmhPI3uIe2NPZ7mJTL4luI9DAxJ1ZCxVke5AAnJZlmz33Qma3j5sMY1so+6WHr8a1IXdoIKTr4dkpqTQZTDq0G14j4oN8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkjYgPbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkjYgPbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC58C4CEF4;
	Tue,  2 Sep 2025 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820394;
	bh=wl+KpYpHxK0NxzKQdzURtvxLHqf+ld45kIShL/6X75U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkjYgPbb4k+3PJy0Luzh6ed9Jm/kINKsgBB3IQk+0qwzj5/3BNgkvAerzci/wB+YO
	 hCHCIJpp8PsFPuZRp3XnV+jeYOoQISTR3u50YYSRTedQCbPBzvT6OqsLAfRbB6Ad2C
	 E1ZWOwDD0dgYBWVYuSQ4FkX8Y5NOkx3QRuET3wXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/50] powerpc/kvm: Fix ifdef to remove build warning
Date: Tue,  2 Sep 2025 15:21:06 +0200
Message-ID: <20250902131931.123263886@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b3c093611baf..7209d00a9c257 100644
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



