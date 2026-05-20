Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705B42DC76C;
	Wed, 20 May 2026 17:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297533; cv=none; b=IOpJnnhUE/UEs+PQioY992OuHAa2AHm3WhuIlhQhTNojyByW079Ibkp0FT+wbIP4Gp/CXBR3YGL2Tysj7NfBn58aykxKfoCN/WbeXgcXD9im1kiPadyjR0oPa5wN+CQZTXbM3f5jWOWOHZEbplCFhEOz6RoBbmB2ZOGxT0FggeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297533; c=relaxed/simple;
	bh=dwAh/kDjJLJJsDftMJjT02E4V/3N59KcuEOWxxbKUuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lew6pxmdmbDyu0nvW1DMk4M3fOhFGGExxBIZVV7DU9Uyl0Sny49hb8ssJIahe4hwfm0GI7Mc3W8vKIgJM9topqBCd1fBMjoEERH/9AxaiHTSxttc6Ot0aYnkQn4097XXsW5uCC9vjsqUnmF831ZmXyeDhi6KdewV8Uow1fzdqgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1Gedyf8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1Gedyf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F61F000E9;
	Wed, 20 May 2026 17:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297532;
	bh=b9fROuNLzeaV+AkB1TUvwq0REh4VBSpXbkjd9qgXTXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1Gedyf8kRB6JyRinRNoHkleD6WxFav38+9zPvgd7eOxV2PLgyIxTF2FaLitt4TVZ
	 Q5K5DYjMPvLx4wGC9hK6MFSU91+pUpnGue8u4Y1Mf2ofTx8uDboOEKXbzyBSU/qfoD
	 lUMpWDx4DswLHR44h7AsBZt6KpOgLP6sF4N83uVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/957] x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE
Date: Wed, 20 May 2026 18:08:43 +0200
Message-ID: <20260520162135.429140060@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit 3aecb2e7b948400354399b26f3f1653bd2c1bae0 ]

The TD scoped TDCS attributes are defined by bit positions. In the guest
side of the TDX code, the 'tdx_attributes' string array holds pretty
print names for these attributes, which are generated via macros and
defines. Today these pretty print names are only used to print the
attribute names to dmesg.

Unfortunately there is a typo in the define for the migratable bit.
Change the defines TDX_ATTR_MIGRTABLE* to TDX_ATTR_MIGRATABLE*. Update
the sole user, the tdx_attributes array, to use the fixed name.

Since these defines control the string printed to dmesg, the change is
user visible. But the risk of breakage is almost zero since it is not
exposed in any interface expected to be consumed programmatically.

Fixes: 564ea84c8c14 ("x86/tdx: Dump attributes and TD_CTLS on boot")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
Link: https://patch.msgid.link/20260303030335.766779-2-xiaoyao.li@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/debug.c         | 2 +-
 arch/x86/include/asm/shared/tdx.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/tdx/debug.c b/arch/x86/coco/tdx/debug.c
index cef847c8bb67f..28990c2ab0a14 100644
--- a/arch/x86/coco/tdx/debug.c
+++ b/arch/x86/coco/tdx/debug.c
@@ -17,7 +17,7 @@ static __initdata const char *tdx_attributes[] = {
 	DEF_TDX_ATTR_NAME(ICSSD),
 	DEF_TDX_ATTR_NAME(LASS),
 	DEF_TDX_ATTR_NAME(SEPT_VE_DISABLE),
-	DEF_TDX_ATTR_NAME(MIGRTABLE),
+	DEF_TDX_ATTR_NAME(MIGRATABLE),
 	DEF_TDX_ATTR_NAME(PKS),
 	DEF_TDX_ATTR_NAME(KL),
 	DEF_TDX_ATTR_NAME(TPA),
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 8bc074c8d7c6a..11f3cf30b1ac8 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -35,8 +35,8 @@
 #define TDX_ATTR_LASS			BIT_ULL(TDX_ATTR_LASS_BIT)
 #define TDX_ATTR_SEPT_VE_DISABLE_BIT	28
 #define TDX_ATTR_SEPT_VE_DISABLE	BIT_ULL(TDX_ATTR_SEPT_VE_DISABLE_BIT)
-#define TDX_ATTR_MIGRTABLE_BIT		29
-#define TDX_ATTR_MIGRTABLE		BIT_ULL(TDX_ATTR_MIGRTABLE_BIT)
+#define TDX_ATTR_MIGRATABLE_BIT		29
+#define TDX_ATTR_MIGRATABLE		BIT_ULL(TDX_ATTR_MIGRATABLE_BIT)
 #define TDX_ATTR_PKS_BIT		30
 #define TDX_ATTR_PKS			BIT_ULL(TDX_ATTR_PKS_BIT)
 #define TDX_ATTR_KL_BIT			31
-- 
2.53.0



