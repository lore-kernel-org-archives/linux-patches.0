Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7BE1F3FF8;
	Mon, 23 Jun 2025 21:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713380; cv=none; b=NmeA668zmKSrqOifQQTKNVGpSs9tR1ff6GgZDqU6ayCFOkImVTEAPJETEHcm4Y4LXhE/vtdJoKBs6q9Vp2Mn5nb3YqMhK4Va2ctEN4nMHwWPrCI5ZpKPHlb0npO/6qWZlzGUXrgymYLLreYY660lpVUz0ucY716rTlt+BFYQnd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713380; c=relaxed/simple;
	bh=AJCDuuP8DojbRKytNZ8uIngWAv1Rsm6zQYCBEYuNkGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aophhQ0gFLadolNFVEu8fFmjpbAH/D3muwrLK5dA/oYWEX7DNWZC6T+lAuSBsHZn8iaWHukxol9jmSLkXCRmlg/uzvZLa24Kib2hxOjeO9Xml3GSUgBLl1SsurIfCjUvUy7JOlWQhl+sEgCV3s6WTsIVB1oEMhbmNg8Em5gYlXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14GrMuxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14GrMuxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A96C4CEEA;
	Mon, 23 Jun 2025 21:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713375;
	bh=AJCDuuP8DojbRKytNZ8uIngWAv1Rsm6zQYCBEYuNkGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14GrMuxtF96SG7Xx3U46+ZiP9kzqL1JJ1u/02oKQHGXvvVYG4xBIFFEXQHx74CaFt
	 ElIJXaSDirhSLlwt5b965UReqAjM6kR2FiHIAWEDU8d6EbpMhF52nXfMGHp5jDudue
	 5Wo9b+mRmMcgK6o1do0e7AJ+IWxlWAvg/uMxUHgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/222] platform: Add Surface platform directory
Date: Mon, 23 Jun 2025 15:08:38 +0200
Message-ID: <20250623130617.674624666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: f4b0fa38d5fe ("platform/x86: dell_rbu: Stop overwriting data buffer")
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
index 2040c2f76dcf7..474daf91a054b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10819,6 +10819,15 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/mscc/
 
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



