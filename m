Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7E31662EF;
	Wed,  5 Feb 2025 15:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768640; cv=none; b=qbu7SxRi2sQqUEkq3QNQCnOgk19dGlQonus0Yrz7le+x/sMQi30vcMEqS+iwlNtqYQpDywsFoLoBc3Ye1oaEaLX97uAY1bRYCVJRkDXkocejJTOhj44y11ZJh/SHusA+wbfLeS7wGlJk35QqXJ4wqZJ8giDprPJe7xS5oDXgPBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768640; c=relaxed/simple;
	bh=62x/IdeRTvTwFRkKAaMeC+e6cNFGCpqdD2HSr/fQW98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lx1kmZvU8ok9oVhbNMfKaQ4eBf/WUrRKTL+/rT4vOD5sOfWV3h+j95t1T5q4Dn3lKYKzbd8fPgKTSSmSfqWL0XCw4a9Z85hV3rSkh+LfX0wR+IDNYPWH+p9hlMBccYPZQ6QxTwsqc8ahOI0ZLAPTY7pX1JtJit5+LX46zO4hZ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dvdw2Shu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dvdw2Shu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A833C4CED1;
	Wed,  5 Feb 2025 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768639;
	bh=62x/IdeRTvTwFRkKAaMeC+e6cNFGCpqdD2HSr/fQW98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dvdw2Shum5QxKveluBmmuQJF5SGV1bhMLODZTblT8Zh66iTEOrHu8V25wVoWKCJ1y
	 vj9AKUcal/pzaADuBc1CNHHRIfIkUGIBV0RIJNW3bjID8rFpOny+pOSj6X2H+dEakY
	 ObkKpQTR5Msg5UopPxBaaDfD0jY3IFKjIAOnWuuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Keith Lucas <keith.lucas@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 614/623] selftests/mm: build with -O2
Date: Wed,  5 Feb 2025 14:45:56 +0100
Message-ID: <20250205134519.706741393@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Brodsky <kevin.brodsky@arm.com>

commit 46036188ea1f5266df23a6149dea0df1c77cd1c7 upstream.

The mm kselftests are currently built with no optimisation (-O0).  It's
unclear why, and besides being obviously suboptimal, this also prevents
the pkeys tests from working as intended.  Let's build all the tests with
-O2.

[kevin.brodsky@arm.com: silence unused-result warnings]
  Link: https://lkml.kernel.org/r/20250107170110.2819685-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20241209095019.1732120-6-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/Makefile |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -33,9 +33,16 @@ endif
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 LDLIBS = -lrt -lpthread -lm
 
+# Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
+# automatically enabled at -O1 or above. This triggers various unused-result
+# warnings where functions such as read() or write() are called and their
+# return value is not checked. Disable _FORTIFY_SOURCE to silence those
+# warnings.
+CFLAGS += -U_FORTIFY_SOURCE
+
 KDIR ?= /lib/modules/$(shell uname -r)/build
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
 ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))


