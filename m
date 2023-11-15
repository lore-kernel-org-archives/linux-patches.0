Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9383DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l+HUcGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1827C433C9;
	Wed, 15 Nov 2023 20:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078647;
	bh=5oMSzBq/lgDe0Pa32gdYVYaZBke34mBiupVzPo+le1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l+HUcGuSHSiORnAhhpOYdq13VkyKFENCrtJTVr9o7qZ4vmrAz0q0imrWShZArU2p
	 nDlMptFgm2fz1aGQp8ce/ZmgdPl7asxJg5e2+Y5uW/6Bc2klv/keyY+gLX+9JYmnCu
	 7hlMhUcDOoW0BJKVbyKzN0knv6M8taV6qgDUxHrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/45] sh: bios: Revive earlyprintk support
Date: Wed, 15 Nov 2023 14:32:59 -0500
Message-ID: <20231115191420.919449823@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
References: <20231115191419.641552204@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
index 4209405179262..4737cbd95cd53 100644
--- a/arch/sh/Kconfig.debug
+++ b/arch/sh/Kconfig.debug
@@ -29,6 +29,17 @@ config STACK_DEBUG
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



