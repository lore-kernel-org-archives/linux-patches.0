Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5720369224;
	Sat, 12 Sep 2026 08:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203316; cv=none; b=UPiDZ0Ya0XW3XpPoIAHPIa4ZAKOpSDxBBjo8ZA7pwWyDx4fMNANhgG/N41yLs34oFBmsOwQllJlD1FtGlh9VDeaVd8J2UpAe/lL0V+PMjoR4a7cX1PjM95Sy8JaCtFdVJg5ASTKIwBjRTElMpITVTAMHoG0cr9vhEWB2QDHhZIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203316; c=relaxed/simple;
	bh=exYOnNXR31n56S4syuaRJ0QgATyYgggrh/zuGof86qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9kAxq0KnZK0SWAY3ToVBr8RT3ITuNv9xFw8sY2pW7DyhJmwhp9KmJnyLD/VEHapDE39Q+Qvmvugaip/efxURTrHLo6hl2aG59UbQJ3edzT4YB9ynqryACi6Ahtv1IkVS6K3DG/OSGgXUErgennOVhdpqY2qmO+FpxF7jZyGnXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFx1Jug3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFx1Jug3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9134E1F000FF;
	Sat, 12 Sep 2026 08:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203314;
	bh=7vP0RGhPHVmArn/saKNAVslDJMSJzHSzsJFTVEHFRe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFx1Jug35bRapE4tXNf8yRvq1+x1a40UAKG9JrfS3Z/ak1m0fxpoJaSHPafq++Czw
	 ey5B13ptZVAH/TlX6F27eWczKRC7ePvtT8OYGrF0eZXuGOCIHKtjMHgZeqiTb3tza1
	 CZplznmSxmwdW4bWtisGNYKZLTj8e0pllKPqfQGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1384/1815] firewire: core: add KUnit test skeleton for node tree
Date: Sat, 12 Sep 2026 08:52:14 +0200
Message-ID: <20260912065721.518082867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a5f5e250223a1..b5abe00accc9d 100644
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
 	depends on PCI && FIREWIRE
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index df2ac0dab1060..1d3a4419f5547 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -507,3 +507,7 @@ void fw_core_handle_bus_reset(struct fw_card *card, int node_id, int generation,
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



