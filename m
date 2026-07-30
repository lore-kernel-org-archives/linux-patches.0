Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4E243CEC4;
	Thu, 30 Jul 2026 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421058; cv=none; b=WW8sduYOkDMVPjaUHGIbAS7dQuCtFgLdSRWPzM/AV3tJzg2ttz3eOYJi3q+TO+PaIlqqS1zuqcZ8SRRudJMaD7svR+IUKndLnHQs275HVRHYrje2Tp+IY7VkKAzn69j5pdixbwZm+XwzniJnbeQm9205u4zzupOei6os0p62RYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421058; c=relaxed/simple;
	bh=zNVK1IKnDHC5IN6PGRskIYJM3zREZOCQKomBB4Wl8rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCw1SrQMJtn3pV0X8gLbCN7VqMFJiwAaOKAB9pmxLXxb85PGvyBphs1pp5GEieYfri6I2TKu4T5kcAVtwtnUeLU23QFuxvyuI1BYMUIsVyd3n4XUHFFSqrcRPgGcLGjpqsRn0O0AkMYBCddkcqF9pB7M+94uWDPzqpjNUJCVEOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qacpP0/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qacpP0/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DA71F000E9;
	Thu, 30 Jul 2026 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421056;
	bh=S6frPNbrAPOLdtDH8WoYyadql6r3lx0czSs8MNr31Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qacpP0/hAjD9zFofaTeKH6YLa3hBw0GY9Q5QEkQYwvgLZTaHy3fY4gQkG0Q4S4+Ec
	 XDgvmfBOQzx0SvPbXJcxMZWlawjg96WHb5L0TF+ksH9ab96MR23A8HCTmlI6mu4rm7
	 XIGQGVTkIxCvF/h9nlnEajFPECWYyWt8mNexULT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/602] net: airoha: Move airoha_eth driver in a dedicated folder
Date: Thu, 30 Jul 2026 16:06:34 +0200
Message-ID: <20260730141436.038788311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fb3dda82fd38ca42140f29b3082324dcdc128293 ]

The airoha_eth driver has no codebase shared with mtk_eth_soc one.
Moreover, the upcoming features (flowtable hw offloading, PCS, ..) will
not reuse any code from MediaTek driver. Move the Airoha driver in a
dedicated folder.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 86e51aa24686 ("net: airoha: Fix skb->priority underflow in airoha_dev_select_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/Kconfig                   |  2 ++
 drivers/net/ethernet/Makefile                  |  1 +
 drivers/net/ethernet/airoha/Kconfig            | 18 ++++++++++++++++++
 drivers/net/ethernet/airoha/Makefile           |  6 ++++++
 .../ethernet/{mediatek => airoha}/airoha_eth.c |  0
 drivers/net/ethernet/mediatek/Kconfig          |  8 --------
 drivers/net/ethernet/mediatek/Makefile         |  1 -
 7 files changed, 27 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/airoha/Kconfig
 create mode 100644 drivers/net/ethernet/airoha/Makefile
 rename drivers/net/ethernet/{mediatek => airoha}/airoha_eth.c (100%)

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 9a542e3c9b05d8..0875b5706b83ac 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -20,6 +20,8 @@ source "drivers/net/ethernet/actions/Kconfig"
 source "drivers/net/ethernet/adaptec/Kconfig"
 source "drivers/net/ethernet/aeroflex/Kconfig"
 source "drivers/net/ethernet/agere/Kconfig"
+source "drivers/net/ethernet/airoha/Kconfig"
+source "drivers/net/ethernet/mellanox/Kconfig"
 source "drivers/net/ethernet/alacritech/Kconfig"
 source "drivers/net/ethernet/allwinner/Kconfig"
 source "drivers/net/ethernet/alteon/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 99fa180dedb805..67182339469a0d 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_NET_VENDOR_ADAPTEC) += adaptec/
 obj-$(CONFIG_GRETH) += aeroflex/
 obj-$(CONFIG_NET_VENDOR_ADI) += adi/
 obj-$(CONFIG_NET_VENDOR_AGERE) += agere/
+obj-$(CONFIG_NET_VENDOR_AIROHA) += airoha/
 obj-$(CONFIG_NET_VENDOR_ALACRITECH) += alacritech/
 obj-$(CONFIG_NET_VENDOR_ALLWINNER) += allwinner/
 obj-$(CONFIG_NET_VENDOR_ALTEON) += alteon/
diff --git a/drivers/net/ethernet/airoha/Kconfig b/drivers/net/ethernet/airoha/Kconfig
new file mode 100644
index 00000000000000..b6a131845f13b2
--- /dev/null
+++ b/drivers/net/ethernet/airoha/Kconfig
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NET_VENDOR_AIROHA
+	bool "Airoha devices"
+	depends on ARCH_AIROHA || COMPILE_TEST
+	help
+	  If you have a Airoha SoC with ethernet, say Y.
+
+if NET_VENDOR_AIROHA
+
+config NET_AIROHA
+	tristate "Airoha SoC Gigabit Ethernet support"
+	depends on NET_DSA || !NET_DSA
+	select PAGE_POOL
+	help
+	  This driver supports the gigabit ethernet MACs in the
+	  Airoha SoC family.
+
+endif #NET_VENDOR_AIROHA
diff --git a/drivers/net/ethernet/airoha/Makefile b/drivers/net/ethernet/airoha/Makefile
new file mode 100644
index 00000000000000..73a6f3680a4c4c
--- /dev/null
+++ b/drivers/net/ethernet/airoha/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Airoha for the Mediatek SoCs built-in ethernet macs
+#
+
+obj-$(CONFIG_NET_AIROHA) += airoha_eth.o
diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
similarity index 100%
rename from drivers/net/ethernet/mediatek/airoha_eth.c
rename to drivers/net/ethernet/airoha/airoha_eth.c
diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 95c4405b7d7bee..7bfd3f230ff507 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -7,14 +7,6 @@ config NET_VENDOR_MEDIATEK
 
 if NET_VENDOR_MEDIATEK
 
-config NET_AIROHA
-	tristate "Airoha SoC Gigabit Ethernet support"
-	depends on NET_DSA || !NET_DSA
-	select PAGE_POOL
-	help
-	  This driver supports the gigabit ethernet MACs in the
-	  Airoha SoC family.
-
 config NET_MEDIATEK_SOC_WED
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	def_bool NET_MEDIATEK_SOC != n
diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index ddbb7f4a516cac..03e008fbc859b3 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -11,4 +11,3 @@ mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
 endif
 obj-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_ops.o
 obj-$(CONFIG_NET_MEDIATEK_STAR_EMAC) += mtk_star_emac.o
-obj-$(CONFIG_NET_AIROHA) += airoha_eth.o
-- 
2.53.0



