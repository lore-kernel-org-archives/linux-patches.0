Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B79C47988D;
	Sat, 12 Sep 2026 13:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218150; cv=none; b=qiwMh6SzUJOWstFxlklWooZMd4920C2+COn6Z+I7oxl9D5TtolnYFOCOtjg0b3P0AYO2NhD7nCGApd6cxZ4OHw/cZ0VnVbAPqlpvlbCNgV9ofSwCX/pCdN86GyMgIjh+/hN9BotJiroD+K+e+7MKwDoASn1pZ8DEtWtE7msckbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218150; c=relaxed/simple;
	bh=UObDT8BX1Nbx/pSlyGfGrWJYfv2krGzYFH1oq0vGpgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2f8i4Toc1511KKnh/Y12A5NEtgyO7YymxRntAWWkmiOqz9kJBPKCfZ3hkPBG7BH6nOYSY6WGZnDAZHsubLD1NoduljWNB+WjOxpLmvds1W6yzOEPYx0G/TFG6tjgQDbdtncIVCZJW7wYbjpeH/tqBzlEAbofamrOrzsotkLkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHrqes2t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHrqes2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF801F000FF;
	Sat, 12 Sep 2026 13:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218149;
	bh=jWaL+yvORJiNNIkDGbP8kCy9V7lp0Xy+ARLfgJY8wEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHrqes2tAx5nG1HOmAGBcf3GsoW/0w+Q9RsGwvEKD+FRepX9sYOMymPZVaqmkRNCn
	 nIEWrjscoIu/ngiCCf9saeT04qRH6HEUvXFpqhlb+wYwVoxWSIYolTUyYO7igh21dr
	 O75EjAMswm06zj6pBh4eWXp01E7E18Sreiu149oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1085/1376] firewire: core: add KUnit test skeleton for node tree
Date: Sat, 12 Sep 2026 08:58:31 +0200
Message-ID: <20260912065631.744770954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 1f9b65cf57081035547b4d3ca1805df20892e9db ]

Some issues have been reported in node tree management. Refactoring
the topology-related code in the core is required. Adding unit tests
would help ensure that the refactoring does not introduce regressions.

This commit adds a KUnit test skeleton for this purpose.

Link: https://lore.kernel.org/r/20260810064119.410324-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Stable-dep-of: 05bfb1327dc5 ("firewire: core: fix memory leak in error path of build_tree()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/.kunitconfig     |  1 +
 drivers/firewire/Kconfig          | 15 +++++++++++++++
 drivers/firewire/core-topology.c  |  4 ++++
 drivers/firewire/node-tree-test.c | 19 +++++++++++++++++++
 4 files changed, 39 insertions(+)
 create mode 100644 drivers/firewire/node-tree-test.c

diff --git a/drivers/firewire/.kunitconfig b/drivers/firewire/.kunitconfig
index 21b7e9eef63d1..7406acb004782 100644
--- a/drivers/firewire/.kunitconfig
+++ b/drivers/firewire/.kunitconfig
@@ -6,3 +6,4 @@ CONFIG_FIREWIRE_KUNIT_DEVICE_ATTRIBUTE_TEST=y
 CONFIG_FIREWIRE_KUNIT_PACKET_SERDES_TEST=y
 CONFIG_FIREWIRE_KUNIT_SELF_ID_SEQUENCE_HELPER_TEST=y
 CONFIG_FIREWIRE_KUNIT_OHCI_SERDES_TEST=y
+CONFIG_FIREWIRE_KUNIT_NODE_TREE_TEST=y
diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 905c82e26ce74..cfbac21660ab4 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -81,6 +81,21 @@ config FIREWIRE_KUNIT_SELF_ID_SEQUENCE_HELPER_TEST
 	  For more information on KUnit and unit tests in general, refer
 	  to the KUnit documentation in Documentation/dev-tools/kunit/.
 
+config FIREWIRE_KUNIT_NODE_TREE_TEST
+	tristate "KUnit tests for node tree" if !KUNIT_ALL_TESTS
+	depends on FIREWIRE && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the KUnit tests for node tree.
+
+	  KUnit tests run during boot and output the results to the debug
+	  log in TAP format (https://testanything.org/). Only useful for
+	  kernel devs running KUnit test harness and are not for inclusion
+	  into a production build.
+
+	  For more information on KUnit and unit tests in general, refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
 config FIREWIRE_OHCI
 	tristate "OHCI-1394 controllers"
 	depends on PCI && FIREWIRE && MMU
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 892b94cfd6260..01c3304ea36c9 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -501,3 +501,7 @@ void fw_core_handle_bus_reset(struct fw_card *card, int node_id, int generation,
 	}
 }
 EXPORT_SYMBOL(fw_core_handle_bus_reset);
+
+#ifdef CONFIG_FIREWIRE_KUNIT_NODE_TREE_TEST
+#include "node-tree-test.c"
+#endif
diff --git a/drivers/firewire/node-tree-test.c b/drivers/firewire/node-tree-test.c
new file mode 100644
index 0000000000000..fca71dd99b25f
--- /dev/null
+++ b/drivers/firewire/node-tree-test.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// node-tree-test.c - An application of Kunit to test node tree.
+//
+// Copyright (c) 2026 Takashi Sakamoto
+//
+// This file can not be built independently since it is intentionally included in core-topology.c.
+
+#include <kunit/test.h>
+
+static struct kunit_case node_tree_test_cases[] = {
+	{}
+};
+
+static struct kunit_suite node_tree_test_suite = {
+	.name = "firewire-node-tree",
+	.test_cases = node_tree_test_cases,
+};
+kunit_test_suite(node_tree_test_suite);
-- 
2.53.0



