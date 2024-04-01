Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD726481B8;
	Mon,  1 Apr 2024 17:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991241; cv=none; b=SLm4p/XsIfMMDh66EGmJG7mgghvBP2rAuPd5rPyPsN+1BC2V4uWtyu90qfBAHctkI5ST/LLdEMOhPAMx/zyuagYzOoYULkg+VDYI4JHdCrfEzQDa2MWZIDkcVVfwjnrflaftF1siAiqB11pLHd8iAzVpz3tay9Y3RCq3NDORYVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991241; c=relaxed/simple;
	bh=ijvwvVPozOxAF87l694yubBP7RzZQBLzXicUQAr0UDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kl6W/LDpZVMWLo4xh61Q1WwRQMWWKKeWhx3QINx3FXkYADR5g6llmaB8K95SDoNMxQO/+yMvJ8l7FSbmVLQfCMCOy8hUktjEDCd091WowGgbe/PLsdLAMe2GewgJNv2jJrIVVV8RiLJ4E12AcWdkcXyWUZKMu9JHiWlab8kbMRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neJZBwtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neJZBwtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323BAC433C7;
	Mon,  1 Apr 2024 17:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991241;
	bh=ijvwvVPozOxAF87l694yubBP7RzZQBLzXicUQAr0UDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neJZBwtF8aOsPXlPnGmcz8yz02wSmokYOOeYVp2iDvAtCa1VYfJIc48ujhsZZL+El
	 zO9FHRIp6oJIACPTdGLn0PLX1DHxgy8ZQl6zJGBZR2yVo7C4atInXyE3Ask/jMIu1+
	 BeNEvCCBA7rcfj16ohE+/cg1aUw5hYA7QbLkv/Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 205/272] x86/coco: Export cc_vendor
Date: Mon,  1 Apr 2024 17:46:35 +0200
Message-ID: <20240401152537.307637014@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 3d91c537296794d5d0773f61abbe7b63f2f132d8 upstream.

It will be used in different checks in future changes. Export it directly
and provide accessor functions and stubs so this can be used in general
code when CONFIG_ARCH_HAS_CC_PLATFORM is not set.

No functional changes.

[ tglx: Add accessor functions ]

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230318115634.9392-2-bp@alien8.de
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/core.c        |   13 ++++---------
 arch/x86/include/asm/coco.h |   23 ++++++++++++++++++++---
 2 files changed, 24 insertions(+), 12 deletions(-)

--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -13,7 +13,7 @@
 #include <asm/coco.h>
 #include <asm/processor.h>
 
-static enum cc_vendor vendor __ro_after_init;
+enum cc_vendor cc_vendor __ro_after_init;
 static u64 cc_mask __ro_after_init;
 
 static bool intel_cc_platform_has(enum cc_attr attr)
@@ -83,7 +83,7 @@ static bool hyperv_cc_platform_has(enum
 
 bool cc_platform_has(enum cc_attr attr)
 {
-	switch (vendor) {
+	switch (cc_vendor) {
 	case CC_VENDOR_AMD:
 		return amd_cc_platform_has(attr);
 	case CC_VENDOR_INTEL:
@@ -105,7 +105,7 @@ u64 cc_mkenc(u64 val)
 	 * - for AMD, bit *set* means the page is encrypted
 	 * - for Intel *clear* means encrypted.
 	 */
-	switch (vendor) {
+	switch (cc_vendor) {
 	case CC_VENDOR_AMD:
 		return val | cc_mask;
 	case CC_VENDOR_INTEL:
@@ -118,7 +118,7 @@ u64 cc_mkenc(u64 val)
 u64 cc_mkdec(u64 val)
 {
 	/* See comment in cc_mkenc() */
-	switch (vendor) {
+	switch (cc_vendor) {
 	case CC_VENDOR_AMD:
 		return val & ~cc_mask;
 	case CC_VENDOR_INTEL:
@@ -129,11 +129,6 @@ u64 cc_mkdec(u64 val)
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
 
-__init void cc_set_vendor(enum cc_vendor v)
-{
-	vendor = v;
-}
-
 __init void cc_set_mask(u64 mask)
 {
 	cc_mask = mask;
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -11,13 +11,30 @@ enum cc_vendor {
 	CC_VENDOR_INTEL,
 };
 
-void cc_set_vendor(enum cc_vendor v);
-void cc_set_mask(u64 mask);
-
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
+extern enum cc_vendor cc_vendor;
+
+static inline enum cc_vendor cc_get_vendor(void)
+{
+	return cc_vendor;
+}
+
+static inline void cc_set_vendor(enum cc_vendor vendor)
+{
+	cc_vendor = vendor;
+}
+
+void cc_set_mask(u64 mask);
 u64 cc_mkenc(u64 val);
 u64 cc_mkdec(u64 val);
 #else
+static inline enum cc_vendor cc_get_vendor(void)
+{
+	return CC_VENDOR_NONE;
+}
+
+static inline void cc_set_vendor(enum cc_vendor vendor) { }
+
 static inline u64 cc_mkenc(u64 val)
 {
 	return val;


