Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C03520B00
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLSSDFNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B32DC433C7;
	Mon,  6 Nov 2023 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276212;
	bh=6WOs0g7ygWEl2LLEx3IFqlOo0aKsr0GegUGR7NIAU2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLSSDFNhboWnTzEGrmdj1VGVyPggvuv0U1hEp00XDuEtSiJZCAyjmr1Y+huFG2CPJ
	 SwcTg7WcvgLosUrTUuWe7WZec5NMIUg2pRTBIMCcllLPmhVL0AAxJ/aK5QJEjhA8XR
	 Bhye5Op6m3cWl8q31IijWjowldKlzhC4innumfTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Laniel <flaniel@linux.microsoft.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/61] selftests/ftrace: Add new test case which checks non unique symbol
Date: Mon,  6 Nov 2023 14:02:59 +0100
Message-ID: <20231106130259.688411639@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francis Laniel <flaniel@linux.microsoft.com>

[ Upstream commit 03b80ff8023adae6780e491f66e932df8165e3a0 ]

If name_show() is non unique, this test will try to install a kprobe on this
function which should fail returning EADDRNOTAVAIL.
On kernel where name_show() is not unique, this test is skipped.

Link: https://lore.kernel.org/all/20231020104250.9537-3-flaniel@linux.microsoft.com/

Cc: stable@vger.kernel.org
Signed-off-by: Francis Laniel <flaniel@linux.microsoft.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc  | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
new file mode 100644
index 0000000000000..bc9514428dbaf
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
@@ -0,0 +1,13 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test failure of registering kprobe on non unique symbol
+# requires: kprobe_events
+
+SYMBOL='name_show'
+
+# We skip this test on kernel where SYMBOL is unique or does not exist.
+if [ "$(grep -c -E "[[:alnum:]]+ t ${SYMBOL}" /proc/kallsyms)" -le '1' ]; then
+	exit_unsupported
+fi
+
+! echo "p:test_non_unique ${SYMBOL}" > kprobe_events
-- 
2.42.0



