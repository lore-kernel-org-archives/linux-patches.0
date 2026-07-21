Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570946D0A0;
	Tue, 21 Jul 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656203; cv=none; b=G/e8LV5BGVeVBSNiYK73H1dkqYNPxdtpPzq0+UlHoRaW7RbA1M3sHwMxqRh72RAqAfilp8Wry4/5Khjm0ubY7GeKk8BvyHdf6LhQlu4mopaZBcLlvN7SsqCFEk0WHoky95UcmRXxBU+sACIxonMnrdonz99XnuJ1XSP2LSafESE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656203; c=relaxed/simple;
	bh=15wD2hx5X2+ErwnnDbtWhGYSAXQjRLXMPdpSdN/tKwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOgfwP30a7FaYsc8miRtnLIxMbkhnJTPgNAtZ4TWFpquzrhusiIrwu7Z3e4ZG1mLoDWC6Fv0vSh48qL+6cJUlYOL82SpzxWaufggslZM++RKoOqeVSaK0pLHpGmmn7grfm3hmL33gZAP4lzJ1mIi+t5uavJx2MKw9iHD5uZ9UrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJuBjNAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJuBjNAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D207F1F000E9;
	Tue, 21 Jul 2026 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656202;
	bh=WO3t5FKhMrkTi2z6LV+M4DZuo+wX2X9yTAwlhve2DXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJuBjNAK5j/NCs4H3qBKfYcvIrnf1gNyAKneTGRLcacmThyMNUQU55pjXIRIkOPyC
	 Z2aySzUFZdKDOIMiGAi3LEIz1lFnoDqeH/G63SRDlHODCoYSkh7FOd+zmxz9W9RWI4
	 0/oq9EP16dJ4x+ADuUlBBMtUbEsCh687RwvR2X08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0299/1611] x86/cpu: Keep the PROCESSOR_SELECT menu together
Date: Tue, 21 Jul 2026 17:06:55 +0200
Message-ID: <20260721152521.799293063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1df61a8b2d01c560822a0421f2a76af7fda34c1f ]

Having a stray kconfig symbol in the middle of the PROCESSOR_SELECT menu
(this symbol plus its dependent symbols) causes the menu dependencies
not to be displayed correctly in "make {menu,n,g,x}config".

Move the BROADCAST_TLB_FLUSH symbol away from the PROCESSOR_SELECT menu
so that the list of processors is displayed correctly.

Fixes: 767ae437a32d ("x86/mm: Add INVLPGB feature and Kconfig entry")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260519173526.10985-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig.cpu | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f928cf6e32524e..755d64bb9d2652 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -358,10 +358,6 @@ menuconfig PROCESSOR_SELECT
 	  This lets you choose what x86 vendor support code your kernel
 	  will include.
 
-config BROADCAST_TLB_FLUSH
-	def_bool y
-	depends on CPU_SUP_AMD && 64BIT
-
 config CPU_SUP_INTEL
 	default y
 	bool "Support Intel processors" if PROCESSOR_SELECT
@@ -482,3 +478,7 @@ config CPU_SUP_VORTEX_32
 	  makes the kernel a tiny bit smaller.
 
 	  If unsure, say N.
+
+config BROADCAST_TLB_FLUSH
+	def_bool y
+	depends on CPU_SUP_AMD && 64BIT
-- 
2.53.0



