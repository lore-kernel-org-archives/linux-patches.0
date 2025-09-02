Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AC92DD5EB;
	Tue,  2 Sep 2025 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819450; cv=none; b=CWuVlBHEBzI9ZrGNlFL8bFWBV3Lzp0dr4qFzlMHvaNBnrrCCDZseSL0OUaFJw0qvQNwicYmC0nAr464n3Xb0ZLuSvA47Q2xBpgL1rJDDvffhfMW1xnDdynUaVXFemZgt3f6lKoFa1VJXcoftKI+Nsik3xHq6H0sWjBsP+wxbWao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819450; c=relaxed/simple;
	bh=9nlB2vPbfg9KxBpgaGZsrnEC1VoUdhNJw3kpAXWZ4bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8nabI5VDtnZsLU+C0oLL6utBgTCN4msxLkaMBFkSP+3LwYvL9Ubu//HlMZfSMJ2jnN5sOnMkfPDBYDWI2PacykommWcJdMrNzjVTfSzsG0NYx7i/bJcvwwv5iU2uBAE6Dydhs2rkbvHd3pF1DwQRZ5ZM7paXB55+gRNLwQaFz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edOLtf8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edOLtf8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F59EC4CEED;
	Tue,  2 Sep 2025 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819449;
	bh=9nlB2vPbfg9KxBpgaGZsrnEC1VoUdhNJw3kpAXWZ4bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edOLtf8R6NfK0TQVuKmdSkvp10Y7CzSP5mfNKlEFDK/PkLAGIHBMrZg959xUYu20r
	 0+y9v39HVHODzH1Uyp8CFizih3GMBRV2lYz24yF0XLNjmChuOkCCQcizAVeMEOL1u8
	 +4DUs4VmWKabw8ZwUEzq+3lAZ0E8BQxclNG50Y5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 038/142] powerpc/kvm: Fix ifdef to remove build warning
Date: Tue,  2 Sep 2025 15:19:00 +0200
Message-ID: <20250902131949.607560836@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



