Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CE51B6CF6;
	Tue, 15 Oct 2024 19:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729022139; cv=none; b=AAKr136apTMWJ7P6kLy9lBp9DZhxNuDMYHSnrKOwkwBWCdV47uTjZwIwkxkFO/Tn8LtBh3oSjQwGEGN47fmSb/TVustECUYwj5cWgsxzOsuF0HRaYw2lgS0Crm8/qzH8iVLru6brEx3kXNuc4CKvSQlAQCGDqQ4adtv0+EaDCMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729022139; c=relaxed/simple;
	bh=bg9WrBjzLChnUbsEv2PJZbLfPRX/TrLVhWXYXN7aqXw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IdmGvbR3iYX4s2bvUdfJBDUBCnx/QvrZ5WuWb2c5Fj8vRK+YHr3beK6r+0RwUQ9PQOjFOy+wceYeEy3qNeVwxDOrSCnCcMeLcDgO+olhAiNkdpD17h+tElQlakg8dUfpz3/WF9Ra9tWNafykivZ5tYZ0vpHeTQ94K1X8wJlT4lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gMWFobD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gMWFobD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E685C4CEC6;
	Tue, 15 Oct 2024 19:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729022138;
	bh=bg9WrBjzLChnUbsEv2PJZbLfPRX/TrLVhWXYXN7aqXw=;
	h=From:Date:Subject:To:Cc:From;
	b=gMWFobD+NJjus4Fp2+iG3jTpZ4mVEbjUb5LhkCRf3UY9Js7uzWYS0x7OrDGJ/8jeG
	 /ATj1OviE4gOLAAFeyPtEkNeaJKcxJXRWpaVMk2FKJQmcu9QZIJeT3OJHCCcqM3R6L
	 /v5yxo6+1joZ6/ADvmK3hcOZuIGwQQdY3hBVNaMI6zCElzqv+DnD2QgAkbKQ/HzlER
	 kI6ISu9m3dTIbnENuYVNAzJa81FslbFSLNrerkKIQ5vPiwdJUVdyp0gIsxbOn6p3vf
	 ULoYmQ3StRHNPWOYB0EyJAo72J4EyIdArhC9D6YMMKesuU/v7efAPbDXC47KO5LkRM
	 RtbcwrGqWzrpg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 15 Oct 2024 12:55:33 -0700
Subject: [PATCH] staging: gpib: Fix PCI header include guard
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241015-staging-gpib-fix-pci-header-guard-v1-1-dfa45fe8d63f@kernel.org>
X-B4-Tracking: v=1; b=H4sIALTIDmcC/x2NywqDMBAAf0X27IKJlhp/RXrIY7vuJQ0bWwriv
 xs8DgwzB1RSoQpLd4DST6p8cgPTdxA3n5lQUmOwg53MYB5Yd8+SGblIwLf8sUTBjXwiRf56Tej
 cM4To7DibGVqnKDXvfqyv87wA7GSalnMAAAA=
X-Change-ID: 20241015-staging-gpib-fix-pci-header-guard-997bbc923818
To: Dave Penkler <dpenkler@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1678; i=nathan@kernel.org;
 h=from:subject:message-id; bh=bg9WrBjzLChnUbsEv2PJZbLfPRX/TrLVhWXYXN7aqXw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOl8J3YeuyPYqsPCl3/d6NDb9LiTDA2X+sJa7nMsWGHsy
 FcQXCDdUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbCz87IMM0oXijc1TajxtNy
 pXTAV7+Q2eX1LQ5v32YfrnHdWMsyk+F/yv67tQ+1S3eL+L0weah2d10Tp/TeZPPyAvXDbjkdxQ1
 8AA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  In file included from drivers/staging/gpib/ines/ines_gpib.c:19:
  drivers/staging/gpib/include/gpib_pci_ids.h:3:9: error: '__GPIB_PCI_IDS_H' is used as a header guard here, followed by #define of a different macro [-Werror,-Wheader-guard]
      3 | #ifndef __GPIB_PCI_IDS_H
        |         ^~~~~~~~~~~~~~~~
  drivers/staging/gpib/include/gpib_pci_ids.h:4:9: note: '__GPIB_LINUX_PCI_IDS_H' is defined here; did you mean '__GPIB_PCI_IDS_H'?
      4 | #define __GPIB_LINUX_PCI_IDS_H
        |         ^~~~~~~~~~~~~~~~~~~~~~
        |         __GPIB_PCI_IDS_H

Fix the define to match the guard like the note suggests, as that is
clearly what was intended here.

Fixes: 6c52d5e3cde2 ("staging: gpib: Add common include files for GPIB drivers")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/staging/gpib/include/gpib_pci_ids.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/include/gpib_pci_ids.h b/drivers/staging/gpib/include/gpib_pci_ids.h
index 162b02deb0ade7ede08ad81ebd41a79727374448..52dcab07a7d188925a4d696d6b658f397f3b0153 100644
--- a/drivers/staging/gpib/include/gpib_pci_ids.h
+++ b/drivers/staging/gpib/include/gpib_pci_ids.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 #ifndef __GPIB_PCI_IDS_H
-#define __GPIB_LINUX_PCI_IDS_H
+#define __GPIB_PCI_IDS_H
 
 #ifndef PCI_VENDOR_ID_AMCC
 #define PCI_VENDOR_ID_AMCC	0x10e8

---
base-commit: e0eb7cc4d70d672cf9344916aba58136fd6e495e
change-id: 20241015-staging-gpib-fix-pci-header-guard-997bbc923818

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

