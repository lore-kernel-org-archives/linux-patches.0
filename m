Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7DB2571CE;
	Mon, 24 Feb 2025 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408758; cv=none; b=ZfRKiTFRYzhde+kaIG7lBpt3i/T3nzQkZzh9erMsX7a8pb84ZSoHV6gziOxm/0d306JLYiPtRKhwGCF8QJIi6dorTsvT49FiM36eEJIOwAEP6tCMWJIYOywx2Tcqxg1A/xM9d6+BpWe/EWvVN6L1hR9v+2JnsjHFayAakvEFMxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408758; c=relaxed/simple;
	bh=rR9mji96kMIsxyuV9R9IRLepEy2FSDQMtXjTDmJW/rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuI17xweOm3od9lfsT4GokKcsYL/CNm6amkXm4zk+91ugsh/Neqout/UzSZlwS/RnMr0lYij6RnRKIe9w9fOsJswVNavBqo0Y4SqgNCcaqIMSsEbfvOtgBf9oL7fKZ5IQE0OK3/l0KbPEgnXskQwMBshWDWUCpty/l1aCqJtguU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pb9H9eLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pb9H9eLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47130C4CED6;
	Mon, 24 Feb 2025 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408758;
	bh=rR9mji96kMIsxyuV9R9IRLepEy2FSDQMtXjTDmJW/rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pb9H9eLSpXwsNtrzOM9iCZokhSkTrDF/EBigTAXKDN48R+HHSAMdCR5PdXku34nc1
	 fdAaLOKWcPSmOxpGO7efJNOq/esCY0Lz105Vo6nOmBIg5/fqbcA8+jqrVScKsAvW5B
	 BTVXY1z5s1VCcyG5aYT/VbOPWeOy0hSMXEbbXF9o=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Yifei Liu <yifei.l.liu@oracle.com>
Subject: [PATCH 6.12 151/154] selftests/mm: build with -O2
Date: Mon, 24 Feb 2025 15:35:50 +0100
Message-ID: <20250224142612.957453182@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ Yifei: This commit also fix the failure of pkey_sighandler_tests_64,
  which is also in linux-6.12.y, thus backport this commit. ]
Signed-off-by: Yifei Liu <yifei.l.liu@oracle.com>
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
 TEST_GEN_FILES = cow
 TEST_GEN_FILES += compaction_test
 TEST_GEN_FILES += gup_longterm


