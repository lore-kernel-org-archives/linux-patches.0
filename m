Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B593B9603;
	Mon, 23 Mar 2026 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282323; cv=none; b=BiMKgsrpYzo9/ukUZSgW7OvbeCDsmBLcaadvpwXCP0V/bHIJyePVEDvq0vuATVKBWhAO10xNrpO7S62FAOgoiuiVo47CVeNVMLqcPm2mJ+OhSU09BoYXUjYTu39VQQ32r71RWSUGzMrOu0blq511+a5X/Cq3wKsgDAl/oKCZzjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282323; c=relaxed/simple;
	bh=2FA00TYLzRRbHiwVBShey18O19VcYoty6Jh4hmTK6CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sovbMXOAz8KeQy10pV6ppNcPpHHeiCjPRMd4aI71ItsVcy6GKT4pvRGcdGZDavAtdgOvEMj4qM1syqnTFMrDJc74gP9qUiDdAY21nLdpXO7EVQR6IDdYRllBpwb8dAhz3wnvSjtTfPCa8QtI08mwkEXd3fmHeJrnRxHBIsaqz40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcyqRaew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcyqRaew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E5CC4CEF7;
	Mon, 23 Mar 2026 16:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282322;
	bh=2FA00TYLzRRbHiwVBShey18O19VcYoty6Jh4hmTK6CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcyqRaewNkQ4BZySsVeorCIYjTMArl/zRpgZ56j8mg2iNuZnpAGuCNyDDQClLZnpS
	 5XucdWgaX5vTC/s/xbrbl/CUkbPbb9SnIBGIOg/oTsz/ltvCEOdlTNSC/mKgTAJerO
	 /2c+0GTRQM3S6ni8DpNJ5z8Rf6Mx/RoHROYXAX/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Latypov <dlatypov@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/481] kunit: tool: remove unused imports and variables
Date: Mon, 23 Mar 2026 14:41:36 +0100
Message-ID: <20260323134528.058453832@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit 126901ba3499880c9ed033633817cf7493120fda ]

We don't run a linter regularly over kunit.py code (the default settings
on most don't like kernel style, e.g. tabs) so some of these imports
didn't get removed when they stopped being used.

Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 40804c4974b8 ("kunit: tool: copy caller args in run_kernel to prevent mutation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit.py           | 2 +-
 tools/testing/kunit/kunit_config.py    | 2 +-
 tools/testing/kunit/kunit_kernel.py    | 1 -
 tools/testing/kunit/kunit_parser.py    | 1 -
 tools/testing/kunit/kunit_tool_test.py | 2 +-
 5 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/kunit/kunit.py b/tools/testing/kunit/kunit.py
index 8cd8188675047..172db04b48f42 100755
--- a/tools/testing/kunit/kunit.py
+++ b/tools/testing/kunit/kunit.py
@@ -132,7 +132,7 @@ def _suites_from_test_list(tests: List[str]) -> List[str]:
 		parts = t.split('.', maxsplit=2)
 		if len(parts) != 2:
 			raise ValueError(f'internal KUnit error, test name should be of the form "<suite>.<test>", got "{t}"')
-		suite, case = parts
+		suite, _ = parts
 		if not suites or suites[-1] != suite:
 			suites.append(suite)
 	return suites
diff --git a/tools/testing/kunit/kunit_config.py b/tools/testing/kunit/kunit_config.py
index 48b5f34b2e5d7..9f76d7b896175 100644
--- a/tools/testing/kunit/kunit_config.py
+++ b/tools/testing/kunit/kunit_config.py
@@ -8,7 +8,7 @@
 
 from dataclasses import dataclass
 import re
-from typing import Dict, Iterable, List, Set, Tuple
+from typing import Dict, Iterable, List, Tuple
 
 CONFIG_IS_NOT_SET_PATTERN = r'^# CONFIG_(\w+) is not set$'
 CONFIG_PATTERN = r'^CONFIG_(\w+)=(\S+|".*")$'
diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 53e90c3358348..cd73256c30c39 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -18,7 +18,6 @@ import threading
 from typing import Iterator, List, Optional, Tuple
 
 import kunit_config
-from kunit_printer import stdout
 import qemu_config
 
 KCONFIG_PATH = '.config'
diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index c02100b70af62..d5abd0567c8e0 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -11,7 +11,6 @@
 
 from __future__ import annotations
 import re
-import sys
 import textwrap
 
 from enum import Enum, auto
diff --git a/tools/testing/kunit/kunit_tool_test.py b/tools/testing/kunit/kunit_tool_test.py
index fc13326e5c47a..9ba0ff95fad5c 100755
--- a/tools/testing/kunit/kunit_tool_test.py
+++ b/tools/testing/kunit/kunit_tool_test.py
@@ -346,7 +346,7 @@ class KUnitParserTest(unittest.TestCase):
 	def test_parse_subtest_header(self):
 		ktap_log = test_data_path('test_parse_subtest_header.log')
 		with open(ktap_log) as file:
-			result = kunit_parser.parse_run_tests(file.readlines())
+			kunit_parser.parse_run_tests(file.readlines())
 		self.print_mock.assert_any_call(StrContains('suite (1 subtest)'))
 
 	def test_show_test_output_on_failure(self):
-- 
2.51.0



