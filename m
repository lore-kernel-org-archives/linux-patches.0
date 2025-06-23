Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F71D42056;
	Mon, 23 Jun 2025 21:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715166; cv=none; b=I33yj3wBlZDgXyRnpGmjVJE2aomUfap3w2hiFOw2Z0js5Pvtck/249xMbl+tk0GFbSbWHfK9A/EZLlFxJ3o4rCkuyV4qXsdSH8KAA0XphlKmNyBbxZfBVVGN11uSfdkB/N9JeS+PzcbugOaRDqrPXJ4aQhD3AQgyS/qWdbLm9gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715166; c=relaxed/simple;
	bh=f3Vd+Hyc9AsoddlAIl7zrKATaWug3DL/cJAEscl+1f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPQbsVAMUQMRJCkeAMimwTZi8n6sUpm7G1ombb3KHHUJb70cDNBxDfRj9PMlSLljmspqQqyil+3Dz6jEv2rnyhtd3rGFO66tw6ix+edLWFX0wirrpFJvAYqvMaV7vDWj+ycMg2djLRaQN2isfotRd20d39rhHI52BPebvuQHri8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziNztmCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziNztmCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD609C4CEEA;
	Mon, 23 Jun 2025 21:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715166;
	bh=f3Vd+Hyc9AsoddlAIl7zrKATaWug3DL/cJAEscl+1f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziNztmCA7yiiIu5E6Hf1FzhbBR+Sz+htz7Os6InBHSywGAKVt4K5NgaDEMWFimmkc
	 CqbVa1wXBvYqqls0cc+Bt+HXZhvEQG9cIC8wuLfCy7/fx08R2RSgdqQAXaPZpUfW1o
	 B0gPQjTRPeN3Lvc8qmfPZWH7BXI5xYHBSJTRG3Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/355] platform: Add Surface platform directory
Date: Mon, 23 Jun 2025 15:08:00 +0200
Message-ID: <20250623130635.169604976@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 1e3a2bc89de44ec34153ab1c1056346b51def250 ]

It may make sense to split the Microsoft Surface hardware platform
drivers out to a separate subdirectory, since some of it may be shared
between ARM and x86 in the future (regarding devices like the Surface
Pro X).

Further, newer Surface devices will require additional platform drivers
for fundamental support (mostly regarding their embedded controller),
which may also warrant this split from a size perspective.

This commit introduces a new platform/surface subdirectory for the
Surface device family, with subsequent commits moving existing Surface
drivers over from platform/x86.

A new MAINTAINERS entry is added for this directory. Patches to files in
this directory will be taken up by the platform-drivers-x86 team (i.e.
Hans de Goede and Mark Gross) after they have been reviewed by
Maximilian Luz.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20201009141128.683254-2-luzmaximilian@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 61ce04601e0d ("platform/x86: dell_rbu: Fix list usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                       |  9 +++++++++
 drivers/platform/Kconfig          |  2 ++
 drivers/platform/Makefile         |  1 +
 drivers/platform/surface/Kconfig  | 14 ++++++++++++++
 drivers/platform/surface/Makefile |  5 +++++
 5 files changed, 31 insertions(+)
 create mode 100644 drivers/platform/surface/Kconfig
 create mode 100644 drivers/platform/surface/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index cdb5f1f22f4c4..beaa5f6294bd2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11633,6 +11633,15 @@ F:	drivers/scsi/smartpqi/smartpqi*.[ch]
 F:	include/linux/cciss*.h
 F:	include/uapi/linux/cciss*.h
 
+MICROSOFT SURFACE HARDWARE PLATFORM SUPPORT
+M:	Hans de Goede <hdegoede@redhat.com>
+M:	Mark Gross <mgross@linux.intel.com>
+M:	Maximilian Luz <luzmaximilian@gmail.com>
+L:	platform-driver-x86@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git
+F:	drivers/platform/surface/
+
 MICROSOFT SURFACE PRO 3 BUTTON DRIVER
 M:	Chen Yu <yu.c.chen@intel.com>
 L:	platform-driver-x86@vger.kernel.org
diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
index 971426bb4302c..18fc6a08569eb 100644
--- a/drivers/platform/Kconfig
+++ b/drivers/platform/Kconfig
@@ -13,3 +13,5 @@ source "drivers/platform/chrome/Kconfig"
 source "drivers/platform/mellanox/Kconfig"
 
 source "drivers/platform/olpc/Kconfig"
+
+source "drivers/platform/surface/Kconfig"
diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
index 6fda58c021ca4..4de08ef4ec9d0 100644
--- a/drivers/platform/Makefile
+++ b/drivers/platform/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_MIPS)		+= mips/
 obj-$(CONFIG_OLPC_EC)		+= olpc/
 obj-$(CONFIG_GOLDFISH)		+= goldfish/
 obj-$(CONFIG_CHROME_PLATFORMS)	+= chrome/
+obj-$(CONFIG_SURFACE_PLATFORMS)	+= surface/
diff --git a/drivers/platform/surface/Kconfig b/drivers/platform/surface/Kconfig
new file mode 100644
index 0000000000000..b67926ece95fb
--- /dev/null
+++ b/drivers/platform/surface/Kconfig
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Microsoft Surface Platform-Specific Drivers
+#
+
+menuconfig SURFACE_PLATFORMS
+	bool "Microsoft Surface Platform-Specific Device Drivers"
+	default y
+	help
+	  Say Y here to get to see options for platform-specific device drivers
+	  for Microsoft Surface devices. This option alone does not add any
+	  kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
diff --git a/drivers/platform/surface/Makefile b/drivers/platform/surface/Makefile
new file mode 100644
index 0000000000000..3700f9e84299e
--- /dev/null
+++ b/drivers/platform/surface/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for linux/drivers/platform/surface
+# Microsoft Surface Platform-Specific Drivers
+#
-- 
2.39.5



