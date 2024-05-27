Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE29E17E90E;
	Mon, 27 May 2024 19:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837004; cv=none; b=TfD8Lp6yLqg8upwq+zOI3sA7jBko+6sQ78cxNlWlthVv9VsG3u8F42/S6LwBVueoJ6Ldkm+2b3dMZkopk0eQsyi29djQpV/JjSm/rtprobg9sjL+dJTcrTX8wWqhAeDZ/5u7RIR+FLhdLhJYes3Yv1ttdJWEAqq5f4eHhW5mC8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837004; c=relaxed/simple;
	bh=C2smHGWuhdwTtqY1BgL7GxjRuTNhWUu2PK5r5vTB49c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKjLWRVQskj1Zi68Bgtqie2MGzFDBs7RWBberCkoz/476w6oVDqA13Jz2X25npox9AoRx4vkT+fvWhliZpbjy9kHdPAH7oDtUY+65SVug/Qhh843fWCn7r6b7sECDWUKUxfKUtkN4XKUOacz6pg/qL+/7I7bM1ZGjsBFN+yDR24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fg2hzSWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fg2hzSWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62654C2BBFC;
	Mon, 27 May 2024 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837004;
	bh=C2smHGWuhdwTtqY1BgL7GxjRuTNhWUu2PK5r5vTB49c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fg2hzSWhsE/59DiYARjj200hXChdyfcDIpQo5yCfcwtdkkVkH+aX4AwxJ6MjjXVFh
	 pCvifvzI/OBYG5lxWTUbJGgr3chK4yAKJs9keAn1GJhMk2yaOg5uoaVeOh8ZEHXtvW
	 cS7L8Jpld6bPughB9IaahAVXimx5/gE4WQVguZ24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Edward Liaw <edliaw@google.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 231/427] selftests: Compile kselftest headers with -D_GNU_SOURCE
Date: Mon, 27 May 2024 20:54:38 +0200
Message-ID: <20240527185624.054270813@linuxfoundation.org>
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

From: Edward Liaw <edliaw@google.com>

[ Upstream commit daef47b89efd0b745e8478d69a3ad724bd8b4dc6 ]

Add the -D_GNU_SOURCE flag to KHDR_INCLUDES so that it is defined in a
central location.

Commit 809216233555 ("selftests/harness: remove use of LINE_MAX")
introduced asprintf into kselftest_harness.h, which is a GNU extension
and needs _GNU_SOURCE to either be defined prior to including headers or
with the -D_GNU_SOURCE flag passed to the compiler.

Fixed up commit log:
Shuah Khan <skhan@linuxfoundation.org>

Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202404301040.3bea5782-oliver.sang@intel.com
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile            | 4 ++--
 tools/testing/selftests/kselftest_harness.h | 2 +-
 tools/testing/selftests/lib.mk              | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index e1504833654db..ed012a7f07865 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -161,11 +161,11 @@ ifneq ($(KBUILD_OUTPUT),)
   # $(realpath ...) resolves symlinks
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
-  KHDR_INCLUDES := -isystem ${abs_objtree}/usr/include
+  KHDR_INCLUDES := -D_GNU_SOURCE -isystem ${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
   abs_srctree := $(shell cd $(top_srcdir) && pwd)
-  KHDR_INCLUDES := -isystem ${abs_srctree}/usr/include
+  KHDR_INCLUDES := -D_GNU_SOURCE -isystem ${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 3c8f2965c2850..37b03f1b8741d 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -51,7 +51,7 @@
 #define __KSELFTEST_HARNESS_H
 
 #ifndef _GNU_SOURCE
-#define _GNU_SOURCE
+static_assert(0, "kselftest harness requires _GNU_SOURCE to be defined");
 #endif
 #include <asm/types.h>
 #include <ctype.h>
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 8ae203d8ed7fa..7fa4a96e26ed6 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -53,7 +53,7 @@ selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
 ifeq ($(KHDR_INCLUDES),)
-KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
+KHDR_INCLUDES := -D_GNU_SOURCE -isystem $(top_srcdir)/usr/include
 endif
 
 # The following are built by lib.mk common compile rules.
-- 
2.43.0



