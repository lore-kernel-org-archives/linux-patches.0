Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C1F1DC9AD;
	Mon,  6 Jan 2025 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177057; cv=none; b=f37dUSVusitkr4gr37i30nrQprk1FWOCucSrsmPlxWNYvAurTwpjPEcZJ03MxiiJvcEbtVR5ESInlZCmIctw/GxYR1rT4BhXZnWcc01PSiXISKqVpg/osXJ739T3DlBJoYLT/N1s22YKc9g0hL9KwnbxGcPy4MMHq53VUzmomx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177057; c=relaxed/simple;
	bh=/3kGyb/Dxi8yP//5IFePPvtsXUuxS31qnoR7rPLs+O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgFFfbwwzkPvf8aa/TnCkM+87v6iZodFahH7L63leNJdLYZGSsEvJKoJow5bH/1bMjfODdYyumLtJzKJV9NbPX1OrJ6iziZNh4YfVFKXJXlENTKKJ+KAzErKQJSdliK+vjQSlhMIaz0uYISFWrHZhf5VFEtME0pJkEPni0xw86o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPnEnlHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPnEnlHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9085AC4CED2;
	Mon,  6 Jan 2025 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177057;
	bh=/3kGyb/Dxi8yP//5IFePPvtsXUuxS31qnoR7rPLs+O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPnEnlHEfOMwrD1GwgduQNJfxT27eRjEEzwIHLhPxPMx1757EgzH+S2ShRMu+KRF9
	 Tlab4OdtPL+caU1zCKAbLWvaWvOSghIEBpdaNhqZGbApaHaxRbrsKvU3QFUdyZu2JF
	 azPQzRUdaVBX6O6jtexbgn/q7dGQ+84Ex4f+URNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/222] i2c: i801: Add support for Intel Arrow Lake-H
Date: Mon,  6 Jan 2025 16:14:01 +0100
Message-ID: <20250106151152.007795058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit f0eda4ddb2146a9f29d31b54c396f741bd0c82f1 ]

Add SMBus PCI ID on Intel Arrow Lake-H.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: bd492b583712 ("i2c: i801: Add support for Intel Panther Lake")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/i2c/busses/i2c-i801.rst | 1 +
 drivers/i2c/busses/Kconfig            | 1 +
 drivers/i2c/busses/i2c-i801.c         | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/Documentation/i2c/busses/i2c-i801.rst b/Documentation/i2c/busses/i2c-i801.rst
index 10eced6c2e46..c840b597912c 100644
--- a/Documentation/i2c/busses/i2c-i801.rst
+++ b/Documentation/i2c/busses/i2c-i801.rst
@@ -48,6 +48,7 @@ Supported adapters:
   * Intel Raptor Lake (PCH)
   * Intel Meteor Lake (SOC and PCH)
   * Intel Birch Stream (SOC)
+  * Intel Arrow Lake (SOC)
 
    Datasheets: Publicly available at the Intel website
 
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 97d27e01a6ee..0dc3c91f52a8 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -159,6 +159,7 @@ config I2C_I801
 	    Raptor Lake (PCH)
 	    Meteor Lake (SOC and PCH)
 	    Birch Stream (SOC)
+	    Arrow Lake (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 2b8bcd121ffa..ed943f303cdb 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -80,6 +80,7 @@
  * Meteor Lake SoC-S (SOC)	0xae22	32	hard	yes	yes	yes
  * Meteor Lake PCH-S (PCH)	0x7f23	32	hard	yes	yes	yes
  * Birch Stream (SOC)		0x5796	32	hard	yes	yes	yes
+ * Arrow Lake-H (SOC)		0x7722	32	hard	yes	yes	yes
  *
  * Features supported by this driver:
  * Software PEC				no
@@ -234,6 +235,7 @@
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_M_SMBUS		0x54a3
 #define PCI_DEVICE_ID_INTEL_BIRCH_STREAM_SMBUS		0x5796
 #define PCI_DEVICE_ID_INTEL_BROXTON_SMBUS		0x5ad4
+#define PCI_DEVICE_ID_INTEL_ARROW_LAKE_H_SMBUS		0x7722
 #define PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_S_SMBUS		0x7a23
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_S_SMBUS		0x7aa3
 #define PCI_DEVICE_ID_INTEL_METEOR_LAKE_P_SMBUS		0x7e22
@@ -1046,6 +1048,7 @@ static const struct pci_device_id i801_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_SOC_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_PCH_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, BIRCH_STREAM_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
+	{ PCI_DEVICE_DATA(INTEL, ARROW_LAKE_H_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ 0, }
 };
 
-- 
2.39.5



