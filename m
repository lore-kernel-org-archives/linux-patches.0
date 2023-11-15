Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4582C3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPvjQkM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B97C433C9;
	Wed, 15 Nov 2023 19:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077634;
	bh=u1ReexMzx/3dinQ7MmCRSyTjel6XNkL12RsEUemYVvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPvjQkM8Q/N6vAxEfyxsCdMQT8XqRBePEzhvyS5HD1K+NcrA0V7qqrFLxutkR+xNL
	 hKwcBIfRFIkuNq6VkbSIENueSoim+z7KUawfcP4078BtEdVdGOf6Vq3kgM2Sceg9eL
	 YHK6jAbMaICbAZzR8jOSb1uUHkBEtjIczLe3Ci/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 392/603] sh: bios: Revive earlyprintk support
Date: Wed, 15 Nov 2023 14:15:37 -0500
Message-ID: <20231115191640.265997793@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 553f7ac78fbb41b2c93ab9b9d78e42274d27daa9 ]

The SuperH BIOS earlyprintk code is protected by CONFIG_EARLY_PRINTK.
However, when this protection was added, it was missed that SuperH no
longer defines an EARLY_PRINTK config symbol since commit
e76fe57447e88916 ("sh: Remove old early serial console code V2"), so
BIOS earlyprintk can no longer be used.

Fix this by reviving the EARLY_PRINTK config symbol.

Fixes: d0380e6c3c0f6edb ("early_printk: consolidate random copies of identical code")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/c40972dfec3dcc6719808d5df388857360262878.1697708489.git.geert+renesas@glider.be
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/Kconfig.debug | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
index c449e7c1b20ff..8bcd6c1431a95 100644
--- a/arch/sh/Kconfig.debug
+++ b/arch/sh/Kconfig.debug
@@ -22,6 +22,17 @@ config STACK_DEBUG
 	  every function call and will therefore incur a major
 	  performance hit. Most users should say N.
 
+config EARLY_PRINTK
+	bool "Early printk"
+	depends on SH_STANDARD_BIOS
+	help
+	  Say Y here to redirect kernel printk messages to the serial port
+	  used by the SH-IPL bootloader, starting very early in the boot
+	  process and ending when the kernel's serial console is initialised.
+	  This option is only useful while porting the kernel to a new machine,
+	  when the kernel may crash or hang before the serial console is
+	  initialised.  If unsure, say N.
+
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL && (MMU || BROKEN) && !PAGE_SIZE_64KB
-- 
2.42.0



