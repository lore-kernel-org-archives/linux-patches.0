Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BED0168C4;
	Mon, 27 May 2024 19:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837400; cv=none; b=Wi/HzEkzkjpBdf0agMBdtG1jqXjGztbTxuPsP3Duy3jwoIJ375d6h7vFIxqMNnsM803cCeCY4K7zvxCoOHZ/PIruUZ6dy+MugCsuLTB2hO+j9wxcHHAseGl3QFy/L13OmQKm1LVN3WGesDqAa5KYNSZr1ycUrnQ6+Ci9eIboDfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837400; c=relaxed/simple;
	bh=gUD0B1nCaQ6OIBmQXMFYYnHXslkXg0aDM6lvKtFVxpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+dWTzaw2+VlYoCdiUHgcujZnrM/5wHn+XdSGdoGmUYu1ay2KOuGWPqMfUf54OUoIHsXnSQSYKg2XQbc/CE/DOn3012KsvKLcjac49eypKg9j3i5z5pp1MgSxaCWIc3UGY14HKoMcz2VCyOYwaJ1iBC8R3Dz9NUfbOGzP61IP8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yhu8dTIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yhu8dTIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A42C2BBFC;
	Mon, 27 May 2024 19:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837400;
	bh=gUD0B1nCaQ6OIBmQXMFYYnHXslkXg0aDM6lvKtFVxpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yhu8dTIRLBXexU/ibR4o9OaP01g67oTQr45+yu5SWrJrhEFseYs3RfwF7/NeV7zUj
	 ZymxTP2FzgV/wg++N5pzJIlG+nLubeZRPxjoo2LFb3lLTaMLDPgi6T5jiq0tTPV1nt
	 x4HVLB5ahW1Y/xAEjgLQQsdZY4D6mhtTdc92Imeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 426/427] Revert "selftests: Compile kselftest headers with -D_GNU_SOURCE"
Date: Mon, 27 May 2024 20:57:53 +0200
Message-ID: <20240527185635.884777098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit cee27ae5f1fb8bc4762f5d5de19ec6de6c45e239 ]

This reverts commit daef47b89efd0b745e8478d69a3ad724bd8b4dc6.

This framework change to add D_GNU_SOURCE to KHDR_INCLUDES
to Makefile, lib.mk, and kselftest_harness.h is causing build
failures and warnings.

Revert this change.

Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile            | 4 ++--
 tools/testing/selftests/kselftest_harness.h | 2 +-
 tools/testing/selftests/lib.mk              | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index ed012a7f07865..e1504833654db 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -161,11 +161,11 @@ ifneq ($(KBUILD_OUTPUT),)
   # $(realpath ...) resolves symlinks
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
-  KHDR_INCLUDES := -D_GNU_SOURCE -isystem ${abs_objtree}/usr/include
+  KHDR_INCLUDES := -isystem ${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
   abs_srctree := $(shell cd $(top_srcdir) && pwd)
-  KHDR_INCLUDES := -D_GNU_SOURCE -isystem ${abs_srctree}/usr/include
+  KHDR_INCLUDES := -isystem ${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 37b03f1b8741d..3c8f2965c2850 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -51,7 +51,7 @@
 #define __KSELFTEST_HARNESS_H
 
 #ifndef _GNU_SOURCE
-static_assert(0, "kselftest harness requires _GNU_SOURCE to be defined");
+#define _GNU_SOURCE
 #endif
 #include <asm/types.h>
 #include <ctype.h>
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 7fa4a96e26ed6..8ae203d8ed7fa 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -53,7 +53,7 @@ selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
 ifeq ($(KHDR_INCLUDES),)
-KHDR_INCLUDES := -D_GNU_SOURCE -isystem $(top_srcdir)/usr/include
+KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
 endif
 
 # The following are built by lib.mk common compile rules.
-- 
2.43.0



