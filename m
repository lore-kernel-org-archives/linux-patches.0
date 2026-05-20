Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECBC33CEA2;
	Wed, 20 May 2026 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302063; cv=none; b=UB5hf7zWLV/Z1BE3oiygLNg+AQ4KIIx7pPyzhfo6EdIFa60b4tF+Z4+azdIysTYbtA6cC1Qflp53ACGtDeGP2YBWq6FXdSl6t+22MiFLqozzxAo57DTNzv+v+VNKpB5rKU9V8ysrN34soMPgLuUc/D4ThHZdghNy5plbDoSykng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302063; c=relaxed/simple;
	bh=rho3vEEOpSfRk+6j78Fqei4wauieSzZm0Cn0/Cel16s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ucpuo0Lp3t7eI1SVCUNT34sFuLn1IWQReRqmTKNCcMsEx2fV5yi0ptagdaY/AxVBbMlGzRLSLtVYgHRVzV8lyVoMYDYxqskwPsWUo/oZ2aiTxg+/sC7xwA+/pBcQuUqyA5+nzna0XPUYlcngS23YmXG3chD6efilkyFYZtqQcCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2jZBOVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2jZBOVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F081F000E9;
	Wed, 20 May 2026 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302061;
	bh=dm5wLpXOgbOIhRQplN2Y/yzd+5S2wgb/ij/pbe1cdsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2jZBOVW0ytsVLQPTSWnaSbet28aLL1po6YG9h2g1PihkwC75GZNK98/vEuMuqz7W
	 krWPhnryyQ3WYsPGy3GTdTJUy2WiGvcFjzc5Z9KytVqvw9jl62i6Dh82TIBAWE3g6k
	 vNXyeTVQRrwxPujlP1gCeXd202/BVhiN9uNyWAls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/508] net: phy: move at803x PHY driver to dedicated directory
Date: Wed, 20 May 2026 18:18:26 +0200
Message-ID: <20260520162100.407910915@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 9e56ff53b4115875667760445b028357848b4748 ]

In preparation for addition of other Qcom PHY and to tidy things up,
move the at803x PHY driver to dedicated directory.

The same order in the Kconfig selection is saved.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240129141600.2592-2-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e7a62edd34b1 ("net: phy: qcom: at803x: Use the correct bit to disable extended next page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/Kconfig             | 7 +------
 drivers/net/phy/Makefile            | 2 +-
 drivers/net/phy/qcom/Kconfig        | 7 +++++++
 drivers/net/phy/qcom/Makefile       | 2 ++
 drivers/net/phy/{ => qcom}/at803x.c | 0
 5 files changed, 11 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/phy/qcom/Kconfig
 create mode 100644 drivers/net/phy/qcom/Makefile
 rename drivers/net/phy/{ => qcom}/at803x.c (100%)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 466d3dff60744..e49131cef9570 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -326,12 +326,7 @@ config NCN26000_PHY
 	  Currently supports the NCN26000 10BASE-T1S Industrial PHY
 	  with MII interface.
 
-config AT803X_PHY
-	tristate "Qualcomm Atheros AR803X PHYs and QCA833x PHYs"
-	depends on REGULATOR
-	help
-	  Currently supports the AR8030, AR8031, AR8033, AR8035 and internal
-	  QCA8337(Internal qca8k PHY) model
+source "drivers/net/phy/qcom/Kconfig"
 
 config QSEMI_PHY
 	tristate "Quality Semiconductor PHYs"
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index ab450a46b8550..6e4493e26816d 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -36,7 +36,6 @@ obj-$(CONFIG_ADIN_PHY)		+= adin.o
 obj-$(CONFIG_ADIN1100_PHY)	+= adin1100.o
 obj-$(CONFIG_AMD_PHY)		+= amd.o
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia/
-obj-$(CONFIG_AT803X_PHY)	+= at803x.o
 ifdef CONFIG_AX88796B_RUST_PHY
   obj-$(CONFIG_AX88796B_PHY)	+= ax88796b_rust.o
 else
@@ -86,6 +85,7 @@ obj-$(CONFIG_NCN26000_PHY)	+= ncn26000.o
 obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
 obj-$(CONFIG_NXP_CBTX_PHY)	+= nxp-cbtx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
+obj-y				+= qcom/
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
 obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
 obj-$(CONFIG_RENESAS_PHY)	+= uPD60620.o
diff --git a/drivers/net/phy/qcom/Kconfig b/drivers/net/phy/qcom/Kconfig
new file mode 100644
index 0000000000000..2c274fbbe410d
--- /dev/null
+++ b/drivers/net/phy/qcom/Kconfig
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config AT803X_PHY
+	tristate "Qualcomm Atheros AR803X PHYs and QCA833x PHYs"
+	depends on REGULATOR
+	help
+	  Currently supports the AR8030, AR8031, AR8033, AR8035 and internal
+	  QCA8337(Internal qca8k PHY) model
diff --git a/drivers/net/phy/qcom/Makefile b/drivers/net/phy/qcom/Makefile
new file mode 100644
index 0000000000000..6a68da8aaa7bf
--- /dev/null
+++ b/drivers/net/phy/qcom/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_AT803X_PHY)	+= at803x.o
diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/qcom/at803x.c
similarity index 100%
rename from drivers/net/phy/at803x.c
rename to drivers/net/phy/qcom/at803x.c
-- 
2.53.0



